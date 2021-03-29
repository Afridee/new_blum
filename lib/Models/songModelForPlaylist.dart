// To parse this JSON data, do
//
//     final songModelForPLayList = songModelForPLayListFromJson(jsonString);

import 'dart:convert';

SongModelForPLayList songModelForPLayListFromJson(String str) => SongModelForPLayList.fromJson(json.decode(str));

String songModelForPLayListToJson(SongModelForPLayList data) => json.encode(data.toJson());

class SongModelForPLayList {
  SongModelForPLayList({
    this.title,
    this.artist,
    this.duration,
    this.isMusic,
    this.album,
    this.albumArtwork,
    this.composer,
    this.albumId,
    this.artistId,
    this.filePath,
    this.fileSize,
  });

  String title;
  String artist;
  String duration;
  bool isMusic;
  String album;
  String albumArtwork;
  String composer;
  String albumId;
  String artistId;
  String filePath;
  String fileSize;

  factory SongModelForPLayList.fromJson(Map<dynamic, dynamic> json) => SongModelForPLayList(
    title: json["title"],
    artist: json["artist"],
    duration: json["duration"],
    isMusic: json["isMusic"],
    album: json["album"],
    albumArtwork: json["albumArtwork"],
    composer: json["composer"],
    albumId: json["albumId"],
    artistId: json["artistId"],
    filePath: json["filePath"],
    fileSize: json["fileSize"],
  );

  Map<dynamic, dynamic> toJson() => {
    "title": title,
    "artist": artist,
    "duration": duration,
    "isMusic": isMusic,
    "album": album,
    "albumArtwork": albumArtwork,
    "composer": composer,
    "albumId": albumId,
    "artistId": artistId,
    "filePath": filePath,
    "fileSize": fileSize,
  };
}
