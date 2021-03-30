import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';
import '../Models/songModelForPlaylist.dart';
import 'AudioQuerying.dart';
import 'package:blum/main.dart';


class AudioPlayerController extends GetxController{

  ///Audio querying:
  AudioQuerying audioQuerying = Get.put(AudioQuerying());

  ///Drag Percantage:
  double dragPercentage = 0.0;

  ///Represents list of currentsongs:
  List<SongModelForPLayList> currentSongList = new List<SongModelForPLayList>();

  ///CurrentSongDuration:
  String currentSongDuration = "00:00:00";

  ///CurrentSongPosition
  String currentSongPosition = "00:00:00";

  ///Stream that gives the index of current song:
  StreamSubscription playerpositionStream;

  StreamSubscription playbackStateStream;

  StreamSubscription currentMediaItemStream;

  ///the current song that is being played:
  SongModelForPLayList currentSong = new SongModelForPLayList();

  AnimationController playPauseAnimationController;

  ///A function to change milliseconds into hh:mm:ss
  changeMillisecondsToTime(Duration d) => d.toString().split('.').first.padLeft(8, "0");


  ///playPauseToggle:
  playPauseToggle(){
    AudioService.playbackState.playing ? AudioService.pause() : AudioService.play();
  }


  ///function for changing drag percentage:
  changeDragPercantage(double current){
    dragPercentage = current;
    AudioService.seekTo(Duration(milliseconds: ((AudioService.currentMediaItem.duration.inMilliseconds/100)*current).toInt()));
    //player.seek();
    update();
  }


  ///A function that initializes all the stream:
  initializeStreams() async{

    playbackStateStream = AudioService.playbackStateStream.listen((state) {
      state.playing ? playPauseAnimationController.forward() : playPauseAnimationController.reverse();
      print('shuffleMode: ');
      print(state.shuffleMode.index);
    });


    currentMediaItemStream = AudioService.currentMediaItemStream.listen((MediaItem item) {
      currentSongDuration = changeMillisecondsToTime(item.duration);
      currentSongList.forEach((element) {
        if(element.filePath==item.id){
          currentSong = element;
        }
      });
      update();
    });

    playerpositionStream = AudioService.positionStream.listen((event) {
      currentSongPosition = changeMillisecondsToTime(event);
      try {
        double _dragPercentage = (event.inMilliseconds / AudioService.currentMediaItem.duration.inMilliseconds) * 100;
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
      //initialIndex: index, // default
      // Playback will be prepared to start from position zero.
      initialPosition: Duration.zero, // default
    );

    player.play();

  }

  ///Sets Audio source(for songs):
  setAudioSourceForSongs({SongInfo song}) async{

    await AudioService.stop();

    int startFromIndex = audioQuerying.songs.indexOf(song);

    final Box<String> AlbumArtworkBox = Hive.box<String>("AlbumArtworkBox");

    currentSongList.clear();

    audioQuerying.songs.forEach((songInfo) {
       if(songInfo.duration!=null){
         currentSongList.add(
             SongModelForPLayList(
                 album: songInfo.album,
                 albumArtwork: AlbumArtworkBox.get(songInfo.album),
                 title: songInfo.title,
                 artist: songInfo.artist,
                 duration: songInfo.duration,
                 composer: songInfo.composer,
                 albumId: songInfo.albumId,
                 artistId: songInfo.artistId,
                 filePath: songInfo.filePath,
                 fileSize: songInfo.fileSize,
                 isMusic: songInfo.isMusic
             )
         );
       }
    });

    update();

    List v = [];

    currentSongList.forEach((element) {
         v.add({
           'id': element.filePath,
           'album': element.album,
           'title': element.title,
           'artist': element.artist,
           'duration': int.parse(element.duration),
           'artUri': ['media.wnyc.org','/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg'],
         });
    });




    AudioService.start(
      params: {'data': v, 'startFromIndex' : startFromIndex},
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
    if(AudioService.playbackState.repeatMode == AudioServiceRepeatMode.none){
      await AudioService.setRepeatMode(AudioServiceRepeatMode.all);
    }
    else if(AudioService.playbackState.repeatMode == AudioServiceRepeatMode.all){
      await AudioService.setRepeatMode(AudioServiceRepeatMode.one);
    }
    else if(AudioService.playbackState.repeatMode == AudioServiceRepeatMode.one){
      await AudioService.setRepeatMode(AudioServiceRepeatMode.none);
    }
  }

}