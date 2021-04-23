import 'package:blum/Controllers/AudioQuerying.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:blum/Screens/Songs/SongList.dart';
import 'package:get/get.dart';

class Songs extends StatefulWidget {
  @override
  _SongsState createState() => _SongsState();
}

class _SongsState extends State<Songs> {

  final AudioQuerying audioQuerying = Get.put(AudioQuerying());

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Color(0xff1f2128).withOpacity(0.9),
      child: Center(
        child: GetBuilder<AudioQuerying>(builder: (aq){
          return SongList(songs: aq.songs);
        }),
      ),
    );
  }
}
