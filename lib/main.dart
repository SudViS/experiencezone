import 'dart:async';

import 'package:experiencezone/webview_screen.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:responsive_framework/utils/scroll_behavior.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'CrossClipper.dart';
import 'chess/chess_game.dart';
import 'covidkill/models/levels_manager.dart';
import 'covidkill/models/settings_manager.dart';
import 'covidkill/screens/home.dart';
import 'covidkill/screens/levels.dart';
import 'covidkill/screens/splash_screen.dart';

final imageAsset = AssetImage("assets/images/Background.png");

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();


  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SettingsManager()),
          ChangeNotifierProvider(create: (context) => LevelsManager()),
        ],
        child: MaterialApp(
            builder: (context, widget) => ResponsiveWrapper.builder(
              BouncingScrollWrapper.builder(context, widget!),
              defaultScale: true,
              breakpoints: const [
                ResponsiveBreakpoint.resize(480, name: MOBILE),
                ResponsiveBreakpoint.autoScale(800, name: TABLET),
                ResponsiveBreakpoint.resize(1000, name: DESKTOP),
                ResponsiveBreakpoint.autoScale(2460, name: '4K'),
              ],
            ),
            title: 'Covi Kill',
            debugShowCheckedModeBanner: false,
            theme: ThemeData.dark(),
            home: HelpScreen(),
            //home: const SplashScrenn(),
            routes: {
              '/home': (context) => const HomeScreen(),
              '/level': (context) => const LevelsScreen()
            }
        ),
      )
      //MaterialApp(debugShowCheckedModeBanner: false, home: HelpScreen())
  );
  //runApp( HelpScreen());
  //runApp(const MyApp());
}


class HelpScreen extends StatefulWidget {
  @override
  HelpScreenState createState() {
    return HelpScreenState();
  }
}

class HelpScreenState extends State<HelpScreen> with TickerProviderStateMixin {


  late CurvedAnimation curve;
  late AnimationController controller;
  late Animation<double> curtainOffset;
  late WebViewController _webController;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  String url = "";
  double progress = 0;

