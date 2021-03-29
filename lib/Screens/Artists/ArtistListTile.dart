import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

import '../../constants.dart';

class ArtistListTile extends StatelessWidget {

  final ArtistInfo artistInfo;

  const ArtistListTile({Key key,@required this.artistInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final Box<String> ArtistArtBox = Hive.box<String>("ArtistArtBox");

    return InkWell(
      onTap: (){
        print(artistInfo.artistArtPath);
      },
      child: ListTile(
        leading: Container(
          height: 50,
          width: 50,
          child: ClipOval(
            child: ArtistArtBox.containsKey(artistInfo.name) &&
                ArtistArtBox.get(artistInfo.name).isNotEmpty
                ? CachedNetworkImage(
                imageUrl: ArtistArtBox.get(artistInfo.name),
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
        title: Text(artistInfo.name, style: song_title_style_1),
      ),
    );
  }
}


