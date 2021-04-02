import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';
import 'main.dart';

class Seeker {
  final AudioPlayer player;
  final Duration positionInterval;
  final Duration stepInterval;
  final MediaItem mediaItem;
  bool _running = false;

  Seeker(
      this.player,
      this.positionInterval,
      this.stepInterval,
      this.mediaItem,
      );

  start() async {
    _running = true;
    while (_running) {
      Duration newPosition = player.position + positionInterval;
      if (newPosition < Duration.zero) newPosition = Duration.zero;
      if (newPosition > mediaItem.duration) newPosition = mediaItem.duration;
      player.seek(newPosition);
      await Future.delayed(stepInterval);
    }
  }

  stop() {
    _running = false;
  }
}


/// This task defines logic for playing a list of podcast episodes.
class AudioPlayerTask extends BackgroundAudioTask {
  AudioProcessingState _skipState;
  Seeker _seeker;
  StreamSubscription<PlaybackEvent> _eventSubscription;


  List<MediaItem> queue ;
  int index;
  MediaItem mediaItem;

  @override
  Future<void> onStart(Map<String, dynamic> params) async {



    List<MediaItem> items = [];

    try {
      params['data'].forEach((element){
            items.add(
              MediaItem(
                id: element['id'],
                album: element['album'],
                title: element['title'],
                artist: element['artist'],
                duration: Duration(milliseconds: element['duration']),
              ),//
            );
          });
    } catch (e) {

    }



    queue = items;
    index  = player.currentIndex;
    if(index==null){
      mediaItem = null;
    }else{
      mediaItem = queue[index];
    }
    // We configure the audio session for speech since we're playing a podcast.
    // You can also put this in your app's initialisation if your app doesn't
    // switch between two types of audio as this example does.
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.speech());
    // Broadcast media item changes.
    player.currentIndexStream.listen((index) {
      if (index != null) AudioServiceBackground.setMediaItem(queue[index]);
    });
    // Propagate all events from the audio player to AudioService clients.
    _eventSubscription = player.playbackEventStream.listen((event) {
      _broadcastState();
    });
    // Special processing for state transitions.
    player.processingStateStream.listen((state) {
      switch (state) {
        case ProcessingState.completed:
        // In this example, the service stops when reaching the end.
          onStop();
          break;
        case ProcessingState.ready:
        // If we just came from skipping between tracks, clear the skip
        // state now that we're ready to play.
          _skipState = null;
          break;
        default:
          break;
      }
    });

