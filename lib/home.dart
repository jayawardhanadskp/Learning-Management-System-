import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import "package:persistent_bottom_nav_bar/persistent_tab_view.dart";
import 'Lecture Schedules.dart';
import 'LectureMaterials.dart';
import 'account.dart';
import 'marks.dart';
import 'login.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PersistentTabController _controller = PersistentTabController(initialIndex: 0);
  FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((User? user) {
      setState(() {
        _user = user;
      });
    });
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.book),
        title: "Materials",
        activeColorPrimary: Colors.purple,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.schedule),
        title: "Schedules",
        activeColorPrimary: Colors.purple,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.assessment_rounded),
        title: "Marks",
        activeColorPrimary: Colors.purple,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.account_circle),
        title: "Account",
        activeColorPrimary: Colors.purple,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return Login();
    } else {
      return PersistentTabView(
        context,
        controller: _controller,
        screens: [
          LectureMaterials(),
          LectureSchedules(),
          Marks(),
          Account(),
        ],
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: Colors.white,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        hideNavigationBarWhenKeyboardShows: true,
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(10.0),
          colorBehindNavBar: Colors.white,
        ),
        popAllScreensOnTapOfSelectedTab: true,
        itemAnimationProperties: ItemAnimationProperties(
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimation(
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle: NavBarStyle.style9,
      );
    }
  }
}
