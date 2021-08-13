import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_svg/svg.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff6F2CFF),
      body: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/images/icon.svg',
            alignment: Alignment.center,
            fit: BoxFit.cover,
          ),
          Text("Blum",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20
          ),
          )
        ],
      )),
    );
  }
}

class Init {
  Init._();
  static final instance = Init._();
    Future initialize() async {
    await Future.delayed(Duration(seconds: 3));
  }
}


