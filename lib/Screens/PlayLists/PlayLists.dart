import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../Screens/PlayLists/ListOfPlayList.dart';
import '../../widgets/PlaylistCreatorDialogue.dart';

class PlayLists extends StatefulWidget {
  @override
  _PlayListsState createState() => _PlayListsState();
}

class _PlayListsState extends State<PlayLists> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Color(0xff1f2128).withOpacity(0.9),
      child: Column(
        children: [
          Expanded(
            flex: 5,
            child: Container(
              child: Center(
                child: ListOfPlayList(),
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Center(
                child: IconButton(
                  icon: Icon(Icons.add_circle, color: Color(0xff6F2CFF),),
                  iconSize: 70,
                  color: Colors.white,
                  onPressed: (){
                    PlayListCreatorDialog(context: context, title: "Create new playlist", color: Color(0xff192462));
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
