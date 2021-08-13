import 'package:audio_service/audio_service.dart';
import 'package:blum/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'AudioPlayerTask.dart';
import 'Screens/Home.dart';

// NOTE: Your entrypoint MUST be a top-level function.
void audioPlayerTaskEntrypoint() async {
  AudioServiceBackground.run(() => AudioPlayerTask());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory Document = await getApplicationDocumentsDirectory();
  Hive.init(Document.path);
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom, SystemUiOverlay.top]);
  await Hive.openBox<String>('AlbumArtworkBox');
  await Hive.openBox<String>('ArtistArtBox');
  await Hive.openBox<List<dynamic>>('PlaylistBox');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Init.instance.initialize(),
      builder: (context, AsyncSnapshot snapshot) {
// Show splash screen while waiting for app resources to load:
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Splash());
        } else {
// Loading is done, return the app:
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: AudioServiceWidget(child: Home()),
          );
        }
      },

    );
  }
}


