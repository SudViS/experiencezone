import 'dart:async';
import 'dart:convert';
import 'package:animated_widgets/widgets/rotation_animated.dart';
import 'package:animated_widgets/widgets/shake_animated_widget.dart';
import 'package:animations/animations.dart';
import 'package:experiencezone/screens/banner_screen.dart';
import 'package:experiencezone/screens/quiz_screen.dart';
import 'package:experiencezone/screens/webview_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io' show Platform;

import '../animation/fadeAnimation.dart';
import 'funfacts_screen.dart';

import 'dart:ui' as ui;
class ZoneHomeScreen extends StatefulWidget {

  @override
  ZoneHomeScreenState createState() {
    return ZoneHomeScreenState();
  }

}

class ZoneHomeScreenState extends State<ZoneHomeScreen>
    with WidgetsBindingObserver  {

  String url = "";
  double progress = 0;
  late CurvedAnimation curve;
  late AnimationController controller;
  late WebViewController _webController;
  String defaultFontFamily = 'Montserrat';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late Timer _timer;
  final int _start = 300; // 5 minute
  late String timeString;
  late TimeOfDay _time ;

  late DateTime timeOfActivationInBackground ;
  late DateTime timeOfActivationInResume ;
  late Duration diff ;
  late int _currentTimer;

  @override
  void initState() {
    print("ZoneHome init");
    WidgetsBinding.instance.addObserver(this);
    startTimer(_start);
    super.initState();
  }

  void startTimer(int _start) {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        print(_start);
        if (_start == 0 || _start < 0) {

          clear();
          Navigator.of(context).pop();
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => BannerScreen()));

        } else {

          if (mounted) {
            setState(() {
              _start--;
              _currentTimer = _start;
            });
          }

        }
      },
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        if (!_timer.isActive) {
          setState(() {
            timeOfActivationInResume = DateTime.now();
            diff = timeOfActivationInResume.difference(timeOfActivationInBackground);
          });
          print(diff.inSeconds.toString()  + " in seconds");
          print(diff.inMinutes.toString()  + " in minutes");
          print("Activated Mode : ZoneHome Timer Restarted in Background");
          print(_currentTimer - diff.inSeconds);
          startTimer(_currentTimer - diff.inSeconds - 20);
          //_timer.cancel();
          //startTimer(300);
        }
        print("app is resumed");
        break;
      case AppLifecycleState.inactive:
        print("app is inactive");
        break;
      case AppLifecycleState.paused:
        if (_timer.isActive) {
          setState(() {
            timeOfActivationInBackground = DateTime.now();
          });
          _timer.cancel();
          // print("ZoneHome Timer Restarted in Background");
          // startTimer(30);
        }
        // else{
        //   _timer.cancel();
        //   print("ZoneHome Timer Activated in Background");
        //   startTimer(30);
        // }
        print(timeOfActivationInBackground.second);
        print("app is paused");
        break;
      case AppLifecycleState.detached:
        print("app is detached");
        break;
    }
  }


  @override
  Widget build(BuildContext context) {

    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.landscapeLeft,
    //   DeviceOrientation.landscapeRight,
    // ]);

    final double height_size = MediaQuery.of(context).size.height;
    final double width_size = MediaQuery.of(context).size.width;
    //print(height_size.toString() + " * " + width_size.toString());
    print("ZoneHome Screen ");

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        extendBodyBehindAppBar: false,
        body: GestureDetector(
          onTap: () {
          },
          child: Stack(
            children: <Widget>[

              width_size < 900
                  ? SingleChildScrollView(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/Background.png"),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 60,
                              ),

                              const SizedBox(
                                height: 90,
                              ),

                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                      child: Text(
                                        "SUD Life Experience Zone",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontFamily: defaultFontFamily,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  // const Spacer(),
                                  // Expanded(
                                  //   child: InkWell(
                                  //     onTap: () {
                                  //       // Navigator.push(
                                  //       //   context,
                                  //       //   MaterialPageRoute(
                                  //       //       // builder: (context) => ChessGame()),
                                  //       //       builder: (context) => SplashScrenn()),
                                  //       // );
                                  //     },
                                  //     child: Container(
                                  //       height: 60,
                                  //       width: 70,
                                  //       decoration: const BoxDecoration(
                                  //         color: Colors.white,
                                  //         borderRadius: BorderRadius.only(
                                  //             // topRight: Radius.circular(40.0),
                                  //             // bottomRight: Radius.circular(40.0),
                                  //             topLeft: Radius.circular(20.0),
                                  //             bottomLeft:
                                  //                 Radius.circular(20.0)),
                                  //       ),
                                  //       child: Container(
                                  //         height: 50,
                                  //         width: 100,
                                  //         margin: const EdgeInsets.all(12),
                                  //         decoration: const BoxDecoration(
                                  //           color: Colors.white,
                                  //           image: DecorationImage(
                                  //             image: AssetImage(
                                  //                 "assets/images/site-logo.png"),
                                  //             fit: BoxFit.contain,
                                  //           ),
                                  //         ),
                                  //         child: null,
                                  //       ),
                                  //     ),
                                  //   ),
                                  // )
                                ],
                              ),

                              const SizedBox(
                                height: 10,
                              ),

                              Column(
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),

                                  Row(
                                    children: [
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Expanded(
                                        child: OpenContainer(
                                          // transitionType: transitionType,
                                          transitionType:
                                              ContainerTransitionType.fade,
                                          transitionDuration:
                                              const Duration(milliseconds: 500),
                                          tappable: false,

                                          closedBuilder: (context,
                                                  VoidCallback openContainer) =>
                                              GestureDetector(
                                            onTap: () {
                                              restartTimer();
                                              print('Clicker : ');
                                              openContainer();
                                              // your onOpen code
                                            },
                                            child: Container(
                                              height: 160,
                                              width: 80,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                // borderRadius: BorderRadius
                                                //     .only(
                                                //     topRight:
                                                //     Radius.circular(0.0),
                                                //     bottomRight:
                                                //     Radius.circular(0.0),
                                                //     topLeft:
                                                //     Radius.circular(0.0),
                                                //     bottomLeft:
                                                //     Radius.circular(0.0)),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.white
                                                        .withOpacity(0.5),
                                                    spreadRadius: 5,
                                                    blurRadius: 7,
                                                    offset: const Offset(0,
                                                        3), // changes position of shadow
                                                  ),
                                                ],
                                              ),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    height: 40,
                                                    width: 40,
                                                    margin: const EdgeInsets
                                                            .fromLTRB(
                                                        30, 20, 30, 10),
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Colors.white,
                                                      image: DecorationImage(
                                                        image: AssetImage(
                                                            "assets/images/Group 3.png"),
                                                        fit: BoxFit.contain,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 60,
                                                    width: 160,
                                                    color: Colors.white,
                                                    child: Center(
                                                      child: Text(
                                                        'Buy \nOnline',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontFamily:
                                                                defaultFontFamily,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Color(
                                                                0xff2474b9)),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),

                                          closedElevation: 6.0,
                                          closedShape:
                                              const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(26 / 2),
                                            ),
                                          ),
                                          openBuilder: (context,
                                                  VoidCallback _) =>
                                              WebViewScreen(
                                                  key: _scaffoldKey,
                                                  title: 'Buy Online',
                                                  url_link:
                                                      'https://bol.sudlife.in/ProductSelection/ProductSelectionPage'),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Expanded(
                                        child: OpenContainer(
                                          // transitionType: transitionType,
                                          transitionType:
                                              ContainerTransitionType.fade,
                                          transitionDuration:
                                              const Duration(milliseconds: 500),
                                          tappable: false,

                                          closedBuilder: (context,
                                                  VoidCallback openContainer) =>
                                              GestureDetector(
                                            onTap: () {
                                              restartTimer();
                                              print('Clicker : ');
                                              openContainer();
                                              // your onOpen code
                                            },
                                            child: Container(
                                              height: 160,
                                              width: 80,
                                              //width: 200,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                // borderRadius: const BorderRadius
                                                //     .only(
                                                //     topRight:
                                                //     Radius.circular(20.0),
                                                //     bottomRight:
                                                //     Radius.circular(20.0),
                                                //     topLeft:
                                                //     Radius.circular(20.0),
                                                //     bottomLeft:
                                                //     Radius.circular(20.0)),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.white
                                                        .withOpacity(0.5),
                                                    spreadRadius: 5,
                                                    blurRadius: 7,
                                                    offset: Offset(0,
                                                        3), // changes position of shadow
                                                  ),
                                                ],
                                              ),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    height: 40,
                                                    width: 40,
                                                    margin: const EdgeInsets
                                                            .fromLTRB(
                                                        30, 20, 30, 10),
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Colors.white,
                                                      image: DecorationImage(
                                                        image: AssetImage(
                                                            "assets/images/Path 92.png"),
                                                        fit: BoxFit.contain,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 60,
                                                    width: 160,
                                                    color: Colors.white,
                                                    child: Center(
                                                      child: Text(
                                                        'Pay \nPremiums',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontFamily:
                                                                defaultFontFamily,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Color(
                                                                0xff2474b9)),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),

                                          closedElevation: 6.0,
                                          closedShape:
                                              const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(26 / 2),
                                            ),
                                          ),
                                          openBuilder: (context,
                                                  VoidCallback _) =>
                                              WebViewScreen(
                                                  key: _scaffoldKey,
                                                  title: 'Pay Premiums',
                                                  url_link:
                                                      'https://www.sudlife.in/customer-service/premium-payment-options'),



                                        ),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                    ],
                                  ),

                                  const SizedBox(
                                    height: 40,
                                  ),

                                  Row(
                                    children: [
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Expanded(
                                        child: OpenContainer(
                                          // transitionType: transitionType,
                                          transitionType:
                                              ContainerTransitionType.fade,
                                          transitionDuration:
                                              const Duration(milliseconds: 500),
                                          tappable: false,

                                          closedBuilder: (context,
                                                  VoidCallback openContainer) =>
                                              GestureDetector(
                                            onTap: () {
                                              restartTimer();
                                              print('Clicker : ');
                                              openContainer();
                                              // your onOpen code
                                            },
                                            child: Container(
                                              height: 160,
                                              width: 80,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                // borderRadius: const BorderRadius
                                                //     .only(
                                                //     topRight:
                                                //     Radius.circular(20.0),
                                                //     bottomRight:
                                                //     Radius.circular(20.0),
                                                //     topLeft:
                                                //     Radius.circular(20.0),
                                                //     bottomLeft:
                                                //     Radius.circular(20.0)),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.white
                                                        .withOpacity(0.5),
                                                    spreadRadius: 5,
                                                    blurRadius: 7,
                                                    offset: const Offset(0,
                                                        3), // changes position of shadow
                                                  ),
                                                ],
                                              ),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    height: 40,
                                                    width: 40,
                                                    margin: const EdgeInsets
                                                            .fromLTRB(
                                                        30, 20, 30, 10),
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Colors.white,
                                                      image: DecorationImage(
                                                        image: AssetImage(
                                                            "assets/images/Group 3.png"),
                                                        fit: BoxFit.contain,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 60,
                                                    width: 160,
                                                    color: Colors.white,
                                                    child: Center(
                                                      child: Text(
                                                        'Insurance \nPlans',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontFamily:
                                                                defaultFontFamily,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Color(
                                                                0xff2474b9)),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),

                                          closedElevation: 6.0,
                                          closedShape:
                                              const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(26 / 2),
                                            ),
                                          ),
                                          openBuilder: (context,
                                                  VoidCallback _) =>
                                              WebViewScreen(
                                                  key: _scaffoldKey,
                                                  title: 'Insurance Plans',
                                                  url_link:
                                                      'https://www.sudlife.in/products/life-insurance'),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Expanded(
                                        child: OpenContainer(
                                          // transitionType: transitionType,
                                          transitionType:
                                              ContainerTransitionType.fade,
                                          transitionDuration:
                                              const Duration(milliseconds: 500),
                                          tappable: false,

                                          closedBuilder: (context,
                                                  VoidCallback openContainer) =>
                                              GestureDetector(
                                            onTap: () {
                                              restartTimer();
                                              print('Clicker : ');
                                              openContainer();
                                              // your onOpen code
                                            },
                                            child: Container(
                                              height: 160,
                                              width: 80,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                // borderRadius: const BorderRadius
                                                //     .only(
                                                //     topRight:
                                                //     Radius.circular(20.0),
                                                //     bottomRight:
                                                //     Radius.circular(20.0),
                                                //     topLeft:
                                                //     Radius.circular(20.0),
                                                //     bottomLeft:
                                                //     Radius.circular(20.0)),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.white
                                                        .withOpacity(0.5),
                                                    spreadRadius: 5,
                                                    blurRadius: 7,
                                                    offset: const Offset(0,
                                                        3), // changes position of shadow
                                                  ),
                                                ],
                                              ),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    height: 40,
                                                    width: 40,
                                                    margin: const EdgeInsets
                                                            .fromLTRB(
                                                        30, 20, 30, 10),
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Colors.white,
                                                      image: DecorationImage(
                                                        image: AssetImage(
                                                            "assets/images/Path 107.png"),
                                                        fit: BoxFit.contain,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 60,
                                                    width: 160,
                                                    color: Colors.white,
                                                    child: Center(
                                                      child: Text(
                                                        'Calculate Your \nPremiums',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                defaultFontFamily,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Color(
                                                                0xff2474b9)),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),

                                          closedElevation: 6.0,
                                          closedShape:
                                              const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(26 / 2),
                                            ),
                                          ),
                                          openBuilder: (context, VoidCallback _) =>
                                              WebViewScreen(
                                                  key: _scaffoldKey,
                                                  title:
                                                      'Calculate Your Premiums',
                                                  url_link:
                                                      'https://si.sudlife.in/SalesIllustration/ProductPage.aspx'),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      // Expanded(
                                      //   child: OpenContainer(
                                      //     // transitionType: transitionType,
                                      //     transitionType:
                                      //     ContainerTransitionType.fade,
                                      //     transitionDuration:
                                      //     const Duration(milliseconds: 500),
                                      //     tappable: false,
                                      //
                                      //     closedBuilder: (context,
                                      //         VoidCallback openContainer) =>
                                      //         GestureDetector(
                                      //           onTap: () {
                                      //             print('Clicker : ');
                                      //             openContainer();
                                      //             // your onOpen code
                                      //           },
                                      //           child: Container(
                                      //             height: 160,
                                      //             width: 80,
                                      //             //width: 200,
                                      //             decoration: BoxDecoration(
                                      //               color: Colors.white,
                                      //               // borderRadius: const BorderRadius
                                      //               //     .only(
                                      //               //     topRight:
                                      //               //     Radius.circular(20.0),
                                      //               //     bottomRight:
                                      //               //     Radius.circular(20.0),
                                      //               //     topLeft:
                                      //               //     Radius.circular(20.0),
                                      //               //     bottomLeft:
                                      //               //     Radius.circular(20.0)),
                                      //               boxShadow: [
                                      //                 BoxShadow(
                                      //                   color: Colors.white
                                      //                       .withOpacity(0.5),
                                      //                   spreadRadius: 5,
                                      //                   blurRadius: 7,
                                      //                   offset: Offset(0,
                                      //                       3), // changes position of shadow
                                      //                 ),
                                      //               ],
                                      //             ),
                                      //             child: Column(
                                      //               children: [
                                      //                 Container(
                                      //                   height: 40,
                                      //                   width: 40,
                                      //                   margin: const EdgeInsets
                                      //                       .fromLTRB(
                                      //                       30, 20, 30, 10),
                                      //                   decoration:
                                      //                   const BoxDecoration(
                                      //                     color: Colors.white,
                                      //                     image: DecorationImage(
                                      //                       image: AssetImage(
                                      //                           "assets/images/Path 92.png"),
                                      //                       fit: BoxFit.contain,
                                      //                     ),
                                      //                   ),
                                      //                 ),
                                      //                 Container(
                                      //                   height: 60,
                                      //                   width: 160,
                                      //                   color: Colors.white,
                                      //                   child: Center(
                                      //                     child: Text(
                                      //                       'Pay \nPremiums',
                                      //                       textAlign:
                                      //                       TextAlign.center,
                                      //                       style: TextStyle(
                                      //                           fontSize: 16,
                                      //                           fontFamily:
                                      //                           defaultFontFamily,
                                      //                           fontWeight:
                                      //                           FontWeight.bold,
                                      //                           color: Colors
                                      //                               .blueAccent
                                      //                               .shade400),
                                      //                     ),
                                      //                   ),
                                      //                 ),
                                      //               ],
                                      //             ),
                                      //           ),
                                      //         ),
                                      //
                                      //     closedElevation: 6.0,
                                      //     closedShape:
                                      //     const RoundedRectangleBorder(
                                      //       borderRadius: BorderRadius.all(
                                      //         Radius.circular(56 / 2),
                                      //       ),
                                      //     ),
                                      //     openBuilder: (context,
                                      //         VoidCallback _) =>
                                      //         WebViewScreen(
                                      //             key: _scaffoldKey,
                                      //             title: 'Pay Premiums',
                                      //             url_link:
                                      //             'https://www.sudlife.in/customer-service/premium-payment-options'),
                                      //   ),
                                      // ),
                                      // const SizedBox(
                                      //   width: 20,
                                      // ),
                                      // Expanded(
                                      //   child: OpenContainer(
                                      //     // transitionType: transitionType,
                                      //     transitionType:
                                      //     ContainerTransitionType.fade,
                                      //     transitionDuration:
                                      //     const Duration(milliseconds: 500),
                                      //     tappable: false,
                                      //
                                      //     closedBuilder: (context,
                                      //         VoidCallback openContainer) =>
                                      //         GestureDetector(
                                      //           onTap: () {
                                      //             print('Clicker : ');
                                      //             openContainer();
                                      //             // your onOpen code
                                      //           },
                                      //           child: Container(
                                      //             height: 160,
                                      //             width: 80,
                                      //             decoration: BoxDecoration(
                                      //               color: Colors.white,
                                      //               // borderRadius: const BorderRadius
                                      //               //     .only(
                                      //               //     topRight:
                                      //               //     Radius.circular(20.0),
                                      //               //     bottomRight:
                                      //               //     Radius.circular(20.0),
                                      //               //     topLeft:
                                      //               //     Radius.circular(20.0),
                                      //               //     bottomLeft:
                                      //               //     Radius.circular(20.0)),
                                      //               boxShadow: [
                                      //                 BoxShadow(
                                      //                   color: Colors.white
                                      //                       .withOpacity(0.5),
                                      //                   spreadRadius: 5,
                                      //                   blurRadius: 7,
                                      //                   offset: const Offset(0,
                                      //                       3), // changes position of shadow
                                      //                 ),
                                      //               ],
                                      //             ),
                                      //             child: Column(
                                      //               children: [
                                      //                 Container(
                                      //                   height: 40,
                                      //                   width: 40,
                                      //                   margin: const EdgeInsets
                                      //                       .fromLTRB(
                                      //                       30, 20, 30, 10),
                                      //                   decoration:
                                      //                   const BoxDecoration(
                                      //                     color: Colors.white,
                                      //                     image: DecorationImage(
                                      //                       image: AssetImage(
                                      //                           "assets/images/Group 3.png"),
                                      //                       fit: BoxFit.contain,
                                      //                     ),
                                      //                   ),
                                      //                 ),
                                      //                 Container(
                                      //                   height: 60,
                                      //                   width: 160,
                                      //                   color: Colors.white,
                                      //                   child: Center(
                                      //                     child: Text(
                                      //                       'Insurance \nPlans',
                                      //                       textAlign:
                                      //                       TextAlign.center,
                                      //                       style: TextStyle(
                                      //                           fontSize: 16,
                                      //                           fontFamily:
                                      //                           defaultFontFamily,
                                      //                           fontWeight:
                                      //                           FontWeight.bold,
                                      //                           color: Colors
                                      //                               .blueAccent
                                      //                               .shade400),
                                      //                     ),
                                      //                   ),
                                      //                 ),
                                      //               ],
                                      //             ),
                                      //           ),
                                      //         ),
                                      //
                                      //     closedElevation: 6.0,
                                      //     closedShape:
                                      //     const RoundedRectangleBorder(
                                      //       borderRadius: BorderRadius.all(
                                      //         Radius.circular(56 / 2),
                                      //       ),
                                      //     ),
                                      //     openBuilder: (context,
                                      //         VoidCallback _) =>
                                      //         WebViewScreen(
                                      //
                                      //             key: _scaffoldKey,
                                      //             title: 'Insurance Plans',
                                      //             url_link:
                                      //             'https://www.sudlife.in/products/life-insurance'),
                                      //   ),
                                      // ),
                                      // const SizedBox(
                                      //   width: 20,
                                      // ),
                                    ],
                                  ),

                                  const SizedBox(
                                    height: 40,
                                  ),

                                  Row(
                                    children: [
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      // Expanded(
                                      //   child: OpenContainer(
                                      //     // transitionType: transitionType,
                                      //     transitionType:
                                      //     ContainerTransitionType.fade,
                                      //     transitionDuration:
                                      //     const Duration(milliseconds: 500),
                                      //     tappable: false,
                                      //
                                      //     closedBuilder: (context,
                                      //         VoidCallback openContainer) =>
                                      //         GestureDetector(
                                      //           onTap: () {
                                      //             print('Clicker : ');
                                      //             openContainer();
                                      //             // your onOpen code
                                      //           },
                                      //           child: Container(
                                      //             height: 160,
                                      //             width: 80,
                                      //             decoration: BoxDecoration(
                                      //               color: Colors.white,
                                      //               // borderRadius: const BorderRadius
                                      //               //     .only(
                                      //               //     topRight:
                                      //               //     Radius.circular(20.0),
                                      //               //     bottomRight:
                                      //               //     Radius.circular(20.0),
                                      //               //     topLeft:
                                      //               //     Radius.circular(20.0),
                                      //               //     bottomLeft:
                                      //               //     Radius.circular(20.0)),
                                      //               boxShadow: [
                                      //                 BoxShadow(
                                      //                   color: Colors.white
                                      //                       .withOpacity(0.5),
                                      //                   spreadRadius: 5,
                                      //                   blurRadius: 7,
                                      //                   offset: const Offset(0,
                                      //                       3), // changes position of shadow
                                      //                 ),
                                      //               ],
                                      //             ),
                                      //             child: Column(
                                      //               children: [
                                      //                 Container(
                                      //                   height: 40,
                                      //                   width: 40,
                                      //                   margin: const EdgeInsets
                                      //                       .fromLTRB(
                                      //                       30, 20, 30, 10),
                                      //                   decoration:
                                      //                   const BoxDecoration(
                                      //                     color: Colors.white,
                                      //                     image: DecorationImage(
                                      //                       image: AssetImage(
                                      //                           "assets/images/Path 107.png"),
                                      //                       fit: BoxFit.contain,
                                      //                     ),
                                      //                   ),
                                      //                 ),
                                      //                 Container(
                                      //                   height: 60,
                                      //                   width: 160,
                                      //                   color: Colors.white,
                                      //                   child: Center(
                                      //                     child: Text(
                                      //                       'Calculate Your \nPremiums',
                                      //                       textAlign:
                                      //                       TextAlign.center,
                                      //                       style: TextStyle(
                                      //                           fontFamily:
                                      //                           defaultFontFamily,
                                      //                           fontSize: 16,
                                      //                           fontWeight:
                                      //                           FontWeight.bold,
                                      //                           color: Colors
                                      //                               .blueAccent
                                      //                               .shade400),
                                      //                     ),
                                      //                   ),
                                      //                 ),
                                      //               ],
                                      //             ),
                                      //           ),
                                      //         ),
                                      //
                                      //     closedElevation: 6.0,
                                      //     closedShape:
                                      //     const RoundedRectangleBorder(
                                      //       borderRadius: BorderRadius.all(
                                      //         Radius.circular(56 / 2),
                                      //       ),
                                      //     ),
                                      //     openBuilder: (context,
                                      //         VoidCallback _) =>
                                      //         WebViewScreen(
                                      //             key: _scaffoldKey,
                                      //             title: 'Calculate Your Premiums',
                                      //             url_link:
                                      //             'https://si.sudlife.in/SalesIllustration/ProductPage.aspx'),
                                      //   ),
                                      // ),
                                      // const SizedBox(
                                      //   width: 20,
                                      // ),
                                      Expanded(
                                        child: OpenContainer(
                                          // transitionType: transitionType,
                                          transitionType:
                                              ContainerTransitionType.fade,
                                          transitionDuration:
                                              const Duration(milliseconds: 500),
                                          tappable: false,

                                          closedBuilder: (context,
                                                  VoidCallback openContainer) =>
                                              GestureDetector(
                                            onTap: () {
                                              restartTimer();
                                              print('Clicker : ');
                                              openContainer();
                                              // your onOpen code
                                            },
                                            child: Container(
                                              height: 160,
                                              width: 80,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                // borderRadius: const BorderRadius
                                                //     .only(
                                                //     topRight:
                                                //     Radius.circular(20.0),
                                                //     bottomRight:
                                                //     Radius.circular(20.0),
                                                //     topLeft:
                                                //     Radius.circular(20.0),
                                                //     bottomLeft:
                                                //     Radius.circular(20.0)),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.white
                                                        .withOpacity(0.5),
                                                    spreadRadius: 5,
                                                    blurRadius: 7,
                                                    offset: const Offset(0,
                                                        3), // changes position of shadow
                                                  ),
                                                ],
                                              ),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    height: 40,
                                                    width: 40,
                                                    margin: const EdgeInsets
                                                            .fromLTRB(
                                                        30, 20, 30, 10),
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Colors.white,
                                                      image: DecorationImage(
                                                        image: AssetImage(
                                                            "assets/images/Group 6.png"),
                                                        fit: BoxFit.contain,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 60,
                                                    width: 160,
                                                    color: Colors.white,
                                                    child: Center(
                                                      child: Text(
                                                        'Customer Portal\n (Self-Help)',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontFamily:
                                                                defaultFontFamily,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Color(
                                                                0xff2474b9)),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),

                                          closedElevation: 6.0,
                                          closedShape:
                                              const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(26 / 2),
                                            ),
                                          ),
                                          openBuilder: (context,
                                                  VoidCallback _) =>
                                              WebViewScreen(
                                                  key: _scaffoldKey,
                                                  title: 'Customer Portal (Self-Help)',
                                                  url_link:
                                                      // 'https://customer.sudlife.in'),
                                                      'https://www.sudlife.in/contact-us'),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Expanded(
                                        child: OpenContainer(
                                          // transitionType: transitionType,
                                          transitionType:
                                              ContainerTransitionType.fade,
                                          transitionDuration:
                                              const Duration(milliseconds: 500),
                                          tappable: false,

                                          closedBuilder: (context,
                                                  VoidCallback openContainer) =>
                                              GestureDetector(
                                            onTap: () {
                                              restartTimer();
                                              print('Clicker : ');
                                              openContainer();
                                              // your onOpen code
                                            },
                                            child: Container(
                                              height: 160,
                                              width: 80,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                // borderRadius: const BorderRadius
                                                //     .only(
                                                //     topRight:
                                                //     Radius.circular(20.0),
                                                //     bottomRight:
                                                //     Radius.circular(20.0),
                                                //     topLeft:
                                                //     Radius.circular(20.0),
                                                //     bottomLeft:
                                                //     Radius.circular(20.0)),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.white
                                                        .withOpacity(0.5),
                                                    spreadRadius: 5,
                                                    blurRadius: 7,
                                                    offset: const Offset(0,
                                                        3), // changes position of shadow
                                                  ),
                                                ],
                                              ),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    height: 40,
                                                    width: 40,
                                                    margin: const EdgeInsets
                                                            .fromLTRB(
                                                        30, 20, 30, 10),
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Colors.white,
                                                      image: DecorationImage(
                                                        image: AssetImage(
                                                            "assets/images/claims.png"),
                                                        fit: BoxFit.contain,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 60,
                                                    width: 160,
                                                    color: Colors.white,
                                                    child: Center(
                                                      child: Text(
                                                        'Claims',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontFamily:
                                                                defaultFontFamily,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Color(
                                                                0xff2474b9)),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),

                                          closedElevation: 6.0,
                                          closedShape:
                                              const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(26 / 2),
                                            ),
                                          ),
                                          openBuilder: (context,
                                                  VoidCallback _) =>
                                              WebViewScreen(
                                                  key: _scaffoldKey,
                                                  title: 'Claims',
                                                  url_link:
                                                      //'https://www.sudlife.in/contact-us'),
                                                      'https://www.sudlife.in/claims'),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                    ],
                                  ),

                                  const SizedBox(
                                    height: 40,
                                  ),

                                ],
                              ),

                            ],
                          ),
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/Background.png"),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: Center(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [

                                const SizedBox(
                                  height: 80,
                                ),

                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding:
                                            EdgeInsets.fromLTRB(20, 0, 0, 0),
                                        child: Text(
                                          "SUD Life Experience Zone",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 24,
                                              fontFamily: defaultFontFamily,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(
                                  height: 20,
                                ),

                                Column(
                                  children: [

                                    const SizedBox(
                                      height: 40,
                                    ),

                                    Row(
                                      children: [
                                        const SizedBox(
                                          width: 70,
                                        ),
                                        Expanded(

                                          child: OpenContainer(
                                            // transitionType: transitionType,
                                            transitionType:
                                                ContainerTransitionType.fade,
                                            transitionDuration: const Duration(
                                                milliseconds: 500),
                                            tappable: false,

                                            closedBuilder: (context,
                                                    VoidCallback
                                                        openContainer) =>
                                                GestureDetector(
                                              onTap: () {
                                                restartTimer();
                                                print('Clicker : ');
                                                openContainer();
                                                // your onOpen code
                                              },
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.all(10),
                                                height: 190,
                                                //width: 200,

                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  // borderRadius: const BorderRadius
                                                  //         .only(
                                                  //     topRight:
                                                  //         Radius.circular(20.0),
                                                  //     bottomRight:
                                                  //         Radius.circular(20.0),
                                                  //     topLeft:
                                                  //         Radius.circular(20.0),
                                                  //     bottomLeft:
                                                  //         Radius.circular(20.0)),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.white
                                                          .withOpacity(0.5),
                                                      spreadRadius: 5,
                                                      blurRadius: 7,
                                                      offset: const Offset(0,
                                                          3), // changes position of shadow
                                                    ),
                                                  ],
                                                ),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      height: 50,
                                                      width: 50,
                                                      margin: const EdgeInsets
                                                              .fromLTRB(
                                                          30, 30, 30, 10),
                                                      decoration:
                                                          const BoxDecoration(
                                                        color: Colors.white,
                                                        image: DecorationImage(
                                                          image: AssetImage(
                                                              "assets/images/Group 3.png"),
                                                          fit: BoxFit.contain,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 80,
                                                      //width: 160,
                                                      color: Colors.white,
                                                      child: Center(
                                                        child: Text(
                                                          'Buy Online',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: 24,
                                                              fontFamily:
                                                                  defaultFontFamily,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Color(
                                                                  0xff2474b9)),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),

                                            closedElevation: 6.0,
                                            closedShape:
                                                const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(26 / 2),
                                              ),
                                            ),
                                            openBuilder: (context,
                                                    VoidCallback _) =>
                                                WebViewScreen(
                                                    key: _scaffoldKey,
                                                    title: 'Buy Online',
                                                    url_link:
                                                        'https://bol.sudlife.in/ProductSelection/ProductSelectionPage'),
                                          ),
                                          //),
                                        ),
                                        const SizedBox(
                                          width: 70,
                                        ),
                                        Expanded(
                                          child: OpenContainer(
                                            // transitionType: transitionType,
                                            transitionType:
                                                ContainerTransitionType.fade,
                                            transitionDuration: const Duration(
                                                milliseconds: 500),
                                            tappable: false,

                                            closedBuilder: (context,
                                                    VoidCallback
                                                        openContainer) =>
                                                GestureDetector(
                                              onTap: () {
                                                restartTimer();
                                                print('Clicker : ');
                                                openContainer();
                                                // your onOpen code
                                              },
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.all(10),
                                                height: 190,
                                                //width: 200,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  // borderRadius: const BorderRadius
                                                  //         .only(
                                                  //     topRight:
                                                  //         Radius.circular(20.0),
                                                  //     bottomRight:
                                                  //         Radius.circular(20.0),
                                                  //     topLeft:
                                                  //         Radius.circular(20.0),
                                                  //     bottomLeft:
                                                  //         Radius.circular(20.0)),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.white
                                                          .withOpacity(0.5),
                                                      spreadRadius: 5,
                                                      blurRadius: 7,
                                                      offset: Offset(0,
                                                          3), // changes position of shadow
                                                    ),
                                                  ],
                                                ),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      height: 50,
                                                      width: 50,
                                                      margin: const EdgeInsets
                                                              .fromLTRB(
                                                          30, 30, 30, 10),
                                                      decoration:
                                                          const BoxDecoration(
                                                        color: Colors.white,
                                                        image: DecorationImage(
                                                          image: AssetImage(
                                                              "assets/images/Path 92.png"),
                                                          fit: BoxFit.contain,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 80,
                                                      width: 160,
                                                      color: Colors.white,
                                                      child: Center(
                                                        child: Text(
                                                          'Pay Premiums',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              fontFamily:
                                                                  defaultFontFamily,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Color(
                                                                  0xff2474b9)),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),

                                            closedElevation: 6.0,
                                            closedShape:
                                                const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(26 / 2),
                                              ),
                                            ),
                                            openBuilder: (context,
                                                    VoidCallback _) =>
                                                WebViewScreen(
                                                    key: _scaffoldKey,
                                                    title: 'Pay Premiums',
                                                    url_link:
                                                        'https://www.sudlife.in/customer-service/premium-payment-options'),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 70,
                                        ),
                                        Expanded(
                                          child: OpenContainer(
                                            // transitionType: transitionType,
                                            transitionType:
                                                ContainerTransitionType.fade,
                                            transitionDuration: const Duration(
                                                milliseconds: 500),
                                            tappable: false,

                                            closedBuilder: (context,
                                                    VoidCallback
                                                        openContainer) =>
                                                GestureDetector(
                                              onTap: () {
                                                restartTimer();
                                                print('Clicker : ');
                                                openContainer();
                                                // your onOpen code
                                              },
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.all(10),
                                                height: 190,
                                                //width: 200,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  // borderRadius: const BorderRadius
                                                  //         .only(
                                                  //     topRight:
                                                  //         Radius.circular(20.0),
                                                  //     bottomRight:
                                                  //         Radius.circular(20.0),
                                                  //     topLeft:
                                                  //         Radius.circular(20.0),
                                                  //     bottomLeft:
                                                  //         Radius.circular(20.0)),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.white
                                                          .withOpacity(0.5),
                                                      spreadRadius: 5,
                                                      blurRadius: 7,
                                                      offset: const Offset(0,
                                                          3), // changes position of shadow
                                                    ),
                                                  ],
                                                ),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      height: 50,
                                                      width: 50,
                                                      margin: const EdgeInsets
                                                              .fromLTRB(
                                                          30, 30, 30, 10),
                                                      decoration:
                                                          const BoxDecoration(
                                                        color: Colors.white,
                                                        image: DecorationImage(
                                                          image: AssetImage(
                                                              "assets/images/Group 3.png"),
                                                          fit: BoxFit.contain,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 80,
                                                      //width: 160,
                                                      color: Colors.white,
                                                      child: Center(
                                                        child: Text(
                                                          'Insurance Plans',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              fontFamily:
                                                                  defaultFontFamily,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Color(
                                                                  0xff2474b9)),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),

                                            closedElevation: 6.0,
                                            closedShape:
                                                const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(26 / 2),
                                              ),
                                            ),
                                            openBuilder: (context,
                                                    VoidCallback _) =>
                                                WebViewScreen(
                                                    key: _scaffoldKey,
                                                    title: 'Insurance Plans',
                                                    url_link:
                                                        'https://www.sudlife.in/products/life-insurance'),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 70,
                                        ),
                                      ],
                                    ),

                                    const SizedBox(
                                      height: 50,
                                    ),

                                    Row(
                                      children: [
                                        const SizedBox(
                                          width: 70,
                                        ),
                                        Expanded(
                                          child: OpenContainer(
                                            // transitionType: transitionType,
                                            transitionType:
                                                ContainerTransitionType.fade,
                                            transitionDuration: const Duration(
                                                milliseconds: 500),
                                            tappable: false,

                                            closedBuilder: (context,
                                                    VoidCallback
                                                        openContainer) =>
                                                GestureDetector(
                                              onTap: () {
                                                restartTimer();
                                                print('Clicker : ');
                                                openContainer();
                                                // your onOpen code
                                              },
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.all(10),
                                                height: 190,
                                                //width: 200,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  // borderRadius: const BorderRadius
                                                  //         .only(
                                                  //     topRight:
                                                  //         Radius.circular(20.0),
                                                  //     bottomRight:
                                                  //         Radius.circular(20.0),
                                                  //     topLeft:
                                                  //         Radius.circular(20.0),
                                                  //     bottomLeft:
                                                  //         Radius.circular(20.0)),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.white
                                                          .withOpacity(0.5),
                                                      spreadRadius: 5,
                                                      blurRadius: 7,
                                                      offset: const Offset(0,
                                                          3), // changes position of shadow
                                                    ),
                                                  ],
                                                ),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      height: 50,
                                                      width: 50,
                                                      margin: const EdgeInsets
                                                              .fromLTRB(
                                                          30, 30, 30, 10),
                                                      decoration:
                                                          const BoxDecoration(
                                                        color: Colors.white,
                                                        image: DecorationImage(
                                                          image: AssetImage(
                                                              "assets/images/Path 107.png"),
                                                          fit: BoxFit.contain,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 80,
                                                      width: 160,
                                                      color: Colors.white,
                                                      child: Center(
                                                        child: Text(
                                                          'Calculate Your \nPremiums',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  defaultFontFamily,
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Color(
                                                                  0xff2474b9)),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),

                                            closedElevation: 6.0,
                                            closedShape:
                                                const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(26 / 2),
                                              ),
                                            ),
                                            openBuilder: (context,
                                                    VoidCallback _) =>
                                                WebViewScreen(
                                                    key: _scaffoldKey,
                                                    title:
                                                        'Calculate Your Premiums',
                                                    url_link:
                                                        'https://si.sudlife.in/SalesIllustration/ProductPage.aspx'),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 70,
                                        ),
                                        Expanded(
                                          child: OpenContainer(
                                            // transitionType: transitionType,
                                            transitionType:
                                                ContainerTransitionType.fade,
                                            transitionDuration: const Duration(
                                                milliseconds: 500),
                                            tappable: false,

                                            closedBuilder: (context,
                                                    VoidCallback
                                                        openContainer) =>
                                                GestureDetector(
                                              onTap: () {
                                                restartTimer();
                                                print('Clicker : ');
                                                openContainer();
                                                // your onOpen code
                                              },
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.all(10),
                                                height: 190,
                                                //width: 200,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  // borderRadius: const BorderRadius
                                                  //         .only(
                                                  //     topRight:
                                                  //         Radius.circular(20.0),
                                                  //     bottomRight:
                                                  //         Radius.circular(20.0),
                                                  //     topLeft:
                                                  //         Radius.circular(20.0),
                                                  //     bottomLeft:
                                                  //         Radius.circular(20.0)),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.white
                                                          .withOpacity(0.5),
                                                      spreadRadius: 5,
                                                      blurRadius: 7,
                                                      offset: const Offset(0,
                                                          3), // changes position of shadow
                                                    ),
                                                  ],
                                                ),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      height: 50,
                                                      width: 50,
                                                      margin: const EdgeInsets
                                                              .fromLTRB(
                                                          30, 30, 30, 10),
                                                      decoration:
                                                          const BoxDecoration(
                                                        color: Colors.white,
                                                        image: DecorationImage(
                                                          image: AssetImage(
                                                              "assets/images/Group 6.png"),
                                                          fit: BoxFit.contain,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 80,
                                                      //width: 160,
                                                      color: Colors.white,
                                                      child: Center(
                                                        child: Text(
                                                          'Customer Portal \n(Self-Help)',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              fontFamily:
                                                                  defaultFontFamily,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Color(
                                                                  0xff2474b9)),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),

                                            closedElevation: 6.0,
                                            closedShape:
                                                const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(26 / 2),
                                              ),
                                            ),
                                            openBuilder: (context,
                                                    VoidCallback _) =>
                                                WebViewScreen(
                                                    key: _scaffoldKey,
                                                    title: 'Customer Portal (Self-Help)',
                                                    url_link:
                                                        //'https://customer.sudlife.in'),
                                                        'https://www.sudlife.in/contact-us'),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 70,
                                        ),
                                        Expanded(
                                          child: OpenContainer(
                                            // transitionType: transitionType,
                                            transitionType:
                                                ContainerTransitionType.fade,
                                            transitionDuration: const Duration(
                                                milliseconds: 500),
                                            tappable: false,

                                            closedBuilder: (context,
                                                    VoidCallback
                                                        openContainer) =>
                                                GestureDetector(
                                              onTap: () {
                                                restartTimer();
                                                print('Claims Clicker : ');
                                                openContainer();
                                              },
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.all(10),
                                                height: 190,
                                                //width: 200,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  // borderRadius: const BorderRadius
                                                  //         .only(
                                                  //     topRight:
                                                  //         Radius.circular(20.0),
                                                  //     bottomRight:
                                                  //         Radius.circular(20.0),
                                                  //     topLeft:
                                                  //         Radius.circular(20.0),
                                                  //     bottomLeft:
                                                  //         Radius.circular(20.0)),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.white
                                                          .withOpacity(0.5),
                                                      spreadRadius: 5,
                                                      blurRadius: 7,
                                                      offset: const Offset(0,
                                                          3), // changes position of shadow
                                                    ),
                                                  ],
                                                ),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      height: 50,
                                                      width: 50,
                                                      margin: const EdgeInsets
                                                              .fromLTRB(
                                                          30, 30, 30, 10),
                                                      decoration:
                                                          const BoxDecoration(
                                                        color: Colors.white,
                                                        image: DecorationImage(
                                                          image: AssetImage(
                                                              "assets/images/claims.png"),
                                                          fit: BoxFit.contain,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 80,
                                                      width: 160,
                                                      color: Colors.white,
                                                      child: Center(
                                                        child: Text(
                                                          //'Office Locator',
                                                          'Claims',
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              fontFamily:
                                                                  defaultFontFamily,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Color(
                                                                  0xff2474b9)),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),

                                            closedElevation: 6.0,
                                            closedShape:
                                                const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(26 / 2),
                                              ),
                                            ),
                                            openBuilder: (context,
                                                    VoidCallback _) =>
                                                WebViewScreen(
                                                    key: _scaffoldKey,
                                                    title: 'Claims',
                                                    url_link:
                                                        'https://www.sudlife.in/claims'),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 70,
                                        ),
                                      ],
                                    ),

                                    const SizedBox(
                                      height: 40,
                                    ),

                                  ],
                                ),

                                const SizedBox(
                                  height: 20,
                                ),

                                FadeAnimation(
                                    1.1,
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .center,
                                      children: [
                                        Text(
                                          "Protecting Families, Enriching Lives",
                                          textAlign:
                                          TextAlign
                                              .center,
                                          style: TextStyle(
                                              fontSize: 24,
                                              fontFamily: defaultFontFamily,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.white),
                                          // style: TextStyle(
                                          //   //fontFamily: defaultFontFamily,
                                          //     color: Colors
                                          //         .white,
                                          //     //Color.fromRGBO(113, 56, 208, 1.0),
                                          //     fontWeight:
                                          //     FontWeight
                                          //         .bold,
                                          //     fontSize: 22),
                                        ),
                                      ],
                                    )),

                                const SizedBox(
                                  height: 10,
                                ),

                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

              Positioned(
                      top: 50.0,
                      left: 0.0,
                      right: 0.0,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(30, 0, 30, 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              // height: 70,
                              // width: 160,
                              padding: const EdgeInsets.all(14),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(15.0),
                                    bottomRight: Radius.circular(15.0),
                                    topLeft: Radius.circular(15.0),
                                    bottomLeft: Radius.circular(15.0)),
                              ),
                              child: Container(
                                // height: 50,
                                // width: 100,
                                padding:
                                    const EdgeInsets.fromLTRB(80, 20, 80, 20),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  image: DecorationImage(
                                    image: AssetImage(
                                        "assets/images/site-logo.png"),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                child: null,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

              width_size < 900
                  ? Positioned(
                      bottom: 80.0,
                      left: 10,
                      right: 10,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                            width: 40,
                          ),
                          InkWell(
                            onTap: () {
                              if (_timer.isActive) {
                                _timer.cancel();
                                print("ZoneHome Timer Canceled in Dispose() ");
                              }
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    // builder: (context) => ChessGame()),
                                    builder: (context) =>
                                        const FunFacts_Screen()),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              height: 80,
                              width: 60,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image:
                                      AssetImage("assets/games/Fun Facts.png"),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 40,
                          ),
                          InkWell(
                            onTap: () {
                              if (_timer.isActive) {
                                _timer.cancel();
                                print("ZoneHome Timer Canceled in Dispose() ");
                              }
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    // builder: (context) => ChessGame()),
                                    builder: (context) => const Quiz_Screen()),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              height: 80,
                              width: 60,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image:
                                      AssetImage("assets/games/Quiz Time.png"),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 40,
                          ),
                        ],
                      ),
                    )
                  : Positioned(
                      top: 30.0,
                      right: 30.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                            width: 40,
                          ),
                          InkWell(
                            onTap: () {
                              if (_timer.isActive) {
                                _timer.cancel();
                                print("ZoneHome Timer Canceled in Dispose() ");
                              }
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    // builder: (context) => ChessGame()),
                                    builder: (context) =>
                                        const FunFacts_Screen()),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              height: 80,
                              width: 60,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image:
                                      AssetImage("assets/games/Fun Facts.png"),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 40,
                          ),
                          InkWell(
                            onTap: () {
                              if (_timer.isActive) {
                                _timer.cancel();
                                print("ZoneHome Timer Canceled in Dispose() ");
                              }
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    // builder: (context) => ChessGame()),
                                    builder: (context) => const Quiz_Screen()),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              height: 80,
                              width: 60,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image:
                                      AssetImage("assets/games/Quiz Time.png"),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 40,
                          ),
                        ],
                      ),
                    ),

              width_size < 900
                  ? Positioned(
                      bottom: 30.0,
                      left: 30,
                      right: 30,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                        child: Container(
                          height: 45,
                          width: 180,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              side: const BorderSide(
                                width: 2,
                                color: Color(0xff0F5A93),
                              ),
                            ),
                            child: const Text(
                              "Exit The Zone",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent,
                              ),
                            ),
                            onPressed: () async {
                              _showMyDialog();
                            },
                          ),
                        ),
                      ),
                    )
                  : Positioned(
                      bottom: 30.0,
                      right: 30.0,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                        child: Container(
                          height: 45,
                          width: 180,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              side: const BorderSide(
                                width: 2,
                                color: Color(0xff0F5A93),
                              ),
                            ),
                            child: const Text(
                              "Exit The Zone",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent,
                              ),
                            ),
                            onPressed: () async {
                              _showMyDialog();

                              // clear();
                              // Navigator.pop(context);
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => BannerScreen()));
                            },
                          ),
                        ),
                      ),
                    ),

            ],
          ),
        ),
      ),
    );
  }

  void restartTimer(){
    if (_timer.isActive) {
      _timer.cancel();
      print("ZoneHome Timer Restarted ");
      startTimer(_start);
    }
  }

  Future<void> _showMyDialog() async {
    return showCupertinoDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Do you want to Exit ?'),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            TextButton(
              onPressed: () {
                clear();
                dispose();
                //Navigator.pop(context);
                Navigator.pop(context, true);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BannerScreen()));
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }

  Future<void> clear() async {
    var prefs = await SharedPreferences.getInstance();

    prefs.remove('0correctA');
    prefs.remove('0correctB');
    prefs.remove('0correctC');
    prefs.remove('0correctD');
    prefs.remove('0pressed');
    prefs.remove('0answerA');
    prefs.remove('0answerB');
    prefs.remove('0answerC');
    prefs.remove('0answerD');

    prefs.remove('1correctA');
    prefs.remove('1correctB');
    prefs.remove('1correctC');
    prefs.remove('1correctD');
    prefs.remove('1pressed');
    prefs.remove('1answerA');
    prefs.remove('1answerB');
    prefs.remove('1answerC');
    prefs.remove('1answerD');

    prefs.remove('2correctA');
    prefs.remove('2correctB');
    prefs.remove('2correctC');
    prefs.remove('2correctD');
    prefs.remove('2pressed');
    prefs.remove('2answerA');
    prefs.remove('2answerB');
    prefs.remove('2answerC');
    prefs.remove('2answerD');

    prefs.remove('3correctA');
    prefs.remove('3correctB');
    prefs.remove('3correctC');
    prefs.remove('3correctD');
    prefs.remove('3pressed');
    prefs.remove('3answerA');
    prefs.remove('3answerB');
    prefs.remove('3answerC');
    prefs.remove('3answerD');

    prefs.remove('4correctA');
    prefs.remove('4correctB');
    prefs.remove('4correctC');
    prefs.remove('4correctD');
    prefs.remove('4pressed');
    prefs.remove('4answerA');
    prefs.remove('4answerB');
    prefs.remove('4answerC');
    prefs.remove('4answerD');

    prefs.remove('5correctA');
    prefs.remove('5correctB');
    prefs.remove('5correctC');
    prefs.remove('5correctD');
    prefs.remove('5pressed');
    prefs.remove('5answerA');
    prefs.remove('5answerB');
    prefs.remove('5answerC');
    prefs.remove('5answerD');

    prefs.remove('6correctA');
    prefs.remove('6correctB');
    prefs.remove('6correctC');
    prefs.remove('6correctD');
    prefs.remove('6pressed');
    prefs.remove('6answerA');
    prefs.remove('6answerB');
    prefs.remove('6answerC');
    prefs.remove('6answerD');

    prefs.remove('7correctA');
    prefs.remove('7correctB');
    prefs.remove('7correctC');
    prefs.remove('7correctD');
    prefs.remove('7pressed');
    prefs.remove('7answerA');
    prefs.remove('7answerB');
    prefs.remove('7answerC');
    prefs.remove('7answerD');

    prefs.remove('8correctA');
    prefs.remove('8correctB');
    prefs.remove('8correctC');
    prefs.remove('8correctD');
    prefs.remove('8pressed');
    prefs.remove('8answerA');
    prefs.remove('8answerB');
    prefs.remove('8answerC');
    prefs.remove('8answerD');

    prefs.remove('9correctA');
    prefs.remove('9correctB');
    prefs.remove('9correctC');
    prefs.remove('9correctD');
    prefs.remove('9pressed');
    prefs.remove('9answerA');
    prefs.remove('9answerB');
    prefs.remove('9answerC');
    prefs.remove('9answerD');

    prefs.remove('10correctA');
    prefs.remove('10correctB');
    prefs.remove('10correctC');
    prefs.remove('10correctD');
    prefs.remove('10pressed');
    prefs.remove('10answerA');
    prefs.remove('10answerB');
    prefs.remove('10answerC');
    prefs.remove('10answerD');

    prefs.remove('11correctA');
    prefs.remove('11correctB');
    prefs.remove('11correctC');
    prefs.remove('11correctD');
    prefs.remove('11pressed');
    prefs.remove('11answerA');
    prefs.remove('11answerB');
    prefs.remove('11answerC');
    prefs.remove('11answerD');

    prefs.clear();
  }

  @override
  void dispose() {
    if (_timer.isActive) {
      _timer.cancel();
      print("ZoneHome Timer Canceled in Dispose() ");
    }

    WidgetsBinding.instance.removeObserver(this);
    //controller.dispose();
    super.dispose();
  }

  // @override
  // Widget build(BuildContext context) {
  //   // SystemChrome.setPreferredOrientations([
  //   //   DeviceOrientation.landscapeLeft,
  //   //   DeviceOrientation.landscapeRight,
  //   // ]);
  //
  //   final double height_size = MediaQuery.of(context).size.height;
  //   final double width_size = MediaQuery.of(context).size.width;
  //   print(height_size.toString() + " * " + width_size.toString());
  //
  //   return WillPopScope(
  //     onWillPop: () async => false,
  //     child: Scaffold(
  //       extendBodyBehindAppBar: false,
  //       // appBar: AppBar(
  //       //   backgroundColor: Colors.black,
  //       //   leading: IconButton(
  //       //     icon: Icon(Icons.arrow_back, color: Colors.white),
  //       //     onPressed: () => Navigator.of(context).pop(),
  //       //   ),
  //       //   title: Text(""),
  //       //   centerTitle: false,
  //       // ),
  //       // backgroundColor: Colors.white,
  //       body: GestureDetector(
  //         onTap: () {
  //           this.controller.isCompleted
  //               ? this.controller.reverse()
  //               : this.controller.forward();
  //         },
  //         child: Stack(
  //           children: <Widget>[
  //             width_size < 900
  //                 ? SingleChildScrollView(
  //                     child: Container(
  //                       width: MediaQuery.of(context).size.width,
  //                       height: MediaQuery.of(context).size.height,
  //                       decoration: const BoxDecoration(
  //                         image: DecorationImage(
  //                           image: AssetImage("assets/images/Background.png"),
  //                           fit: BoxFit.fill,
  //                         ),
  //                       ),
  //                       child: SingleChildScrollView(
  //                         child: Column(
  //                           children: [
  //                             const SizedBox(
  //                               height: 60,
  //                             ),
  //
  //                             // Padding(
  //                             //   padding: EdgeInsets.fromLTRB(30, 0, 30, 30),
  //                             //   child: Row(
  //                             //     mainAxisAlignment: MainAxisAlignment.center,
  //                             //     children: [
  //                             //       Container(
  //                             //         // height: 70,
  //                             //         // width: 160,
  //                             //         padding: const EdgeInsets.all(14),
  //                             //         decoration: const BoxDecoration(
  //                             //           color: Colors.white,
  //                             //           borderRadius: BorderRadius.only(
  //                             //               topRight: Radius.circular(15.0),
  //                             //               bottomRight: Radius.circular(15.0),
  //                             //               topLeft: Radius.circular(15.0),
  //                             //               bottomLeft: Radius.circular(15.0)),
  //                             //         ),
  //                             //         child: Container(
  //                             //           // height: 50,
  //                             //           // width: 100,
  //                             //           padding: const EdgeInsets.fromLTRB(60,15,60,15),
  //                             //           decoration: const BoxDecoration(
  //                             //             color: Colors.white,
  //                             //             image: DecorationImage(
  //                             //               image:
  //                             //               AssetImage("assets/images/site-logo.png"),
  //                             //               fit: BoxFit.contain,
  //                             //             ),
  //                             //           ),
  //                             //           child: null,
  //                             //         ),
  //                             //       ),
  //                             //     ],
  //                             //   ),
  //                             // ),
  //
  //                             const SizedBox(
  //                               height: 90,
  //                             ),
  //
  //                             Row(
  //                               children: [
  //                                 Expanded(
  //                                   child: Container(
  //                                     padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
  //                                     child: Text(
  //                                       "SUD Life Experience Zone",
  //                                       textAlign: TextAlign.center,
  //                                       style: TextStyle(
  //                                           fontSize: 22,
  //                                           fontFamily: defaultFontFamily,
  //                                           fontWeight: FontWeight.w800,
  //                                           color: Colors.white),
  //                                     ),
  //                                   ),
  //                                 ),
  //                                 // const Spacer(),
  //                                 // Expanded(
  //                                 //   child: InkWell(
  //                                 //     onTap: () {
  //                                 //       // Navigator.push(
  //                                 //       //   context,
  //                                 //       //   MaterialPageRoute(
  //                                 //       //       // builder: (context) => ChessGame()),
  //                                 //       //       builder: (context) => SplashScrenn()),
  //                                 //       // );
  //                                 //     },
  //                                 //     child: Container(
  //                                 //       height: 60,
  //                                 //       width: 70,
  //                                 //       decoration: const BoxDecoration(
  //                                 //         color: Colors.white,
  //                                 //         borderRadius: BorderRadius.only(
  //                                 //             // topRight: Radius.circular(40.0),
  //                                 //             // bottomRight: Radius.circular(40.0),
  //                                 //             topLeft: Radius.circular(20.0),
  //                                 //             bottomLeft:
  //                                 //                 Radius.circular(20.0)),
  //                                 //       ),
  //                                 //       child: Container(
  //                                 //         height: 50,
  //                                 //         width: 100,
  //                                 //         margin: const EdgeInsets.all(12),
  //                                 //         decoration: const BoxDecoration(
  //                                 //           color: Colors.white,
  //                                 //           image: DecorationImage(
  //                                 //             image: AssetImage(
  //                                 //                 "assets/images/site-logo.png"),
  //                                 //             fit: BoxFit.contain,
  //                                 //           ),
  //                                 //         ),
  //                                 //         child: null,
  //                                 //       ),
  //                                 //     ),
  //                                 //   ),
  //                                 // )
  //                               ],
  //                             ),
  //
  //                             const SizedBox(
  //                               height: 10,
  //                             ),
  //
  //                             // Column(
  //                             //   children: [
  //                             //     const SizedBox(
  //                             //       height: 20,
  //                             //     ),
  //                             //
  //                             //     Row(
  //                             //       children: [
  //                             //         const SizedBox(
  //                             //           width: 20,
  //                             //         ),
  //                             //         Expanded(
  //                             //           child: OpenContainer(
  //                             //             // transitionType: transitionType,
  //                             //             transitionType:
  //                             //                 ContainerTransitionType.fade,
  //                             //             transitionDuration:
  //                             //                 const Duration(milliseconds: 500),
  //                             //             tappable: false,
  //                             //
  //                             //             closedBuilder: (context,
  //                             //                     VoidCallback openContainer) =>
  //                             //                 GestureDetector(
  //                             //               onTap: () {
  //                             //                 print('Clicker : ');
  //                             //                 openContainer();
  //                             //                 // your onOpen code
  //                             //               },
  //                             //               child: Container(
  //                             //                 height: 140,
  //                             //                 width: 80,
  //                             //
  //                             //                 // height: 150,
  //                             //                 // width: 200,
  //                             //                 decoration: BoxDecoration(
  //                             //                   color: Colors.white,
  //                             //                   borderRadius: const BorderRadius
  //                             //                           .only(
  //                             //                       topRight:
  //                             //                           Radius.circular(20.0),
  //                             //                       bottomRight:
  //                             //                           Radius.circular(20.0),
  //                             //                       topLeft:
  //                             //                           Radius.circular(20.0),
  //                             //                       bottomLeft:
  //                             //                           Radius.circular(20.0)),
  //                             //                   boxShadow: [
  //                             //                     BoxShadow(
  //                             //                       color: Colors.white
  //                             //                           .withOpacity(0.5),
  //                             //                       spreadRadius: 5,
  //                             //                       blurRadius: 7,
  //                             //                       offset: const Offset(0,
  //                             //                           3), // changes position of shadow
  //                             //                     ),
  //                             //                   ],
  //                             //                 ),
  //                             //                 child: Column(
  //                             //                   children: [
  //                             //                     Container(
  //                             //                       height: 40,
  //                             //                       width: 40,
  //                             //                       margin: const EdgeInsets
  //                             //                               .fromLTRB(
  //                             //                           30, 20, 30, 10),
  //                             //                       decoration:
  //                             //                           const BoxDecoration(
  //                             //                         color: Colors.white,
  //                             //                         image: DecorationImage(
  //                             //                           image: AssetImage(
  //                             //                               "assets/images/Group 3.png"),
  //                             //                           fit: BoxFit.contain,
  //                             //                         ),
  //                             //                       ),
  //                             //                     ),
  //                             //                     Container(
  //                             //                       height: 40,
  //                             //                       width: 160,
  //                             //                       color: Colors.white,
  //                             //                       child: Center(
  //                             //                         child: Text(
  //                             //                           'Buy \nOnline',
  //                             //                           textAlign:
  //                             //                               TextAlign.center,
  //                             //                           style: TextStyle(
  //                             //                               fontSize: 18,
  //                             //                               fontFamily:
  //                             //                                   defaultFontFamily,
  //                             //                               fontWeight:
  //                             //                                   FontWeight.bold,
  //                             //                               color: Colors
  //                             //                                   .blueAccent
  //                             //                                   .shade400),
  //                             //                         ),
  //                             //                       ),
  //                             //                     ),
  //                             //                   ],
  //                             //                 ),
  //                             //               ),
  //                             //             ),
  //                             //
  //                             //             closedElevation: 6.0,
  //                             //             closedShape:
  //                             //                 const RoundedRectangleBorder(
  //                             //               borderRadius: BorderRadius.all(
  //                             //                 Radius.circular(56 / 2),
  //                             //               ),
  //                             //             ),
  //                             //             openBuilder: (context,
  //                             //                     VoidCallback _) =>
  //                             //                 WebViewScreen(
  //                             //                     key: _scaffoldKey,
  //                             //                     title: 'Buy Online',
  //                             //                     url_link:
  //                             //                         'https://bol.sudlife.in/ProductSelection/ProductSelectionPage'),
  //                             //           ),
  //                             //         ),
  //                             //         const SizedBox(
  //                             //           width: 20,
  //                             //         ),
  //                             //         Expanded(
  //                             //           child: OpenContainer(
  //                             //             // transitionType: transitionType,
  //                             //             transitionType:
  //                             //                 ContainerTransitionType.fade,
  //                             //             transitionDuration:
  //                             //                 const Duration(milliseconds: 500),
  //                             //             tappable: false,
  //                             //
  //                             //             closedBuilder: (context,
  //                             //                     VoidCallback openContainer) =>
  //                             //                 GestureDetector(
  //                             //               onTap: () {
  //                             //                 print('Clicker : ');
  //                             //                 openContainer();
  //                             //                 // your onOpen code
  //                             //               },
  //                             //               child: Container(
  //                             //                 height: 140,
  //                             //                 width: 80,
  //                             //                 //width: 200,
  //                             //                 decoration: BoxDecoration(
  //                             //                   color: Colors.white,
  //                             //                   borderRadius: const BorderRadius
  //                             //                           .only(
  //                             //                       topRight:
  //                             //                           Radius.circular(20.0),
  //                             //                       bottomRight:
  //                             //                           Radius.circular(20.0),
  //                             //                       topLeft:
  //                             //                           Radius.circular(20.0),
  //                             //                       bottomLeft:
  //                             //                           Radius.circular(20.0)),
  //                             //                   boxShadow: [
  //                             //                     BoxShadow(
  //                             //                       color: Colors.white
  //                             //                           .withOpacity(0.5),
  //                             //                       spreadRadius: 5,
  //                             //                       blurRadius: 7,
  //                             //                       offset: Offset(0,
  //                             //                           3), // changes position of shadow
  //                             //                     ),
  //                             //                   ],
  //                             //                 ),
  //                             //                 child: Column(
  //                             //                   children: [
  //                             //                     Container(
  //                             //                       height: 40,
  //                             //                       width: 40,
  //                             //                       margin: const EdgeInsets
  //                             //                               .fromLTRB(
  //                             //                           30, 20, 30, 10),
  //                             //                       decoration:
  //                             //                           const BoxDecoration(
  //                             //                         color: Colors.white,
  //                             //                         image: DecorationImage(
  //                             //                           image: AssetImage(
  //                             //                               "assets/images/Path 92.png"),
  //                             //                           fit: BoxFit.contain,
  //                             //                         ),
  //                             //                       ),
  //                             //                     ),
  //                             //                     Container(
  //                             //                       height: 40,
  //                             //                       width: 160,
  //                             //                       color: Colors.white,
  //                             //                       child: Center(
  //                             //                         child: Text(
  //                             //                           'Pay \nPremiums',
  //                             //                           textAlign:
  //                             //                               TextAlign.center,
  //                             //                           style: TextStyle(
  //                             //                               fontSize: 18,
  //                             //                               fontFamily:
  //                             //                                   defaultFontFamily,
  //                             //                               fontWeight:
  //                             //                                   FontWeight.bold,
  //                             //                               color: Colors
  //                             //                                   .blueAccent
  //                             //                                   .shade400),
  //                             //                         ),
  //                             //                       ),
  //                             //                     ),
  //                             //                   ],
  //                             //                 ),
  //                             //               ),
  //                             //             ),
  //                             //
  //                             //             closedElevation: 6.0,
  //                             //             closedShape:
  //                             //                 const RoundedRectangleBorder(
  //                             //               borderRadius: BorderRadius.all(
  //                             //                 Radius.circular(56 / 2),
  //                             //               ),
  //                             //             ),
  //                             //             openBuilder: (context,
  //                             //                     VoidCallback _) =>
  //                             //                 WebViewScreen(
  //                             //                     key: _scaffoldKey,
  //                             //                     title: 'Pay Premiums',
  //                             //                     url_link:
  //                             //                         'https://www.sudlife.in/customer-service/premium-payment-options'),
  //                             //           ),
  //                             //         ),
  //                             //         const SizedBox(
  //                             //           width: 20,
  //                             //         ),
  //                             //         Expanded(
  //                             //           child: OpenContainer(
  //                             //             // transitionType: transitionType,
  //                             //             transitionType:
  //                             //                 ContainerTransitionType.fade,
  //                             //             transitionDuration:
  //                             //                 const Duration(milliseconds: 500),
  //                             //             tappable: false,
  //                             //
  //                             //             closedBuilder: (context,
  //                             //                     VoidCallback openContainer) =>
  //                             //                 GestureDetector(
  //                             //               onTap: () {
  //                             //                 print('Clicker : ');
  //                             //                 openContainer();
  //                             //                 // your onOpen code
  //                             //               },
  //                             //               child: Container(
  //                             //                 height: 140,
  //                             //                 width: 80,
  //                             //                 decoration: BoxDecoration(
  //                             //                   color: Colors.white,
  //                             //                   borderRadius: const BorderRadius
  //                             //                           .only(
  //                             //                       topRight:
  //                             //                           Radius.circular(20.0),
  //                             //                       bottomRight:
  //                             //                           Radius.circular(20.0),
  //                             //                       topLeft:
  //                             //                           Radius.circular(20.0),
  //                             //                       bottomLeft:
  //                             //                           Radius.circular(20.0)),
  //                             //                   boxShadow: [
  //                             //                     BoxShadow(
  //                             //                       color: Colors.white
  //                             //                           .withOpacity(0.5),
  //                             //                       spreadRadius: 5,
  //                             //                       blurRadius: 7,
  //                             //                       offset: const Offset(0,
  //                             //                           3), // changes position of shadow
  //                             //                     ),
  //                             //                   ],
  //                             //                 ),
  //                             //                 child: Column(
  //                             //                   children: [
  //                             //                     Container(
  //                             //                       height: 40,
  //                             //                       width: 40,
  //                             //                       margin: const EdgeInsets
  //                             //                               .fromLTRB(
  //                             //                           30, 20, 30, 10),
  //                             //                       decoration:
  //                             //                           const BoxDecoration(
  //                             //                         color: Colors.white,
  //                             //                         image: DecorationImage(
  //                             //                           image: AssetImage(
  //                             //                               "assets/images/Group 3.png"),
  //                             //                           fit: BoxFit.contain,
  //                             //                         ),
  //                             //                       ),
  //                             //                     ),
  //                             //                     Container(
  //                             //                       height: 40,
  //                             //                       width: 160,
  //                             //                       color: Colors.white,
  //                             //                       child: Center(
  //                             //                         child: Text(
  //                             //                           'Insurance \nPlans',
  //                             //                           textAlign:
  //                             //                               TextAlign.center,
  //                             //                           style: TextStyle(
  //                             //                               fontSize: 18,
  //                             //                               fontFamily:
  //                             //                                   defaultFontFamily,
  //                             //                               fontWeight:
  //                             //                                   FontWeight.bold,
  //                             //                               color: Colors
  //                             //                                   .blueAccent
  //                             //                                   .shade400),
  //                             //                         ),
  //                             //                       ),
  //                             //                     ),
  //                             //                   ],
  //                             //                 ),
  //                             //               ),
  //                             //             ),
  //                             //
  //                             //             closedElevation: 6.0,
  //                             //             closedShape:
  //                             //                 const RoundedRectangleBorder(
  //                             //               borderRadius: BorderRadius.all(
  //                             //                 Radius.circular(56 / 2),
  //                             //               ),
  //                             //             ),
  //                             //             openBuilder: (context,
  //                             //                     VoidCallback _) =>
  //                             //                 WebViewScreen(
  //                             //
  //                             //                     key: _scaffoldKey,
  //                             //                     title: 'Insurance Plans',
  //                             //                     url_link:
  //                             //                         'https://www.sudlife.in/products/life-insurance'),
  //                             //           ),
  //                             //         ),
  //                             //         const SizedBox(
  //                             //           width: 20,
  //                             //         ),
  //                             //       ],
  //                             //     ),
  //                             //
  //                             //     const SizedBox(
  //                             //       height: 40,
  //                             //     ),
  //                             //
  //                             //     Row(
  //                             //       children: [
  //                             //         const SizedBox(
  //                             //           width: 20,
  //                             //         ),
  //                             //         Expanded(
  //                             //           child: OpenContainer(
  //                             //             // transitionType: transitionType,
  //                             //             transitionType:
  //                             //                 ContainerTransitionType.fade,
  //                             //             transitionDuration:
  //                             //                 const Duration(milliseconds: 500),
  //                             //             tappable: false,
  //                             //
  //                             //             closedBuilder: (context,
  //                             //                     VoidCallback openContainer) =>
  //                             //                 GestureDetector(
  //                             //               onTap: () {
  //                             //                 print('Clicker : ');
  //                             //                 openContainer();
  //                             //                 // your onOpen code
  //                             //               },
  //                             //               child: Container(
  //                             //                 height: 140,
  //                             //                 width: 80,
  //                             //                 decoration: BoxDecoration(
  //                             //                   color: Colors.white,
  //                             //                   borderRadius: const BorderRadius
  //                             //                           .only(
  //                             //                       topRight:
  //                             //                           Radius.circular(20.0),
  //                             //                       bottomRight:
  //                             //                           Radius.circular(20.0),
  //                             //                       topLeft:
  //                             //                           Radius.circular(20.0),
  //                             //                       bottomLeft:
  //                             //                           Radius.circular(20.0)),
  //                             //                   boxShadow: [
  //                             //                     BoxShadow(
  //                             //                       color: Colors.white
  //                             //                           .withOpacity(0.5),
  //                             //                       spreadRadius: 5,
  //                             //                       blurRadius: 7,
  //                             //                       offset: const Offset(0,
  //                             //                           3), // changes position of shadow
  //                             //                     ),
  //                             //                   ],
  //                             //                 ),
  //                             //                 child: Column(
  //                             //                   children: [
  //                             //                     Container(
  //                             //                       height: 40,
  //                             //                       width: 40,
  //                             //                       margin: const EdgeInsets
  //                             //                               .fromLTRB(
  //                             //                           30, 20, 30, 10),
  //                             //                       decoration:
  //                             //                           const BoxDecoration(
  //                             //                         color: Colors.white,
  //                             //                         image: DecorationImage(
  //                             //                           image: AssetImage(
  //                             //                               "assets/images/Path 107.png"),
  //                             //                           fit: BoxFit.contain,
  //                             //                         ),
  //                             //                       ),
  //                             //                     ),
  //                             //                     Container(
  //                             //                       height: 40,
  //                             //                       width: 160,
  //                             //                       color: Colors.white,
  //                             //                       child: Center(
  //                             //                         child: Text(
  //                             //                           'Calculate Your \nPremiums',
  //                             //                           textAlign:
  //                             //                               TextAlign.center,
  //                             //                           style: TextStyle(
  //                             //                               fontFamily:
  //                             //                                   defaultFontFamily,
  //                             //                               fontSize: 18,
  //                             //                               fontWeight:
  //                             //                                   FontWeight.bold,
  //                             //                               color: Colors
  //                             //                                   .blueAccent
  //                             //                                   .shade400),
  //                             //                         ),
  //                             //                       ),
  //                             //                     ),
  //                             //                   ],
  //                             //                 ),
  //                             //               ),
  //                             //             ),
  //                             //
  //                             //             closedElevation: 6.0,
  //                             //             closedShape:
  //                             //                 const RoundedRectangleBorder(
  //                             //               borderRadius: BorderRadius.all(
  //                             //                 Radius.circular(56 / 2),
  //                             //               ),
  //                             //             ),
  //                             //             openBuilder: (context,
  //                             //                     VoidCallback _) =>
  //                             //                 WebViewScreen(
  //                             //                     key: _scaffoldKey,
  //                             //                     title: 'Calculate Your Premiums',
  //                             //                     url_link:
  //                             //                         'https://si.sudlife.in/SalesIllustration/ProductPage.aspx'),
  //                             //           ),
  //                             //         ),
  //                             //         const SizedBox(
  //                             //           width: 20,
  //                             //         ),
  //                             //         Expanded(
  //                             //           child: OpenContainer(
  //                             //             // transitionType: transitionType,
  //                             //             transitionType:
  //                             //                 ContainerTransitionType.fade,
  //                             //             transitionDuration:
  //                             //                 const Duration(milliseconds: 500),
  //                             //             tappable: false,
  //                             //
  //                             //             closedBuilder: (context,
  //                             //                     VoidCallback openContainer) =>
  //                             //                 GestureDetector(
  //                             //               onTap: () {
  //                             //                 print('Clicker : ');
  //                             //                 openContainer();
  //                             //                 // your onOpen code
  //                             //               },
  //                             //               child: Container(
  //                             //                 height: 140,
  //                             //                 width: 80,
  //                             //                 decoration: BoxDecoration(
  //                             //                   color: Colors.white,
  //                             //                   borderRadius: const BorderRadius
  //                             //                           .only(
  //                             //                       topRight:
  //                             //                           Radius.circular(20.0),
  //                             //                       bottomRight:
  //                             //                           Radius.circular(20.0),
  //                             //                       topLeft:
  //                             //                           Radius.circular(20.0),
  //                             //                       bottomLeft:
  //                             //                           Radius.circular(20.0)),
  //                             //                   boxShadow: [
  //                             //                     BoxShadow(
  //                             //                       color: Colors.white
  //                             //                           .withOpacity(0.5),
  //                             //                       spreadRadius: 5,
  //                             //                       blurRadius: 7,
  //                             //                       offset: const Offset(0,
  //                             //                           3), // changes position of shadow
  //                             //                     ),
  //                             //                   ],
  //                             //                 ),
  //                             //                 child: Column(
  //                             //                   children: [
  //                             //                     Container(
  //                             //                       height: 40,
  //                             //                       width: 40,
  //                             //                       margin: const EdgeInsets
  //                             //                               .fromLTRB(
  //                             //                           30, 20, 30, 10),
  //                             //                       decoration:
  //                             //                           const BoxDecoration(
  //                             //                         color: Colors.white,
  //                             //                         image: DecorationImage(
  //                             //                           image: AssetImage(
  //                             //                               "assets/images/Group 6.png"),
  //                             //                           fit: BoxFit.contain,
  //                             //                         ),
  //                             //                       ),
  //                             //                     ),
  //                             //                     Container(
  //                             //                       height: 50,
  //                             //                       width: 160,
  //                             //                       color: Colors.white,
  //                             //                       child: Center(
  //                             //                         child: Text(
  //                             //                           'Customer \nPortal',
  //                             //                           textAlign:
  //                             //                               TextAlign.center,
  //                             //                           style: TextStyle(
  //                             //                               fontSize: 18,
  //                             //                               fontFamily:
  //                             //                                   defaultFontFamily,
  //                             //                               fontWeight:
  //                             //                                   FontWeight.bold,
  //                             //                               color: Colors
  //                             //                                   .blueAccent
  //                             //                                   .shade400),
  //                             //                         ),
  //                             //                       ),
  //                             //                     ),
  //                             //                   ],
  //                             //                 ),
  //                             //               ),
  //                             //             ),
  //                             //
  //                             //             closedElevation: 6.0,
  //                             //             closedShape:
  //                             //                 const RoundedRectangleBorder(
  //                             //               borderRadius: BorderRadius.all(
  //                             //                 Radius.circular(56 / 2),
  //                             //               ),
  //                             //             ),
  //                             //             openBuilder: (context,
  //                             //                     VoidCallback _) =>
  //                             //                 WebViewScreen(
  //                             //                     key: _scaffoldKey,
  //                             //                     title: 'Customer Portal',
  //                             //                     url_link:
  //                             //                         'https://customer.sudlife.in'),
  //                             //           ),
  //                             //         ),
  //                             //         const SizedBox(
  //                             //           width: 20,
  //                             //         ),
  //                             //         Expanded(
  //                             //           child: OpenContainer(
  //                             //             // transitionType: transitionType,
  //                             //             transitionType:
  //                             //                 ContainerTransitionType.fade,
  //                             //             transitionDuration:
  //                             //                 const Duration(milliseconds: 500),
  //                             //             tappable: false,
  //                             //
  //                             //             closedBuilder: (context,
  //                             //                     VoidCallback openContainer) =>
  //                             //                 GestureDetector(
  //                             //               onTap: () {
  //                             //                 print('Clicker : ');
  //                             //                 openContainer();
  //                             //                 // your onOpen code
  //                             //               },
  //                             //               child: Container(
  //                             //                 height: 140,
  //                             //                 width: 80,
  //                             //                 decoration: BoxDecoration(
  //                             //                   color: Colors.white,
  //                             //                   borderRadius: const BorderRadius
  //                             //                           .only(
  //                             //                       topRight:
  //                             //                           Radius.circular(20.0),
  //                             //                       bottomRight:
  //                             //                           Radius.circular(20.0),
  //                             //                       topLeft:
  //                             //                           Radius.circular(20.0),
  //                             //                       bottomLeft:
  //                             //                           Radius.circular(20.0)),
  //                             //                   boxShadow: [
  //                             //                     BoxShadow(
  //                             //                       color: Colors.white
  //                             //                           .withOpacity(0.5),
  //                             //                       spreadRadius: 5,
  //                             //                       blurRadius: 7,
  //                             //                       offset: const Offset(0,
  //                             //                           3), // changes position of shadow
  //                             //                     ),
  //                             //                   ],
  //                             //                 ),
  //                             //                 child: Column(
  //                             //                   children: [
  //                             //                     Container(
  //                             //                       height: 40,
  //                             //                       width: 40,
  //                             //                       margin: const EdgeInsets
  //                             //                               .fromLTRB(
  //                             //                           30, 20, 30, 10),
  //                             //                       decoration:
  //                             //                           const BoxDecoration(
  //                             //                         color: Colors.white,
  //                             //                         image: DecorationImage(
  //                             //                           image: AssetImage(
  //                             //                               "assets/images/Path 95.png"),
  //                             //                           fit: BoxFit.contain,
  //                             //                         ),
  //                             //                       ),
  //                             //                     ),
  //                             //                     Container(
  //                             //                       height: 50,
  //                             //                       width: 160,
  //                             //                       color: Colors.white,
  //                             //                       child: Center(
  //                             //                         child: Text(
  //                             //                           'Office \nLocator',
  //                             //                           textAlign:
  //                             //                               TextAlign.center,
  //                             //                           style: TextStyle(
  //                             //                               fontSize: 18,
  //                             //                               fontFamily:
  //                             //                                   defaultFontFamily,
  //                             //                               fontWeight:
  //                             //                                   FontWeight.bold,
  //                             //                               color: Colors
  //                             //                                   .blueAccent
  //                             //                                   .shade400),
  //                             //                         ),
  //                             //                       ),
  //                             //                     ),
  //                             //                   ],
  //                             //                 ),
  //                             //               ),
  //                             //             ),
  //                             //
  //                             //             closedElevation: 6.0,
  //                             //             closedShape:
  //                             //                 const RoundedRectangleBorder(
  //                             //               borderRadius: BorderRadius.all(
  //                             //                 Radius.circular(56 / 2),
  //                             //               ),
  //                             //             ),
  //                             //             openBuilder: (context,
  //                             //                     VoidCallback _) =>
  //                             //                 WebViewScreen(
  //                             //                     key: _scaffoldKey,
  //                             //                     title: 'Office Locator',
  //                             //                     url_link:
  //                             //                         'https://www.sudlife.in/contact-u'),
  //                             //           ),
  //                             //         ),
  //                             //         const SizedBox(
  //                             //           width: 20,
  //                             //         ),
  //                             //       ],
  //                             //     ),
  //                             //
  //                             //     const SizedBox(
  //                             //       height: 40,
  //                             //     ),
  //                             //
  //                             //     // Row(
  //                             //     //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                             //     //   children: [
  //                             //     //     const SizedBox(
  //                             //     //       width: 40,
  //                             //     //     ),
  //                             //     //     InkWell(
  //                             //     //       onTap: () {
  //                             //     //         Navigator.push(
  //                             //     //           context,
  //                             //     //           MaterialPageRoute(
  //                             //     //               builder: (context) => ChessGame()),
  //                             //     //         );
  //                             //     //       },
  //                             //     //       child: Container(
  //                             //     //         margin: const EdgeInsets.all(10),
  //                             //     //         height: 200,
  //                             //     //         width: 150,
  //                             //     //         decoration: const BoxDecoration(
  //                             //     //           image: DecorationImage(
  //                             //     //             image:
  //                             //     //                 AssetImage("assets/games/Chesss.png"),
  //                             //     //             fit: BoxFit.fill,
  //                             //     //           ),
  //                             //     //         ),
  //                             //     //       ),
  //                             //     //     ),
  //                             //     //
  //                             //     //     InkWell(
  //                             //     //       onTap: () {
  //                             //     //         Navigator.push(
  //                             //     //           context,
  //                             //     //           MaterialPageRoute(
  //                             //     //               // builder: (context) => ChessGame()),
  //                             //     //               builder: (context) => SplashScrenn()),
  //                             //     //         );
  //                             //     //       },
  //                             //     //       child: Container(
  //                             //     //         margin: const EdgeInsets.all(10),
  //                             //     //         height: 200,
  //                             //     //         width: 150,
  //                             //     //         decoration: const BoxDecoration(
  //                             //     //           image: DecorationImage(
  //                             //     //             image: AssetImage(
  //                             //     //                 "assets/games/Covi KIll.png"),
  //                             //     //             fit: BoxFit.fill,
  //                             //     //           ),
  //                             //     //         ),
  //                             //     //       ),
  //                             //     //     ),
  //                             //     //
  //                             //     //     InkWell(
  //                             //     //       onTap: () {},
  //                             //     //       child: Container(
  //                             //     //         margin: const EdgeInsets.all(10),
  //                             //     //         height: 200,
  //                             //     //         width: 150,
  //                             //     //         decoration: const BoxDecoration(
  //                             //     //           image: DecorationImage(
  //                             //     //             image: AssetImage(
  //                             //     //                 "assets/games/Fun Facts.png"),
  //                             //     //             fit: BoxFit.fill,
  //                             //     //           ),
  //                             //     //         ),
  //                             //     //       ),
  //                             //     //     ),
  //                             //     //
  //                             //     //     InkWell(
  //                             //     //       onTap: () {},
  //                             //     //       child: Container(
  //                             //     //         margin: const EdgeInsets.all(10),
  //                             //     //
  //                             //     //         height: 200,
  //                             //     //         width: 150,
  //                             //     //         decoration: const BoxDecoration(
  //                             //     //           image: DecorationImage(
  //                             //     //             image: AssetImage(
  //                             //     //                 "assets/games/Quiz Time.png"),
  //                             //     //             fit: BoxFit.fill,
  //                             //     //           ),
  //                             //     //         ),
  //                             //     //       ),
  //                             //     //     ),
  //                             //     //     const SizedBox(
  //                             //     //       width: 40,
  //                             //     //     ),
  //                             //     //   ],
  //                             //     // ),
  //                             //     //
  //                             //     // const SizedBox(
  //                             //     //   height: 40,
  //                             //     // ),
  //                             //
  //                             //   ],
  //                             // ),
  //
  //                             Column(
  //                               children: [
  //                                 const SizedBox(
  //                                   height: 20,
  //                                 ),
  //
  //                                 Row(
  //                                   children: [
  //                                     const SizedBox(
  //                                       width: 20,
  //                                     ),
  //                                     Expanded(
  //                                       child: OpenContainer(
  //                                         // transitionType: transitionType,
  //                                         transitionType:
  //                                             ContainerTransitionType.fade,
  //                                         transitionDuration:
  //                                             const Duration(milliseconds: 500),
  //                                         tappable: false,
  //
  //                                         closedBuilder: (context,
  //                                                 VoidCallback openContainer) =>
  //                                             GestureDetector(
  //                                           onTap: () {
  //                                             print('Clicker : ');
  //                                             openContainer();
  //                                             // your onOpen code
  //                                           },
  //                                           child: Container(
  //                                             height: 160,
  //                                             width: 80,
  //                                             decoration: BoxDecoration(
  //                                               color: Colors.white,
  //                                               // borderRadius: BorderRadius
  //                                               //     .only(
  //                                               //     topRight:
  //                                               //     Radius.circular(0.0),
  //                                               //     bottomRight:
  //                                               //     Radius.circular(0.0),
  //                                               //     topLeft:
  //                                               //     Radius.circular(0.0),
  //                                               //     bottomLeft:
  //                                               //     Radius.circular(0.0)),
  //                                               boxShadow: [
  //                                                 BoxShadow(
  //                                                   color: Colors.white
  //                                                       .withOpacity(0.5),
  //                                                   spreadRadius: 5,
  //                                                   blurRadius: 7,
  //                                                   offset: const Offset(0,
  //                                                       3), // changes position of shadow
  //                                                 ),
  //                                               ],
  //                                             ),
  //                                             child: Column(
  //                                               children: [
  //                                                 Container(
  //                                                   height: 40,
  //                                                   width: 40,
  //                                                   margin: const EdgeInsets
  //                                                           .fromLTRB(
  //                                                       30, 20, 30, 10),
  //                                                   decoration:
  //                                                       const BoxDecoration(
  //                                                     color: Colors.white,
  //                                                     image: DecorationImage(
  //                                                       image: AssetImage(
  //                                                           "assets/images/Group 3.png"),
  //                                                       fit: BoxFit.contain,
  //                                                     ),
  //                                                   ),
  //                                                 ),
  //                                                 Container(
  //                                                   height: 60,
  //                                                   width: 160,
  //                                                   color: Colors.white,
  //                                                   child: Center(
  //                                                     child: Text(
  //                                                       'Buy \nOnline',
  //                                                       textAlign:
  //                                                           TextAlign.center,
  //                                                       style: TextStyle(
  //                                                           fontSize: 16,
  //                                                           fontFamily:
  //                                                               defaultFontFamily,
  //                                                           fontWeight:
  //                                                               FontWeight.bold,
  //                                                           color: Color(
  //                                                               0xff2474b9)),
  //                                                     ),
  //                                                   ),
  //                                                 ),
  //                                               ],
  //                                             ),
  //                                           ),
  //                                         ),
  //
  //                                         closedElevation: 6.0,
  //                                         closedShape:
  //                                             const RoundedRectangleBorder(
  //                                           borderRadius: BorderRadius.all(
  //                                             Radius.circular(26 / 2),
  //                                           ),
  //                                         ),
  //                                         openBuilder: (context,
  //                                                 VoidCallback _) =>
  //                                             WebViewScreen(
  //                                                 key: _scaffoldKey,
  //                                                 title: 'Buy Online',
  //                                                 url_link:
  //                                                     'https://bol.sudlife.in/ProductSelection/ProductSelectionPage'),
  //                                       ),
  //                                     ),
  //                                     const SizedBox(
  //                                       width: 20,
  //                                     ),
  //                                     Expanded(
  //                                       child: OpenContainer(
  //                                         // transitionType: transitionType,
  //                                         transitionType:
  //                                             ContainerTransitionType.fade,
  //                                         transitionDuration:
  //                                             const Duration(milliseconds: 500),
  //                                         tappable: false,
  //
  //                                         closedBuilder: (context,
  //                                                 VoidCallback openContainer) =>
  //                                             GestureDetector(
  //                                           onTap: () {
  //                                             print('Clicker : ');
  //                                             openContainer();
  //                                             // your onOpen code
  //                                           },
  //                                           child: Container(
  //                                             height: 160,
  //                                             width: 80,
  //                                             //width: 200,
  //                                             decoration: BoxDecoration(
  //                                               color: Colors.white,
  //                                               // borderRadius: const BorderRadius
  //                                               //     .only(
  //                                               //     topRight:
  //                                               //     Radius.circular(20.0),
  //                                               //     bottomRight:
  //                                               //     Radius.circular(20.0),
  //                                               //     topLeft:
  //                                               //     Radius.circular(20.0),
  //                                               //     bottomLeft:
  //                                               //     Radius.circular(20.0)),
  //                                               boxShadow: [
  //                                                 BoxShadow(
  //                                                   color: Colors.white
  //                                                       .withOpacity(0.5),
  //                                                   spreadRadius: 5,
  //                                                   blurRadius: 7,
  //                                                   offset: Offset(0,
  //                                                       3), // changes position of shadow
  //                                                 ),
  //                                               ],
  //                                             ),
  //                                             child: Column(
  //                                               children: [
  //                                                 Container(
  //                                                   height: 40,
  //                                                   width: 40,
  //                                                   margin: const EdgeInsets
  //                                                           .fromLTRB(
  //                                                       30, 20, 30, 10),
  //                                                   decoration:
  //                                                       const BoxDecoration(
  //                                                     color: Colors.white,
  //                                                     image: DecorationImage(
  //                                                       image: AssetImage(
  //                                                           "assets/images/Path 92.png"),
  //                                                       fit: BoxFit.contain,
  //                                                     ),
  //                                                   ),
  //                                                 ),
  //                                                 Container(
  //                                                   height: 60,
  //                                                   width: 160,
  //                                                   color: Colors.white,
  //                                                   child: Center(
  //                                                     child: Text(
  //                                                       'Pay \nPremiums',
  //                                                       textAlign:
  //                                                           TextAlign.center,
  //                                                       style: TextStyle(
  //                                                           fontSize: 16,
  //                                                           fontFamily:
  //                                                               defaultFontFamily,
  //                                                           fontWeight:
  //                                                               FontWeight.bold,
  //                                                           color: Color(
  //                                                               0xff2474b9)),
  //                                                     ),
  //                                                   ),
  //                                                 ),
  //                                               ],
  //                                             ),
  //                                           ),
  //                                         ),
  //
  //                                         closedElevation: 6.0,
  //                                         closedShape:
  //                                             const RoundedRectangleBorder(
  //                                           borderRadius: BorderRadius.all(
  //                                             Radius.circular(26 / 2),
  //                                           ),
  //                                         ),
  //                                         openBuilder: (context,
  //                                                 VoidCallback _) =>
  //                                             WebViewScreen(
  //                                                 key: _scaffoldKey,
  //                                                 title: 'Pay Premiums',
  //                                                 url_link:
  //                                                     'https://www.sudlife.in/customer-service/premium-payment-options'),
  //                                       ),
  //                                     ),
  //                                     const SizedBox(
  //                                       width: 20,
  //                                     ),
  //                                   ],
  //                                 ),
  //
  //                                 const SizedBox(
  //                                   height: 40,
  //                                 ),
  //
  //                                 Row(
  //                                   children: [
  //                                     const SizedBox(
  //                                       width: 20,
  //                                     ),
  //                                     Expanded(
  //                                       child: OpenContainer(
  //                                         // transitionType: transitionType,
  //                                         transitionType:
  //                                             ContainerTransitionType.fade,
  //                                         transitionDuration:
  //                                             const Duration(milliseconds: 500),
  //                                         tappable: false,
  //
  //                                         closedBuilder: (context,
  //                                                 VoidCallback openContainer) =>
  //                                             GestureDetector(
  //                                           onTap: () {
  //                                             print('Clicker : ');
  //                                             openContainer();
  //                                             // your onOpen code
  //                                           },
  //                                           child: Container(
  //                                             height: 160,
  //                                             width: 80,
  //                                             decoration: BoxDecoration(
  //                                               color: Colors.white,
  //                                               // borderRadius: const BorderRadius
  //                                               //     .only(
  //                                               //     topRight:
  //                                               //     Radius.circular(20.0),
  //                                               //     bottomRight:
  //                                               //     Radius.circular(20.0),
  //                                               //     topLeft:
  //                                               //     Radius.circular(20.0),
  //                                               //     bottomLeft:
  //                                               //     Radius.circular(20.0)),
  //                                               boxShadow: [
  //                                                 BoxShadow(
  //                                                   color: Colors.white
  //                                                       .withOpacity(0.5),
  //                                                   spreadRadius: 5,
  //                                                   blurRadius: 7,
  //                                                   offset: const Offset(0,
  //                                                       3), // changes position of shadow
  //                                                 ),
  //                                               ],
  //                                             ),
  //                                             child: Column(
  //                                               children: [
  //                                                 Container(
  //                                                   height: 40,
  //                                                   width: 40,
  //                                                   margin: const EdgeInsets
  //                                                           .fromLTRB(
  //                                                       30, 20, 30, 10),
  //                                                   decoration:
  //                                                       const BoxDecoration(
  //                                                     color: Colors.white,
  //                                                     image: DecorationImage(
  //                                                       image: AssetImage(
  //                                                           "assets/images/Group 3.png"),
  //                                                       fit: BoxFit.contain,
  //                                                     ),
  //                                                   ),
  //                                                 ),
  //                                                 Container(
  //                                                   height: 60,
  //                                                   width: 160,
  //                                                   color: Colors.white,
  //                                                   child: Center(
  //                                                     child: Text(
  //                                                       'Insurance \nPlans',
  //                                                       textAlign:
  //                                                           TextAlign.center,
  //                                                       style: TextStyle(
  //                                                           fontSize: 16,
  //                                                           fontFamily:
  //                                                               defaultFontFamily,
  //                                                           fontWeight:
  //                                                               FontWeight.bold,
  //                                                           color: Color(
  //                                                               0xff2474b9)),
  //                                                     ),
  //                                                   ),
  //                                                 ),
  //                                               ],
  //                                             ),
  //                                           ),
  //                                         ),
  //
  //                                         closedElevation: 6.0,
  //                                         closedShape:
  //                                             const RoundedRectangleBorder(
  //                                           borderRadius: BorderRadius.all(
  //                                             Radius.circular(26 / 2),
  //                                           ),
  //                                         ),
  //                                         openBuilder: (context,
  //                                                 VoidCallback _) =>
  //                                             WebViewScreen(
  //                                                 key: _scaffoldKey,
  //                                                 title: 'Insurance Plans',
  //                                                 url_link:
  //                                                     'https://www.sudlife.in/products/life-insurance'),
  //                                       ),
  //                                     ),
  //                                     const SizedBox(
  //                                       width: 20,
  //                                     ),
  //                                     Expanded(
  //                                       child: OpenContainer(
  //                                         // transitionType: transitionType,
  //                                         transitionType:
  //                                             ContainerTransitionType.fade,
  //                                         transitionDuration:
  //                                             const Duration(milliseconds: 500),
  //                                         tappable: false,
  //
  //                                         closedBuilder: (context,
  //                                                 VoidCallback openContainer) =>
  //                                             GestureDetector(
  //                                           onTap: () {
  //                                             print('Clicker : ');
  //                                             openContainer();
  //                                             // your onOpen code
  //                                           },
  //                                           child: Container(
  //                                             height: 160,
  //                                             width: 80,
  //                                             decoration: BoxDecoration(
  //                                               color: Colors.white,
  //                                               // borderRadius: const BorderRadius
  //                                               //     .only(
  //                                               //     topRight:
  //                                               //     Radius.circular(20.0),
  //                                               //     bottomRight:
  //                                               //     Radius.circular(20.0),
  //                                               //     topLeft:
  //                                               //     Radius.circular(20.0),
  //                                               //     bottomLeft:
  //                                               //     Radius.circular(20.0)),
  //                                               boxShadow: [
  //                                                 BoxShadow(
  //                                                   color: Colors.white
  //                                                       .withOpacity(0.5),
  //                                                   spreadRadius: 5,
  //                                                   blurRadius: 7,
  //                                                   offset: const Offset(0,
  //                                                       3), // changes position of shadow
  //                                                 ),
  //                                               ],
  //                                             ),
  //                                             child: Column(
  //                                               children: [
  //                                                 Container(
  //                                                   height: 40,
  //                                                   width: 40,
  //                                                   margin: const EdgeInsets
  //                                                           .fromLTRB(
  //                                                       30, 20, 30, 10),
  //                                                   decoration:
  //                                                       const BoxDecoration(
  //                                                     color: Colors.white,
  //                                                     image: DecorationImage(
  //                                                       image: AssetImage(
  //                                                           "assets/images/Path 107.png"),
  //                                                       fit: BoxFit.contain,
  //                                                     ),
  //                                                   ),
  //                                                 ),
  //                                                 Container(
  //                                                   height: 60,
  //                                                   width: 160,
  //                                                   color: Colors.white,
  //                                                   child: Center(
  //                                                     child: Text(
  //                                                       'Calculate Your \nPremiums',
  //                                                       textAlign:
  //                                                           TextAlign.center,
  //                                                       style: TextStyle(
  //                                                           fontFamily:
  //                                                               defaultFontFamily,
  //                                                           fontSize: 16,
  //                                                           fontWeight:
  //                                                               FontWeight.bold,
  //                                                           color: Color(
  //                                                               0xff2474b9)),
  //                                                     ),
  //                                                   ),
  //                                                 ),
  //                                               ],
  //                                             ),
  //                                           ),
  //                                         ),
  //
  //                                         closedElevation: 6.0,
  //                                         closedShape:
  //                                             const RoundedRectangleBorder(
  //                                           borderRadius: BorderRadius.all(
  //                                             Radius.circular(26 / 2),
  //                                           ),
  //                                         ),
  //                                         openBuilder: (context, VoidCallback _) =>
  //                                             WebViewScreen(
  //                                                 key: _scaffoldKey,
  //                                                 title:
  //                                                     'Calculate Your Premiums',
  //                                                 url_link:
  //                                                     'https://si.sudlife.in/SalesIllustration/ProductPage.aspx'),
  //                                       ),
  //                                     ),
  //                                     const SizedBox(
  //                                       width: 20,
  //                                     ),
  //                                     // Expanded(
  //                                     //   child: OpenContainer(
  //                                     //     // transitionType: transitionType,
  //                                     //     transitionType:
  //                                     //     ContainerTransitionType.fade,
  //                                     //     transitionDuration:
  //                                     //     const Duration(milliseconds: 500),
  //                                     //     tappable: false,
  //                                     //
  //                                     //     closedBuilder: (context,
  //                                     //         VoidCallback openContainer) =>
  //                                     //         GestureDetector(
  //                                     //           onTap: () {
  //                                     //             print('Clicker : ');
  //                                     //             openContainer();
  //                                     //             // your onOpen code
  //                                     //           },
  //                                     //           child: Container(
  //                                     //             height: 160,
  //                                     //             width: 80,
  //                                     //             //width: 200,
  //                                     //             decoration: BoxDecoration(
  //                                     //               color: Colors.white,
  //                                     //               // borderRadius: const BorderRadius
  //                                     //               //     .only(
  //                                     //               //     topRight:
  //                                     //               //     Radius.circular(20.0),
  //                                     //               //     bottomRight:
  //                                     //               //     Radius.circular(20.0),
  //                                     //               //     topLeft:
  //                                     //               //     Radius.circular(20.0),
  //                                     //               //     bottomLeft:
  //                                     //               //     Radius.circular(20.0)),
  //                                     //               boxShadow: [
  //                                     //                 BoxShadow(
  //                                     //                   color: Colors.white
  //                                     //                       .withOpacity(0.5),
  //                                     //                   spreadRadius: 5,
  //                                     //                   blurRadius: 7,
  //                                     //                   offset: Offset(0,
  //                                     //                       3), // changes position of shadow
  //                                     //                 ),
  //                                     //               ],
  //                                     //             ),
  //                                     //             child: Column(
  //                                     //               children: [
  //                                     //                 Container(
  //                                     //                   height: 40,
  //                                     //                   width: 40,
  //                                     //                   margin: const EdgeInsets
  //                                     //                       .fromLTRB(
  //                                     //                       30, 20, 30, 10),
  //                                     //                   decoration:
  //                                     //                   const BoxDecoration(
  //                                     //                     color: Colors.white,
  //                                     //                     image: DecorationImage(
  //                                     //                       image: AssetImage(
  //                                     //                           "assets/images/Path 92.png"),
  //                                     //                       fit: BoxFit.contain,
  //                                     //                     ),
  //                                     //                   ),
  //                                     //                 ),
  //                                     //                 Container(
  //                                     //                   height: 60,
  //                                     //                   width: 160,
  //                                     //                   color: Colors.white,
  //                                     //                   child: Center(
  //                                     //                     child: Text(
  //                                     //                       'Pay \nPremiums',
  //                                     //                       textAlign:
  //                                     //                       TextAlign.center,
  //                                     //                       style: TextStyle(
  //                                     //                           fontSize: 16,
  //                                     //                           fontFamily:
  //                                     //                           defaultFontFamily,
  //                                     //                           fontWeight:
  //                                     //                           FontWeight.bold,
  //                                     //                           color: Colors
  //                                     //                               .blueAccent
  //                                     //                               .shade400),
  //                                     //                     ),
  //                                     //                   ),
  //                                     //                 ),
  //                                     //               ],
  //                                     //             ),
  //                                     //           ),
  //                                     //         ),
  //                                     //
  //                                     //     closedElevation: 6.0,
  //                                     //     closedShape:
  //                                     //     const RoundedRectangleBorder(
  //                                     //       borderRadius: BorderRadius.all(
  //                                     //         Radius.circular(56 / 2),
  //                                     //       ),
  //                                     //     ),
  //                                     //     openBuilder: (context,
  //                                     //         VoidCallback _) =>
  //                                     //         WebViewScreen(
  //                                     //             key: _scaffoldKey,
  //                                     //             title: 'Pay Premiums',
  //                                     //             url_link:
  //                                     //             'https://www.sudlife.in/customer-service/premium-payment-options'),
  //                                     //   ),
  //                                     // ),
  //                                     // const SizedBox(
  //                                     //   width: 20,
  //                                     // ),
  //                                     // Expanded(
  //                                     //   child: OpenContainer(
  //                                     //     // transitionType: transitionType,
  //                                     //     transitionType:
  //                                     //     ContainerTransitionType.fade,
  //                                     //     transitionDuration:
  //                                     //     const Duration(milliseconds: 500),
  //                                     //     tappable: false,
  //                                     //
  //                                     //     closedBuilder: (context,
  //                                     //         VoidCallback openContainer) =>
  //                                     //         GestureDetector(
  //                                     //           onTap: () {
  //                                     //             print('Clicker : ');
  //                                     //             openContainer();
  //                                     //             // your onOpen code
  //                                     //           },
  //                                     //           child: Container(
  //                                     //             height: 160,
  //                                     //             width: 80,
  //                                     //             decoration: BoxDecoration(
  //                                     //               color: Colors.white,
  //                                     //               // borderRadius: const BorderRadius
  //                                     //               //     .only(
  //                                     //               //     topRight:
  //                                     //               //     Radius.circular(20.0),
  //                                     //               //     bottomRight:
  //                                     //               //     Radius.circular(20.0),
  //                                     //               //     topLeft:
  //                                     //               //     Radius.circular(20.0),
  //                                     //               //     bottomLeft:
  //                                     //               //     Radius.circular(20.0)),
  //                                     //               boxShadow: [
  //                                     //                 BoxShadow(
  //                                     //                   color: Colors.white
  //                                     //                       .withOpacity(0.5),
  //                                     //                   spreadRadius: 5,
  //                                     //                   blurRadius: 7,
  //                                     //                   offset: const Offset(0,
  //                                     //                       3), // changes position of shadow
  //                                     //                 ),
  //                                     //               ],
  //                                     //             ),
  //                                     //             child: Column(
  //                                     //               children: [
  //                                     //                 Container(
  //                                     //                   height: 40,
  //                                     //                   width: 40,
  //                                     //                   margin: const EdgeInsets
  //                                     //                       .fromLTRB(
  //                                     //                       30, 20, 30, 10),
  //                                     //                   decoration:
  //                                     //                   const BoxDecoration(
  //                                     //                     color: Colors.white,
  //                                     //                     image: DecorationImage(
  //                                     //                       image: AssetImage(
  //                                     //                           "assets/images/Group 3.png"),
  //                                     //                       fit: BoxFit.contain,
  //                                     //                     ),
  //                                     //                   ),
  //                                     //                 ),
  //                                     //                 Container(
  //                                     //                   height: 60,
  //                                     //                   width: 160,
  //                                     //                   color: Colors.white,
  //                                     //                   child: Center(
  //                                     //                     child: Text(
  //                                     //                       'Insurance \nPlans',
  //                                     //                       textAlign:
  //                                     //                       TextAlign.center,
  //                                     //                       style: TextStyle(
  //                                     //                           fontSize: 16,
  //                                     //                           fontFamily:
  //                                     //                           defaultFontFamily,
  //                                     //                           fontWeight:
  //                                     //                           FontWeight.bold,
  //                                     //                           color: Colors
  //                                     //                               .blueAccent
  //                                     //                               .shade400),
  //                                     //                     ),
  //                                     //                   ),
  //                                     //                 ),
  //                                     //               ],
  //                                     //             ),
  //                                     //           ),
  //                                     //         ),
  //                                     //
  //                                     //     closedElevation: 6.0,
  //                                     //     closedShape:
  //                                     //     const RoundedRectangleBorder(
  //                                     //       borderRadius: BorderRadius.all(
  //                                     //         Radius.circular(56 / 2),
  //                                     //       ),
  //                                     //     ),
  //                                     //     openBuilder: (context,
  //                                     //         VoidCallback _) =>
  //                                     //         WebViewScreen(
  //                                     //
  //                                     //             key: _scaffoldKey,
  //                                     //             title: 'Insurance Plans',
  //                                     //             url_link:
  //                                     //             'https://www.sudlife.in/products/life-insurance'),
  //                                     //   ),
  //                                     // ),
  //                                     // const SizedBox(
  //                                     //   width: 20,
  //                                     // ),
  //                                   ],
  //                                 ),
  //
  //                                 const SizedBox(
  //                                   height: 40,
  //                                 ),
  //
  //                                 Row(
  //                                   children: [
  //                                     const SizedBox(
  //                                       width: 20,
  //                                     ),
  //                                     // Expanded(
  //                                     //   child: OpenContainer(
  //                                     //     // transitionType: transitionType,
  //                                     //     transitionType:
  //                                     //     ContainerTransitionType.fade,
  //                                     //     transitionDuration:
  //                                     //     const Duration(milliseconds: 500),
  //                                     //     tappable: false,
  //                                     //
  //                                     //     closedBuilder: (context,
  //                                     //         VoidCallback openContainer) =>
  //                                     //         GestureDetector(
  //                                     //           onTap: () {
  //                                     //             print('Clicker : ');
  //                                     //             openContainer();
  //                                     //             // your onOpen code
  //                                     //           },
  //                                     //           child: Container(
  //                                     //             height: 160,
  //                                     //             width: 80,
  //                                     //             decoration: BoxDecoration(
  //                                     //               color: Colors.white,
  //                                     //               // borderRadius: const BorderRadius
  //                                     //               //     .only(
  //                                     //               //     topRight:
  //                                     //               //     Radius.circular(20.0),
  //                                     //               //     bottomRight:
  //                                     //               //     Radius.circular(20.0),
  //                                     //               //     topLeft:
  //                                     //               //     Radius.circular(20.0),
  //                                     //               //     bottomLeft:
  //                                     //               //     Radius.circular(20.0)),
  //                                     //               boxShadow: [
  //                                     //                 BoxShadow(
  //                                     //                   color: Colors.white
  //                                     //                       .withOpacity(0.5),
  //                                     //                   spreadRadius: 5,
  //                                     //                   blurRadius: 7,
  //                                     //                   offset: const Offset(0,
  //                                     //                       3), // changes position of shadow
  //                                     //                 ),
  //                                     //               ],
  //                                     //             ),
  //                                     //             child: Column(
  //                                     //               children: [
  //                                     //                 Container(
  //                                     //                   height: 40,
  //                                     //                   width: 40,
  //                                     //                   margin: const EdgeInsets
  //                                     //                       .fromLTRB(
  //                                     //                       30, 20, 30, 10),
  //                                     //                   decoration:
  //                                     //                   const BoxDecoration(
  //                                     //                     color: Colors.white,
  //                                     //                     image: DecorationImage(
  //                                     //                       image: AssetImage(
  //                                     //                           "assets/images/Path 107.png"),
  //                                     //                       fit: BoxFit.contain,
  //                                     //                     ),
  //                                     //                   ),
  //                                     //                 ),
  //                                     //                 Container(
  //                                     //                   height: 60,
  //                                     //                   width: 160,
  //                                     //                   color: Colors.white,
  //                                     //                   child: Center(
  //                                     //                     child: Text(
  //                                     //                       'Calculate Your \nPremiums',
  //                                     //                       textAlign:
  //                                     //                       TextAlign.center,
  //                                     //                       style: TextStyle(
  //                                     //                           fontFamily:
  //                                     //                           defaultFontFamily,
  //                                     //                           fontSize: 16,
  //                                     //                           fontWeight:
  //                                     //                           FontWeight.bold,
  //                                     //                           color: Colors
  //                                     //                               .blueAccent
  //                                     //                               .shade400),
  //                                     //                     ),
  //                                     //                   ),
  //                                     //                 ),
  //                                     //               ],
  //                                     //             ),
  //                                     //           ),
  //                                     //         ),
  //                                     //
  //                                     //     closedElevation: 6.0,
  //                                     //     closedShape:
  //                                     //     const RoundedRectangleBorder(
  //                                     //       borderRadius: BorderRadius.all(
  //                                     //         Radius.circular(56 / 2),
  //                                     //       ),
  //                                     //     ),
  //                                     //     openBuilder: (context,
  //                                     //         VoidCallback _) =>
  //                                     //         WebViewScreen(
  //                                     //             key: _scaffoldKey,
  //                                     //             title: 'Calculate Your Premiums',
  //                                     //             url_link:
  //                                     //             'https://si.sudlife.in/SalesIllustration/ProductPage.aspx'),
  //                                     //   ),
  //                                     // ),
  //                                     // const SizedBox(
  //                                     //   width: 20,
  //                                     // ),
  //                                     Expanded(
  //                                       child: OpenContainer(
  //                                         // transitionType: transitionType,
  //                                         transitionType:
  //                                             ContainerTransitionType.fade,
  //                                         transitionDuration:
  //                                             const Duration(milliseconds: 500),
  //                                         tappable: false,
  //
  //                                         closedBuilder: (context,
  //                                                 VoidCallback openContainer) =>
  //                                             GestureDetector(
  //                                           onTap: () {
  //                                             print('Clicker : ');
  //                                             openContainer();
  //                                             // your onOpen code
  //                                           },
  //                                           child: Container(
  //                                             height: 160,
  //                                             width: 80,
  //                                             decoration: BoxDecoration(
  //                                               color: Colors.white,
  //                                               // borderRadius: const BorderRadius
  //                                               //     .only(
  //                                               //     topRight:
  //                                               //     Radius.circular(20.0),
  //                                               //     bottomRight:
  //                                               //     Radius.circular(20.0),
  //                                               //     topLeft:
  //                                               //     Radius.circular(20.0),
  //                                               //     bottomLeft:
  //                                               //     Radius.circular(20.0)),
  //                                               boxShadow: [
  //                                                 BoxShadow(
  //                                                   color: Colors.white
  //                                                       .withOpacity(0.5),
  //                                                   spreadRadius: 5,
  //                                                   blurRadius: 7,
  //                                                   offset: const Offset(0,
  //                                                       3), // changes position of shadow
  //                                                 ),
  //                                               ],
  //                                             ),
  //                                             child: Column(
  //                                               children: [
  //                                                 Container(
  //                                                   height: 40,
  //                                                   width: 40,
  //                                                   margin: const EdgeInsets
  //                                                           .fromLTRB(
  //                                                       30, 20, 30, 10),
  //                                                   decoration:
  //                                                       const BoxDecoration(
  //                                                     color: Colors.white,
  //                                                     image: DecorationImage(
  //                                                       image: AssetImage(
  //                                                           "assets/images/Group 6.png"),
  //                                                       fit: BoxFit.contain,
  //                                                     ),
  //                                                   ),
  //                                                 ),
  //                                                 Container(
  //                                                   height: 60,
  //                                                   width: 160,
  //                                                   color: Colors.white,
  //                                                   child: Center(
  //                                                     child: Text(
  //                                                       'Customer \nPortal',
  //                                                       textAlign:
  //                                                           TextAlign.center,
  //                                                       style: TextStyle(
  //                                                           fontSize: 16,
  //                                                           fontFamily:
  //                                                               defaultFontFamily,
  //                                                           fontWeight:
  //                                                               FontWeight.bold,
  //                                                           color: Color(
  //                                                               0xff2474b9)),
  //                                                     ),
  //                                                   ),
  //                                                 ),
  //                                               ],
  //                                             ),
  //                                           ),
  //                                         ),
  //
  //                                         closedElevation: 6.0,
  //                                         closedShape:
  //                                             const RoundedRectangleBorder(
  //                                           borderRadius: BorderRadius.all(
  //                                             Radius.circular(26 / 2),
  //                                           ),
  //                                         ),
  //                                         openBuilder: (context,
  //                                                 VoidCallback _) =>
  //                                             WebViewScreen(
  //                                                 key: _scaffoldKey,
  //                                                 title: 'Customer Portal',
  //                                                 url_link:
  //                                                     // 'https://customer.sudlife.in'),
  //                                                     'https://www.sudlife.in/contact-us'),
  //                                       ),
  //                                     ),
  //                                     const SizedBox(
  //                                       width: 20,
  //                                     ),
  //                                     Expanded(
  //                                       child: OpenContainer(
  //                                         // transitionType: transitionType,
  //                                         transitionType:
  //                                             ContainerTransitionType.fade,
  //                                         transitionDuration:
  //                                             const Duration(milliseconds: 500),
  //                                         tappable: false,
  //
  //                                         closedBuilder: (context,
  //                                                 VoidCallback openContainer) =>
  //                                             GestureDetector(
  //                                           onTap: () {
  //                                             print('Clicker : ');
  //                                             openContainer();
  //                                             // your onOpen code
  //                                           },
  //                                           child: Container(
  //                                             height: 160,
  //                                             width: 80,
  //                                             decoration: BoxDecoration(
  //                                               color: Colors.white,
  //                                               // borderRadius: const BorderRadius
  //                                               //     .only(
  //                                               //     topRight:
  //                                               //     Radius.circular(20.0),
  //                                               //     bottomRight:
  //                                               //     Radius.circular(20.0),
  //                                               //     topLeft:
  //                                               //     Radius.circular(20.0),
  //                                               //     bottomLeft:
  //                                               //     Radius.circular(20.0)),
  //                                               boxShadow: [
  //                                                 BoxShadow(
  //                                                   color: Colors.white
  //                                                       .withOpacity(0.5),
  //                                                   spreadRadius: 5,
  //                                                   blurRadius: 7,
  //                                                   offset: const Offset(0,
  //                                                       3), // changes position of shadow
  //                                                 ),
  //                                               ],
  //                                             ),
  //                                             child: Column(
  //                                               children: [
  //                                                 Container(
  //                                                   height: 40,
  //                                                   width: 40,
  //                                                   margin: const EdgeInsets
  //                                                           .fromLTRB(
  //                                                       30, 20, 30, 10),
  //                                                   decoration:
  //                                                       const BoxDecoration(
  //                                                     color: Colors.white,
  //                                                     image: DecorationImage(
  //                                                       image: AssetImage(
  //                                                           "assets/images/Path 95.png"),
  //                                                       fit: BoxFit.contain,
  //                                                     ),
  //                                                   ),
  //                                                 ),
  //                                                 Container(
  //                                                   height: 60,
  //                                                   width: 160,
  //                                                   color: Colors.white,
  //                                                   child: Center(
  //                                                     child: Text(
  //                                                       'Office \nLocator',
  //                                                       textAlign:
  //                                                           TextAlign.center,
  //                                                       style: TextStyle(
  //                                                           fontSize: 16,
  //                                                           fontFamily:
  //                                                               defaultFontFamily,
  //                                                           fontWeight:
  //                                                               FontWeight.bold,
  //                                                           color: Color(
  //                                                               0xff2474b9)),
  //                                                     ),
  //                                                   ),
  //                                                 ),
  //                                               ],
  //                                             ),
  //                                           ),
  //                                         ),
  //
  //                                         closedElevation: 6.0,
  //                                         closedShape:
  //                                             const RoundedRectangleBorder(
  //                                           borderRadius: BorderRadius.all(
  //                                             Radius.circular(26 / 2),
  //                                           ),
  //                                         ),
  //                                         openBuilder: (context,
  //                                                 VoidCallback _) =>
  //                                             WebViewScreen(
  //                                                 key: _scaffoldKey,
  //                                                 title: 'Office Locator',
  //                                                 url_link:
  //                                                     'https://www.sudlife.in/contact-us'),
  //                                       ),
  //                                     ),
  //                                     const SizedBox(
  //                                       width: 20,
  //                                     ),
  //                                   ],
  //                                 ),
  //
  //                                 const SizedBox(
  //                                   height: 40,
  //                                 ),
  //
  //                                 // Row(
  //                                 //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                                 //   children: [
  //                                 //     const SizedBox(
  //                                 //       width: 40,
  //                                 //     ),
  //                                 //     InkWell(
  //                                 //       onTap: () {
  //                                 //         Navigator.push(
  //                                 //           context,
  //                                 //           MaterialPageRoute(
  //                                 //               builder: (context) => ChessGame()),
  //                                 //         );
  //                                 //       },
  //                                 //       child: Container(
  //                                 //         margin: const EdgeInsets.all(10),
  //                                 //         height: 200,
  //                                 //         width: 150,
  //                                 //         decoration: const BoxDecoration(
  //                                 //           image: DecorationImage(
  //                                 //             image:
  //                                 //                 AssetImage("assets/games/Chesss.png"),
  //                                 //             fit: BoxFit.fill,
  //                                 //           ),
  //                                 //         ),
  //                                 //       ),
  //                                 //     ),
  //                                 //
  //                                 //     InkWell(
  //                                 //       onTap: () {
  //                                 //         Navigator.push(
  //                                 //           context,
  //                                 //           MaterialPageRoute(
  //                                 //               // builder: (context) => ChessGame()),
  //                                 //               builder: (context) => SplashScrenn()),
  //                                 //         );
  //                                 //       },
  //                                 //       child: Container(
  //                                 //         margin: const EdgeInsets.all(10),
  //                                 //         height: 200,
  //                                 //         width: 150,
  //                                 //         decoration: const BoxDecoration(
  //                                 //           image: DecorationImage(
  //                                 //             image: AssetImage(
  //                                 //                 "assets/games/Covi KIll.png"),
  //                                 //             fit: BoxFit.fill,
  //                                 //           ),
  //                                 //         ),
  //                                 //       ),
  //                                 //     ),
  //                                 //
  //                                 //     InkWell(
  //                                 //       onTap: () {},
  //                                 //       child: Container(
  //                                 //         margin: const EdgeInsets.all(10),
  //                                 //         height: 200,
  //                                 //         width: 150,
  //                                 //         decoration: const BoxDecoration(
  //                                 //           image: DecorationImage(
  //                                 //             image: AssetImage(
  //                                 //                 "assets/games/Fun Facts.png"),
  //                                 //             fit: BoxFit.fill,
  //                                 //           ),
  //                                 //         ),
  //                                 //       ),
  //                                 //     ),
  //                                 //
  //                                 //     InkWell(
  //                                 //       onTap: () {},
  //                                 //       child: Container(
  //                                 //         margin: const EdgeInsets.all(10),
  //                                 //
  //                                 //         height: 200,
  //                                 //         width: 150,
  //                                 //         decoration: const BoxDecoration(
  //                                 //           image: DecorationImage(
  //                                 //             image: AssetImage(
  //                                 //                 "assets/games/Quiz Time.png"),
  //                                 //             fit: BoxFit.fill,
  //                                 //           ),
  //                                 //         ),
  //                                 //       ),
  //                                 //     ),
  //                                 //     const SizedBox(
  //                                 //       width: 40,
  //                                 //     ),
  //                                 //   ],
  //                                 // ),
  //                                 //
  //                                 // const SizedBox(
  //                                 //   height: 40,
  //                                 // ),
  //                               ],
  //                             ),
  //
  //                             // Container(
  //                             //   child: PhysicalModel(
  //                             //     borderRadius: BorderRadius.circular(20),
  //                             //     color: Colors.blue,
  //                             //     elevation: 18,
  //                             //     shadowColor: Colors.red,
  //                             //     child: Container(
  //                             //       height: 100,
  //                             //       width: 100,
  //                             //     ),
  //                             //   ),
  //                             // ),
  //                             // SizedBox(
  //                             //   height: 60,
  //                             // ),
  //                             // Container(
  //                             //   child: PhysicalShape(
  //                             //     color: Colors.blue,
  //                             //     shadowColor: Colors.red,
  //                             //     elevation: 18,
  //                             //     clipper: ShapeBorderClipper(shape: CircleBorder()),
  //                             //     child: Container(
  //                             //       height: 150,
  //                             //       width: 150,
  //                             //     ),
  //                             //   ),
  //                             // ),
  //
  //                             //Container(height: MediaQuery.of(context).size.height,)
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                   )
  //                 : SingleChildScrollView(
  //                     child: Container(
  //                       width: MediaQuery.of(context).size.width,
  //                       height: MediaQuery.of(context).size.height,
  //                       decoration: const BoxDecoration(
  //                         image: DecorationImage(
  //                           image: AssetImage("assets/images/Background.png"),
  //                           fit: BoxFit.fill,
  //                         ),
  //                       ),
  //                       child: Center(
  //                         child: SingleChildScrollView(
  //                           child: Column(
  //                             children: [
  //                               SizedBox(
  //                                 height: 80,
  //                               ),
  //
  //                               Row(
  //                                 children: [
  //                                   Expanded(
  //                                     child: Container(
  //                                       padding:
  //                                           EdgeInsets.fromLTRB(20, 0, 0, 0),
  //                                       child: Text(
  //                                         "SUD Life Experience Zone",
  //                                         textAlign: TextAlign.center,
  //                                         style: TextStyle(
  //                                             fontSize: 24,
  //                                             fontFamily: defaultFontFamily,
  //                                             fontWeight: FontWeight.w800,
  //                                             color: Colors.white),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                   // const Spacer(),
  //                                   // Expanded(
  //                                   //   child: InkWell(
  //                                   //     onTap: () {
  //                                   //       // Navigator.push(
  //                                   //       //   context,
  //                                   //       //   MaterialPageRoute(
  //                                   //       //       // builder: (context) => ChessGame()),
  //                                   //       //       builder: (context) => SplashScrenn()),
  //                                   //       // );
  //                                   //     },
  //                                   //     child: Container(
  //                                   //       height: 60,
  //                                   //       width: 70,
  //                                   //       decoration: const BoxDecoration(
  //                                   //         color: Colors.white,
  //                                   //         borderRadius: BorderRadius.only(
  //                                   //             // topRight: Radius.circular(40.0),
  //                                   //             // bottomRight: Radius.circular(40.0),
  //                                   //             topLeft: Radius.circular(20.0),
  //                                   //             bottomLeft:
  //                                   //                 Radius.circular(20.0)),
  //                                   //       ),
  //                                   //       child: Container(
  //                                   //         height: 50,
  //                                   //         width: 100,
  //                                   //         margin: const EdgeInsets.all(12),
  //                                   //         decoration: const BoxDecoration(
  //                                   //           color: Colors.white,
  //                                   //           image: DecorationImage(
  //                                   //             image: AssetImage(
  //                                   //                 "assets/images/site-logo.png"),
  //                                   //             fit: BoxFit.contain,
  //                                   //           ),
  //                                   //         ),
  //                                   //         child: null,
  //                                   //       ),
  //                                   //     ),
  //                                   //   ),
  //                                   // )
  //                                 ],
  //                               ),
  //
  //                               // Row(
  //                               //   children: [
  //                               //     Expanded(
  //                               //       child: Container(
  //                               //         padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
  //                               //         child: Text(
  //                               //           "SUD Life Experience Zone",
  //                               //           style: TextStyle(
  //                               //               fontSize: 32,
  //                               //               fontFamily: defaultFontFamily,
  //                               //               fontWeight: FontWeight.w700,
  //                               //               color: Colors.white),
  //                               //         ),
  //                               //       ),
  //                               //     ),
  //                               //     const Spacer(),
  //                               //     Expanded(
  //                               //       child: InkWell(
  //                               //         onTap: () {
  //                               //           // Navigator.push(
  //                               //           //   context,
  //                               //           //   MaterialPageRoute(
  //                               //           //       // builder: (context) => ChessGame()),
  //                               //           //       builder: (context) => SplashScrenn()),
  //                               //           // );
  //                               //         },
  //                               //         child: Container(
  //                               //           height: 90,
  //                               //           width: 120,
  //                               //           decoration: const BoxDecoration(
  //                               //             color: Colors.white,
  //                               //             borderRadius: BorderRadius.only(
  //                               //                 // topRight: Radius.circular(40.0),
  //                               //                 // bottomRight: Radius.circular(40.0),
  //                               //                 topLeft: Radius.circular(20.0),
  //                               //                 bottomLeft:
  //                               //                     Radius.circular(20.0)),
  //                               //           ),
  //                               //           child: Container(
  //                               //             height: 50,
  //                               //             width: 100,
  //                               //             margin: const EdgeInsets.all(12),
  //                               //             decoration: const BoxDecoration(
  //                               //               color: Colors.white,
  //                               //               image: DecorationImage(
  //                               //                 image: AssetImage(
  //                               //                     "assets/images/site-logo.png"),
  //                               //                 fit: BoxFit.contain,
  //                               //               ),
  //                               //             ),
  //                               //             child: null,
  //                               //           ),
  //                               //         ),
  //                               //       ),
  //                               //     )
  //                               //   ],
  //                               // ),
  //
  //                               const SizedBox(
  //                                 height: 20,
  //                               ),
  //
  //                               Column(
  //                                 children: [
  //                                   const SizedBox(
  //                                     height: 40,
  //                                   ),
  //
  //                                   Row(
  //                                     children: [
  //                                       const SizedBox(
  //                                         width: 70,
  //                                       ),
  //                                       Expanded(
  //                                         //child: InkWell(
  //                                         // onTap: () {
  //                                         //   Navigator.push(
  //                                         //     context,
  //                                         //     MaterialPageRoute(
  //                                         //         builder: (context) => WebViewScreen(
  //                                         //             key: _scaffoldKey,
  //                                         //             url_link:
  //                                         //                 'https://bol.sudlife.in/ProductSelection/ProductSelectionPage')),
  //                                         //   );
  //                                         // },
  //                                         // child: Container(
  //                                         //   margin: const EdgeInsets.all(10),
  //                                         //   height: 190,
  //                                         //   //width: 200,
  //                                         //   decoration: BoxDecoration(
  //                                         //     color: Colors.white,
  //                                         //     borderRadius: const BorderRadius.only(
  //                                         //         topRight: Radius.circular(20.0),
  //                                         //         bottomRight: Radius.circular(20.0),
  //                                         //         topLeft: Radius.circular(20.0),
  //                                         //         bottomLeft: Radius.circular(20.0)),
  //                                         //     boxShadow: [
  //                                         //       BoxShadow(
  //                                         //         color: Colors.white.withOpacity(0.5),
  //                                         //         spreadRadius: 5,
  //                                         //         blurRadius: 7,
  //                                         //         offset: const Offset(0,
  //                                         //             3), // changes position of shadow
  //                                         //       ),
  //                                         //     ],
  //                                         //   ),
  //                                         //   child: Column(
  //                                         //     children: [
  //                                         //       Container(
  //                                         //         height: 50,
  //                                         //         width: 50,
  //                                         //         margin: const EdgeInsets.fromLTRB(
  //                                         //             30, 30, 30, 10),
  //                                         //         decoration: const BoxDecoration(
  //                                         //           color: Colors.white,
  //                                         //           image: DecorationImage(
  //                                         //             image: AssetImage(
  //                                         //                 "assets/images/Group 3.png"),
  //                                         //             fit: BoxFit.contain,
  //                                         //           ),
  //                                         //         ),
  //                                         //       ),
  //                                         //       Container(
  //                                         //         height: 80,
  //                                         //         width: 160,
  //                                         //         color: Colors.white,
  //                                         //         child: Center(
  //                                         //           child: Text(
  //                                         //             'Buy \nOnline',
  //                                         //             style: TextStyle(
  //                                         //                 fontSize: 20,
  //                                         //                 fontFamily: defaultFontFamily,
  //                                         //                 fontWeight: FontWeight.bold,
  //                                         //                 color: Colors.blueAccent.shade400
  //                                         //                 ),
  //                                         //           ),
  //                                         //         ),
  //                                         //       ),
  //                                         //     ],
  //                                         //   ),
  //                                         // ),
  //                                         child: OpenContainer(
  //                                           // transitionType: transitionType,
  //                                           transitionType:
  //                                               ContainerTransitionType.fade,
  //                                           transitionDuration: const Duration(
  //                                               milliseconds: 500),
  //                                           tappable: false,
  //
  //                                           closedBuilder: (context,
  //                                                   VoidCallback
  //                                                       openContainer) =>
  //                                               GestureDetector(
  //                                             onTap: () {
  //                                               print('Clicker : ');
  //                                               openContainer();
  //                                               // your onOpen code
  //                                             },
  //                                             child: Container(
  //                                               margin:
  //                                                   const EdgeInsets.all(10),
  //                                               height: 190,
  //                                               //width: 200,
  //
  //                                               decoration: BoxDecoration(
  //                                                 color: Colors.white,
  //                                                 // borderRadius: const BorderRadius
  //                                                 //         .only(
  //                                                 //     topRight:
  //                                                 //         Radius.circular(20.0),
  //                                                 //     bottomRight:
  //                                                 //         Radius.circular(20.0),
  //                                                 //     topLeft:
  //                                                 //         Radius.circular(20.0),
  //                                                 //     bottomLeft:
  //                                                 //         Radius.circular(20.0)),
  //                                                 boxShadow: [
  //                                                   BoxShadow(
  //                                                     color: Colors.white
  //                                                         .withOpacity(0.5),
  //                                                     spreadRadius: 5,
  //                                                     blurRadius: 7,
  //                                                     offset: const Offset(0,
  //                                                         3), // changes position of shadow
  //                                                   ),
  //                                                 ],
  //                                               ),
  //                                               child: Column(
  //                                                 children: [
  //                                                   Container(
  //                                                     height: 50,
  //                                                     width: 50,
  //                                                     margin: const EdgeInsets
  //                                                             .fromLTRB(
  //                                                         30, 30, 30, 10),
  //                                                     decoration:
  //                                                         const BoxDecoration(
  //                                                       color: Colors.white,
  //                                                       image: DecorationImage(
  //                                                         image: AssetImage(
  //                                                             "assets/images/Group 3.png"),
  //                                                         fit: BoxFit.contain,
  //                                                       ),
  //                                                     ),
  //                                                   ),
  //                                                   Container(
  //                                                     height: 80,
  //                                                     //width: 160,
  //                                                     color: Colors.white,
  //                                                     child: Center(
  //                                                       child: Text(
  //                                                         'Buy Online',
  //                                                         textAlign:
  //                                                             TextAlign.center,
  //                                                         style: TextStyle(
  //                                                             fontSize: 24,
  //                                                             fontFamily:
  //                                                                 defaultFontFamily,
  //                                                             fontWeight:
  //                                                                 FontWeight
  //                                                                     .bold,
  //                                                             color: Color(
  //                                                                 0xff2474b9)),
  //                                                       ),
  //                                                     ),
  //                                                   ),
  //                                                 ],
  //                                               ),
  //                                             ),
  //                                           ),
  //
  //                                           closedElevation: 6.0,
  //                                           closedShape:
  //                                               const RoundedRectangleBorder(
  //                                             borderRadius: BorderRadius.all(
  //                                               Radius.circular(26 / 2),
  //                                             ),
  //                                           ),
  //                                           openBuilder: (context,
  //                                                   VoidCallback _) =>
  //                                               WebViewScreen(
  //                                                   key: _scaffoldKey,
  //                                                   title: 'Buy Online',
  //                                                   url_link:
  //                                                       'https://bol.sudlife.in/ProductSelection/ProductSelectionPage'),
  //                                         ),
  //                                         //),
  //                                       ),
  //                                       const SizedBox(
  //                                         width: 70,
  //                                       ),
  //                                       Expanded(
  //                                         child: OpenContainer(
  //                                           // transitionType: transitionType,
  //                                           transitionType:
  //                                               ContainerTransitionType.fade,
  //                                           transitionDuration: const Duration(
  //                                               milliseconds: 500),
  //                                           tappable: false,
  //
  //                                           closedBuilder: (context,
  //                                                   VoidCallback
  //                                                       openContainer) =>
  //                                               GestureDetector(
  //                                             onTap: () {
  //                                               print('Clicker : ');
  //                                               openContainer();
  //                                               // your onOpen code
  //                                             },
  //                                             child: Container(
  //                                               margin:
  //                                                   const EdgeInsets.all(10),
  //                                               height: 190,
  //                                               //width: 200,
  //                                               decoration: BoxDecoration(
  //                                                 color: Colors.white,
  //                                                 // borderRadius: const BorderRadius
  //                                                 //         .only(
  //                                                 //     topRight:
  //                                                 //         Radius.circular(20.0),
  //                                                 //     bottomRight:
  //                                                 //         Radius.circular(20.0),
  //                                                 //     topLeft:
  //                                                 //         Radius.circular(20.0),
  //                                                 //     bottomLeft:
  //                                                 //         Radius.circular(20.0)),
  //                                                 boxShadow: [
  //                                                   BoxShadow(
  //                                                     color: Colors.white
  //                                                         .withOpacity(0.5),
  //                                                     spreadRadius: 5,
  //                                                     blurRadius: 7,
  //                                                     offset: Offset(0,
  //                                                         3), // changes position of shadow
  //                                                   ),
  //                                                 ],
  //                                               ),
  //                                               child: Column(
  //                                                 children: [
  //                                                   Container(
  //                                                     height: 50,
  //                                                     width: 50,
  //                                                     margin: const EdgeInsets
  //                                                             .fromLTRB(
  //                                                         30, 30, 30, 10),
  //                                                     decoration:
  //                                                         const BoxDecoration(
  //                                                       color: Colors.white,
  //                                                       image: DecorationImage(
  //                                                         image: AssetImage(
  //                                                             "assets/images/Path 92.png"),
  //                                                         fit: BoxFit.contain,
  //                                                       ),
  //                                                     ),
  //                                                   ),
  //                                                   Container(
  //                                                     height: 80,
  //                                                     width: 160,
  //                                                     color: Colors.white,
  //                                                     child: Center(
  //                                                       child: Text(
  //                                                         'Pay Premiums',
  //                                                         textAlign:
  //                                                             TextAlign.center,
  //                                                         style: TextStyle(
  //                                                             fontSize: 20,
  //                                                             fontFamily:
  //                                                                 defaultFontFamily,
  //                                                             fontWeight:
  //                                                                 FontWeight
  //                                                                     .bold,
  //                                                             color: Color(
  //                                                                 0xff2474b9)),
  //                                                       ),
  //                                                     ),
  //                                                   ),
  //                                                 ],
  //                                               ),
  //                                             ),
  //                                           ),
  //
  //                                           closedElevation: 6.0,
  //                                           closedShape:
  //                                               const RoundedRectangleBorder(
  //                                             borderRadius: BorderRadius.all(
  //                                               Radius.circular(26 / 2),
  //                                             ),
  //                                           ),
  //                                           openBuilder: (context,
  //                                                   VoidCallback _) =>
  //                                               WebViewScreen(
  //                                                   key: _scaffoldKey,
  //                                                   title: 'Pay Premiums',
  //                                                   url_link:
  //                                                       'https://www.sudlife.in/customer-service/premium-payment-options'),
  //                                         ),
  //                                       ),
  //                                       const SizedBox(
  //                                         width: 70,
  //                                       ),
  //                                       Expanded(
  //                                         child: OpenContainer(
  //                                           // transitionType: transitionType,
  //                                           transitionType:
  //                                               ContainerTransitionType.fade,
  //                                           transitionDuration: const Duration(
  //                                               milliseconds: 500),
  //                                           tappable: false,
  //
  //                                           closedBuilder: (context,
  //                                                   VoidCallback
  //                                                       openContainer) =>
  //                                               GestureDetector(
  //                                             onTap: () {
  //                                               print('Clicker : ');
  //                                               openContainer();
  //                                               // your onOpen code
  //                                             },
  //                                             child: Container(
  //                                               margin:
  //                                                   const EdgeInsets.all(10),
  //                                               height: 190,
  //                                               //width: 200,
  //                                               decoration: BoxDecoration(
  //                                                 color: Colors.white,
  //                                                 // borderRadius: const BorderRadius
  //                                                 //         .only(
  //                                                 //     topRight:
  //                                                 //         Radius.circular(20.0),
  //                                                 //     bottomRight:
  //                                                 //         Radius.circular(20.0),
  //                                                 //     topLeft:
  //                                                 //         Radius.circular(20.0),
  //                                                 //     bottomLeft:
  //                                                 //         Radius.circular(20.0)),
  //                                                 boxShadow: [
  //                                                   BoxShadow(
  //                                                     color: Colors.white
  //                                                         .withOpacity(0.5),
  //                                                     spreadRadius: 5,
  //                                                     blurRadius: 7,
  //                                                     offset: const Offset(0,
  //                                                         3), // changes position of shadow
  //                                                   ),
  //                                                 ],
  //                                               ),
  //                                               child: Column(
  //                                                 children: [
  //                                                   Container(
  //                                                     height: 50,
  //                                                     width: 50,
  //                                                     margin: const EdgeInsets
  //                                                             .fromLTRB(
  //                                                         30, 30, 30, 10),
  //                                                     decoration:
  //                                                         const BoxDecoration(
  //                                                       color: Colors.white,
  //                                                       image: DecorationImage(
  //                                                         image: AssetImage(
  //                                                             "assets/images/Group 3.png"),
  //                                                         fit: BoxFit.contain,
  //                                                       ),
  //                                                     ),
  //                                                   ),
  //                                                   Container(
  //                                                     height: 80,
  //                                                     //width: 160,
  //                                                     color: Colors.white,
  //                                                     child: Center(
  //                                                       child: Text(
  //                                                         'Insurance Plans',
  //                                                         textAlign:
  //                                                             TextAlign.center,
  //                                                         style: TextStyle(
  //                                                             fontSize: 20,
  //                                                             fontFamily:
  //                                                                 defaultFontFamily,
  //                                                             fontWeight:
  //                                                                 FontWeight
  //                                                                     .bold,
  //                                                             color: Color(
  //                                                                 0xff2474b9)),
  //                                                       ),
  //                                                     ),
  //                                                   ),
  //                                                 ],
  //                                               ),
  //                                             ),
  //                                           ),
  //
  //                                           closedElevation: 6.0,
  //                                           closedShape:
  //                                               const RoundedRectangleBorder(
  //                                             borderRadius: BorderRadius.all(
  //                                               Radius.circular(26 / 2),
  //                                             ),
  //                                           ),
  //                                           openBuilder: (context,
  //                                                   VoidCallback _) =>
  //                                               WebViewScreen(
  //                                                   key: _scaffoldKey,
  //                                                   title: 'Insurance Plans',
  //                                                   url_link:
  //                                                       'https://www.sudlife.in/products/life-insurance'),
  //                                         ),
  //                                       ),
  //                                       const SizedBox(
  //                                         width: 70,
  //                                       ),
  //                                     ],
  //                                   ),
  //
  //                                   const SizedBox(
  //                                     height: 50,
  //                                   ),
  //
  //                                   Row(
  //                                     children: [
  //                                       const SizedBox(
  //                                         width: 70,
  //                                       ),
  //                                       Expanded(
  //                                         child: OpenContainer(
  //                                           // transitionType: transitionType,
  //                                           transitionType:
  //                                               ContainerTransitionType.fade,
  //                                           transitionDuration: const Duration(
  //                                               milliseconds: 500),
  //                                           tappable: false,
  //
  //                                           closedBuilder: (context,
  //                                                   VoidCallback
  //                                                       openContainer) =>
  //                                               GestureDetector(
  //                                             onTap: () {
  //                                               print('Clicker : ');
  //                                               openContainer();
  //                                               // your onOpen code
  //                                             },
  //                                             child: Container(
  //                                               margin:
  //                                                   const EdgeInsets.all(10),
  //                                               height: 190,
  //                                               //width: 200,
  //                                               decoration: BoxDecoration(
  //                                                 color: Colors.white,
  //                                                 // borderRadius: const BorderRadius
  //                                                 //         .only(
  //                                                 //     topRight:
  //                                                 //         Radius.circular(20.0),
  //                                                 //     bottomRight:
  //                                                 //         Radius.circular(20.0),
  //                                                 //     topLeft:
  //                                                 //         Radius.circular(20.0),
  //                                                 //     bottomLeft:
  //                                                 //         Radius.circular(20.0)),
  //                                                 boxShadow: [
  //                                                   BoxShadow(
  //                                                     color: Colors.white
  //                                                         .withOpacity(0.5),
  //                                                     spreadRadius: 5,
  //                                                     blurRadius: 7,
  //                                                     offset: const Offset(0,
  //                                                         3), // changes position of shadow
  //                                                   ),
  //                                                 ],
  //                                               ),
  //                                               child: Column(
  //                                                 children: [
  //                                                   Container(
  //                                                     height: 50,
  //                                                     width: 50,
  //                                                     margin: const EdgeInsets
  //                                                             .fromLTRB(
  //                                                         30, 30, 30, 10),
  //                                                     decoration:
  //                                                         const BoxDecoration(
  //                                                       color: Colors.white,
  //                                                       image: DecorationImage(
  //                                                         image: AssetImage(
  //                                                             "assets/images/Path 107.png"),
  //                                                         fit: BoxFit.contain,
  //                                                       ),
  //                                                     ),
  //                                                   ),
  //                                                   Container(
  //                                                     height: 80,
  //                                                     width: 160,
  //                                                     color: Colors.white,
  //                                                     child: Center(
  //                                                       child: Text(
  //                                                         'Calculate Your \nPremiums',
  //                                                         style: TextStyle(
  //                                                             fontFamily:
  //                                                                 defaultFontFamily,
  //                                                             fontSize: 20,
  //                                                             fontWeight:
  //                                                                 FontWeight
  //                                                                     .bold,
  //                                                             color: Color(
  //                                                                 0xff2474b9)),
  //                                                       ),
  //                                                     ),
  //                                                   ),
  //                                                 ],
  //                                               ),
  //                                             ),
  //                                           ),
  //
  //                                           closedElevation: 6.0,
  //                                           closedShape:
  //                                               const RoundedRectangleBorder(
  //                                             borderRadius: BorderRadius.all(
  //                                               Radius.circular(26 / 2),
  //                                             ),
  //                                           ),
  //                                           openBuilder: (context,
  //                                                   VoidCallback _) =>
  //                                               WebViewScreen(
  //                                                   key: _scaffoldKey,
  //                                                   title:
  //                                                       'Calculate Your Premiums',
  //                                                   url_link:
  //                                                       'https://si.sudlife.in/SalesIllustration/ProductPage.aspx'),
  //                                         ),
  //                                       ),
  //                                       const SizedBox(
  //                                         width: 70,
  //                                       ),
  //                                       Expanded(
  //                                         child: OpenContainer(
  //                                           // transitionType: transitionType,
  //                                           transitionType:
  //                                               ContainerTransitionType.fade,
  //                                           transitionDuration: const Duration(
  //                                               milliseconds: 500),
  //                                           tappable: false,
  //
  //                                           closedBuilder: (context,
  //                                                   VoidCallback
  //                                                       openContainer) =>
  //                                               GestureDetector(
  //                                             onTap: () {
  //                                               print('Clicker : ');
  //                                               openContainer();
  //                                               // your onOpen code
  //                                             },
  //                                             child: Container(
  //                                               margin:
  //                                                   const EdgeInsets.all(10),
  //                                               height: 190,
  //                                               //width: 200,
  //                                               decoration: BoxDecoration(
  //                                                 color: Colors.white,
  //                                                 // borderRadius: const BorderRadius
  //                                                 //         .only(
  //                                                 //     topRight:
  //                                                 //         Radius.circular(20.0),
  //                                                 //     bottomRight:
  //                                                 //         Radius.circular(20.0),
  //                                                 //     topLeft:
  //                                                 //         Radius.circular(20.0),
  //                                                 //     bottomLeft:
  //                                                 //         Radius.circular(20.0)),
  //                                                 boxShadow: [
  //                                                   BoxShadow(
  //                                                     color: Colors.white
  //                                                         .withOpacity(0.5),
  //                                                     spreadRadius: 5,
  //                                                     blurRadius: 7,
  //                                                     offset: const Offset(0,
  //                                                         3), // changes position of shadow
  //                                                   ),
  //                                                 ],
  //                                               ),
  //                                               child: Column(
  //                                                 children: [
  //                                                   Container(
  //                                                     height: 50,
  //                                                     width: 50,
  //                                                     margin: const EdgeInsets
  //                                                             .fromLTRB(
  //                                                         30, 30, 30, 10),
  //                                                     decoration:
  //                                                         const BoxDecoration(
  //                                                       color: Colors.white,
  //                                                       image: DecorationImage(
  //                                                         image: AssetImage(
  //                                                             "assets/images/Group 6.png"),
  //                                                         fit: BoxFit.contain,
  //                                                       ),
  //                                                     ),
  //                                                   ),
  //                                                   Container(
  //                                                     height: 80,
  //                                                     //width: 160,
  //                                                     color: Colors.white,
  //                                                     child: Center(
  //                                                       child: Text(
  //                                                         'Customer Portal',
  //                                                         textAlign:
  //                                                             TextAlign.center,
  //                                                         style: TextStyle(
  //                                                             fontSize: 20,
  //                                                             fontFamily:
  //                                                                 defaultFontFamily,
  //                                                             fontWeight:
  //                                                                 FontWeight
  //                                                                     .bold,
  //                                                             color: Color(
  //                                                                 0xff2474b9)),
  //                                                       ),
  //                                                     ),
  //                                                   ),
  //                                                 ],
  //                                               ),
  //                                             ),
  //                                           ),
  //
  //                                           closedElevation: 6.0,
  //                                           closedShape:
  //                                               const RoundedRectangleBorder(
  //                                             borderRadius: BorderRadius.all(
  //                                               Radius.circular(26 / 2),
  //                                             ),
  //                                           ),
  //                                           openBuilder: (context,
  //                                                   VoidCallback _) =>
  //                                               WebViewScreen(
  //                                                   key: _scaffoldKey,
  //                                                   title: 'Customer Portal',
  //                                                   url_link:
  //                                                       //'https://customer.sudlife.in'),
  //                                                       'https://www.sudlife.in/contact-us'),
  //                                         ),
  //                                       ),
  //                                       const SizedBox(
  //                                         width: 70,
  //                                       ),
  //                                       Expanded(
  //                                         child: OpenContainer(
  //                                           // transitionType: transitionType,
  //                                           transitionType:
  //                                               ContainerTransitionType.fade,
  //                                           transitionDuration: const Duration(
  //                                               milliseconds: 500),
  //                                           tappable: false,
  //
  //                                           closedBuilder: (context,
  //                                                   VoidCallback
  //                                                       openContainer) =>
  //                                               GestureDetector(
  //                                             onTap: () {
  //                                               print('Clicker : ');
  //                                               openContainer();
  //                                               // your onOpen code
  //                                             },
  //                                             child: Container(
  //                                               margin:
  //                                                   const EdgeInsets.all(10),
  //                                               height: 190,
  //                                               //width: 200,
  //                                               decoration: BoxDecoration(
  //                                                 color: Colors.white,
  //                                                 // borderRadius: const BorderRadius
  //                                                 //         .only(
  //                                                 //     topRight:
  //                                                 //         Radius.circular(20.0),
  //                                                 //     bottomRight:
  //                                                 //         Radius.circular(20.0),
  //                                                 //     topLeft:
  //                                                 //         Radius.circular(20.0),
  //                                                 //     bottomLeft:
  //                                                 //         Radius.circular(20.0)),
  //                                                 boxShadow: [
  //                                                   BoxShadow(
  //                                                     color: Colors.white
  //                                                         .withOpacity(0.5),
  //                                                     spreadRadius: 5,
  //                                                     blurRadius: 7,
  //                                                     offset: const Offset(0,
  //                                                         3), // changes position of shadow
  //                                                   ),
  //                                                 ],
  //                                               ),
  //                                               child: Column(
  //                                                 children: [
  //                                                   Container(
  //                                                     height: 50,
  //                                                     width: 50,
  //                                                     margin: const EdgeInsets
  //                                                             .fromLTRB(
  //                                                         30, 30, 30, 10),
  //                                                     decoration:
  //                                                         const BoxDecoration(
  //                                                       color: Colors.white,
  //                                                       image: DecorationImage(
  //                                                         image: AssetImage(
  //                                                             "assets/images/Path 95.png"),
  //                                                         fit: BoxFit.contain,
  //                                                       ),
  //                                                     ),
  //                                                   ),
  //                                                   Container(
  //                                                     height: 80,
  //                                                     width: 160,
  //                                                     color: Colors.white,
  //                                                     child: Center(
  //                                                       child: Text(
  //                                                         'Office Locator',
  //                                                         style: TextStyle(
  //                                                             fontSize: 20,
  //                                                             fontFamily:
  //                                                                 defaultFontFamily,
  //                                                             fontWeight:
  //                                                                 FontWeight
  //                                                                     .bold,
  //                                                             color: Color(
  //                                                                 0xff2474b9)),
  //                                                       ),
  //                                                     ),
  //                                                   ),
  //                                                 ],
  //                                               ),
  //                                             ),
  //                                           ),
  //
  //                                           closedElevation: 6.0,
  //                                           closedShape:
  //                                               const RoundedRectangleBorder(
  //                                             borderRadius: BorderRadius.all(
  //                                               Radius.circular(26 / 2),
  //                                             ),
  //                                           ),
  //                                           openBuilder: (context,
  //                                                   VoidCallback _) =>
  //                                               WebViewScreen(
  //                                                   key: _scaffoldKey,
  //                                                   title: 'Office Locator',
  //                                                   url_link:
  //                                                       'https://www.sudlife.in/contact-us'),
  //                                         ),
  //                                       ),
  //                                       const SizedBox(
  //                                         width: 70,
  //                                       ),
  //                                     ],
  //                                   ),
  //
  //                                   const SizedBox(
  //                                     height: 40,
  //                                   ),
  //
  //                                   // Row(
  //                                   //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                                   //   children: [
  //                                   //     const SizedBox(
  //                                   //       width: 40,
  //                                   //     ),
  //                                   //     InkWell(
  //                                   //       onTap: () {
  //                                   //         Navigator.push(
  //                                   //           context,
  //                                   //           MaterialPageRoute(
  //                                   //               builder: (context) => ChessGame()),
  //                                   //         );
  //                                   //       },
  //                                   //       child: Container(
  //                                   //         margin: const EdgeInsets.all(10),
  //                                   //         height: 200,
  //                                   //         width: 150,
  //                                   //         decoration: const BoxDecoration(
  //                                   //           image: DecorationImage(
  //                                   //             image:
  //                                   //                 AssetImage("assets/games/Chesss.png"),
  //                                   //             fit: BoxFit.fill,
  //                                   //           ),
  //                                   //         ),
  //                                   //       ),
  //                                   //     ),
  //                                   //
  //                                   //     InkWell(
  //                                   //       onTap: () {
  //                                   //         Navigator.push(
  //                                   //           context,
  //                                   //           MaterialPageRoute(
  //                                   //               // builder: (context) => ChessGame()),
  //                                   //               builder: (context) => SplashScrenn()),
  //                                   //         );
  //                                   //       },
  //                                   //       child: Container(
  //                                   //         margin: const EdgeInsets.all(10),
  //                                   //         height: 200,
  //                                   //         width: 150,
  //                                   //         decoration: const BoxDecoration(
  //                                   //           image: DecorationImage(
  //                                   //             image: AssetImage(
  //                                   //                 "assets/games/Covi KIll.png"),
  //                                   //             fit: BoxFit.fill,
  //                                   //           ),
  //                                   //         ),
  //                                   //       ),
  //                                   //     ),
  //                                   //
  //                                   //     InkWell(
  //                                   //       onTap: () {},
  //                                   //       child: Container(
  //                                   //         margin: const EdgeInsets.all(10),
  //                                   //         height: 200,
  //                                   //         width: 150,
  //                                   //         decoration: const BoxDecoration(
  //                                   //           image: DecorationImage(
  //                                   //             image: AssetImage(
  //                                   //                 "assets/games/Fun Facts.png"),
  //                                   //             fit: BoxFit.fill,
  //                                   //           ),
  //                                   //         ),
  //                                   //       ),
  //                                   //     ),
  //                                   //
  //                                   //     InkWell(
  //                                   //       onTap: () {},
  //                                   //       child: Container(
  //                                   //         margin: const EdgeInsets.all(10),
  //                                   //
  //                                   //         height: 200,
  //                                   //         width: 150,
  //                                   //         decoration: const BoxDecoration(
  //                                   //           image: DecorationImage(
  //                                   //             image: AssetImage(
  //                                   //                 "assets/games/Quiz Time.png"),
  //                                   //             fit: BoxFit.fill,
  //                                   //           ),
  //                                   //         ),
  //                                   //       ),
  //                                   //     ),
  //                                   //     const SizedBox(
  //                                   //       width: 40,
  //                                   //     ),
  //                                   //   ],
  //                                   // ),
  //                                   //
  //                                   // const SizedBox(
  //                                   //   height: 40,
  //                                   // ),
  //                                 ],
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //
  //             // if (Platform.isAndroid) {
  //             //   // Android-specific code
  //             // } else if (Platform.isIOS) {
  //             //   // iOS-specific code
  //             // }
  //
  //             ///
  //             // Platform.isAndroid
  //             //     ? Positioned(
  //             //   top: 30.0,
  //             //   left: 10.0,
  //             //   right: 0.0,
  //             //   child: AppBar(
  //             //     title: const Text(''), // You can add title here
  //             //     leading: IconButton(
  //             //       icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
  //             //       onPressed: () => Navigator.of(context).pop(),
  //             //     ),
  //             //     backgroundColor:
  //             //         Colors.transparent, //You can make this transparent
  //             //     elevation: 0.0, //No shadow
  //             //   ),
  //             // )
  //             //     : Positioned(
  //             //   top: 5.0,
  //             //   left: 10.0,
  //             //   right: 0.0,
  //             //   child: AppBar(
  //             //     title: const Text(''), // You can add title here
  //             //     leading: IconButton(
  //             //       icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
  //             //       onPressed: () => Navigator.of(context).pop(),
  //             //     ),
  //             //     backgroundColor:
  //             //     Colors.transparent, //You can make this transparent
  //             //     elevation: 0.0, //No shadow
  //             //   ),
  //             // ),
  //
  //             Platform.isAndroid
  //                 ? Positioned(
  //                     top: 30.0,
  //                     left: 0.0,
  //                     right: 0.0,
  //                     child: Padding(
  //                       padding: EdgeInsets.fromLTRB(30, 0, 30, 30),
  //                       child: Row(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         children: [
  //                           Container(
  //                             // height: 70,
  //                             // width: 160,
  //                             padding: const EdgeInsets.all(14),
  //                             decoration: const BoxDecoration(
  //                               color: Colors.white,
  //                               borderRadius: BorderRadius.only(
  //                                   topRight: Radius.circular(15.0),
  //                                   bottomRight: Radius.circular(15.0),
  //                                   topLeft: Radius.circular(15.0),
  //                                   bottomLeft: Radius.circular(15.0)),
  //                             ),
  //                             child: Container(
  //                               // height: 50,
  //                               // width: 100,
  //                               padding:
  //                                   const EdgeInsets.fromLTRB(60, 15, 60, 15),
  //                               decoration: const BoxDecoration(
  //                                 color: Colors.white,
  //                                 image: DecorationImage(
  //                                   image: AssetImage(
  //                                       "assets/images/site-logo.png"),
  //                                   fit: BoxFit.contain,
  //                                 ),
  //                               ),
  //                               child: null,
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   )
  //                 : Positioned(
  //                     top: 50.0,
  //                     left: 0.0,
  //                     right: 0.0,
  //                     child: Padding(
  //                       padding: EdgeInsets.fromLTRB(30, 0, 30, 30),
  //                       child: Row(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         children: [
  //                           Container(
  //                             // height: 70,
  //                             // width: 160,
  //                             padding: const EdgeInsets.all(14),
  //                             decoration: const BoxDecoration(
  //                               color: Colors.white,
  //                               borderRadius: BorderRadius.only(
  //                                   topRight: Radius.circular(15.0),
  //                                   bottomRight: Radius.circular(15.0),
  //                                   topLeft: Radius.circular(15.0),
  //                                   bottomLeft: Radius.circular(15.0)),
  //                             ),
  //                             child: Container(
  //                               // height: 50,
  //                               // width: 100,
  //                               padding:
  //                                   const EdgeInsets.fromLTRB(60, 15, 60, 15),
  //                               decoration: const BoxDecoration(
  //                                 color: Colors.white,
  //                                 image: DecorationImage(
  //                                   image: AssetImage(
  //                                       "assets/images/site-logo.png"),
  //                                   fit: BoxFit.contain,
  //                                 ),
  //                               ),
  //                               child: null,
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //
  //             width_size < 900
  //                 ? Positioned(
  //                     bottom: 80.0,
  //                     left: 10,
  //                     right: 10,
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         const SizedBox(
  //                           width: 40,
  //                         ),
  //                         InkWell(
  //                           onTap: () {              Navigator.of(context).pop();
  //
  //                           Navigator.push(
  //                               context,
  //                               MaterialPageRoute(
  //                                   // builder: (context) => ChessGame()),
  //                                   builder: (context) =>
  //                                       const FunFacts_Screen()),
  //                             );
  //                           },
  //                           child: Container(
  //                             margin: const EdgeInsets.all(10),
  //                             height: 80,
  //                             width: 60,
  //                             decoration: const BoxDecoration(
  //                               image: DecorationImage(
  //                                 image:
  //                                     AssetImage("assets/games/Fun Facts.png"),
  //                                 fit: BoxFit.fill,
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                         const SizedBox(
  //                           width: 40,
  //                         ),
  //                         InkWell(
  //                           onTap: () {
  //                             Navigator.of(context).pop();
  //                             Navigator.push(
  //                               context,
  //                               MaterialPageRoute(
  //                                   // builder: (context) => ChessGame()),
  //                                   builder: (context) => const Quiz_Screen()),
  //                             );
  //                           },
  //                           child: Container(
  //                             margin: const EdgeInsets.all(10),
  //                             height: 80,
  //                             width: 60,
  //                             decoration: const BoxDecoration(
  //                               image: DecorationImage(
  //                                 image:
  //                                     AssetImage("assets/games/Quiz Time.png"),
  //                                 fit: BoxFit.fill,
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                         const SizedBox(
  //                           width: 40,
  //                         ),
  //                       ],
  //                     ),
  //                   )
  //                 : Positioned(
  //                     top: 30.0,
  //                     right: 30.0,
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         const SizedBox(
  //                           width: 40,
  //                         ),
  //                         InkWell(
  //                           onTap: () {
  //                             Navigator.of(context).pop();
  //
  //                           Navigator.push(
  //                               context,
  //                               MaterialPageRoute(
  //                                   // builder: (context) => ChessGame()),
  //                                   builder: (context) =>
  //                                       const FunFacts_Screen()),
  //                             );
  //                           },
  //                           child: Container(
  //                             margin: const EdgeInsets.all(10),
  //                             height: 80,
  //                             width: 60,
  //                             decoration: const BoxDecoration(
  //                               image: DecorationImage(
  //                                 image:
  //                                     AssetImage("assets/games/Fun Facts.png"),
  //                                 fit: BoxFit.fill,
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                         const SizedBox(
  //                           width: 40,
  //                         ),
  //                         InkWell(
  //                           onTap: () {
  //                             Navigator.of(context).pop();
  //                             Navigator.push(
  //                               context,
  //                               MaterialPageRoute(
  //                                   // builder: (context) => ChessGame()),
  //                                   builder: (context) => const Quiz_Screen()),
  //                             );
  //                           },
  //                           child: Container(
  //                             margin: const EdgeInsets.all(10),
  //                             height: 80,
  //                             width: 60,
  //                             decoration: const BoxDecoration(
  //                               image: DecorationImage(
  //                                 image:
  //                                     AssetImage("assets/games/Quiz Time.png"),
  //                                 fit: BoxFit.fill,
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                         const SizedBox(
  //                           width: 40,
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //
  //             width_size < 900
  //                 ? Positioned(
  //                     bottom: 30.0,
  //                     left: 30,
  //                     right: 30,
  //                     child: Padding(
  //                       padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
  //                       child: Container(
  //                         height: 45,
  //                         width: 180,
  //                         child: OutlinedButton(
  //                           style: OutlinedButton.styleFrom(
  //                             backgroundColor: Colors.white,
  //                             shape: RoundedRectangleBorder(
  //                                 borderRadius: BorderRadius.circular(10.0)),
  //                             side: const BorderSide(
  //                               width: 2,
  //                               color: Color(0xff0F5A93),
  //                             ),
  //                           ),
  //                           child: const Text(
  //                             "Exit The Zone",
  //                             style: TextStyle(
  //                               fontSize: 16,
  //                               fontWeight: FontWeight.bold,
  //                               color: Colors.redAccent,
  //                             ),
  //                           ),
  //                           onPressed: () async {
  //
  //
  //                             _showMyDialog();
  //
  //                           },
  //                         ),
  //                       ),
  //                     ),
  //                   )
  //                 : Positioned(
  //                     bottom: 30.0,
  //                     right: 30.0,
  //                     child: Padding(
  //                       padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
  //                       child: Container(
  //                         height: 45,
  //                         width: 180,
  //                         child: OutlinedButton(
  //                           style: OutlinedButton.styleFrom(
  //                             backgroundColor: Colors.white,
  //                             shape: RoundedRectangleBorder(
  //                                 borderRadius: BorderRadius.circular(10.0)),
  //                             side: const BorderSide(
  //                               width: 2,
  //                               color: Color(0xff0F5A93),
  //                             ),
  //                           ),
  //                           child: const Text(
  //                             "Exit The Zone",
  //                             style: TextStyle(
  //                               fontSize: 16,
  //                               fontWeight: FontWeight.bold,
  //                               color: Colors.redAccent,
  //                             ),
  //                           ),
  //                           onPressed: () async {
  //
  //                             _showMyDialog();
  //
  //                             // clear();
  //                             // Navigator.pop(context);
  //                             // Navigator.push(
  //                             //     context,
  //                             //     MaterialPageRoute(
  //                             //         builder: (context) => BannerScreen()));
  //                           },
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
  //
  // Future<void> _showMyDialog() async {
  //   return showCupertinoDialog<void>(
  //     context: context,
  //     barrierDismissible: false, // user must tap button!
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Do you want to Exit ?'),
  //         actionsAlignment: MainAxisAlignment.spaceBetween,
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               clear();
  //               //Navigator.pop(context);
  //               Navigator.pop(context, true);
  //               Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                       builder: (context) => BannerScreen()));
  //
  //             },
  //             child: const Text('Yes'),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               Navigator.pop(context, false);
  //             },
  //             child: const Text('No'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
  //
  // @override
  // void dispose() {
  //   _timer.cancel();
  //   controller.dispose();
  //   super.dispose();
  // }

  _loadHtmlFromAssets(String url) async {
    // String fileText = await rootBundle.loadString('assets/screen1.html');
    String fileText = await rootBundle.loadString(url);
    _webController.loadUrl(Uri.dataFromString(fileText,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }

}
