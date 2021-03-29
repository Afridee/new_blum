import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../Controllers/AudioQuerying.dart';
import 'AlbumListTile.dart';

class AlbumList extends StatefulWidget {
  @override
  _AlbumListState createState() => _AlbumListState();
}

class _AlbumListState extends State<AlbumList> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AudioQuerying>(builder: (aq) {
      return ListView.builder(
          itemCount: aq.albumList.length, itemBuilder: (context, index) {
            return AlbumListTile(albumInfo: aq.albumList[index]);
      });
    });
  }
}
