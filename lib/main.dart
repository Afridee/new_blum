import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'AudioPlayerTask.dart';
import 'Screens/Home.dart';



// NOTE: Your entrypoint MUST be a top-level function.
void audioPlayerTaskEntrypoint() async {
  AudioServiceBackground.run(() => AudioPlayerTask());
}


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Directory Document = await getApplicationDocumentsDirectory();
  Hive.init(Document.path);
  await Hive.openBox<String>('AlbumArtworkBox');
  await Hive.openBox<String>('ArtistArtBox');
  await Hive.openBox<List<dynamic>>('PlaylistBox');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AudioServiceWidget(child: Home()) ,
    );
  }
}

