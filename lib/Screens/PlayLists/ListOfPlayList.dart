import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'PlayListListTile.dart';

class ListOfPlayList extends StatefulWidget {
  @override
  _ListOfPlayListState createState() => _ListOfPlayListState();
}

class _ListOfPlayListState extends State<ListOfPlayList> {

  @override
  Widget build(BuildContext context) {

    Box<List<dynamic>> PlaylistBox = Hive.box<List<dynamic>>("PlaylistBox");

    return  ValueListenableBuilder(
      valueListenable: PlaylistBox.listenable(),
      builder: (context, Box<List<dynamic>> PlaylistBox, _){
        return ListView.builder(
          itemCount: PlaylistBox.keys.toList().length,
          itemBuilder: (context, index){
            return PlayListListTile(playlistInfo: {PlaylistBox.keyAt(index) : PlaylistBox.getAt(index)});
          },
        );
      },
    );
  }
}
