import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:blum/Controllers/AudioPlayer.dart';
import 'package:blum/Controllers/AudioQuerying.dart';
import 'package:blum/Controllers/chooseSongsForPlayList.dart';
import 'package:blum/Screens/AudioPlayer/AudioPlayer.dart';
import '../../../constants.dart';

class ChooseSongsToAdd_ListTile extends StatelessWidget {
  final SongInfo songInfo;

  const ChooseSongsToAdd_ListTile({Key key, this.songInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audioQuerying = Get.put(AudioQuerying());
    final Box<String> AlbumArtworkBox = Hive.box<String>("AlbumArtworkBox");
    final ChooseSongsForPlaylistController chooseSongsForPlaylistController = Get.put(ChooseSongsForPlaylistController());


    return GetBuilder<ChooseSongsForPlaylistController>(builder: (csfpc){
      return ListTile(
        onTap: (){
          chooseSongsForPlaylistController.addRemoveToggle(songInfo);
        },
        trailing: csfpc.selected.contains(songInfo) ? Icon(Icons.check_circle, color: Color(0xff6F2CFF),size: 30,) : Container(height: 0, width: 0,),
        leading: Container(
          height: 50,
          width: 50,
          child: ClipOval(
            child: AlbumArtworkBox.containsKey(songInfo.album) &&
                AlbumArtworkBox.get(songInfo.album).isNotEmpty
                ? CachedNetworkImage(
                imageUrl: AlbumArtworkBox.get(songInfo.album),
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
        title: Text(songInfo.title, style: song_title_style_1,),
        subtitle: Text(audioQuerying.changeMillisecondsToTime(
            Duration(milliseconds: int.parse(songInfo.duration))), style: duration_style_1),
      );
    });
  }
}
