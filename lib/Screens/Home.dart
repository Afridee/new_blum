import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Screens/Albums/Albums.dart';
import '../Screens/Artists/Artists.dart';
import '../Screens/Genres/Genres.dart';
import '../Screens/PlayLists/PlayLists.dart';
import '../Screens/Songs/Songs.dart';
import '../constants.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PageController pageController;


  @override
  void initState() {
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
          children: [Songs(),PlayLists(),Artists(),Albums(),Genres()],
        ),
      ),
    );
  }
}
