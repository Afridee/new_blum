import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:blum/Controllers/AudioQuerying.dart';

import '../../constants.dart';

class AlbumListTile extends StatelessWidget {

  final AlbumInfo albumInfo;

  const AlbumListTile({Key key,@required this.albumInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Box<String> AlbumArtworkBox = Hive.box<String>("AlbumArtworkBox");

    return InkWell(
      onTap: (){
        print(albumInfo);
      },
      child: ListTile(
        leading: Container(
          height: 50,
          width: 50,
          child: ClipOval(
            child: AlbumArtworkBox.containsKey(albumInfo.title) &&
                AlbumArtworkBox.get(albumInfo.title).isNotEmpty
                ? CachedNetworkImage(
                imageUrl: AlbumArtworkBox.get(albumInfo.title),
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => Image.asset(
                  'assets/images/image_1.jfif',
                  fit: BoxFit.cover,
                )
            )
                : Image.asset(
              'assets/images/image_1.jfif',
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(albumInfo.title, style: song_title_style_1,),
      ),
    );
  }
}

