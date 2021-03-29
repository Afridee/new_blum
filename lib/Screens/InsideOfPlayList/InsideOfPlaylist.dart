import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../Controllers/Actions.dart';
import '../../Controllers/AudioPlayer.dart';
import '../../Models/songModelForPlaylist.dart';
import '../../Screens/AudioPlayer/AudioPlayer.dart';
import '../../Screens/InsideOfPlayList/PlayListSongListTile.dart';
import 'ChooseSongsToAdd/choose_songs_to_add.dart';

  class InsideOfPlayList extends StatefulWidget {

  final Map playList;

  const InsideOfPlayList({Key key, @required this.playList}) : super(key: key);

  @override
  _InsideOfPlayListState createState() => _InsideOfPlayListState();
}

class _InsideOfPlayListState extends State<InsideOfPlayList> {
  @override
  Widget build(BuildContext context) {
    final appActions = Get.put(AppActions());
    Box<List<dynamic>> PlaylistBox = Hive.box<List<dynamic>>("PlaylistBox");
    final audioPlayerController = Get.put(AudioPlayerController());

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.transparent,
        onPressed: () {
          var route = new MaterialPageRoute(
            builder: (BuildContext context) => new ChooseSongsToAdd(
              playListName: widget.playList.keys.first,
            ),
          );
          Navigator.of(context).push(route);
        },
        child: Container(
          height: double.infinity,
          width: double.infinity,
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 40,
          ),
          decoration: BoxDecoration(
              color: Color(0xff6F2CFF),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Color(0xff6F2CFF).withOpacity(0.3),
                  spreadRadius: 3,
                  blurRadius: 8,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ]),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Color(0xff1f2128).withOpacity(0.95),
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(55)),
                  color: Color(0xff6F2CFF).withOpacity(0.9),
                ),
                height: MediaQuery.of(context).size.height - 190,
                width: MediaQuery.of(context).size.width,
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(55)),
                  color: Colors.white,
                ),
                height: MediaQuery.of(context).size.height - 200,
                width: MediaQuery.of(context).size.width,
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                height: MediaQuery.of(context).size.height - 200,
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent,
                child: Center(
                  child: ValueListenableBuilder(
                      valueListenable: PlaylistBox.listenable(),
                      builder: (context, Box<List<dynamic>> PlaylistBox, _) {
                        return ListView.builder(
                          itemCount: PlaylistBox.get(widget.playList.keys.first)
                              .length,
                          itemBuilder: (context, index) {
                            return Dismissible(
                              key: Key(
                                  "${widget.playList.keys.first}_${PlaylistBox.get(widget.playList.keys.first)[index]['title']}"),
                              direction: DismissDirection.startToEnd,
                              background: Container(
                                color: Colors.red.withOpacity(0.9),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(
                                      Icons.remove_circle_outline,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Removing...",
                                      style: TextStyle(
                                        color: Colors.white
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onDismissed: (dir) {
                                if (dir == DismissDirection.startToEnd) {
                                  appActions.removeSongFromPlaylist(
                                      playListname: widget.playList.keys.first,
                                      songInfoList: [
                                        SongModelForPLayList.fromJson(
                                            PlaylistBox.get(widget
                                                .playList.keys.first)[index])
                                      ]);
                                }
                              },
                              child: PlayListSongListTile(
                                  songInfo: SongModelForPLayList.fromJson(PlaylistBox.get(widget.playList.keys.first)[index]),
                                  playList: {widget.playList.keys.first : PlaylistBox.get(widget.playList.keys.first)},
                                  index: index),
                            );
                          },
                        );
                      }),
                ),
              ),
            ),
            Positioned(
              right: 40,
              bottom: MediaQuery.of(context).size.height - 235,
              child: InkWell(
                onTap: () {

                  Box<List<dynamic>> PlaylistBox = Hive.box<List<dynamic>>("PlaylistBox");

                  List<dynamic> Songs = PlaylistBox.get(widget.playList.keys.first);

                  if(Songs.isNotEmpty){
                    audioPlayerController.setAudioSourceForPlayList(songList: Songs, index: 0);
                    var route = new MaterialPageRoute(
                      builder: (BuildContext context) => new AudioPlayer(),
                    );
                    Navigator.of(context).push(route);
                  }
                },
                child: Container(
                  height: 70,
                  width: 70,
                  child: Icon(
                    Icons.play_circle_filled,
                    color: Colors.white,
                    size: 65,
                  ),
                  decoration: BoxDecoration(
                      color: Color(0xff6F2CFF),
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xff6F2CFF).withOpacity(0.3),
                          spreadRadius: 3,
                          blurRadius: 8,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ]),
                ),
              ),
            ),
            Positioned(
              top: 100,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 40,
                color: Colors.transparent,
                child: Center(
                  child: Text(
                    widget.playList.keys.first,
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40.0, left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    color: Color(0xff6F2CFF),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.more_horiz),
                    color: Color(0xff6F2CFF),
                    onPressed: () {},
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
