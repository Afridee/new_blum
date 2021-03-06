import 'package:blum/Screens/SongsFromAlbumsOrArtists/songsFromAlbumOrArtist.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../../Controllers/AudioQuerying.dart';
import 'AlbumListTile.dart';

class AlbumList extends StatefulWidget {
  @override
  _AlbumListState createState() => _AlbumListState();
}

class _AlbumListState extends State<AlbumList> {
  @override
  Widget build(BuildContext context) {

    final Box<String> AlbumArtworkBox = Hive.box<String>("AlbumArtworkBox");

    return GetBuilder<AudioQuerying>(builder: (aq) {
      return GridView.count(
        crossAxisCount: 2,
        children: List.generate(aq.albumList.length, (index) {
            return InkWell(child: AlbumListTile(albumInfo: aq.albumList[index]), onTap: () async{

            final AudioQuerying audioQuerying = Get.put(AudioQuerying());
            List<SongInfo> songs = await audioQuerying.getSongsByAlbum(aq.albumList[index].id);

            var route = new MaterialPageRoute(
              builder: (BuildContext context) =>
              new SongsFromAlbumOrArtist(title: aq.albumList[index].title,songs: songs, image: AlbumArtworkBox.get(aq.albumList[index].title)),
            );
            Navigator.of(context).push(route);
          },);
        }),
      );
    });
  }
}

