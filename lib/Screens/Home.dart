import 'package:auto_size_text/auto_size_text.dart';
import 'package:blum/Controllers/Actions.dart';
import 'package:blum/Controllers/AudioPlayer.dart';
import 'package:blum/Controllers/AudioQuerying.dart';
import 'package:blum/Screens/AudioPlayer/AudioPlayer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../Screens/Albums/Albums.dart';
import '../Screens/Artists/Artists.dart';
import '../Screens/PlayLists/PlayLists.dart';
import '../Screens/Songs/Songs.dart';
import '../constants.dart';
import 'package:audio_service/audio_service.dart';

import '../Equalizer.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PageController pageController;
  final AudioPlayerController audioPlayerController = Get.put(AudioPlayerController());
  final AppActions actions = Get.put(AppActions());
  final Box<String> AlbumArtworkBox = Hive.box<String>("AlbumArtworkBox");
  final AudioQuerying audioQuerying = Get.put(AudioQuerying());

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
      length: 4,
      child: Scaffold(
        backgroundColor: Color(0xff1f2128),
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(icon: Icon(Icons.equalizer_rounded, color: Colors.white, size: 35,), onPressed: (){
                var route = new MaterialPageRoute(
                  builder: (BuildContext context) => new Eqlzr(),
                );
                Navigator.of(context).push(route);
              }),
            )
          ],
          centerTitle: false,
          title: GetBuilder<AppActions>(
            builder: (aaContext){
              return AnimatedContainer(
                width: aaContext.searchBarwidth,
                duration: Duration (milliseconds: 500),
                decoration: BoxDecoration(
                    color: Color(0xff0f0f0f).withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20)
                ),
                child: aaContext.search? TextField(
                  onChanged: (value){
                    audioQuerying.Search(value);
                  },
                  style: TextStyle(
                      color: Colors.white
                  ),
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Colors.white),
                      suffixIcon: IconButton(icon: Icon(Icons.cancel, color: Colors.white.withOpacity(0.5)), onPressed: (){
                        actions.searchStat(context);
                      }),
                      border: InputBorder.none,
                      hintText: 'Search for songs...',
                      hintStyle: TextStyle(
                          color: Colors.white
                      )
                  ),
                ) : IconButton(icon: Icon(Icons.search, color: Colors.white), onPressed: (){
                    actions.searchStat(context);
                }),
              );
            }
          ),
          elevation: 0,
          backgroundColor: Color(0xff1f2128),
          bottom: TabBar(
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(
                color: Color(0xff6F2CFF),
                    width: 4.0
              ),
              insets: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0)
            ),
            isScrollable: true,
            indicatorColor: Color(0xff6F2CFF),
            indicatorWeight: 6,
            onTap: (index) {
              bottomBarOnTap(index);
            },
            tabs: Tabs,
          ),
        ),
        body: PageView(
          controller: pageController,
          physics: NeverScrollableScrollPhysics(),
          children: [Songs(), PlayLists(), Artists(), Albums()],
        ),
        bottomNavigationBar: GetBuilder<AudioPlayerController>(
          builder: (apc) {
            return AudioService.running
                ? Container(
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xff1f2128),
                          spreadRadius: 8,
                          blurRadius: 5,
                          offset: Offset(
                              0, 0), // changes position of shadow
                        ),
                      ]
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Color(0xff0f0f0f)),
                      height: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: 70,
                            width: 70,
                            child: ClipOval(
                              child: AlbumArtworkBox.containsKey(
                                          apc.currentSong.album) &&
                                      AlbumArtworkBox.get(apc.currentSong.album)
                                          .isNotEmpty
                                  ? CachedNetworkImage(
                                      imageUrl: AlbumArtworkBox.get(
                                          apc.currentSong.album),
                                      fit: BoxFit.cover,
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                            'assets/images/image_1.jfif',
                                            fit: BoxFit.cover,
                                          ))
                                  : Image.asset(
                                      'assets/images/image_1.jfif',
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          Column(
                            children: [
                              GetBuilder<AudioPlayerController>(
                                builder: (apc) {
                                  return Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Container(
                                      width: 150,
                                      height: 30,
                                      child: Center(
                                        child: AutoSizeText(
                                          apc.currentSong.title.toString(),
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          minFontSize: 13,
                                          style: TextStyle(
                                              fontFamily: 'Nunito',
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.skip_previous),
                                    iconSize: 20,
                                    color: Colors.white,
                                    onPressed: () async {
                                      if (AudioService.running)
                                        await AudioService.skipToPrevious();
                                    },
                                  ),
                                  GetBuilder<AudioPlayerController>(
                                      builder: (apc) {
                                    return IconButton(
                                      icon: apc.Mini_play_pause,
                                      color: Colors.white,
                                      iconSize: 35,
                                      onPressed: () {
                                        audioPlayerController.playPauseToggle();
                                      },
                                    );
                                  }),
                                  IconButton(
                                    icon: Icon(Icons.skip_next),
                                    iconSize: 20,
                                    color: Colors.white,
                                    onPressed: () async {
                                      if (AudioService.running)
                                        await AudioService.skipToNext();
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          IconButton(
                            icon: Icon(Icons.expand),
                            iconSize: 30,
                            color: Color(0xff6F2CFF),
                            onPressed: () async {
                              if (AudioService.running) {
                                var route = new MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      new AudioPlayer(),
                                );
                                Navigator.of(context).push(route);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                : Container(height: 0, width: 0);
          },
        ),
      ),
    );
  }
}
