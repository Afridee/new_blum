import 'package:blum/Controllers/Actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../Screens/InsideOfPlayList/InsideOfPlaylist.dart';


class PlayListListTile extends StatelessWidget {

  final Map playlistInfo;
  const PlayListListTile({Key key, this.playlistInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final appActions = Get.put(AppActions());

    return InkWell(
      onTap: (){
        var route = new MaterialPageRoute(
          builder: (BuildContext context) => new InsideOfPlayList(playList: playlistInfo),
        );
        Navigator.of(context).push(route);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.black.withOpacity(0.2)
          ),
          child: ListTile(
            trailing: IconButton(icon: Icon(Icons.delete, color: Colors.grey,size: 30,),onPressed: (){
              appActions.deletePlayList(playlistInfo.keys.first);
            }),
            leading: Icon(Icons.queue_music, color: Colors.grey,size: 30,),
            title: Text(playlistInfo.keys.first, style: TextStyle(
              color: Colors.white,
              fontSize: 20
            ),),
          ),
        ),
      ),
    );
  }
}
