import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:blum/Screens/Artists/ArtistListTile.dart';
import '../../Controllers/AudioQuerying.dart';

class ArtistList extends StatefulWidget {
  @override
  _ArtistListState createState() => _ArtistListState();
}

class _ArtistListState extends State<ArtistList> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AudioQuerying>(builder: (aq){
      return ListView.builder(
        itemCount: aq.artists.length,
        itemBuilder: (context, index){
           return ArtistListTile(artistInfo: aq.artists[index]);
        },
      );
    });
  }
}
