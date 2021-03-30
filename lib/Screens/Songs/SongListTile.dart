import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../../Controllers/AudioPlayer.dart';
import '../../Controllers/AudioQuerying.dart';
import '../../Screens/AudioPlayer/AudioPlayer.dart';
import '../../constants.dart';
import '../../main.dart';

class SongListTile extends StatelessWidget {
  final SongInfo songInfo;

  const SongListTile({Key key, this.songInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audioQuerying = Get.put(AudioQuerying());
    final  audioPlayerController = Get.put(AudioPlayerController());
    final Box<String> AlbumArtworkBox = Hive.box<String>("AlbumArtworkBox");

    return InkWell(
      onTap: (){
        // print('filepath: '+songInfo.filePath);
        audioPlayerController.setAudioSourceForSongs(song: songInfo);
        var route = new MaterialPageRoute(
          builder: (BuildContext context) => new AudioPlayer(),
        );
        Navigator.of(context).push(route);
      },
      child: ListTile(
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
      ),
    );
  }
}
