// To parse this JSON data, do
//
//     final albumModel = albumModelFromJson(jsonString);

import 'dart:convert';

AlbumModel albumModelFromJson(String str) => AlbumModel.fromJson(json.decode(str));

String albumModelToJson(AlbumModel data) => json.encode(data.toJson());

class AlbumModel {
  AlbumModel({
    this.album,
  });

  Album album;

  factory AlbumModel.fromJson(Map<String, dynamic> json) => AlbumModel(
    album: Album.fromJson(json["album"]),
  );

  Map<String, dynamic> toJson() => {
    "album": album.toJson(),
  };
}

class Album {
  Album({
    this.listeners,
    this.playcount,
    this.tracks,
    this.image,
    this.tags,
    this.url,
    this.artist,
    this.name,
    this.mbid,
  });

  String listeners;
  String playcount;
  Tracks tracks;
  List<Image> image;
  Tags tags;
  String url;
  ArtistEnum artist;
  String name;
  String mbid;

  factory Album.fromJson(Map<String, dynamic> json) => Album(
    listeners: json["listeners"],
    playcount: json["playcount"],
    tracks: Tracks.fromJson(json["tracks"]),
    image: List<Image>.from(json["image"].map((x) => Image.fromJson(x))),
    tags: Tags.fromJson(json["tags"]),
    url: json["url"],
    artist: artistEnumValues.map[json["artist"]],
    name: json["name"],
    mbid: json["mbid"],
  );

  Map<String, dynamic> toJson() => {
    "listeners": listeners,
    "playcount": playcount,
    "tracks": tracks.toJson(),
    "image": List<dynamic>.from(image.map((x) => x.toJson())),
    "tags": tags.toJson(),
    "url": url,
    "artist": artistEnumValues.reverse[artist],
    "name": name,
    "mbid": mbid,
  };
}

enum ArtistEnum { CHER }

final artistEnumValues = EnumValues({
  "Cher": ArtistEnum.CHER
});

class Image {
  Image({
    this.size,
    this.text,
  });

  String size;
  String text;

  factory Image.fromJson(Map<String, dynamic> json) => Image(
    size: json["size"],
    text: json["#text"],
  );

  Map<String, dynamic> toJson() => {
    "size": size,
    "#text": text,
  };
}

class Tags {
  Tags({
    this.tag,
  });

  List<Tag> tag;

  factory Tags.fromJson(Map<String, dynamic> json) => Tags(
    tag: List<Tag>.from(json["tag"].map((x) => Tag.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "tag": List<dynamic>.from(tag.map((x) => x.toJson())),
  };
}

class Tag {
  Tag({
    this.name,
    this.url,
  });

  String name;
  String url;

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
    name: json["name"],
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "url": url,
  };
}

class Tracks {
  Tracks({
    this.track,
  });

  List<Track> track;

  factory Tracks.fromJson(Map<String, dynamic> json) => Tracks(
    track: List<Track>.from(json["track"].map((x) => Track.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "track": List<dynamic>.from(track.map((x) => x.toJson())),
  };
}

class Track {
  Track({
    this.artist,
    this.attr,
    this.duration,
    this.url,
    this.name,
    this.streamable,
  });

  ArtistClass artist;
  Attr attr;
  int duration;
  String url;
  String name;
  Streamable streamable;

  factory Track.fromJson(Map<String, dynamic> json) => Track(
    artist: ArtistClass.fromJson(json["artist"]),
    attr: Attr.fromJson(json["@attr"]),
    duration: json["duration"],
    url: json["url"],
    name: json["name"],
    streamable: Streamable.fromJson(json["streamable"]),
  );

  Map<String, dynamic> toJson() => {
    "artist": artist.toJson(),
    "@attr": attr.toJson(),
    "duration": duration,
    "url": url,
    "name": name,
    "streamable": streamable.toJson(),
  };
}

class ArtistClass {
  ArtistClass({
    this.url,
    this.name,
    this.mbid,
  });

  String url;
  ArtistEnum name;
  String mbid;

  factory ArtistClass.fromJson(Map<String, dynamic> json) => ArtistClass(
    url: json["url"],
    name: artistEnumValues.map[json["name"]],
    mbid: json["mbid"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "name": artistEnumValues.reverse[name],
    "mbid": mbid,
  };
}

class Attr {
  Attr({
    this.rank,
  });

  int rank;

  factory Attr.fromJson(Map<String, dynamic> json) => Attr(
    rank: json["rank"],
  );

  Map<String, dynamic> toJson() => {
    "rank": rank,
  };
}

class Streamable {
  Streamable({
    this.fulltrack,
    this.text,
  });

  String fulltrack;
  String text;

  factory Streamable.fromJson(Map<String, dynamic> json) => Streamable(
    fulltrack: json["fulltrack"],
    text: json["#text"],
  );

  Map<String, dynamic> toJson() => {
    "fulltrack": fulltrack,
    "#text": text,
  };
}



class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
