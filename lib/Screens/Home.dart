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

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PageController pageController;
  final AudioPlayerController audioPlayerController = Get.put(AudioPlayerController());
  final AppActions actions = Get.put(AppActions());
  final Box<String> AlbumArtworkBox = Hive.box<String>("AlbumArtworkBox");


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
        drawer: Drawer(),
        backgroundColor: Color(0xff1f2128),
        appBar: AppBar(
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
                    print(value);
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
            isScrollable: true,
            indicatorColor: Color(0xff6F2CFF),
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
          children: [Songs(), PlayLists(), Artists(), Albums()],
        ),
        bottomNavigationBar: GetBuilder<AudioPlayerController>(
          builder: (apc) {
            return AudioService.running
                ? Padding(
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
                            // GetBuilder<AudioPlayerController>(builder: (apc) {
                            //   return SliderTheme(
                            //     data: SliderTheme.of(context).copyWith(
                            //       activeTrackColor: Color(0xff6F2CFF),
                            //       inactiveTrackColor: Color(0xff6F2CFF).withOpacity(0.3),
                            //       trackShape: RectangularSliderTrackShape(),
                            //       trackHeight: 6.0,
                            //       thumbColor: Colors.white,
                            //       thumbShape: RoundSliderThumbShape(enabledThumbRadius: 7.0),
                            //       overlayColor: Color(0xff6F2CFF).withAlpha(32),
                            //       overlayShape: RoundSliderOverlayShape(overlayRadius: 20.0),
                            //     ),
                            //     child: Slider(
                            //       min: 0,
                            //       max: 100,
                            //       value: apc.dragPercentage,
                            //       onChanged: (value) {
                            //         audioPlayerController.changeDragPercantage(value);
                            //       },
                            //     ),
                            //   );
                            // })
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
                )
                : Container(height: 0, width: 0);
          },
        ),
      ),
    );
  }
}
