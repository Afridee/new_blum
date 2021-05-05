import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
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
  MediaItem currentSong = new MediaItem(id: '...', album: '...', title: '...');

  AnimationController playPauseAnimationController;

  Icon Mini_play_pause = Icon(Icons.play_arrow);

  ///A function to change milliseconds into hh:mm:ss
  changeMillisecondsToTime(Duration d) => d.toString().split('.').first.padLeft(8, "0");


  ///playPauseToggle:
  playPauseToggle(){
    if(AudioService.running){
      AudioService.playbackState.playing ? AudioService.pause() : AudioService.play();
    }
  }


  ///function for changing drag percentage:
  changeDragPercantage(double current){
     if(AudioService.running){
       dragPercentage = current;
       AudioService.seekTo(Duration(milliseconds: ((AudioService.currentMediaItem.duration.inMilliseconds/100)*current).toInt()));
       update();
     }
  }


  ///A function that initializes all the stream:
  initializeStreams() async{

    playbackStateStream = AudioService.playbackStateStream.listen((state) {
      try {
        state.playing ? playPauseAnimationController.forward() : playPauseAnimationController.reverse();
      } catch (e) {

      }

      try {
        state.playing ? Mini_play_pause = Icon(Icons.pause) : Mini_play_pause = Icon(Icons.play_arrow);
        update();
      } catch (e) {
        print(e);
      }
    });


    currentMediaItemStream = AudioService.currentMediaItemStream.listen((MediaItem item) {
      try {
        currentSongDuration = changeMillisecondsToTime(item.duration);
        currentSong = item;
        update();
      } catch (e) {

      }
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
      } catch (e) {

      }
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

    bool mediasAreStillSame = true;


    if(AudioService.running && AudioService.queue.length==currentSongList.length){
      for(int i=0;i<AudioService.queue.length;i++){
        if(AudioService.queue[i].id != currentSongList[i].filePath){
          mediasAreStillSame = false;
        }
      }
    }else{
      mediasAreStillSame = false;
    }

    if(mediasAreStillSame){
      AudioService.skipToQueueItem(currentSongList[index].filePath);
    }else{

      List playThese = [];

      currentSongList.forEach((element) {
        playThese.add({
          'id': element.filePath,
          'album': element.album,
          'title': element.title,
          'artist': element.artist,
          'duration': int.parse(element.duration),
        });
      });

      if(AudioService.running){
        await AudioService.stop();
      }

      AudioService.start(
        params: {'data': playThese, 'startFromIndex' : index},
        backgroundTaskEntrypoint: audioPlayerTaskEntrypoint,
        androidNotificationChannelName: 'Audio Service Demo',
        // Enable this if you want the Android service to exit the foreground state on pause.
        //androidStopForegroundOnPause: true,
        androidNotificationColor: 0xFF2196f3,
        androidNotificationIcon: 'mipmap/ic_launcher',
        androidEnableQueue: true,
      );
    }

  }

  ///Sets Audio source(for Albums_and_Artists):
  setAudioSourceForAlbums_and_Artists({@required List<SongInfo> songList, @required int index}) async{

    currentSongList.clear();

    final Box<String> AlbumArtworkBox = Hive.box<String>("AlbumArtworkBox");

    songList.forEach((songInfo) {
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

    bool mediasAreStillSame = true;


    if(AudioService.running && AudioService.queue.length==currentSongList.length){
      for(int i=0;i<AudioService.queue.length;i++){
        if(AudioService.queue[i].id != currentSongList[i].filePath){
          mediasAreStillSame = false;
        }
      }
    }else{
      mediasAreStillSame = false;
    }

    if(mediasAreStillSame){
      AudioService.skipToQueueItem(currentSongList[index].filePath);
    }else{

      List playThese = [];

      currentSongList.forEach((element) {
        playThese.add({
          'id': element.filePath,
          'album': element.album,
          'title': element.title,
          'artist': element.artist,
          'duration': int.parse(element.duration),
        });
      });

      if(AudioService.running){
        await AudioService.stop();
      }

      AudioService.start(
        params: {'data': playThese, 'startFromIndex' : index},
        backgroundTaskEntrypoint: audioPlayerTaskEntrypoint,
        androidNotificationChannelName: 'Audio Service Demo',
        // Enable this if you want the Android service to exit the foreground state on pause.
        //androidStopForegroundOnPause: true,
        androidNotificationColor: 0xFF2196f3,
        androidNotificationIcon: 'mipmap/ic_launcher',
        androidEnableQueue: true,
      );
    }

  }

  ///Sets Audio source(for songs):
  setAudioSourceForSongs({SongInfo song}) async{

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

        bool mediasAreStillSame = true;



        if(AudioService.running && AudioService.queue.length==currentSongList.length){
          for(int i=0;i<AudioService.queue.length;i++){
            if(AudioService.queue[i].id != currentSongList[i].filePath){
              mediasAreStillSame = false;
            }
          }
        }else{
          mediasAreStillSame = false;
        }

        if(mediasAreStillSame){
          AudioService.skipToQueueItem(song.filePath);
        }else{

          List playThese = [];

          currentSongList.forEach((element) {
            playThese.add({
              'id': element.filePath,
              'album': element.album,
              'title': element.title,
              'artist': element.artist,
              'duration': int.parse(element.duration),
            });
          });

          if(AudioService.running){
            await AudioService.stop();
          }

          AudioService.start(
            params: {'data': playThese, 'startFromIndex' : startFromIndex},
            backgroundTaskEntrypoint: audioPlayerTaskEntrypoint,
            androidNotificationChannelName: 'Audio Service Demo',
            // Enable this if you want the Android service to exit the foreground state on pause.
            //androidStopForegroundOnPause: true,
            androidNotificationColor: 0xFF2196f3,
            androidNotificationIcon: 'mipmap/ic_launcher',
            androidEnableQueue: true,
          );
        }

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