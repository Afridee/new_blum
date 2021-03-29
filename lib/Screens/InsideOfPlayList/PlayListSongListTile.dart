import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../../Controllers/Actions.dart';
import '../../Controllers/AudioPlayer.dart';
import '../../Controllers/AudioQuerying.dart';
import '../../Models/songModelForPlaylist.dart';
import '../../Screens/AudioPlayer/AudioPlayer.dart';

import '../../constants.dart';

class PlayListSongListTile extends StatelessWidget {
  final Map playList;
  final SongModelForPLayList songInfo;
  final int index;

  const PlayListSongListTile({Key key,@required this.songInfo,@required this.index,@required this.playList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final  audioPlayerController = Get.put(AudioPlayerController());
    final audioQuerying = Get.put(AudioQuerying());
    final appActions = Get.put(AppActions());
    final Box<String> AlbumArtworkBox = Hive.box<String>("AlbumArtworkBox");

    return InkWell(
      onTap: (){
        audioPlayerController.setAudioSourceForPlayList(songList: playList.values.first, index: index);
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
        title: Text(songInfo.title, style: song_title_style_4,),
        subtitle: Text(audioQuerying.changeMillisecondsToTime(
            Duration(milliseconds: int.parse(songInfo.duration))), style: duration_style_2),
      ),
    );
  }
}
