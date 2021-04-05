import 'package:blum/Controllers/AudioPlayer.dart';
import 'package:blum/Screens/AudioPlayer/AudioPlayer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Screens/Albums/Albums.dart';
import '../Screens/Artists/Artists.dart';
import '../Screens/Genres/Genres.dart';
import '../Screens/PlayLists/PlayLists.dart';
import '../Screens/Songs/Songs.dart';
import '../constants.dart';
import 'package:audio_service/audio_service.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>{
  PageController pageController;
  final AudioPlayerController audioPlayerController =
      Get.put(AudioPlayerController());

  @override
  void initState() {
    audioPlayerController.initializeStreams();
    pageController = PageController(initialPage: 0);
    super.initState();
  }

  bottomBarOnTap(int pageIndex) {
    pageController.animateToPage(
      pageIndex,
      duration: Duration(milliseconds: 200),
      curve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(0xff192462),
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: Color(0xff566acd),
            indicatorWeight: 6.0,
            onTap: (index) {
              bottomBarOnTap(index);
            },
            tabs: Tabs,
          ),
        ),
        body: PageView(
          controller: pageController,
          physics: NeverScrollableScrollPhysics(),
          children: [Songs(), PlayLists(), Artists(), Albums(), Genres()],
        ),
        bottomNavigationBar:  GetBuilder<AudioPlayerController>(
          builder: (apc){
           return apc.currentSong.title!=null ? Container(
              color: Colors.white,
              height: 130,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  GetBuilder<AudioPlayerController>(
                    builder: (apc){
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(apc.currentSong.title.toString()),
                      );
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(Icons.skip_previous),
                        iconSize: 20,
                        color: Colors.black,
                        onPressed: () async {
                          if (AudioService.running)
                            await AudioService.skipToPrevious();
                        },
                      ),
                      GetBuilder<AudioPlayerController>(
                          builder: (apc){
                            return IconButton(
                              icon: apc.Mini_play_pause,
                              color: Colors.black,
                              iconSize: 35,
                              onPressed: () {
                                audioPlayerController.playPauseToggle();
                              },
                            );
                          }
                      ),
                      IconButton(
                        icon: Icon(Icons.skip_next),
                        iconSize: 20,
                        color: Colors.black,
                        onPressed: () async {
                          if (AudioService.running) await AudioService.skipToNext();
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.expand),
                        iconSize: 20,
                        color: Colors.black,
                        onPressed: () async {
                          if(AudioService.running){
                            var route = new MaterialPageRoute(
                              builder: (BuildContext context) => new AudioPlayer(),
                            );
                            Navigator.of(context).push(route);
                          }
                        },
                      ),
                    ],
                  ),
                  GetBuilder<AudioPlayerController>(builder: (apc) {
                    return SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: Color(0xff6F2CFF),
                        inactiveTrackColor: Color(0xff6F2CFF).withOpacity(0.3),
                        trackShape: RectangularSliderTrackShape(),
                        trackHeight: 6.0,
                        thumbColor: Colors.white,
                        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 7.0),
                        overlayColor: Color(0xff6F2CFF).withAlpha(32),
                        overlayShape: RoundSliderOverlayShape(overlayRadius: 20.0),
                      ),
                      child: Slider(
                        min: 0,
                        max: 100,
                        value: apc.dragPercentage,
                        onChanged: (value) {
                          audioPlayerController.changeDragPercantage(value);
                        },
                      ),
                    );
                  })
                ],
              ),
            ) : Container(height: 0, width: 0);
          },
        ),
      ),
    );
  }
}
