import 'package:blum/Screens/Songs/SongList.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:blum/Screens/Artists/ArtistListTile.dart';
import 'package:hive/hive.dart';
import '../../Controllers/AudioQuerying.dart';
import '../../Screens/SongsFromAlbumsOrArtists/songsFromAlbumOrArtist.dart';

class ArtistList extends StatefulWidget {
  @override
  _ArtistListState createState() => _ArtistListState();
}

class _ArtistListState extends State<ArtistList> {
  @override
  Widget build(BuildContext context) {
    final Box<String> ArtistArtBox = Hive.box<String>("ArtistArtBox");

    return GetBuilder<AudioQuerying>(builder: (aq){
      return GridView.count(
        crossAxisCount: 2,
        children: List.generate(aq.artists.length, (index) {
          return InkWell(child: ArtistListTile(artistInfo: aq.artists[index]),
          onTap: () async{

            final AudioQuerying audioQuerying = Get.put(AudioQuerying());
            List<SongInfo> songs = await audioQuerying.getSongsByArtists(aq.artists[index].id);

            var route = new MaterialPageRoute(
              builder: (BuildContext context) =>
              new SongsFromAlbumOrArtist(songs: songs, image: ArtistArtBox.get(aq.artists[index].name)),
            );
            Navigator.of(context).push(route);

          },);
        }),
      );
    });
  }
}
