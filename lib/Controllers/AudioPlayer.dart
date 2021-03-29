import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';
import '../AudioPlayerTask.dart';
import '../Models/songModelForPlaylist.dart';
import 'AudioQuerying.dart';
import 'package:blum/main.dart';


class AudioPlayerController extends GetxController{

  ///LoopMode:
  LoopMode loopMode = LoopMode.off;

  ///shuffled?:
  bool shuffled = false;

  ///Audio querying:
  AudioQuerying audioQuerying = Get.put(AudioQuerying());

  ///Drag Percantage:
  double dragPercentage = 0.0;

  ///Represents list of currentsongs:
  List<SongModelForPLayList> currentSongList = new List<SongModelForPLayList>();

  ///Stream that gives the index of current song:
  StreamSubscription streamOfCurrentSong;

  ///Stream that gives the index of current song:
  StreamSubscription playerdurationStream;

  ///CurrentSongDuration:
  String currentSongDuration = "00:00:00";

  ///CurrentSongPosition
  String currentSongPosition = "00:00:00";

  ///Stream that gives the index of current song:
  StreamSubscription playerpositionStream;

  ///Stream that tells loopmode:
  StreamSubscription loopModeStream;

  ///Stream shuffleMode:
  StreamSubscription shuffleModeEnabledStream;

  ///the current song that is being played:
  SongModelForPLayList currentSong = new SongModelForPLayList();

  AnimationController playPauseAnimationController;

  final Box<String> AlbumArtworkBox = Hive.box<String>("AlbumArtworkBox");



  ///A function to change milliseconds into hh:mm:ss
  changeMillisecondsToTime(Duration d) => d.toString().split('.').first.padLeft(8, "0");


  ///playPauseToggle:
  playPauseToggle(){
    player.playing ? player.pause() : player.play();
  }


  ///function for changing drag percentage:
  changeDragPercantage(double current){
    dragPercentage = current;
    player.seek(Duration(milliseconds: ((player.duration.inMilliseconds/100)*current).toInt()));
    update();
  }


  ///A function that initializes all the stream:
  initializeStreams() async{

    player.playerStateStream.listen((state) {
      state.playing ? playPauseAnimationController.forward() : playPauseAnimationController.reverse();
    });

    playerdurationStream = player.durationStream.listen((event) {
      currentSongDuration = changeMillisecondsToTime(Duration(milliseconds: event.inMilliseconds));
      update();
    });

    playerpositionStream = player.positionStream.listen((event) {
      currentSongPosition = changeMillisecondsToTime(Duration(milliseconds: event.inMilliseconds));
      try {
        double _dragPercentage = (event.inMilliseconds / player.duration.inMilliseconds) * 100;
        if(_dragPercentage<=100){
          dragPercentage = _dragPercentage;
        }else{
          dragPercentage = 100;
        }
        update();
      } catch (e) {
        print(e);
      }
    });


    streamOfCurrentSong = player.currentIndexStream.listen((event) {
       currentSong = currentSongList[event];
       update();
    });

    loopModeStream = player.loopModeStream.listen((event) {
       loopMode = event;
       update();
    });

    shuffleModeEnabledStream = player.shuffleModeEnabledStream.listen((event) {
       shuffled = event;
       update();
    });
  }

  ///Sets Audio source(for playlist):
  setAudioSourceForPlayList({@required List<dynamic> songList, @required int index}) async{

    currentSongList.clear();

    songList.forEach((element) {
      currentSongList.add(SongModelForPLayList.fromJson(element));
    });

    update();

    List<AudioSource> sourceChildren = new List<AudioSource>();

    currentSongList.forEach((element) {
      sourceChildren.add(AudioSource.uri(Uri.parse(element.filePath)));
    });

    await player.setAudioSource(
      ConcatenatingAudioSource(
        // Start loading next item just before reaching it.
        useLazyPreparation: true, // default
        // Customise the shuffle algorithm.
        shuffleOrder: DefaultShuffleOrder(), // default
        // Specify the items in the playlist.
        children: sourceChildren,
      ),
      // Playback will be prepared to start from track1.mp3
      initialIndex: index, // default
      // Playback will be prepared to start from position zero.
      initialPosition: Duration.zero, // default
    );

    player.play();

  }

  ///Sets Audio source(for songs):
  setAudioSourceForSongs({SongInfo song}) async{
    //
    // int startFromIndex = audioQuerying.songs.indexOf(song);
    //
    // final Box<String> AlbumArtworkBox = Hive.box<String>("AlbumArtworkBox");
    //
    // currentSongList.clear();
    //
    // audioQuerying.songs.forEach((songInfo) {
    //    if(songInfo.duration!=null){
    //      currentSongList.add(
    //          SongModelForPLayList(
    //              album: songInfo.album,
    //              albumArtwork: AlbumArtworkBox.get(songInfo.album),
    //              title: songInfo.title,
    //              artist: songInfo.artist,
    //              duration: songInfo.duration,
    //              composer: songInfo.composer,
    //              albumId: songInfo.albumId,
    //              artistId: songInfo.artistId,
    //              filePath: songInfo.filePath,
    //              fileSize: songInfo.fileSize,
    //              isMusic: songInfo.isMusic
    //          )
    //      );
    //    }
    // });
    //
    // update();
    //
    // List<AudioSource> sourceChildren = new List<AudioSource>();
    //
    // currentSongList.forEach((element) {
    //   sourceChildren.add(AudioSource.uri(Uri.parse(element.filePath)));
    // });
    //
    // await player.setAudioSource(
    //   ConcatenatingAudioSource(
    //     // Start loading next item just before reaching it.
    //     useLazyPreparation: true, // default
    //     // Customise the shuffle algorithm.
    //     shuffleOrder: DefaultShuffleOrder(), // default
    //     // Specify the items in the playlist.
    //     children: sourceChildren,
    //   ),
    //   // Playback will be prepared to start from track1.mp3
    //   initialIndex: startFromIndex, // default
    //   // Playback will be prepared to start from position zero.
    //   initialPosition: Duration.zero, // default
    // );

    // player.play();


    List v = [
      {
        'id': "/storage/emulated/0/Music/Alec Benjamin - Narrated For You (2018) Mp3 Album 320kbps Quality [PMEDIA]/12. 1994.mp3",
        'album': "Science Friday",
        'title': "A Salute To Head-Scratching Science",
        'artist': "Science Friday and WNYC Studios",
        'duration': 5739820,
        'artUri': ['media.wnyc.org','/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg'],
      }
    ];

    AudioService.start(
      params: {'data': v},
      backgroundTaskEntrypoint: audioPlayerTaskEntrypoint,
      androidNotificationChannelName: 'Audio Service Demo',
      // Enable this if you want the Android service to exit the foreground state on pause.
      //androidStopForegroundOnPause: true,
      androidNotificationColor: 0xFF2196f3,
      androidNotificationIcon: 'mipmap/ic_launcher',
      androidEnableQueue: true,
    );

  }

  ///loopToggling:
  loopToggle() async{
    if(loopMode == LoopMode.off){
      await player.setLoopMode(LoopMode.all);
    }
    else if(loopMode == LoopMode.all){
      await player.setLoopMode(LoopMode.one);
    }
    else if(loopMode == LoopMode.one){
      await player.setLoopMode(LoopMode.off);
    }
  }

  ///Shuffle Mode Toggling:
  shuffleToggle() async{
    await player.setShuffleModeEnabled(!player.shuffleModeEnabled);
  }

}