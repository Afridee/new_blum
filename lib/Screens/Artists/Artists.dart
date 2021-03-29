import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ArtistList.dart';

class Artists extends StatefulWidget {
  @override
  _ArtistsState createState() => _ArtistsState();
}

class _ArtistsState extends State<Artists> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Color(0xff192462),
      child: Center(
        child: ArtistList(),
      ),
    );
  }
}


