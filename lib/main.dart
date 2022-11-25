import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_garage/activities/splash_screen.dart';
import 'package:smart_garage/utils/bottom_navigation_bar_provider.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:smart_garage/utils/config.dart';

import 'dart:io' show Platform;

import 'package:smart_garage/utils/preference_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  State<MyApp> createState() {
    return _MyApp();
  }
}

class _MyApp extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      OneSignal.shared.setLogLevel(OSLogLevel.debug, OSLogLevel.none);
      OneSignal.shared.setAppId(Config.API_KEY);
      OneSignal.shared
          .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
        Log.log(Log.TAG_OPEN_SIGNAL, "Token ${changes.to.userId}", Log.I);
        String? userId = changes.to.userId ?? '';
        if (userId != '') {
          Config.saveToStorage(Config.KEY_DEVICE_ID, userId);
        }
      });
      final status = OneSignal.shared.getDeviceState();
      status.then((value) {
        final String osUserID = value?.userId ?? "";
        Log.log(Log.TAG_OPEN_SIGNAL, "Token $osUserID", Log.I);
      });
      OneSignal.shared
          .promptUserForPushNotificationPermission()
          .then((value) => {});
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BottomNavigationBarProvider>(
          create: (context) => BottomNavigationBarProvider(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.cyan,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
