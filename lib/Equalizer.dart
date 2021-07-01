import 'dart:ui';

import 'package:blum/CustomEQ.dart';
import 'package:equalizer/equalizer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Eqlzr extends StatefulWidget {
  @override
  _EqlzrState createState() => _EqlzrState();
}

class _EqlzrState extends State<Eqlzr> {
  bool enableCustomEQ = false;

  @override
  void initState() {
    super.initState();
    Equalizer.init(0);
  }

  @override
  void dispose() {
    Equalizer.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1f2128).withOpacity(1),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xff1f2128).withOpacity(1),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: InkWell(
              onTap: () async {
                try {
                  await Equalizer.open(0);
                } on PlatformException catch (e) {
                  final snackBar = SnackBar(
                    behavior: SnackBarBehavior.floating,
                    content: Text('${e.message}\n${e.details}'),
                  );
                  Scaffold.of(context).showSnackBar(snackBar);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  // color: Colors.blueGrey,
                  border: Border.all(
                    width: 0.3,
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Open Device Equalier',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Icon(
                        CupertinoIcons.graph_circle,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),

          // SizedBox(height: 10.0),
          // Center(
          //   child: Builder(
          //     builder: (context) {
          //       return FlatButton.icon(
          //         icon: Icon(Icons.equalizer),
          //         label: Text('Open device equalizer'),
          //         color: Colors.blue,
          //         textColor: Colors.white,
          //         onPressed: () async {
          //           try {
          //             await Equalizer.open(0);
          //           } on PlatformException catch (e) {
          //             final snackBar = SnackBar(
          //               behavior: SnackBarBehavior.floating,
          //               content: Text('${e.message}\n${e.details}'),
          //             );
          //             Scaffold.of(context).showSnackBar(snackBar);
          //           }
          //         },
          //       );
          //     },
          //   ),
          // ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                // color: Colors.blueGrey,
                border: Border.all(
                  width: 0.3,
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: SwitchListTile(
                activeColor: Colors.green,
                inactiveTrackColor: Colors.grey,
                title: Text(
                  'Custom Equalizer',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                value: enableCustomEQ,
                onChanged: (value) {
                  Equalizer.setEnabled(value);
                  setState(() {
                    enableCustomEQ = value;
                  });
                },
              ),
            ),
          ),

          FutureBuilder<List<int>>(
            future: Equalizer.getBandLevelRange(),
            builder: (context, snapshot) {
              return snapshot.connectionState == ConnectionState.done
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomEQ(enableCustomEQ, snapshot.data),
                    )
                  : CircularProgressIndicator();
            },
          ),
        ],
      ),
    );
  }
}
