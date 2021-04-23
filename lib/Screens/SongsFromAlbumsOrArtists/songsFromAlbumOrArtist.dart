import 'package:blum/Screens/Songs/SongList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';

class SongsFromAlbumOrArtist extends StatefulWidget {

  final List<SongInfo> songs;

  const SongsFromAlbumOrArtist({Key key, this.songs}) : super(key: key);

  @override
  _SongsFromAlbumOrArtistState createState() => _SongsFromAlbumOrArtistState();
}

class _SongsFromAlbumOrArtistState extends State<SongsFromAlbumOrArtist> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1f2128).withOpacity(0.9),
      body: SongList(songs: widget.songs),
    );
  }
}
