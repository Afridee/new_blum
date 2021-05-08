import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Actions.dart';
import '../../../Controllers/AudioQuerying.dart';
import '../../../Controllers/chooseSongsForPlayList.dart';
import '../../../Screens/InsideOfPlayList/ChooseSongsToAdd/ChooseSongsToAdd_ListTile.dart';

class ChooseSongsToAdd extends StatefulWidget {

  final String playListName;

  ChooseSongsToAdd({Key key,@required this.playListName}) : super(key: key);

  @override
  _ChooseSongsToAddState createState() => _ChooseSongsToAddState();
}

class _ChooseSongsToAddState extends State<ChooseSongsToAdd> {
  AudioQuerying audioQuerying = Get.put(AudioQuerying());
  AppActions appActions = Get.put(AppActions());

  ChooseSongsForPlaylistController chooseSongsForPlaylistController = Get.put(ChooseSongsForPlaylistController());

  @override
  void initState() {
    chooseSongsForPlaylistController.clearList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Color(0xff1f2128),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.black,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xff6F2CFF).withOpacity(0.3),
                        spreadRadius: 3,
                        blurRadius: 8,
                        offset: Offset(
                            0, 0), // changes position of shadow
                      ),
                    ]
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0,left: 15, right: 15),
                    child: TextField(
                      onChanged: (value){
                        audioQuerying.searchSongsToAddToPlaylist(value);
                      },
                      style: TextStyle(
                        color: Colors.white
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search here for songs...",
                        hintStyle: TextStyle(
                          color: Colors.white
                        ),
                        prefixIcon: Icon(Icons.search_rounded, color: Colors.white,)
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Container(
                child: GetBuilder<AudioQuerying>(builder: (aq){
                  return ListView.builder(
                    itemCount: aq.songs.length,
                    itemBuilder: (context, index){
                      return aq.songs[index].isMusic && aq.songs[index].duration!=null && aq.MatchQueryWhileAddingSongsToPlaylist(aq.songs[index].title) ?  ChooseSongsToAdd_ListTile(songInfo : aq.songs[index]) : Container();
                    },
                  );
                }
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff6F2CFF),
        child: Icon(Icons.done, color: Colors.white,),
        onPressed: (){
           audioQuerying.searchSongsToAddToPlaylist('');
           appActions.addSongToPlayList(playListname: widget.playListName, songInfoList: chooseSongsForPlaylistController.selected);
           Navigator.of(context).pop();
        },
      ),
    );
  }
}
