import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../Models/songModelForPlaylist.dart';
import 'AudioQuerying.dart';

class AppActions extends GetxController{

  Box<List<dynamic>> PlaylistBox = Hive.box<List<dynamic>>("PlaylistBox");
  Box<String> AlbumArtworkBox = Hive.box<String>("AlbumArtworkBox");
  AudioQuerying audioQuerying = Get.put(AudioQuerying());
  bool search = false;
  double searchBarwidth = 50;

  addSongToPlayList({String playListname, List<SongInfo> songInfoList}){

    if(playListname.length>0){

      List<dynamic> SongModelList = new List<dynamic>();

      songInfoList.forEach((songInfoElement) {
        SongModelList.add(new SongModelForPLayList(
            album: songInfoElement.album,
            albumArtwork: AlbumArtworkBox.get(songInfoElement.album),
            title: songInfoElement.title,
            artist: songInfoElement.artist,
            duration: songInfoElement.duration,
            composer: songInfoElement.composer,
            albumId: songInfoElement.albumId,
            artistId: songInfoElement.artistId,
            filePath: songInfoElement.filePath,
            fileSize: songInfoElement.fileSize,
            isMusic: songInfoElement.isMusic
        ).toJson());
      });


      try {
        if(PlaylistBox.get(playListname)==null){
          PlaylistBox.put(playListname, SongModelList);
        }else{
          List<dynamic> existingSongs = PlaylistBox.get(playListname);
          SongModelList.addAll(existingSongs);

          // convert each item to a string by using JSON encoding
          final jsonList = SongModelList.map((item) => jsonEncode(item)).toList();

          // using toSet - toList strategy
          final uniqueJsonList = jsonList.toSet().toList();

          // convert each item back to the original form using JSON decoding
          final result = uniqueJsonList.map((item) => jsonDecode(item)).toList();

          PlaylistBox.put(playListname, result);
        }
      } catch (e) {
        print('Error: ' + e.toString());
      }

    }

  }

  removeSongFromPlaylist({String playListname, List<SongModelForPLayList> songInfoList}){

    List<dynamic> Songs = PlaylistBox.get(playListname);

    List<dynamic> filtered = new List<dynamic>();

    songInfoList.forEach((songInfoList_element) {
      Songs.forEach((Songs_element) {
         if(Songs_element.toString()==songInfoList_element.toJson().toString()){
           filtered.add(Songs_element);
         }
      });
    });

    filtered.forEach((element) {
      if(Songs.contains(element)){
         Songs.remove(element);
      }
    });

    PlaylistBox.put(playListname, Songs);
 }

  searchStat(BuildContext context){
    search = !search;
    if(search){
      searchBarwidth = MediaQuery.of(context).size.width;
    }else{
      searchBarwidth = 50;
      audioQuerying.Search('');
    }
    update();
  }
}