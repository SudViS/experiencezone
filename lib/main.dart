// @dart=2.9
import 'dart:async';
import 'package:animations/animations.dart';
import 'package:experiencezone/screens/banner_screen.dart';
import 'package:experiencezone/screens/splash_screen.dart';
import 'package:experiencezone/screens/webview_screen.dart';
import 'package:experiencezone/screens/zonehome_screen.dart';
import 'package:experiencezone/utils/light_color.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:responsive_framework/utils/scroll_behavior.dart';
import 'widget/CrossClipper.dart';
import 'dart:io' show Platform;
import 'config/config.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// flutter build web --release --web-renderer html
// flutter build web --release --web-renderer canvaskit

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (defaultTargetPlatform == TargetPlatform.iOS) {

    await Firebase.initializeApp();
    runApp(MaterialApp(
      builder: (context, widget) => ResponsiveWrapper.builder(
        BouncingScrollWrapper.builder(context, widget),
        defaultScale: true,
        breakpoints: const [
          ResponsiveBreakpoint.resize(480, name: MOBILE),
          ResponsiveBreakpoint.autoScale(800, name: TABLET),
          ResponsiveBreakpoint.resize(1000, name: DESKTOP),
          ResponsiveBreakpoint.autoScale(2460, name: '4K'),
        ],
      ),
      title: 'Experience Zone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: BannerScreen(),
      //home: ZoneHomeScreen(),
      //home: const SplashScrenn(),
      // routes: {
      //   '/home': (context) => const HomeScreen(),
      //   '/level': (context) => const LevelsScreen()
      // }
    ));

  }
  // else if (defaultTargetPlatform == TargetPlatform.macOS) {
  //
  //   Firebase.initializeApp();
  //   runApp(MaterialApp(
  //     builder: (context, widget) => ResponsiveWrapper.builder(
  //       BouncingScrollWrapper.builder(context, widget),
  //       defaultScale: true,
  //       breakpoints: const [
  //         ResponsiveBreakpoint.resize(480, name: MOBILE),
  //         ResponsiveBreakpoint.autoScale(800, name: TABLET),
  //         ResponsiveBreakpoint.resize(1000, name: DESKTOP),
  //         ResponsiveBreakpoint.autoScale(2460, name: '4K'),
  //       ],
  //     ),
  //     title: 'Covid Kill',
  //     debugShowCheckedModeBanner: false,
  //     theme: ThemeData.dark(),
  //     //home: ZoneHomeScreen(),
  //     home: BannerScreen(),
  //     //home: const SplashScrenn(),
  //     // routes: {
  //     //   '/home': (context) => const HomeScreen(),
  //     //   '/level': (context) => const LevelsScreen()
  //     // }
  //   ));
  //
  // }
  // else if (defaultTargetPlatform == TargetPlatform.android) {
  //
  //   await Firebase.initializeApp();
  //   runApp(MaterialApp(
  //     builder: (context, widget) => ResponsiveWrapper.builder(
  //       BouncingScrollWrapper.builder(context, widget),
  //       defaultScale: true,
  //       breakpoints: const [
  //         ResponsiveBreakpoint.resize(480, name: MOBILE),
  //         ResponsiveBreakpoint.autoScale(800, name: TABLET),
  //         ResponsiveBreakpoint.resize(1000, name: DESKTOP),
  //         ResponsiveBreakpoint.autoScale(2460, name: '4K'),
  //       ],
  //     ),
  //     title: 'Experience Zone',
  //     debugShowCheckedModeBanner: false,
  //     theme: ThemeData.dark(),
  //     //home: ZoneScreen(),
  //     home: BannerScreen(),
  //     //home: const SplashScrenn(),
  //     // routes: {
  //     //   '/home': (context) => const HomeScreen(),
  //     //   '/level': (context) => const LevelsScreen()
  //     // }
  //   ));
  //
  // }
  else {

    print("Web Version Ready");
    //final configurations = Configurations();
    // await Firebase.initializeApp(
    //     // Replace with actual values
    //     options: FirebaseOptions(
    //         apiKey: configurations.apiKey,
    //         appId: configurations.appId,
    //         messagingSenderId: configurations.messagingSenderId,
    //         projectId: configurations.projectId));
    runApp(MaterialApp(
      builder: (context, widget) => ResponsiveWrapper.builder(
        BouncingScrollWrapper.builder(context, widget),
        defaultScale: true,
        breakpoints: const [
          ResponsiveBreakpoint.resize(480, name: MOBILE),
          ResponsiveBreakpoint.autoScale(800, name: TABLET),
          ResponsiveBreakpoint.resize(1000, name: DESKTOP),
          ResponsiveBreakpoint.autoScale(2460, name: '4K'),
        ],
      ),
      title: 'Experience Zone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      //home: BannerScreen(),
      home: ZoneHomeScreen(),
      //home: const SplashScrenn(),
      // routes: {
      //   '/home': (context) => const HomeScreen(),
      //   '/level': (context) => const LevelsScreen()
      // }
    ));

  }

}
