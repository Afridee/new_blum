import 'package:blum/Controllers/AudioPlayer.dart';
import 'package:blum/Screens/AudioPlayer/AudioPlayer.dart';
import 'package:blum/Screens/Songs/SongList.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:get/get.dart';

class SongsFromAlbumOrArtist extends StatefulWidget {
  final String title;
  final List<SongInfo> songs;
  final String image;

  const SongsFromAlbumOrArtist(
      {Key key,
      @required this.songs,
      @required this.image,
      @required this.title})
      : super(key: key);

  @override
  _SongsFromAlbumOrArtistState createState() => _SongsFromAlbumOrArtistState();
}

class _SongsFromAlbumOrArtistState extends State<SongsFromAlbumOrArtist> {
  @override
  Widget build(BuildContext context) {

    final  audioPlayerController = Get.put(AudioPlayerController());

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
                  image: widget.image == null || widget.image == ''
                      ? AssetImage('assets/images/image_1.jfif')
                      : NetworkImage(widget.image),
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
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.07),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(

                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text(
                          widget.title,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontFamily: 'Nunito'),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: Center(
                      child: IconButton(
                        icon: Icon(Icons.play_circle_fill),
                        color: Colors.white,
                        iconSize: 30,
                        onPressed: () {
                          audioPlayerController.setAudioSourceForAlbums_and_Artists(songList: widget.songs, index: 0);
                          var route = new MaterialPageRoute(
                            builder: (BuildContext context) => new AudioPlayer(),
                          );
                          Navigator.of(context).push(route);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: SongList(songs: widget.songs),
          )
        ],
      ),
    );
  }
}
