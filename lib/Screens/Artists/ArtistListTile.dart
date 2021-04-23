import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

import '../../constants.dart';

class ArtistListTile extends StatelessWidget {
  final ArtistInfo artistInfo;

  const ArtistListTile({Key key, @required this.artistInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Box<String> ArtistArtBox = Hive.box<String>("ArtistArtBox");

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(60), color: Colors.black),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 80,
              width: 80,
              child: ClipOval(
                child: ArtistArtBox.containsKey(artistInfo.name) &&
                        ArtistArtBox.get(artistInfo.name).isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: ArtistArtBox.get(artistInfo.name),
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => Image.asset(
                              'assets/images/image_1.jfif',
                              fit: BoxFit.cover,
                            ))
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
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AutoSizeText(
                    artistInfo.name,
                    style: song_title_style_1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              width: 120,
              height: 40,
            )
          ],
        ),
      ),
    );
  }
}
