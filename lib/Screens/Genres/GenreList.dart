import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:blum/Controllers/AudioQuerying.dart';
import 'package:blum/Screens/Genres/GenreListTile.dart';

class GenreList extends StatefulWidget {
  @override
  _GenreListState createState() => _GenreListState();
}

class _GenreListState extends State<GenreList> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AudioQuerying>(builder: (aq){
      return ListView.builder(
         itemCount: aq.genreList.length,
         itemBuilder: (context, index){
           return GenreListTile(genreInfo: aq.genreList[index]);
         }
      );
    });
  }
}
