import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_garage/activities/home_screen/dash_page.dart';
import 'package:smart_garage/activities/home_screen/door_page.dart';
import 'package:smart_garage/activities/home_screen/lighting_page.dart';
import 'package:smart_garage/activities/home_screen/user_page.dart';
import 'package:smart_garage/utils/bottom_navigation_bar_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  var currentTabs = [
    const DashPage(),
    const DoorPage(),
    const LightingPage(),
    UserPage(),
  ];

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<BottomNavigationBarProvider>(context);
    return Scaffold(
      body: currentTabs[provider.currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: provider.currentIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.black26,
          onTap: (index) {
            provider.currentIndex = index;
          },
          items: [
            BottomNavigationBarItem(
              icon: new Icon(Icons.home),
              label: 'Dash',
              backgroundColor: Colors.cyan,
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.door_back_door_outlined),
              label: 'Door',
              backgroundColor: Colors.cyan,
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.light),
              label: 'Lights',
              backgroundColor: Colors.cyan,
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.people),
              label: 'User',
              backgroundColor: Colors.cyan,
            ),
          ]),
    );
  }
}