  num _stackToView = 1;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);

    curve = CurvedAnimation(parent: controller, curve: Curves.elasticIn);

    curtainOffset = Tween(begin: 0.0, end: 500.0).animate(controller)
      ..addListener(() {
        setState(() {});
      });

    Future.delayed(
        const Duration(milliseconds: 300), () => controller.forward());

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          this.controller.isCompleted
              ? this.controller.reverse()
              : this.controller.forward();
        },
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Container(
                //height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/Background.png"),
                    fit: BoxFit.fitHeight,
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 100,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: const Text(
                              "SUD Life Experience Zone",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Expanded(
                          child: InkWell(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  // builder: (context) => ChessGame()),
                                    builder: (context) => SplashScrenn()),
                              );
                            },
                            child: Container(
                              height: 70,
                              width: 120,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  // topRight: Radius.circular(40.0),
                                  // bottomRight: Radius.circular(40.0),
                                    topLeft: Radius.circular(20.0),
                                    bottomLeft: Radius.circular(20.0)),
                              ),
                              child: Container(
                                height: 50,
                                width: 120,
                                margin: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  image: DecorationImage(
                                    image:
                                    AssetImage("assets/images/site-logo.png"),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                child: null,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => WebViewScreen(
                                            key: _scaffoldKey,
                                            url_link:
                                            'https://bol.sudlife.in/ProductSelection/ProductSelectionPage')),
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(10),
                                  height: 140,
                                  //width: 200,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(20.0),
                                        bottomRight: Radius.circular(20.0),
                                        topLeft: Radius.circular(20.0),
                                        bottomLeft: Radius.circular(20.0)),
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 30,
                                        width: 70,
                                        margin: const EdgeInsets.fromLTRB(
                                            30, 30, 30, 20),
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          image: DecorationImage(
                                            image: AssetImage(
                                                "assets/images/Group 3.png"),
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 40,
                                        width: 160,
                                        color: Colors.white,
                                        child: Center(
                                          child: Text(
                                            'Buy \nOnline',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blueAccent),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),


                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => WebViewScreen(
                                            key: _scaffoldKey,
                                            url_link:
                                            'https://www.sudlife.in/customer-service/premium-payment-options')),
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(10),
                                  height: 140,
                                  //width: 200,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(20.0),
                                        bottomRight: Radius.circular(20.0),
                                        topLeft: Radius.circular(20.0),
                                        bottomLeft: Radius.circular(20.0)),
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 30,
                                        width: 70,
                                        margin: const EdgeInsets.fromLTRB(
                                            30, 30, 30, 20),
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          image: DecorationImage(
                                            image: AssetImage(
                                                "assets/images/Path 92.png"),
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 40,
                                        width: 160,
                                        color: Colors.white,
                                        child: const Center(
                                          child: Text(
                                            'Pay \nPremiums',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blueAccent),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),


                            Expanded(
                              child: InkWell(
                                onTap: () {

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => WebViewScreen(
                                            key: _scaffoldKey,
                                            url_link:
                                            'https://www.sudlife.in/products/life-insurance')),
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(10),
                                  height: 140,
                                  //width: 200,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(20.0),
                                        bottomRight: Radius.circular(20.0),
                                        topLeft: Radius.circular(20.0),
                                        bottomLeft: Radius.circular(20.0)),
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 30,
                                        width: 70,
                                        margin: const EdgeInsets.fromLTRB(
                                            30, 30, 30, 20),
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          image: DecorationImage(
                                            image: AssetImage(
                                                "assets/images/Group 3.png"),
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 40,
                                        width: 160,
                                        color: Colors.white,
                                        child: const Center(
                                          child: Text(
                                            'Insurannce \nPlans',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blueAccent),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Row(
                          children: [

                            Expanded(
                              child: InkWell(
                                onTap: () {

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => WebViewScreen(
                                            key: _scaffoldKey,
                                            url_link:
                                            'https://si.sudlife.in/SalesIllustration/ProductPage.aspx')),
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(10),
                                  height: 140,
                                  //width: 200,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(20.0),
                                        bottomRight: Radius.circular(20.0),
                                        topLeft: Radius.circular(20.0),
                                        bottomLeft: Radius.circular(20.0)),
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 30,
                                        width: 70,
                                        margin: const EdgeInsets.fromLTRB(
                                            30, 30, 30, 20),
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          image: DecorationImage(
                                            image: AssetImage(
                                                "assets/images/Path 107.png"),
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 40,
                                        width: 160,
                                        color: Colors.white,
                                        child: Center(
                                          child: Text(
                                            'Calculate your \nPremiums',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blueAccent),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => WebViewScreen(
                                            key: _scaffoldKey,
                                            url_link:
                                            'https://customer.sudlife.in')),
                                  );
                                },

                                child: Container(
                                  margin: const EdgeInsets.all(10),
                                  height: 140,
                                  //width: 200,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(20.0),
                                        bottomRight: Radius.circular(20.0),
                                        topLeft: Radius.circular(20.0),
                                        bottomLeft: Radius.circular(20.0)),
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 30,
                                        width: 70,
                                        margin: const EdgeInsets.fromLTRB(
                                            30, 30, 30, 20),
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          image: DecorationImage(
                                            image: AssetImage(
                                                "assets/images/Group 6.png"),
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 40,
                                        width: 160,
                                        color: Colors.white,
                                        child: Center(
                                          child: Text(
                                            'Customer \nPortal',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blueAccent),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            Expanded(
                              child: InkWell(
                                onTap: () {

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => WebViewScreen(
                                            key: _scaffoldKey,
                                            url_link:
                                            'https://www.sudlife.in/contact-u')),
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(10),
                                  height: 140,
                                  //width: 200,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(20.0),
                                        bottomRight: Radius.circular(20.0),
                                        topLeft: Radius.circular(20.0),
                                        bottomLeft: Radius.circular(20.0)),
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 30,
                                        width: 70,
                                        margin: const EdgeInsets.fromLTRB(
                                            30, 30, 30, 20),
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          image: DecorationImage(
                                            image: AssetImage(
                                                "assets/images/Path 95.png"),
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 40,
                                        width: 160,
                                        color: Colors.white,
                                        child: Center(
                                          child: Text(
                                            'Office \nLocator',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blueAccent),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                  ],
                ),
              ),
            ),
            Hero(
              tag: "curtain",
              child: Stack(
                children: <Widget>[
                  Transform.translate(
                    offset: Offset(0, -curtainOffset.value),
                    child: ClipPath(
                      clipper: CrossClipper(),
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageAsset,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(0, curtainOffset.value),
                    child: ClipPath(
                      clipper: CrossClipper(showTop: false),
                      child: Container(
                        decoration: new BoxDecoration(
                          image: new DecorationImage(
                            image: imageAsset,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    // return MultiProvider(
    //   providers: [
    //     ChangeNotifierProvider(create: (context) => SettingsManager()),
    //     ChangeNotifierProvider(create: (context) => LevelsManager()),
    //   ],
    //   child: MaterialApp(
    //       builder: (context, widget) => ResponsiveWrapper.builder(
    //         BouncingScrollWrapper.builder(context, widget!),
    //         defaultScale: true,
    //         breakpoints: const [
    //           ResponsiveBreakpoint.resize(480, name: MOBILE),
    //           ResponsiveBreakpoint.autoScale(800, name: TABLET),
    //           ResponsiveBreakpoint.resize(1000, name: DESKTOP),
    //           ResponsiveBreakpoint.autoScale(2460, name: '4K'),
    //         ],
    //       ),
    //       title: 'Covi Kill',
    //       debugShowCheckedModeBanner: false,
    //       theme: ThemeData.dark(),
    //       home: Scaffold(
    //         body: GestureDetector(
    //           onTap: () {
    //             this.controller.isCompleted
    //                 ? this.controller.reverse()
    //                 : this.controller.forward();
    //           },
    //           child: Stack(
    //             children: <Widget>[
    //               SingleChildScrollView(
    //                 child: Container(
    //                   //height: MediaQuery.of(context).size.height,
    //                   decoration: const BoxDecoration(
    //                     image: DecorationImage(
    //                       image: AssetImage("assets/images/Background.png"),
    //                       fit: BoxFit.fitHeight,
    //                     ),
    //                   ),
    //                   child: Column(
    //                     children: [
    //                       const SizedBox(
    //                         height: 100,
    //                       ),
    //                       Row(
    //                         children: [
    //                           Expanded(
    //                             child: Container(
    //                               padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
    //                               child: const Text(
    //                                 "SUD Life Experience Zone",
    //                                 style: TextStyle(
    //                                     fontSize: 18,
    //                                     fontWeight: FontWeight.bold,
    //                                     color: Colors.white),
    //                               ),
    //                             ),
    //                           ),
    //                           const Spacer(),
    //                           Expanded(
    //                             child: InkWell(
    //                               onTap: (){
    //                                 Navigator.push(
    //                                   context,
    //                                   MaterialPageRoute(
    //                                      // builder: (context) => ChessGame()),
    //                                       builder: (context) => SplashScrenn()),
    //                                 );
    //                               },
    //                               child: Container(
    //                                 height: 70,
    //                                 width: 120,
    //                                 decoration: const BoxDecoration(
    //                                   color: Colors.white,
    //                                   borderRadius: BorderRadius.only(
    //                                     // topRight: Radius.circular(40.0),
    //                                     // bottomRight: Radius.circular(40.0),
    //                                       topLeft: Radius.circular(20.0),
    //                                       bottomLeft: Radius.circular(20.0)),
    //                                 ),
    //                                 child: Container(
    //                                   height: 50,
    //                                   width: 120,
    //                                   margin: const EdgeInsets.all(10),
    //                                   decoration: const BoxDecoration(
    //                                     color: Colors.white,
    //                                     image: DecorationImage(
    //                                       image:
    //                                       AssetImage("assets/images/site-logo.png"),
    //                                       fit: BoxFit.contain,
    //                                     ),
    //                                   ),
    //                                   child: null,
    //                                 ),
    //                               ),
    //                             ),
    //                           )
    //                         ],
    //                       ),
    //                       const SizedBox(
    //                         height: 50,
    //                       ),
    //                       Column(
    //                         children: [
    //                           Row(
    //                             children: [
    //                               Expanded(
    //                                 child: InkWell(
    //                                   onTap: () {
    //                                     Navigator.push(
    //                                       context,
    //                                       MaterialPageRoute(
    //                                           builder: (context) => WebViewScreen(
    //                                               key: _scaffoldKey,
    //                                               url_link:
    //                                               'https://bol.sudlife.in/ProductSelection/ProductSelectionPage')),
    //                                     );
    //                                   },
    //                                   child: Container(
    //                                     margin: const EdgeInsets.all(10),
    //                                     height: 140,
    //                                     //width: 200,
    //                                     decoration: const BoxDecoration(
    //                                       color: Colors.white,
    //                                       borderRadius: BorderRadius.only(
    //                                           topRight: Radius.circular(20.0),
    //                                           bottomRight: Radius.circular(20.0),
    //                                           topLeft: Radius.circular(20.0),
    //                                           bottomLeft: Radius.circular(20.0)),
    //                                     ),
    //                                     child: Column(
    //                                       children: [
    //                                         Container(
    //                                           height: 30,
    //                                           width: 70,
    //                                           margin: const EdgeInsets.fromLTRB(
    //                                               30, 30, 30, 20),
    //                                           decoration: const BoxDecoration(
    //                                             color: Colors.white,
    //                                             image: DecorationImage(
    //                                               image: AssetImage(
    //                                                   "assets/images/Group 3.png"),
    //                                               fit: BoxFit.contain,
    //                                             ),
    //                                           ),
    //                                         ),
    //                                         Container(
    //                                           height: 40,
    //                                           width: 160,
    //                                           color: Colors.white,
    //                                           child: Center(
    //                                             child: Text(
    //                                               'Buy \nOnline',
    //                                               style: TextStyle(
    //                                                   fontSize: 18,
    //                                                   fontWeight: FontWeight.bold,
    //                                                   color: Colors.blueAccent),
    //                                             ),
    //                                           ),
    //                                         ),
    //                                       ],
    //                                     ),
    //                                   ),
    //                                 ),
    //                               ),
    //
    //
    //                               Expanded(
    //                                 child: InkWell(
    //                                   onTap: () {
    //                                     Navigator.push(
    //                                       context,
    //                                       MaterialPageRoute(
    //                                           builder: (context) => WebViewScreen(
    //                                               key: _scaffoldKey,
    //                                               url_link:
    //                                               'https://www.sudlife.in/customer-service/premium-payment-options')),
    //                                     );
    //                                   },
    //                                   child: Container(
    //                                     margin: const EdgeInsets.all(10),
    //                                     height: 140,
    //                                     //width: 200,
    //                                     decoration: const BoxDecoration(
    //                                       color: Colors.white,
    //                                       borderRadius: BorderRadius.only(
    //                                           topRight: Radius.circular(20.0),
    //                                           bottomRight: Radius.circular(20.0),
    //                                           topLeft: Radius.circular(20.0),
    //                                           bottomLeft: Radius.circular(20.0)),
    //                                     ),
    //                                     child: Column(
    //                                       children: [
    //                                         Container(
    //                                           height: 30,
    //                                           width: 70,
    //                                           margin: const EdgeInsets.fromLTRB(
    //                                               30, 30, 30, 20),
    //                                           decoration: const BoxDecoration(
    //                                             color: Colors.white,
    //                                             image: DecorationImage(
    //                                               image: AssetImage(
    //                                                   "assets/images/Path 92.png"),
    //                                               fit: BoxFit.contain,
    //                                             ),
    //                                           ),
    //                                         ),
    //                                         Container(
    //                                           height: 40,
    //                                           width: 160,
    //                                           color: Colors.white,
    //                                           child: const Center(
    //                                             child: Text(
    //                                               'Pay \nPremiums',
    //                                               style: TextStyle(
    //                                                   fontSize: 18,
    //                                                   fontWeight: FontWeight.bold,
    //                                                   color: Colors.blueAccent),
    //                                             ),
    //                                           ),
    //                                         ),
    //                                       ],
    //                                     ),
    //                                   ),
    //                                 ),
    //                               ),
    //
    //
    //                               Expanded(
    //                                 child: InkWell(
    //                                   onTap: () {
    //
    //                                     Navigator.push(
    //                                       context,
    //                                       MaterialPageRoute(
    //                                           builder: (context) => WebViewScreen(
    //                                               key: _scaffoldKey,
    //                                               url_link:
    //                                               'https://www.sudlife.in/products/life-insurance')),
    //                                     );
    //                                   },
    //                                   child: Container(
    //                                     margin: const EdgeInsets.all(10),
    //                                     height: 140,
    //                                     //width: 200,
    //                                     decoration: const BoxDecoration(
    //                                       color: Colors.white,
    //                                       borderRadius: BorderRadius.only(
    //                                           topRight: Radius.circular(20.0),
    //                                           bottomRight: Radius.circular(20.0),
    //                                           topLeft: Radius.circular(20.0),
    //                                           bottomLeft: Radius.circular(20.0)),
    //                                     ),
    //                                     child: Column(
    //                                       children: [
    //                                         Container(
    //                                           height: 30,
    //                                           width: 70,
    //                                           margin: const EdgeInsets.fromLTRB(
    //                                               30, 30, 30, 20),
    //                                           decoration: const BoxDecoration(
    //                                             color: Colors.white,
    //                                             image: DecorationImage(
    //                                               image: AssetImage(
    //                                                   "assets/images/Group 3.png"),
    //                                               fit: BoxFit.contain,
    //                                             ),
    //                                           ),
    //                                         ),
    //                                         Container(
    //                                           height: 40,
    //                                           width: 160,
    //                                           color: Colors.white,
    //                                           child: const Center(
    //                                             child: Text(
    //                                               'Insurannce \nPlans',
    //                                               style: TextStyle(
    //                                                   fontSize: 18,
    //                                                   fontWeight: FontWeight.bold,
    //                                                   color: Colors.blueAccent),
    //                                             ),
    //                                           ),
    //                                         ),
    //                                       ],
    //                                     ),
    //                                   ),
    //                                 ),
    //                               ),
    //                             ],
    //                           ),
    //                           const SizedBox(
    //                             height: 40,
    //                           ),
    //                           Row(
    //                             children: [
    //
    //                               Expanded(
    //                                 child: InkWell(
    //                                   onTap: () {
    //
    //                                     Navigator.push(
    //                                       context,
    //                                       MaterialPageRoute(
    //                                           builder: (context) => WebViewScreen(
    //                                               key: _scaffoldKey,
    //                                               url_link:
    //                                               'https://si.sudlife.in/SalesIllustration/ProductPage.aspx')),
    //                                     );
    //                                   },
    //                                   child: Container(
    //                                     margin: const EdgeInsets.all(10),
    //                                     height: 140,
    //                                     //width: 200,
    //                                     decoration: const BoxDecoration(
    //                                       color: Colors.white,
    //                                       borderRadius: BorderRadius.only(
    //                                           topRight: Radius.circular(20.0),
    //                                           bottomRight: Radius.circular(20.0),
    //                                           topLeft: Radius.circular(20.0),
    //                                           bottomLeft: Radius.circular(20.0)),
    //                                     ),
    //                                     child: Column(
    //                                       children: [
    //                                         Container(
    //                                           height: 30,
    //                                           width: 70,
    //                                           margin: const EdgeInsets.fromLTRB(
    //                                               30, 30, 30, 20),
    //                                           decoration: const BoxDecoration(
    //                                             color: Colors.white,
    //                                             image: DecorationImage(
    //                                               image: AssetImage(
    //                                                   "assets/images/Path 107.png"),
    //                                               fit: BoxFit.contain,
    //                                             ),
    //                                           ),
    //                                         ),
    //                                         Container(
    //                                           height: 40,
    //                                           width: 160,
    //                                           color: Colors.white,
    //                                           child: Center(
    //                                             child: Text(
    //                                               'Calculate your \nPremiums',
    //                                               style: TextStyle(
    //                                                   fontSize: 18,
    //                                                   fontWeight: FontWeight.bold,
    //                                                   color: Colors.blueAccent),
    //                                             ),
    //                                           ),
    //                                         ),
    //                                       ],
    //                                     ),
    //                                   ),
    //                                 ),
    //                               ),
    //
    //                               Expanded(
    //                                 child: InkWell(
    //                                   onTap: () {
    //                                     Navigator.push(
    //                                       context,
    //                                       MaterialPageRoute(
    //                                           builder: (context) => WebViewScreen(
    //                                               key: _scaffoldKey,
    //                                               url_link:
    //                                               'https://customer.sudlife.in')),
    //                                     );
    //                                   },
    //
    //                                   child: Container(
    //                                     margin: const EdgeInsets.all(10),
    //                                     height: 140,
    //                                     //width: 200,
    //                                     decoration: const BoxDecoration(
    //                                       color: Colors.white,
    //                                       borderRadius: BorderRadius.only(
    //                                           topRight: Radius.circular(20.0),
    //                                           bottomRight: Radius.circular(20.0),
    //                                           topLeft: Radius.circular(20.0),
    //                                           bottomLeft: Radius.circular(20.0)),
    //                                     ),
    //                                     child: Column(
    //                                       children: [
    //                                         Container(
    //                                           height: 30,
    //                                           width: 70,
    //                                           margin: const EdgeInsets.fromLTRB(
    //                                               30, 30, 30, 20),
    //                                           decoration: const BoxDecoration(
    //                                             color: Colors.white,
    //                                             image: DecorationImage(
    //                                               image: AssetImage(
    //                                                   "assets/images/Group 6.png"),
    //                                               fit: BoxFit.contain,
    //                                             ),
    //                                           ),
    //                                         ),
    //                                         Container(
    //                                           height: 40,
    //                                           width: 160,
    //                                           color: Colors.white,
    //                                           child: Center(
    //                                             child: Text(
    //                                               'Customer \nPortal',
    //                                               style: TextStyle(
    //                                                   fontSize: 18,
    //                                                   fontWeight: FontWeight.bold,
    //                                                   color: Colors.blueAccent),
    //                                             ),
    //                                           ),
    //                                         ),
    //                                       ],
    //                                     ),
    //                                   ),
    //                                 ),
    //                               ),
    //
    //                               Expanded(
    //                                 child: InkWell(
    //                                   onTap: () {
    //
    //                                     Navigator.push(
    //                                       context,
    //                                       MaterialPageRoute(
    //                                           builder: (context) => WebViewScreen(
    //                                               key: _scaffoldKey,
    //                                               url_link:
    //                                               'https://www.sudlife.in/contact-u')),
    //                                     );
    //                                   },
    //                                   child: Container(
    //                                     margin: const EdgeInsets.all(10),
    //                                     height: 140,
    //                                     //width: 200,
    //                                     decoration: const BoxDecoration(
    //                                       color: Colors.white,
    //                                       borderRadius: BorderRadius.only(
    //                                           topRight: Radius.circular(20.0),
    //                                           bottomRight: Radius.circular(20.0),
    //                                           topLeft: Radius.circular(20.0),
    //                                           bottomLeft: Radius.circular(20.0)),
    //                                     ),
    //                                     child: Column(
    //                                       children: [
    //                                         Container(
    //                                           height: 30,
    //                                           width: 70,
    //                                           margin: const EdgeInsets.fromLTRB(
    //                                               30, 30, 30, 20),
    //                                           decoration: const BoxDecoration(
    //                                             color: Colors.white,
    //                                             image: DecorationImage(
    //                                               image: AssetImage(
    //                                                   "assets/images/Path 95.png"),
    //                                               fit: BoxFit.contain,
    //                                             ),
    //                                           ),
    //                                         ),
    //                                         Container(
    //                                           height: 40,
    //                                           width: 160,
    //                                           color: Colors.white,
    //                                           child: Center(
    //                                             child: Text(
    //                                               'Office \nLocator',
    //                                               style: TextStyle(
    //                                                   fontSize: 18,
    //                                                   fontWeight: FontWeight.bold,
    //                                                   color: Colors.blueAccent),
    //                                             ),
    //                                           ),
    //                                         ),
    //                                       ],
    //                                     ),
    //                                   ),
    //                                 ),
    //                               ),
    //                             ],
    //                           )
    //                         ],
    //                       ),
    //                       const SizedBox(
    //                         height: 100,
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               ),
    //               Hero(
    //                 tag: "curtain",
    //                 child: Stack(
    //                   children: <Widget>[
    //                     Transform.translate(
    //                       offset: Offset(0, -curtainOffset.value),
    //                       child: ClipPath(
    //                         clipper: CrossClipper(),
    //                         child: Container(
    //                           decoration: BoxDecoration(
    //                             image: DecorationImage(
    //                               image: imageAsset,
    //                               fit: BoxFit.fitWidth,
    //                             ),
    //                           ),
    //                         ),
    //                       ),
    //                     ),
    //                     Transform.translate(
    //                       offset: Offset(0, curtainOffset.value),
    //                       child: ClipPath(
    //                         clipper: CrossClipper(showTop: false),
    //                         child: Container(
    //                           decoration: new BoxDecoration(
    //                             image: new DecorationImage(
    //                               image: imageAsset,
    //                               fit: BoxFit.fitWidth,
    //                             ),
    //                           ),
    //                         ),
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //       //home: const SplashScrenn(),
    //       routes: {
    //         '/home': (context) => const HomeScreen(),
    //         '/level': (context) => const LevelsScreen()
    //       }
    //   ),
    // );
  }

  // @override
  // Widget build(BuildContext context) {
  //
  //
  //   return Scaffold(
  //     body: GestureDetector(
  //       onTap: () {
  //         this.controller.isCompleted
  //             ? this.controller.reverse()
  //             : this.controller.forward();
  //       },
  //       child: Stack(
  //         children: <Widget>[
  //           SingleChildScrollView(
  //             child: Container(
  //               //height: MediaQuery.of(context).size.height,
  //               decoration: const BoxDecoration(
  //                 image: DecorationImage(
  //                   image: AssetImage("assets/images/Background.png"),
  //                   fit: BoxFit.fitHeight,
  //                 ),
  //               ),
  //               child: Column(
  //                 children: [
  //                   const SizedBox(
  //                     height: 100,
  //                   ),
  //                   Row(
  //                     children: [
  //                       Expanded(
  //                         child: Container(
  //                           padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
  //                           child: const Text(
  //                             "SUD Life Experience Zone",
  //                             style: TextStyle(
  //                                 fontSize: 18,
  //                                 fontWeight: FontWeight.bold,
  //                                 color: Colors.white),
  //                           ),
  //                         ),
  //                       ),
  //                       const Spacer(),
  //                       Expanded(
  //                         child: InkWell(
  //                           onTap: (){
  //                             Navigator.push(
  //                               context,
  //                               MaterialPageRoute(
  //                                   builder: (context) => ChessGame()),
  //                             );
  //                           },
  //                           child: Container(
  //                             height: 70,
  //                             width: 120,
  //                             decoration: const BoxDecoration(
  //                               color: Colors.white,
  //                               borderRadius: BorderRadius.only(
  //                                   // topRight: Radius.circular(40.0),
  //                                   // bottomRight: Radius.circular(40.0),
  //                                   topLeft: Radius.circular(20.0),
  //                                   bottomLeft: Radius.circular(20.0)),
  //                             ),
  //                             child: Container(
  //                               height: 50,
  //                               width: 120,
  //                               margin: const EdgeInsets.all(10),
  //                               decoration: const BoxDecoration(
  //                                 color: Colors.white,
  //                                 image: DecorationImage(
  //                                   image:
  //                                       AssetImage("assets/images/site-logo.png"),
  //                                   fit: BoxFit.contain,
  //                                 ),
  //                               ),
  //                               child: null,
  //                             ),
  //                           ),
  //                         ),
  //                       )
  //                     ],
  //                   ),
  //                   const SizedBox(
  //                     height: 50,
  //                   ),
  //                   Column(
  //                     children: [
  //                       Row(
  //                         children: [
  //                           Expanded(
  //                             child: InkWell(
  //                               onTap: () {
  //                                 Navigator.push(
  //                                   context,
  //                                   MaterialPageRoute(
  //                                       builder: (context) => WebViewScreen(
  //                                           key: _scaffoldKey,
  //                                           url_link:
  //                                               'https://bol.sudlife.in/ProductSelection/ProductSelectionPage')),
  //                                 );
  //                               },
  //                               child: Container(
  //                                 margin: const EdgeInsets.all(10),
  //                                 height: 140,
  //                                 //width: 200,
  //                                 decoration: const BoxDecoration(
  //                                   color: Colors.white,
  //                                   borderRadius: BorderRadius.only(
  //                                       topRight: Radius.circular(20.0),
  //                                       bottomRight: Radius.circular(20.0),
  //                                       topLeft: Radius.circular(20.0),
  //                                       bottomLeft: Radius.circular(20.0)),
  //                                 ),
  //                                 child: Column(
  //                                   children: [
  //                                     Container(
  //                                       height: 30,
  //                                       width: 70,
  //                                       margin: const EdgeInsets.fromLTRB(
  //                                           30, 30, 30, 20),
  //                                       decoration: const BoxDecoration(
  //                                         color: Colors.white,
  //                                         image: DecorationImage(
  //                                           image: AssetImage(
  //                                               "assets/images/Group 3.png"),
  //                                           fit: BoxFit.contain,
  //                                         ),
  //                                       ),
  //                                     ),
  //                                     Container(
  //                                       height: 40,
  //                                       width: 160,
  //                                       color: Colors.white,
  //                                       child: Center(
  //                                         child: Text(
  //                                           'Buy \nOnline',
  //                                           style: TextStyle(
  //                                               fontSize: 18,
  //                                               fontWeight: FontWeight.bold,
  //                                               color: Colors.blueAccent),
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //
  //
  //                           Expanded(
  //                             child: InkWell(
  //                               onTap: () {
  //                                 Navigator.push(
  //                                   context,
  //                                   MaterialPageRoute(
  //                                       builder: (context) => WebViewScreen(
  //                                           key: _scaffoldKey,
  //                                           url_link:
  //                                           'https://www.sudlife.in/customer-service/premium-payment-options')),
  //                                 );
  //                               },
  //                               child: Container(
  //                                 margin: const EdgeInsets.all(10),
  //                                 height: 140,
  //                                 //width: 200,
  //                                 decoration: const BoxDecoration(
  //                                   color: Colors.white,
  //                                   borderRadius: BorderRadius.only(
  //                                       topRight: Radius.circular(20.0),
  //                                       bottomRight: Radius.circular(20.0),
  //                                       topLeft: Radius.circular(20.0),
  //                                       bottomLeft: Radius.circular(20.0)),
  //                                 ),
  //                                 child: Column(
  //                                   children: [
  //                                     Container(
  //                                       height: 30,
  //                                       width: 70,
  //                                       margin: const EdgeInsets.fromLTRB(
  //                                           30, 30, 30, 20),
  //                                       decoration: const BoxDecoration(
  //                                         color: Colors.white,
  //                                         image: DecorationImage(
  //                                           image: AssetImage(
  //                                               "assets/images/Path 92.png"),
  //                                           fit: BoxFit.contain,
  //                                         ),
  //                                       ),
  //                                     ),
  //                                     Container(
  //                                       height: 40,
  //                                       width: 160,
  //                                       color: Colors.white,
  //                                       child: const Center(
  //                                         child: Text(
  //                                           'Pay \nPremiums',
  //                                           style: TextStyle(
  //                                               fontSize: 18,
  //                                               fontWeight: FontWeight.bold,
  //                                               color: Colors.blueAccent),
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //
  //
  //                           Expanded(
  //                             child: InkWell(
  //                               onTap: () {
  //
  //                                 Navigator.push(
  //                                   context,
  //                                   MaterialPageRoute(
  //                                       builder: (context) => WebViewScreen(
  //                                           key: _scaffoldKey,
  //                                           url_link:
  //                                           'https://www.sudlife.in/products/life-insurance')),
  //                                 );
  //                               },
  //                               child: Container(
  //                                 margin: const EdgeInsets.all(10),
  //                                 height: 140,
  //                                 //width: 200,
  //                                 decoration: const BoxDecoration(
  //                                   color: Colors.white,
  //                                   borderRadius: BorderRadius.only(
  //                                       topRight: Radius.circular(20.0),
  //                                       bottomRight: Radius.circular(20.0),
  //                                       topLeft: Radius.circular(20.0),
  //                                       bottomLeft: Radius.circular(20.0)),
  //                                 ),
  //                                 child: Column(
  //                                   children: [
  //                                     Container(
  //                                       height: 30,
  //                                       width: 70,
  //                                       margin: const EdgeInsets.fromLTRB(
  //                                           30, 30, 30, 20),
  //                                       decoration: const BoxDecoration(
  //                                         color: Colors.white,
  //                                         image: DecorationImage(
  //                                           image: AssetImage(
  //                                               "assets/images/Group 3.png"),
  //                                           fit: BoxFit.contain,
  //                                         ),
  //                                       ),
  //                                     ),
  //                                     Container(
  //                                       height: 40,
  //                                       width: 160,
  //                                       color: Colors.white,
  //                                       child: const Center(
  //                                         child: Text(
  //                                           'Insurannce \nPlans',
  //                                           style: TextStyle(
  //                                               fontSize: 18,
  //                                               fontWeight: FontWeight.bold,
  //                                               color: Colors.blueAccent),
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                       const SizedBox(
  //                         height: 40,
  //                       ),
  //                       Row(
  //                         children: [
  //
  //                           Expanded(
  //                             child: InkWell(
  //                               onTap: () {
  //
  //                                 Navigator.push(
  //                                   context,
  //                                   MaterialPageRoute(
  //                                       builder: (context) => WebViewScreen(
  //                                           key: _scaffoldKey,
  //                                           url_link:
  //                                           'https://si.sudlife.in/SalesIllustration/ProductPage.aspx')),
  //                                 );
  //                               },
  //                               child: Container(
  //                                 margin: const EdgeInsets.all(10),
  //                                 height: 140,
  //                                 //width: 200,
  //                                 decoration: const BoxDecoration(
  //                                   color: Colors.white,
  //                                   borderRadius: BorderRadius.only(
  //                                       topRight: Radius.circular(20.0),
  //                                       bottomRight: Radius.circular(20.0),
  //                                       topLeft: Radius.circular(20.0),
  //                                       bottomLeft: Radius.circular(20.0)),
  //                                 ),
  //                                 child: Column(
  //                                   children: [
  //                                     Container(
  //                                       height: 30,
  //                                       width: 70,
  //                                       margin: const EdgeInsets.fromLTRB(
  //                                           30, 30, 30, 20),
  //                                       decoration: const BoxDecoration(
  //                                         color: Colors.white,
  //                                         image: DecorationImage(
  //                                           image: AssetImage(
  //                                               "assets/images/Path 107.png"),
  //                                           fit: BoxFit.contain,
  //                                         ),
  //                                       ),
  //                                     ),
  //                                     Container(
  //                                       height: 40,
  //                                       width: 160,
  //                                       color: Colors.white,
  //                                       child: Center(
  //                                         child: Text(
  //                                           'Calculate your \nPremiums',
  //                                           style: TextStyle(
  //                                               fontSize: 18,
  //                                               fontWeight: FontWeight.bold,
  //                                               color: Colors.blueAccent),
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //
  //                           Expanded(
  //                             child: InkWell(
  //                               onTap: () {
  //                                 Navigator.push(
  //                                   context,
  //                                   MaterialPageRoute(
  //                                       builder: (context) => WebViewScreen(
  //                                           key: _scaffoldKey,
  //                                           url_link:
  //                                           'https://customer.sudlife.in')),
  //                                 );
  //                               },
  //
  //                               child: Container(
  //                                 margin: const EdgeInsets.all(10),
  //                                 height: 140,
  //                                 //width: 200,
  //                                 decoration: const BoxDecoration(
  //                                   color: Colors.white,
  //                                   borderRadius: BorderRadius.only(
  //                                       topRight: Radius.circular(20.0),
  //                                       bottomRight: Radius.circular(20.0),
  //                                       topLeft: Radius.circular(20.0),
  //                                       bottomLeft: Radius.circular(20.0)),
  //                                 ),
  //                                 child: Column(
  //                                   children: [
  //                                     Container(
  //                                       height: 30,
  //                                       width: 70,
  //                                       margin: const EdgeInsets.fromLTRB(
  //                                           30, 30, 30, 20),
  //                                       decoration: const BoxDecoration(
  //                                         color: Colors.white,
  //                                         image: DecorationImage(
  //                                           image: AssetImage(
  //                                               "assets/images/Group 6.png"),
  //                                           fit: BoxFit.contain,
  //                                         ),
  //                                       ),
  //                                     ),
  //                                     Container(
  //                                       height: 40,
  //                                       width: 160,
  //                                       color: Colors.white,
  //                                       child: Center(
  //                                         child: Text(
  //                                           'Customer \nPortal',
  //                                           style: TextStyle(
  //                                               fontSize: 18,
  //                                               fontWeight: FontWeight.bold,
  //                                               color: Colors.blueAccent),
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //
  //                           Expanded(
  //                             child: InkWell(
  //                               onTap: () {
  //
  //                                 Navigator.push(
  //                                   context,
  //                                   MaterialPageRoute(
  //                                       builder: (context) => WebViewScreen(
  //                                           key: _scaffoldKey,
  //                                           url_link:
  //                                           'https://www.sudlife.in/contact-u')),
  //                                 );
  //                               },
  //                               child: Container(
  //                                 margin: const EdgeInsets.all(10),
  //                                 height: 140,
  //                                 //width: 200,
  //                                 decoration: const BoxDecoration(
  //                                   color: Colors.white,
  //                                   borderRadius: BorderRadius.only(
  //                                       topRight: Radius.circular(20.0),
  //                                       bottomRight: Radius.circular(20.0),
  //                                       topLeft: Radius.circular(20.0),
  //                                       bottomLeft: Radius.circular(20.0)),
  //                                 ),
  //                                 child: Column(
  //                                   children: [
  //                                     Container(
  //                                       height: 30,
  //                                       width: 70,
  //                                       margin: const EdgeInsets.fromLTRB(
  //                                           30, 30, 30, 20),
  //                                       decoration: const BoxDecoration(
  //                                         color: Colors.white,
  //                                         image: DecorationImage(
  //                                           image: AssetImage(
  //                                               "assets/images/Path 95.png"),
  //                                           fit: BoxFit.contain,
  //                                         ),
  //                                       ),
  //                                     ),
  //                                     Container(
  //                                       height: 40,
  //                                       width: 160,
  //                                       color: Colors.white,
  //                                       child: Center(
  //                                         child: Text(
  //                                           'Office \nLocator',
  //                                           style: TextStyle(
  //                                               fontSize: 18,
  //                                               fontWeight: FontWeight.bold,
  //                                               color: Colors.blueAccent),
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                         ],
  //                       )
  //                     ],
  //                   ),
  //                   const SizedBox(
  //                     height: 100,
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //           Hero(
  //             tag: "curtain",
  //             child: Stack(
  //               children: <Widget>[
  //                 Transform.translate(
  //                   offset: Offset(0, -curtainOffset.value),
  //                   child: ClipPath(
  //                     clipper: CrossClipper(),
  //                     child: Container(
  //                       decoration: new BoxDecoration(
  //                         image: new DecorationImage(
  //                           image: imageAsset,
  //                           fit: BoxFit.fitWidth,
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //                 Transform.translate(
  //                   offset: Offset(0, curtainOffset.value),
  //                   child: ClipPath(
  //                     clipper: CrossClipper(showTop: false),
  //                     child: Container(
  //                       decoration: new BoxDecoration(
  //                         image: new DecorationImage(
  //                           image: imageAsset,
  //                           fit: BoxFit.fitWidth,
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  //
  //   // return MaterialApp(
  //   //
  //   //   home: Scaffold(
  //   //     //    appBar: AppBar(backgroundColor: Colors.transparent,title: Text('')),
  //   //     body: SingleChildScrollView(
  //   //       child: Container(
  //   //         //height: MediaQuery.of(context).size.height,
  //   //         decoration: BoxDecoration(
  //   //           image: DecorationImage(
  //   //             image: AssetImage("assets/images/Background.png"),
  //   //             fit: BoxFit.cover,
  //   //           ),
  //   //         ),
  //   //         child: Column(
  //   //           children: [
  //   //             const SizedBox(
  //   //               height: 60,
  //   //             ),
  //   //             Row(
  //   //               children: [
  //   //                 Text(
  //   //                   "SUD Life Experience Zone",
  //   //                   style: TextStyle(
  //   //                       fontSize: 18,
  //   //                       fontWeight: FontWeight.bold,
  //   //                       color: Colors.white),
  //   //                 ),
  //   //                 Spacer(),
  //   //                 Expanded(
  //   //                   child: Container(
  //   //                     height: 70,
  //   //                     width: 200,
  //   //                     decoration: const BoxDecoration(
  //   //                       color: Colors.white,
  //   //                       borderRadius: BorderRadius.only(
  //   //                           // topRight: Radius.circular(40.0),
  //   //                           // bottomRight: Radius.circular(40.0),
  //   //                           topLeft: Radius.circular(20.0),
  //   //                           bottomLeft: Radius.circular(20.0)),
  //   //                     ),
  //   //                     child: Container(
  //   //                       height: 50,
  //   //                       width: 160,
  //   //                       margin: EdgeInsets.all(10),
  //   //                       decoration: BoxDecoration(
  //   //                         color: Colors.white,
  //   //                         image: DecorationImage(
  //   //                           image: AssetImage("assets/images/site-logo.png"),
  //   //                           fit: BoxFit.contain,
  //   //                         ),
  //   //                       ),
  //   //                       child: null,
  //   //                     ),
  //   //                   ),
  //   //                 )
  //   //               ],
  //   //             ),
  //   //             Column(
  //   //               children: [
  //   //                 Row(
  //   //                   children: [
  //   //                     Expanded(
  //   //                       child: Container(
  //   //                         margin: const EdgeInsets.all(10),
  //   //                         height: 140,
  //   //                         //width: 200,
  //   //                         decoration: const BoxDecoration(
  //   //                           color: Colors.white,
  //   //                           borderRadius: BorderRadius.only(
  //   //                               topRight: Radius.circular(20.0),
  //   //                               bottomRight: Radius.circular(20.0),
  //   //                               topLeft: Radius.circular(20.0),
  //   //                               bottomLeft: Radius.circular(20.0)),
  //   //                         ),
  //   //                         child: Column(
  //   //                           children: [
  //   //                             Container(
  //   //                               height: 30,
  //   //                               width: 70,
  //   //                               margin:
  //   //                                   const EdgeInsets.fromLTRB(30, 30, 30, 20),
  //   //                               decoration: const BoxDecoration(
  //   //                                 color: Colors.white,
  //   //                                 image: DecorationImage(
  //   //                                   image: AssetImage(
  //   //                                       "assets/images/Group 3.png"),
  //   //                                   fit: BoxFit.contain,
  //   //                                 ),
  //   //                               ),
  //   //                             ),
  //   //                             Container(
  //   //                               height: 40,
  //   //                               width: 160,
  //   //                               color: Colors.white,
  //   //                               child: Center(
  //   //                                 child: Text(
  //   //                                   'Buy \nOnline',
  //   //                                   style: TextStyle(
  //   //                                       fontSize: 18,
  //   //                                       fontWeight: FontWeight.bold,
  //   //                                       color: Colors.blueAccent),
  //   //                                 ),
  //   //                               ),
  //   //                             ),
  //   //                           ],
  //   //                         ),
  //   //                       ),
  //   //                     ),
  //   //                     Expanded(
  //   //                       child: Container(
  //   //                         margin: const EdgeInsets.all(10),
  //   //                         height: 140,
  //   //                         //width: 200,
  //   //                         decoration: const BoxDecoration(
  //   //                           color: Colors.white,
  //   //                           borderRadius: BorderRadius.only(
  //   //                               topRight: Radius.circular(20.0),
  //   //                               bottomRight: Radius.circular(20.0),
  //   //                               topLeft: Radius.circular(20.0),
  //   //                               bottomLeft: Radius.circular(20.0)),
  //   //                         ),
  //   //                         child: Column(
  //   //                           children: [
  //   //                             Container(
  //   //                               height: 30,
  //   //                               width: 70,
  //   //                               margin:
  //   //                                   const EdgeInsets.fromLTRB(30, 30, 30, 20),
  //   //                               decoration: const BoxDecoration(
  //   //                                 color: Colors.white,
  //   //                                 image: DecorationImage(
  //   //                                   image: AssetImage(
  //   //                                       "assets/images/Path 92.png"),
  //   //                                   fit: BoxFit.contain,
  //   //                                 ),
  //   //                               ),
  //   //                             ),
  //   //                             Container(
  //   //                               height: 40,
  //   //                               width: 160,
  //   //                               color: Colors.white,
  //   //                               child: const Center(
  //   //                                 child: Text(
  //   //                                   'Pay \nPremiums',
  //   //                                   style: TextStyle(
  //   //                                       fontSize: 18,
  //   //                                       fontWeight: FontWeight.bold,
  //   //                                       color: Colors.blueAccent),
  //   //                                 ),
  //   //                               ),
  //   //                             ),
  //   //                           ],
  //   //                         ),
  //   //                       ),
  //   //                     ),
  //   //                     Expanded(
  //   //                       child: Container(
  //   //                         margin: const EdgeInsets.all(10),
  //   //                         height: 140,
  //   //                         //width: 200,
  //   //                         decoration: const BoxDecoration(
  //   //                           color: Colors.white,
  //   //                           borderRadius: BorderRadius.only(
  //   //                               topRight: Radius.circular(20.0),
  //   //                               bottomRight: Radius.circular(20.0),
  //   //                               topLeft: Radius.circular(20.0),
  //   //                               bottomLeft: Radius.circular(20.0)),
  //   //                         ),
  //   //                         child: Column(
  //   //                           children: [
  //   //                             Container(
  //   //                               height: 30,
  //   //                               width: 70,
  //   //                               margin:
  //   //                                   const EdgeInsets.fromLTRB(30, 30, 30, 20),
  //   //                               decoration: const BoxDecoration(
  //   //                                 color: Colors.white,
  //   //                                 image: DecorationImage(
  //   //                                   image: AssetImage(
  //   //                                       "assets/images/Group 3.png"),
  //   //                                   fit: BoxFit.contain,
  //   //                                 ),
  //   //                               ),
  //   //                             ),
  //   //                             Container(
  //   //                               height: 40,
  //   //                               width: 160,
  //   //                               color: Colors.white,
  //   //                               child: const Center(
  //   //                                 child: Text(
  //   //                                   'Insurannce \nPlans',
  //   //                                   style: TextStyle(
  //   //                                       fontSize: 18,
  //   //                                       fontWeight: FontWeight.bold,
  //   //                                       color: Colors.blueAccent),
  //   //                                 ),
  //   //                               ),
  //   //                             ),
  //   //                           ],
  //   //                         ),
  //   //                       ),
  //   //                     ),
  //   //                   ],
  //   //                 ),
  //   //                 const SizedBox(
  //   //                   height: 40,
  //   //                 ),
  //   //                 Row(
  //   //                   children: [
  //   //                     Expanded(
  //   //                       child: Container(
  //   //                         margin: const EdgeInsets.all(10),
  //   //                         height: 140,
  //   //                         //width: 200,
  //   //                         decoration: const BoxDecoration(
  //   //                           color: Colors.white,
  //   //                           borderRadius: BorderRadius.only(
  //   //                               topRight: Radius.circular(20.0),
  //   //                               bottomRight: Radius.circular(20.0),
  //   //                               topLeft: Radius.circular(20.0),
  //   //                               bottomLeft: Radius.circular(20.0)),
  //   //                         ),
  //   //                         child: Column(
  //   //                           children: [
  //   //                             Container(
  //   //                               height: 30,
  //   //                               width: 70,
  //   //                               margin:
  //   //                                   const EdgeInsets.fromLTRB(30, 30, 30, 20),
  //   //                               decoration: const BoxDecoration(
  //   //                                 color: Colors.white,
  //   //                                 image: DecorationImage(
  //   //                                   image: AssetImage(
  //   //                                       "assets/images/Path 107.png"),
  //   //                                   fit: BoxFit.contain,
  //   //                                 ),
  //   //                               ),
  //   //                             ),
  //   //                             Container(
  //   //                               height: 40,
  //   //                               width: 160,
  //   //                               color: Colors.white,
  //   //                               child: Center(
  //   //                                 child: Text(
  //   //                                   'Calculate your \nPremiums',
  //   //                                   style: TextStyle(
  //   //                                       fontSize: 18,
  //   //                                       fontWeight: FontWeight.bold,
  //   //                                       color: Colors.blueAccent),
  //   //                                 ),
  //   //                               ),
  //   //                             ),
  //   //                           ],
  //   //                         ),
  //   //                       ),
  //   //                     ),
  //   //                     Expanded(
  //   //                       child: Container(
  //   //                         margin: const EdgeInsets.all(10),
  //   //                         height: 140,
  //   //                         //width: 200,
  //   //                         decoration: const BoxDecoration(
  //   //                           color: Colors.white,
  //   //                           borderRadius: BorderRadius.only(
  //   //                               topRight: Radius.circular(20.0),
  //   //                               bottomRight: Radius.circular(20.0),
  //   //                               topLeft: Radius.circular(20.0),
  //   //                               bottomLeft: Radius.circular(20.0)),
  //   //                         ),
  //   //                         child: Column(
  //   //                           children: [
  //   //                             Container(
  //   //                               height: 30,
  //   //                               width: 70,
  //   //                               margin:
  //   //                                   const EdgeInsets.fromLTRB(30, 30, 30, 20),
  //   //                               decoration: const BoxDecoration(
  //   //                                 color: Colors.white,
  //   //                                 image: DecorationImage(
  //   //                                   image: AssetImage(
  //   //                                       "assets/images/Group 6.png"),
  //   //                                   fit: BoxFit.contain,
  //   //                                 ),
  //   //                               ),
  //   //                             ),
  //   //                             Container(
  //   //                               height: 40,
  //   //                               width: 160,
  //   //                               color: Colors.white,
  //   //                               child: Center(
  //   //                                 child: Text(
  //   //                                   'Customer \nPortal',
  //   //                                   style: TextStyle(
  //   //                                       fontSize: 18,
  //   //                                       fontWeight: FontWeight.bold,
  //   //                                       color: Colors.blueAccent),
  //   //                                 ),
  //   //                               ),
  //   //                             ),
  //   //                           ],
  //   //                         ),
  //   //                       ),
  //   //                     ),
  //   //                     Expanded(
  //   //                       child: Container(
  //   //                         margin: const EdgeInsets.all(10),
  //   //                         height: 140,
  //   //                         //width: 200,
  //   //                         decoration: const BoxDecoration(
  //   //                           color: Colors.white,
  //   //                           borderRadius: BorderRadius.only(
  //   //                               topRight: Radius.circular(20.0),
  //   //                               bottomRight: Radius.circular(20.0),
  //   //                               topLeft: Radius.circular(20.0),
  //   //                               bottomLeft: Radius.circular(20.0)),
  //   //                         ),
  //   //                         child: Column(
  //   //                           children: [
  //   //                             Container(
  //   //                               height: 30,
  //   //                               width: 70,
  //   //                               margin:
  //   //                                   const EdgeInsets.fromLTRB(30, 30, 30, 20),
  //   //                               decoration: const BoxDecoration(
  //   //                                 color: Colors.white,
  //   //                                 image: DecorationImage(
  //   //                                   image: AssetImage(
  //   //                                       "assets/images/Path 95.png"),
  //   //                                   fit: BoxFit.contain,
  //   //                                 ),
  //   //                               ),
  //   //                             ),
  //   //                             Container(
  //   //                               height: 40,
  //   //                               width: 160,
  //   //                               color: Colors.white,
  //   //                               child: Center(
  //   //                                 child: Text(
  //   //                                   'Office \nLocator',
  //   //                                   style: TextStyle(
  //   //                                       fontSize: 18,
  //   //                                       fontWeight: FontWeight.bold,
  //   //                                       color: Colors.blueAccent),
  //   //                                 ),
  //   //                               ),
  //   //                             ),
  //   //                           ],
  //   //                         ),
  //   //                       ),
  //   //                     ),
  //   //                   ],
  //   //                 )
  //   //               ],
  //   //             )
  //   //           ],
  //   //         ),
  //   //       ),
  //   //     ),
  //   //     // body: WebView(
  //   //     //
  //   //     //   initialUrl: 'about:blank',
  //   //     //   onWebViewCreated: (WebViewController webViewController) {
  //   //     //     _controller = webViewController;
  //   //     //     _loadHtmlFromAssets();
  //   //     //   },
  //   //     //   javascriptMode: JavascriptMode.unrestricted,
  //   //     // ),
  //   //   ),
  //   // );
  // }

  _loadHtmlFromAssets(String url) async {
    // String fileText = await rootBundle.loadString('assets/screen1.html');
    String fileText = await rootBundle.loadString(url);
    _webController.loadUrl(Uri.dataFromString(fileText,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }

  Widget WidgetWebView(String url) {

//     return Container(
//         child: Column(children: <Widget>[
//           Expanded(
//             child:InAppWebView(
//               initialData: InAppWebViewInitialData(
//                   data: """
// <!DOCTYPE html>
// <html lang="en">
//     <head>
//         <meta charset="UTF-8">
//         <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
//     </head>
//     <body>
//         <h1>JavaScript Handlers (Channels) TEST</h1>
//         <script>
//             window.addEventListener("flutterInAppWebViewPlatformReady", function(event) {
//                 window.flutter_inappwebview.callHandler('handlerFoo')
//                   .then(function(result) {
//                     // print to the console the data coming
//                     // from the Flutter side.
//                     console.log(JSON.stringify(result));
//
//                     window.flutter_inappwebview
//                       .callHandler('handlerFooWithArgs', 1, true, ['bar', 5], {foo: 'baz'}, result);
//                 });
//             });
//         </script>
//     </body>
// </html>
//                       """
//               ),
//               initialOptions: InAppWebViewGroupOptions(
//                   crossPlatform: InAppWebViewOptions(
//                     //debuggingEnabled: true,
//                   )
//               ),
//               onWebViewCreated: (InAppWebViewController controller) {
//                 _webViewController = controller;
//
//                 _webViewController.addJavaScriptHandler(handlerName:'handlerFoo', callback: (args) {
//                   // return data to JavaScript side!
//                   return {
//                     'bar': 'bar_value', 'baz': 'baz_value'
//                   };
//                 });
//
//                 _webViewController.addJavaScriptHandler(handlerName: 'handlerFooWithArgs', callback: (args) {
//                   print(args);
//                   // it will print: [1, true, [bar, 5], {foo: baz}, {bar: bar_value, baz: baz_value}]
//                 });
//               },
//               onConsoleMessage: (controller, consoleMessage) {
//                 print(consoleMessage);
//                 // it will print: {message: {"bar":"bar_value","baz":"baz_value"}, messageLevel: 1}
//               },
//             ),
//           ),
//         ]));

    return Container(
      margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
      child: Expanded(
          child: WebView(
        initialUrl: url,
        gestureNavigationEnabled: false,
        javascriptMode: JavascriptMode.unrestricted,
        onPageFinished: _handleLoad,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      )),
    );
  }

  void _handleLoad(String value) {
    setState(() {
      _stackToView = 0;
    });
  }
}
