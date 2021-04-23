import 'package:auto_size_text/auto_size_text.dart';
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

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(60),
            color: Colors.black
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 80,
              width: 80,
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
            SizedBox(
              height: 10,
            ),
            Container(
              child: Center(child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: AutoSizeText(albumInfo.title, style: song_title_style_1, overflow: TextOverflow.ellipsis,),
              )), width: 120, height: 40,)
          ],
        ),
      ),
    );
  }
}



