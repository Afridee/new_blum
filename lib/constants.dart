import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const TextStyle song_title_style_1 = TextStyle(
    fontFamily: 'Nunito',
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 13
);

const TextStyle song_title_style_2 = TextStyle(
    fontFamily: 'Nunito',
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 25
);

const TextStyle song_title_style_3 = TextStyle(
    fontFamily: 'Nunito',
    color: Colors.white,
    fontWeight: FontWeight.w300,
    fontSize: 25
);

const TextStyle song_title_style_4 = TextStyle(
    fontFamily: 'Nunito',
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 13
);

TextStyle Artist_title_style_1 = TextStyle(
    color: Colors.white.withOpacity(0.7),
    fontWeight: FontWeight.w300,
    fontSize: 15
);

const TextStyle seek_style = TextStyle(
        fontSize: 12,
        color: Colors.white,
        fontWeight: FontWeight.bold
);

const TextStyle duration_style_1 = TextStyle(
    fontFamily: 'Nunito',
    color: Colors.white,
    fontSize: 10
);

const TextStyle duration_style_2 = TextStyle(
    fontFamily: 'Nunito',
    color: Colors.black,
    fontSize: 10
);

/// tablist, shoud not be more than 5:
List<Widget> Tabs = [
  Tab(
    child: Container(
      child: Text(
        'Songs',
        style: TextStyle(color: Colors.white, fontSize: 18.0),
      ),
    ),
  ),
  Tab(
    child: Container(
      child: Text(
        'Playlists',
        style: TextStyle(color: Colors.white, fontSize: 18.0),
      ),
    ),
  ),
  Tab(
    child: Container(
      child: Text(
        'Artists',
        style: TextStyle(color: Colors.white, fontSize: 18.0),
      ),
    ),
  ),
  Tab(
    child: Container(
      child: Text(
        'Albums',
        style: TextStyle(color: Colors.white, fontSize: 18.0),
      ),
    ),
  ),
  Tab(
    child: Container(
      child: Text(
        'Genres',
        style: TextStyle(color: Colors.white, fontSize: 18.0),
      ),
    ),
  ),
];