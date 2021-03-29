import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:blum/Screens/Genres/GenreList.dart';

class Genres extends StatefulWidget {
  @override
  _GenresState createState() => _GenresState();
}

class _GenresState extends State<Genres> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Color(0xff192462),
      child: Center(
        child: GenreList(),
      ),
    );
  }
}
