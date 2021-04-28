import 'package:blum/Screens/Songs/SongList.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';

class SongsFromAlbumOrArtist extends StatefulWidget {

  final List<SongInfo> songs;
  final String image;

  const SongsFromAlbumOrArtist({Key key,@required this.songs,@required this.image}) : super(key: key);

  @override
  _SongsFromAlbumOrArtistState createState() => _SongsFromAlbumOrArtistState();
}

class _SongsFromAlbumOrArtistState extends State<SongsFromAlbumOrArtist> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1f2128).withOpacity(0.9),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                  image: widget.image==null || widget.image==''? AssetImage('assets/images/image_1.jfif') : NetworkImage(widget.image),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      color: Colors.white,
                      iconSize: 30,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.more_horiz),
                      iconSize: 30,
                      color: Colors.white,
                      onPressed: () {},
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.black,
          ),),
          Expanded(
            flex: 4,
            child: SongList(songs: widget.songs),
          )
        ],
      ),
    );
  }
}
