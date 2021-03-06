import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controllers/Actions.dart';

//function 5:
void PlayListCreatorDialog({@required BuildContext context,@required String title,@required Color
color}) {
  String playListName = '';
  final appActions = Get.put(AppActions());
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Text(
          title,
          style: TextStyle(
              fontSize: 30, color: Colors.white, fontFamily: 'Varela'),
        ),
        content: new TextField(
          style: TextStyle(
            color: Colors.white
          ),
          onChanged: (value){
            playListName = value;
          },
        ),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new FlatButton(
            child: new Text(
              "Create New",
              style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                  fontFamily: 'Varela',
                  fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              appActions.addSongToPlayList(playListname: playListName, songInfoList: []);
              Navigator.of(context).pop();
            },
          ),
          new FlatButton(
            child: new Text(
              "Cancel",
              style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                  fontFamily: 'Varela',
                  fontWeight: FontWeight.bold),
            ),
            onPressed: () {
                Navigator.of(context).pop();
            },
          )
        ],
        backgroundColor: color,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
      );
    },
  );
}