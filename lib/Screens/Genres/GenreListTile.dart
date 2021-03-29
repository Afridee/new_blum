import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';

class GenreListTile extends StatelessWidget {

  final GenreInfo genreInfo;

  const GenreListTile({Key key,@required this.genreInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(genreInfo.name),
    );
  }
}
