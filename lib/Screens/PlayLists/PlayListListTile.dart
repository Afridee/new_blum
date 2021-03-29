import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../Screens/InsideOfPlayList/InsideOfPlaylist.dart';


class PlayListListTile extends StatelessWidget {

  final Map playlistInfo;

  const PlayListListTile({Key key, this.playlistInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        var route = new MaterialPageRoute(
          builder: (BuildContext context) => new InsideOfPlayList(playList: playlistInfo),
        );
        Navigator.of(context).push(route);
      },
      child: ListTile(
        title: Text(playlistInfo.keys.first, style: TextStyle(
          color: Colors.white
        ),),
      ),
    );
  }
}
