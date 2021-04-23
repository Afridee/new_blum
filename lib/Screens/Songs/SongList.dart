import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:get/get.dart';
import 'package:blum/Controllers/Actions.dart';
import 'package:blum/Controllers/AudioQuerying.dart';
import 'package:blum/Screens/Songs/SongListTile.dart';

class SongList extends StatefulWidget {

  final List<SongInfo> songs;

  const SongList({Key key,@required this.songs}) : super(key: key);

  @override
  _SongListState createState() => _SongListState();
}

class _SongListState extends State<SongList> {

  AudioQuerying audioQuerying;

  @override
  void initState() {
    audioQuerying = Get.put(AudioQuerying());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.songs.length,
      itemBuilder: (context, index){
        return widget.songs[index].isMusic && widget.songs[index].duration!=null && audioQuerying.MatchQuery(widget.songs[index].title)?  SongListTile(songInfo : widget.songs[index]) : Container();
      },
    );
  }
}
