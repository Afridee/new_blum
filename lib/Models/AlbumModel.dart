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
    this.artist,
    this.mbid,
    this.url,
    this.image,
    this.listeners,
    this.playcount,
    this.tracks,
    this.tags,
  });


  ArtistEnum artist;
  String mbid;
  String url;
  List<Image> image;
  String listeners;
  String playcount;
  Tracks tracks;
  Tags tags;

  factory Album.fromJson(Map<String, dynamic> json) => Album(
    artist: artistEnumValues.map[json["artist"]],
    mbid: json["mbid"],
    url: json["url"],
    image: List<Image>.from(json["image"].map((x) => Image.fromJson(x))),
    listeners: json["listeners"],
    playcount: json["playcount"],
    tracks: Tracks.fromJson(json["tracks"]),
    tags: Tags.fromJson(json["tags"]),
  );

  Map<String, dynamic> toJson() => {
    "artist": artistEnumValues.reverse[artist],
    "mbid": mbid,
    "url": url,
    "image": List<dynamic>.from(image.map((x) => x.toJson())),
    "listeners": listeners,
    "playcount": playcount,
    "tracks": tracks.toJson(),
    "tags": tags.toJson(),
  };
}

enum ArtistEnum { CHER }

final artistEnumValues = EnumValues({
  "Cher": ArtistEnum.CHER
});

class Image {
  Image({
    this.text,
    this.size,
  });

  String text;
  String size;

  factory Image.fromJson(Map<String, dynamic> json) => Image(
    text: json["#text"],
    size: json["size"],
  );

  Map<String, dynamic> toJson() => {
    "#text": text,
    "size": size,
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
    this.name,
    this.url,
    this.duration,
    this.attr,
    this.streamable,
    this.artist,
  });

  String name;
  String url;
  String duration;
  Attr attr;
  Streamable streamable;
  ArtistClass artist;

  factory Track.fromJson(Map<String, dynamic> json) => Track(
    name: json["name"],
    url: json["url"],
    duration: json["duration"],
    attr: Attr.fromJson(json["@attr"]),
    streamable: Streamable.fromJson(json["streamable"]),
    artist: ArtistClass.fromJson(json["artist"]),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "url": url,
    "duration": duration,
    "@attr": attr.toJson(),
    "streamable": streamable.toJson(),
    "artist": artist.toJson(),
  };
}

class ArtistClass {
  ArtistClass({
    this.name,
    this.mbid,
    this.url,
  });

  ArtistEnum name;
  String mbid;
  String url;

  factory ArtistClass.fromJson(Map<String, dynamic> json) => ArtistClass(
    name: artistEnumValues.map[json["name"]],
    mbid: json["mbid"],
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "name": artistEnumValues.reverse[name],
    "mbid": mbid,
    "url": url,
  };
}

class Attr {
  Attr({
    this.rank,
  });

  String rank;

  factory Attr.fromJson(Map<String, dynamic> json) => Attr(
    rank: json["rank"],
  );

  Map<String, dynamic> toJson() => {
    "rank": rank,
  };
}

class Streamable {
  Streamable({
    this.text,
    this.fulltrack,
  });

  String text;
  String fulltrack;

  factory Streamable.fromJson(Map<String, dynamic> json) => Streamable(
    text: json["#text"],
    fulltrack: json["fulltrack"],
  );

  Map<String, dynamic> toJson() => {
    "#text": text,
    "fulltrack": fulltrack,
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