    // Load and broadcast the queue
    AudioServiceBackground.setQueue(queue);
    try {
      await player.setAudioSource(
        ConcatenatingAudioSource(
          // Start loading next item just before reaching it.
          useLazyPreparation: true, // default
          // Customise the shuffle algorithm.
          shuffleOrder: DefaultShuffleOrder(), // default
          // Specify the items in the playlist.
          children: queue.map((item) => AudioSource.uri(Uri.parse(item.id))).toList(),
        ),
        // Playback will be prepared to start from track1.mp3
        initialIndex: params['startFromIndex'], // default
        // Playback will be prepared to start from position zero.
        initialPosition: Duration.zero, // default
      );
      // In this example, we automatically start playing on start.
      onPlay();
    } catch (e) {
      //print("Error: $e");
      onStop();
    }
  }

  @override
  Future<void> onSkipToNext() async {
    await player.seekToNext();
  }

  @override
  Future<void> onSkipToPrevious() async{
    await player.seekToPrevious();
  }

  @override
  Future<void> onSkipToQueueItem(String mediaId) async {
    // Then default implementations of onSkipToNext and onSkipToPrevious will
    // delegate to this method.
    final newIndex = queue.indexWhere((item) => item.id == mediaId);
    if (newIndex == -1) return;
    // During a skip, the player may enter the buffering state. We could just
    // propagate that state directly to AudioService clients but AudioService
    // has some more specific states we could use for skipping to next and
    // previous. This variable holds the preferred state to send instead of
    // buffering during a skip, and it is cleared as soon as the player exits
    // buffering (see the listener in onStart).
    _skipState = newIndex > player.currentIndex
        ? AudioProcessingState.skippingToNext
        : AudioProcessingState.skippingToPrevious;
    // This jumps to the beginning of the queue item at newIndex.
    player.seek(Duration.zero, index: newIndex);
    // Demonstrate custom events.
    AudioServiceBackground.sendCustomEvent('skip to $newIndex');
  }

  @override
  Future<void> onPlay() => player.play();

  @override
  Future<void> onPause() => player.pause();

  @override
  Future<void> onSeekTo(Duration position) => player.seek(position);

  @override
  Future<void> onFastForward() => _seekRelative(fastForwardInterval);

  @override
  Future<void> onRewind() => _seekRelative(-rewindInterval);

  @override
  Future<void> onSeekForward(bool begin) async => _seekContinuously(begin, 1);

  @override
  Future<void> onSeekBackward(bool begin) async => _seekContinuously(begin, -1);

  @override
  Future<void> onStop() async {
    await player.dispose();
    _eventSubscription.cancel();
    // It is important to wait for this state to be broadcast before we shut
    // down the task. If we don't, the background task will be destroyed before
    // the message gets sent to the UI.
    await _broadcastState();
    // Shut down this task
    await super.onStop();
  }

  @override
  Future<void> onSetShuffleMode(AudioServiceShuffleMode shuffleMode) async{

    try {
      await player.setShuffleModeEnabled(!player.shuffleModeEnabled);
      //print('here shuffle w e:');
    } catch (e) {
      //print('here shuffle:');
      //print(e);
    }

    await _broadcastState();
  }

  @override
  Future<void> onSetRepeatMode(AudioServiceRepeatMode repeatMode) async {
    if(repeatMode == AudioServiceRepeatMode.all){
      player.setLoopMode(LoopMode.all);
    }
    else if(repeatMode == AudioServiceRepeatMode.one){
      player.setLoopMode(LoopMode.one);
    }
    else if(repeatMode == AudioServiceRepeatMode.none){
      player.setLoopMode(LoopMode.off);
    }

    _broadcastState();
  }

  /// Jumps away from the current position by [offset].
  Future<void> _seekRelative(Duration offset) async {
    var newPosition = player.position + offset;
    // Make sure we don't jump out of bounds.
    if (newPosition < Duration.zero) newPosition = Duration.zero;
    if (newPosition > mediaItem.duration) newPosition = mediaItem.duration;
    // Perform the jump via a seek.
    await player.seek(newPosition);
  }

  /// Begins or stops a continuous seek in [direction]. After it begins it will
  /// continue seeking forward or backward by 10 seconds within the audio, at
  /// intervals of 1 second in app time.
  void _seekContinuously(bool begin, int direction) {
    _seeker?.stop();
    if (begin) {
      _seeker = Seeker(player, Duration(seconds: 10 * direction),
          Duration(seconds: 1), mediaItem)
        ..start();
    }
  }

  /// Broadcasts the current state to all clients.
  Future<void> _broadcastState() async {
    await AudioServiceBackground.setState(
      controls: [
        MediaControl.skipToPrevious,
        if (player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
        MediaControl.skipToNext,
      ],
      systemActions: [
        MediaAction.seekTo,
        MediaAction.seekForward,
        MediaAction.seekBackward,
        MediaAction.setShuffleMode,
        MediaAction.setRepeatMode
      ],
      androidCompactActions: [0, 1, 3],
      processingState: _getProcessingState(),
      playing: player.playing,
      position: player.position,
      bufferedPosition: player.bufferedPosition,
      shuffleMode: _getShuffleMode(),
      speed: player.speed,
      repeatMode: _getRepeatModeStat()
    );
  }

  /// Maps just_audio's processing state into into audio_service's playing
  /// state. If we are in the middle of a skip, we use [_skipState] instead.
  AudioProcessingState _getProcessingState() {
    if (_skipState != null) return _skipState;
    switch (player.processingState) {
      case ProcessingState.idle:
        return AudioProcessingState.stopped;
      case ProcessingState.loading:
        return AudioProcessingState.connecting;
      case ProcessingState.buffering:
        return AudioProcessingState.buffering;
      case ProcessingState.ready:
        return AudioProcessingState.ready;
      case ProcessingState.completed:
        return AudioProcessingState.completed;
      default:
        throw Exception("Invalid state: ${player.processingState}");
    }
  }

  AudioServiceShuffleMode _getShuffleMode(){
    if(player.shuffleModeEnabled){
      return AudioServiceShuffleMode.all;
    }else{
      return AudioServiceShuffleMode.none;
    }
  }

  AudioServiceRepeatMode _getRepeatModeStat(){
    if(player.loopMode == LoopMode.all){
      return AudioServiceRepeatMode.all;
    }
    else if(player.loopMode == LoopMode.one){
      return AudioServiceRepeatMode.one;
    }
    if(player.loopMode == LoopMode.off){
      return AudioServiceRepeatMode.none;
    }
  }

}