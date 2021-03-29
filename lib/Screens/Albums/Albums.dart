import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'AlbumList.dart';

class Albums extends StatefulWidget {
  @override
  _AlbumsState createState() => _AlbumsState();
}

class _AlbumsState extends State<Albums> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Color(0xff192462),
      child: Center(
        child: AlbumList(),
      ),
    );
  }
}
