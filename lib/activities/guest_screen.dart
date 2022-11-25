import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_garage/activities/home_screen/dash_page.dart';
import 'package:smart_garage/activities/home_screen/door_page.dart';
import 'package:smart_garage/activities/home_screen/lighting_page.dart';
import 'package:smart_garage/utils/bottom_navigation_bar_provider.dart';

class GuestScreen extends StatefulWidget {
  const GuestScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<GuestScreen> createState() {
    return _GuestScreenState();
  }
}

class _GuestScreenState extends State<GuestScreen> {
  var currentTabs = [
    const DashPage(),
    const DoorPage(),
    const LightingPage(),
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
          backgroundColor: Colors.cyan,
          onTap: (index) {
            provider.currentIndex = index;
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Dash',
              backgroundColor: Colors.cyan,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.door_back_door_outlined),
              label: 'Door',
              backgroundColor: Colors.cyan,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.light),
              label: 'Lights',
              backgroundColor: Colors.cyan,
            ),
          ]),
    );
  }
}
