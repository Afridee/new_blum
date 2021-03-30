import 'dart:ui';
import 'package:audio_service/audio_service.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:blum/Controllers/AudioPlayer.dart';
import '../../constants.dart';
import 'package:blum/main.dart';

class AudioPlayer extends StatefulWidget {
  @override
  _AudioPlayerState createState() => _AudioPlayerState();
}

class _AudioPlayerState extends State<AudioPlayer>
    with SingleTickerProviderStateMixin {
  final audioPlayerController = Get.put(AudioPlayerController());

  @override
  void initState() {
    audioPlayerController.playPauseAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    super.initState();
  }

  @override
  void dispose() {
    audioPlayerController.playPauseAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    audioPlayerController.initializeStreams();
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Color(0xff1f2128)),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: GetBuilder<AudioPlayerController>(
                builder: (apc) {
                  return CachedNetworkImage(
                      imageUrl: apc.currentSong.albumArtwork.toString(),
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Image.asset(
                            'assets/images/image_1.jfif',
                            fit: BoxFit.cover,
                          ));
                },
              ),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration:
                    BoxDecoration(color: Color(0xff1f2128).withOpacity(0.9)),
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 40.0, left: 20, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: Icon(Icons.arrow_back_ios),
                              color: Colors.white,
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.more_horiz),
                              color: Colors.white,
                              onPressed: () {},
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 40.0),
                        child: Container(
                          height: 250,
                          width: 250,
                          child: ClipOval(
                            child: GetBuilder<AudioPlayerController>(
                              builder: (apc) {
                                return CachedNetworkImage(
                                    imageUrl:
                                        apc.currentSong.albumArtwork.toString(),
                                    fit: BoxFit.cover,
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                          'assets/images/image_1.jfif',
                                          fit: BoxFit.cover,
                                        ));
                              },
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 15.0, left: 15, right: 15),
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          child: GetBuilder<AudioPlayerController>(
                            builder: (apc) {
                              return Center(
                                child: AutoSizeText(
                                  apc.currentSong.title.toString(),
                                  style: song_title_style_3,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      GetBuilder<AudioPlayerController>(builder: (apc) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            apc.currentSong.artist.toString(),
                            style: Artist_title_style_1,
                            textAlign: TextAlign.center,
                          ),
                        );
                      }),
                      GetBuilder<AudioPlayerController>(builder: (apc) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: Color(0xff6F2CFF),
                              inactiveTrackColor:
                                  Color(0xff6F2CFF).withOpacity(0.3),
                              trackShape: RectangularSliderTrackShape(),
                              trackHeight: 6.0,
                              thumbColor: Colors.white,
                              thumbShape: RoundSliderThumbShape(
                                  enabledThumbRadius: 7.0),
                              overlayColor: Color(0xff6F2CFF).withAlpha(32),
                              overlayShape:
                                  RoundSliderOverlayShape(overlayRadius: 20.0),
                            ),
                            child: Slider(
                              min: 0,
                              max: 100,
                              value: apc.dragPercentage,
                              onChanged: (value) {
                                audioPlayerController
                                    .changeDragPercantage(value);
                              },
                            ),
                          ),
                        );
                      }),
                      Padding(
                        padding: EdgeInsets.only(left: 25, right: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GetBuilder<AudioPlayerController>(builder: (apc) {
                              return Text(
                                apc.currentSongPosition.toString(),
                                style: seek_style,
                              );
                            }),
                            GetBuilder<AudioPlayerController>(builder: (apc) {
                              return Text(
                                apc.currentSongDuration.toString(),
                                style: seek_style,
                              );
                            }),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 40, left: 25, right: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                             GetBuilder<AudioPlayerController>(builder: (apc){
                               return IconButton(
                                 iconSize: 20,
                                 icon: Icon(Icons.shuffle),
                                 color: AudioService.playbackState.shuffleMode == AudioServiceShuffleMode.all? Color(0xff6F2CFF) : Colors.white,
                                 onPressed: () {
                                   if(AudioService.playbackState.shuffleMode == AudioServiceShuffleMode.none){
                                     AudioService.setShuffleMode(AudioServiceShuffleMode.all);
                                   }else if(AudioService.playbackState.shuffleMode == AudioServiceShuffleMode.all){
                                     AudioService.setShuffleMode(AudioServiceShuffleMode.none);
                                   }
                                 },
                               );
                             }),
                            IconButton(
                              icon: Icon(Icons.skip_previous),
                              iconSize: 40,
                              color: Colors.white.withOpacity(0.7),
                              onPressed: () async{
                                await AudioService.skipToPrevious();
                              },
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Color(0xff6F2CFF),
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xff6F2CFF).withOpacity(0.3),
                                      spreadRadius: 3,
                                      blurRadius: 8,
                                      offset: Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ]),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: IconButton(
                                  icon: AnimatedIcon(
                                    icon: AnimatedIcons.play_pause,
                                    progress: audioPlayerController
                                        .playPauseAnimationController,
                                  ),
                                  color: Colors.white,
                                  iconSize: 35,
                                  onPressed: () {
                                    audioPlayerController.playPauseToggle();
                                  },
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.skip_next),
                              iconSize: 40,
                              color: Colors.white.withOpacity(0.7),
                              onPressed: () async{
                                await AudioService.skipToNext();
                              },
                            ),
                            GetBuilder<AudioPlayerController>(builder: (apc){
                              return IconButton(
                                icon: AudioService.playbackState.repeatMode == AudioServiceRepeatMode.all || AudioService.playbackState.repeatMode == AudioServiceRepeatMode.none ? Icon(Icons.repeat) : Icon(Icons.repeat_one),
                                color: AudioService.playbackState.repeatMode == AudioServiceRepeatMode.none ? Colors.white : Color(0xff6F2CFF),
                                iconSize: 20,
                                onPressed: () {
                                  audioPlayerController.loopToggle();
                                },
                              );
                            })
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: GetBuilder<AudioPlayerController>(
                builder: (apc) {
                  return player.playing
                      ? Container(
                          height: 60,
                          width: MediaQuery.of(context).size.width,
//                          child: WaveWidget(
//                            isLoop: true,
//                            waveFrequency: 4,
//                            config: CustomConfig(
//                              gradients: [
//                                [
//                                  Color(0xff6F2CFF).withOpacity(0.07),
//                                  Color(0xff6F2CFF).withOpacity(0.07)
//                                ],
//                                [
//                                  Color(0xff6F2CFF).withOpacity(0.07),
//                                  Color(0xff6F2CFF).withOpacity(0.07)
//                                ],
//                                [
//                                  Color(0xff6F2CFF).withOpacity(0.07),
//                                  Color(0xff6F2CFF).withOpacity(0.07)
//                                ],
//                                [
//                                  Color(0xff6F2CFF).withOpacity(0.07),
//                                  Color(0xff6F2CFF).withOpacity(0.07)
//                                ]
//                              ],
//                              durations: [1000, 2000, 3000, 4000],
//                              heightPercentages: [0.20, 0.23, 0.25, 0.30],
//                              blur: MaskFilter.blur(BlurStyle.solid, 10),
//                              gradientBegin: Alignment.bottomLeft,
//                              gradientEnd: Alignment.topRight,
//                            ),
//                            waveAmplitude: 0,
//                            size: Size(
//                              double.infinity,
//                              60,
//                            ),
//                          ),
                        )
                      : Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                          gradient: LinearGradient(colors: [
                            Color(0xff1f2128).withOpacity(0.07),
                            Color(0xff6F2CFF).withOpacity(0.07),
                            Color(0xff1f2128).withOpacity(0.07)
                          ]),
                          //color: Color(0xff6F2CFF).withOpacity(0.07)
                        ),
                      );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
