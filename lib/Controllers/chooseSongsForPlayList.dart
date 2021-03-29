import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:get/get.dart';

class ChooseSongsForPlaylistController extends GetxController{

  List<SongInfo> selected  = new  List<SongInfo>();

  addRemoveToggle(SongInfo song){
    selected.contains(song) ? selected.remove(song) : selected.add(song);
    update();
  }

  clearList(){
    selected.clear();
    update();
  }

}