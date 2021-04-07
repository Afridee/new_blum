import 'dart:math';
import 'dart:convert';

import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Models/AlbumModel.dart';

class AudioQuerying extends GetxController {
  FlutterAudioQuery audioQuery = FlutterAudioQuery();
  Box<String> AlbumArtworkBox = Hive.box<String>("AlbumArtworkBox");
  Box<String> ArtistArtBox = Hive.box<String>("ArtistArtBox");
  List<SongInfo> songs = new List<SongInfo>();
  List<PlaylistInfo> playlist = new List<PlaylistInfo>();
  List<ArtistInfo> artists = new List<ArtistInfo>();
  List<GenreInfo> genreList = new List<GenreInfo>();
  List<AlbumInfo> albumList = [];

  AudioQuerying() {
    initialize();
  }

  initialize() async {
    audioQuery = FlutterAudioQuery();

    /// getting all songs available on device storage
    songs = await audioQuery.getSongs(sortType: SongSortType.DEFAULT);

    /// getting all playlist available
    playlist = await audioQuery.getPlaylists();

    /// returns all artists available
    artists = await audioQuery.getArtists();

    /// getting all genres available
    genreList = await audioQuery.getGenres();

    /// getting all albums available on device storage
    albumList = await audioQuery.getAlbums();

    update();

    /// getting all album artworks because the one from the plugin doesn't work
    initializeAlbumArtwork();

    update();
  }

  initializeAlbumArtwork() {
    albumList.forEach((element) async {
      var client = http.Client();

      if (!AlbumArtworkBox.containsKey(element.title)) {
        final response =
            await client.post(Uri.http('ws.audioscrobbler.com', '/2.0', {
          "method": "album.getinfo",
          "api_key": "7cd3935946a144b1b49d6b30dd4a5a0d",
          "artist": element.artist.toString(),
          "album": element.title.toString(),
          "format": "json"
        }));

        try {
          if (jsonDecode(response.body)['message'] != "Album not found") {
            try {
              AlbumModel m = AlbumModel.fromJson(jsonDecode(response.body));
              AlbumArtworkBox.put(element.title, m.album.image.last.text);
              ArtistArtBox.put(element.artist, m.album.image.last.text);
            } catch (e) {
              print('Error: ' + e.toString());
            }
          } else {
            AlbumArtworkBox.put(element.title,
                'https://images.unsplash.com/photo-1458560871784-56d23406c091?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80');
            ArtistArtBox.put(element.artist,
                'https://images.unsplash.com/photo-1458560871784-56d23406c091?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80');
          }
        } catch (e) {
          print(e);
        }
      }
    });
  }

  Search(String query){

  }

  changeMillisecondsToTime(Duration d) =>
      d.toString().split('.').first.padLeft(8, "0");
}
