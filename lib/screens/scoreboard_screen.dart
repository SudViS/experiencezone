import 'dart:async';
import 'package:experiencezone/screens/zonehome_screen.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:experiencezone/screens/quiz_screen.dart';
import 'package:flutter/material.dart';
import '../utils/light_color.dart';
import 'banner_screen.dart';
import 'funfacts_screen.dart';

class ScoreBoardScreen extends StatefulWidget {
  final String Score;
  const ScoreBoardScreen({Key? key, required this.Score}) : super(key: key);

  @override
  State<ScoreBoardScreen> createState() => _ScoreBoardScreenState();
}

class _ScoreBoardScreenState extends State<ScoreBoardScreen> {

  late Timer _timer;
  int _start = 120; // 2 minute

  void startTimer() {
    _start = 120;
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            _timer.cancel();
            timer.cancel();
          });

          showSnackBar(
              "2 Minute Limit Over");
          clear();
          Navigator.of(context).pop();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BannerScreen()));

          // setState(() {
          //   timer.cancel();
          //   _show = true;
          // });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  Future showSnackBar(String error) async {
    HapticFeedback.vibrate();
    final snackBar = SnackBar(
      backgroundColor: LightColor.appBlue,
      content: Text(
        error,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      action: SnackBarAction(
        textColor: Colors.white,
        label: 'Okay',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    // flush = Flushbar<bool>(
    //   duration: Duration(seconds: 2),
    //   isDismissible: true,
    //   title: " ",
    //   //message: "Enter correct number!",
    //   message: error.toString(),
    //   showProgressIndicator: false,
    //   backgroundGradient: LinearGradient(
    //     colors: [LightColor.ypurple, Colors.white],
    //     stops: [0.6, 1],
    //   ),
    //   margin: EdgeInsets.all(20),
    //   icon: Icon(
    //     Icons.warning_rounded,
    //     color: Colors.white,
    //   ),
    // )
    //   ..show(context).then((result) {
    //   });
    // flush.duration;
    // HapticFeedback.vibrate();
  }

  @override
  void initState() {
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    print("ScoreBoard Screen");
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        //extendBodyBehindAppBar: true,
        // appBar: AppBar(
        //   //backgroundColor: Colors.black,
        //   backgroundColor: Colors.transparent,
        //   leading: IconButton(
        //     icon: Icon(Icons.arrow_back, color: Colors.white),
        //     onPressed: () => Navigator.of(context).pop(),
        //   ),
        //   title: Text(""),
        //   centerTitle: false,
        // ),
        body: Stack(
          children: [
            Container(
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
                      height: 150,
                    ),
                    Container(
                      height: 70,
                      width: 140,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15.0),
                            bottomRight: Radius.circular(15.0),
                            topLeft: Radius.circular(15.0),
                            bottomLeft: Radius.circular(15.0)),
                      ),
                      child: Container(
                        height: 50,
                        width: 100,
                        margin: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          image: DecorationImage(
                            image: AssetImage("assets/images/site-logo.png"),
                            fit: BoxFit.contain,
                          ),
                        ),
                        child: null,
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    SingleChildScrollView(
                      child: Container(
                        //height: 350,
                        //width: 450,
                        width: MediaQuery.of(context).size.width - 120,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(15.0),
                              bottomRight: Radius.circular(15.0),
                              topLeft: Radius.circular(15.0),
                              bottomLeft: Radius.circular(15.0)),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.all(10),
                                  height: 40,
                                  width: 40,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image:
                                      AssetImage("assets/Quiz time ic.png"),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 40,
                                      //width: 90,
                                      child: Center(
                                        child: Text(
                                          "Match the following",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.blue.shade800,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 20,

                                      //width: 90,
                                      child: Text(
                                        "10 Questions",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.blue.shade800,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                InkWell(
                                  onTap: () {
                                    clear();
                                    dispose();
                                    //Navigator.of(context).pop();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ZoneHomeScreen()));
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) => BannerScreen()));
                                  },
                                  child: Container(
                                    height: 35,
                                    width: 35,
                                    margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image:
                                        AssetImage("assets/icon/close.png"),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Divider(
                                color: Colors.black45,
                                height: 0.5,
                              ),
                            ),
                            Container(
                              height: 250,
                              width: 350,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Your Score",
                                      style: TextStyle(
                                          color: Color(0xff2474B9),
                                          fontSize: 30,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      widget.Score.toString() + "/10",
                                      style: const TextStyle(
                                          color: Color(0xff2474B9),
                                          fontSize: 48,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        clear();

                                        dispose();
                                        //Navigator.of(context).pop();
                                        // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                                        //     builder: (context) => Quiz_Screen()), (Route<dynamic> route) => false);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Quiz_Screen()));
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: 15,
                                            width: 15,
                                            margin: const EdgeInsets.all(12),
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              image: DecorationImage(
                                                image: AssetImage(
                                                    "assets/images/try again.png"),
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                          const Text(
                                            "Take Quiz Again    ",
                                            style: TextStyle(
                                                color: Color(0xff2474B9),
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
            //       Positioned(
            //         top: 0.0,
            //         left: 10.0,
            //         right: 0.0,
            //         child: AppBar(
            //           title: const Text(''), // You can add title here
            //           leading: IconButton(
            //             icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            //             onPressed: () => {
            //               clear(),
            //               Navigator.of(context).pop(),
            // Navigator.push(context,
            // MaterialPageRoute(builder: (context) => BannerScreen())),
            //             },
            //           ),
            //           backgroundColor:
            //               Colors.transparent, //You can make this transparent
            //           elevation: 0.0, //No shadow
            //         ),
            //       ),
            Positioned(
              top: 20.0,
              right: 30.0,
              child: InkWell(
                onTap: () {
                  dispose();
                  //Navigator.of(context).pop();
                  // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                  //     builder: (context) => ZoneHomeScreen()), (Route<dynamic> route) => false);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      // builder: (context) => ChessGame()),
                        builder: (context) => ZoneHomeScreen()),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.all(10),
                  height: 100,
                  width: 40,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          "assets/games/Home Icon.png"),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),


          ],
          // child: Container(
          //   width: MediaQuery.of(context).size.width,
          //   height: MediaQuery.of(context).size.height,
          //   decoration: const BoxDecoration(
          //     image: DecorationImage(
          //       image: AssetImage("assets/images/Background.png"),
          //       fit: BoxFit.fill,
          //     ),
          //   ),
          //   child: SingleChildScrollView(
          //     child: Column(
          //       children: [
          //
          //         SizedBox(
          //           height: 50,
          //         ),
          //
          //         Container(
          //           height: 70,
          //           width: 140,
          //           decoration: const BoxDecoration(
          //             color: Colors.white,
          //             borderRadius: BorderRadius.only(
          //                 topRight: Radius.circular(15.0),
          //                 bottomRight: Radius.circular(15.0),
          //                 topLeft: Radius.circular(15.0),
          //                 bottomLeft: Radius.circular(15.0)),
          //           ),
          //           child: Container(
          //             height: 50,
          //             width: 100,
          //             margin: const EdgeInsets.all(12),
          //             decoration: const BoxDecoration(
          //               color: Colors.white,
          //               image: DecorationImage(
          //                 image: AssetImage("assets/images/site-logo.png"),
          //                 fit: BoxFit.contain,
          //               ),
          //             ),
          //             child: null,
          //           ),
          //         ),
          //
          //         SizedBox(
          //           height: 50,
          //         ),
          //
          //         Container(
          //           //height: 350,
          //           width: 350,
          //           decoration: const BoxDecoration(
          //             color: Colors.white,
          //             borderRadius: BorderRadius.only(
          //                 topRight: Radius.circular(15.0),
          //                 bottomRight: Radius.circular(15.0),
          //                 topLeft: Radius.circular(15.0),
          //                 bottomLeft: Radius.circular(15.0)),
          //           ),
          //           child: Expanded(
          //             child: Column(
          //               children: [
          //                 Row(
          //                   children: [
          //                     Container(
          //                       margin: EdgeInsets.all(10),
          //                       height: 35,
          //                       width: 35,
          //                       decoration: const BoxDecoration(
          //                         image: DecorationImage(
          //                           image: AssetImage("assets/icon/fun facts ic.png"),
          //                           fit: BoxFit.fill,
          //                         ),
          //                       ),
          //                     ),
          //                     Container(
          //                       height: 40,
          //                       width: 90,
          //                       child: Center(
          //                         child: Text(
          //                           "Fun Facts",
          //                           style: TextStyle(fontSize: 18, color: Colors.blue,fontWeight: FontWeight.bold),
          //                         ),
          //                       ),
          //                     ),
          //                     Spacer(),
          //                     Container(
          //                       height: 35,
          //                       width: 35,
          //                       margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
          //                       decoration: const BoxDecoration(
          //                         image: DecorationImage(
          //                           image: AssetImage("assets/icon/close.png"),
          //                           fit: BoxFit.fill,
          //                         ),
          //                       ),
          //                     ),
          //                   ],
          //                 ),
          //
          //                 Padding(
          //                   padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          //                   child: const Divider(
          //
          //                     color: Colors.black45,
          //                     height: 0.5,
          //                   ),
          //                 ),
          //
          //                 Container(
          //                   //height: 150,
          //                   width: MediaQuery.of(context).size.width,
          //                   margin: EdgeInsets.all(20),
          //                   decoration: const BoxDecoration(
          //                     color: Colors.white,
          //                     image: DecorationImage(
          //                       image: AssetImage("assets/icon/Background.png"),
          //                       fit: BoxFit.fill,
          //                     ),
          //                   ),
          //                   child: Container(
          //                     //height: 130,
          //                     width: 220,
          //                     margin: EdgeInsets.all(30),
          //                     padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
          //                     child: Center(
          //                       child: Text(
          //                         "•	The word 'insurance' is derived from the French word 'ensurer' and originally meant an 'engagement to marry'.",
          //                         style: TextStyle(fontSize: 18, color: Colors.blue),
          //                       ),
          //                     ),
          //                   ),
          //                 ),
          //
          //                 SizedBox(height: 10),
          //
          //                 Row(
          //                   children: [
          //                     Container(
          //                       margin: EdgeInsets.fromLTRB(20,0,0,0),
          //                       height: 45,
          //                       width: 100,
          //                       decoration: const BoxDecoration(
          //                         image: DecorationImage(
          //                           image: AssetImage("assets/icon/Previous.png"),
          //                           fit: BoxFit.fill,
          //                         ),
          //                       ),
          //                     ),
          //                     Spacer(),
          //                     Container(
          //                       margin: EdgeInsets.fromLTRB(0,0,20,0),
          //                       height: 45,
          //                       width: 100,
          //                       decoration: const BoxDecoration(
          //                         image: DecorationImage(
          //                           image: AssetImage("assets/icon/Next.png"),
          //                           fit: BoxFit.fill,
          //                         ),
          //                       ),
          //                     ),
          //                   ],
          //                 ),
          //
          //                 SizedBox(height: 20),
          //
          //               ],
          //             ),
          //           ),
          //         )
          //       ],
          //     ),
          //   ),
          // ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    if(_timer.isActive){
      _timer.cancel();
      print("ScoreBoard Timer Canceled in Dispose() ");
    }
  }

  // @override
  // Widget build(BuildContext context) {
  //   return WillPopScope(
  //     onWillPop: () async => false,
  //     child: Scaffold(
  //       //extendBodyBehindAppBar: true,
  //       // appBar: AppBar(
  //       //   //backgroundColor: Colors.black,
  //       //   backgroundColor: Colors.transparent,
  //       //   leading: IconButton(
  //       //     icon: Icon(Icons.arrow_back, color: Colors.white),
  //       //     onPressed: () => Navigator.of(context).pop(),
  //       //   ),
  //       //   title: Text(""),
  //       //   centerTitle: false,
  //       // ),
  //       body: Stack(
  //         children: [
  //           Container(
  //             width: MediaQuery.of(context).size.width,
  //             height: MediaQuery.of(context).size.height,
  //             decoration: const BoxDecoration(
  //               image: DecorationImage(
  //                 image: AssetImage("assets/images/Background.png"),
  //                 fit: BoxFit.fill,
  //               ),
  //             ),
  //             child: SingleChildScrollView(
  //               child: Column(
  //                 children: [
  //                   const SizedBox(
  //                     height: 150,
  //                   ),
  //                   Container(
  //                     height: 70,
  //                     width: 140,
  //                     decoration: const BoxDecoration(
  //                       color: Colors.white,
  //                       borderRadius: BorderRadius.only(
  //                           topRight: Radius.circular(15.0),
  //                           bottomRight: Radius.circular(15.0),
  //                           topLeft: Radius.circular(15.0),
  //                           bottomLeft: Radius.circular(15.0)),
  //                     ),
  //                     child: Container(
  //                       height: 50,
  //                       width: 100,
  //                       margin: const EdgeInsets.all(12),
  //                       decoration: const BoxDecoration(
  //                         color: Colors.white,
  //                         image: DecorationImage(
  //                           image: AssetImage("assets/images/site-logo.png"),
  //                           fit: BoxFit.contain,
  //                         ),
  //                       ),
  //                       child: null,
  //                     ),
  //                   ),
  //                   const SizedBox(
  //                     height: 50,
  //                   ),
  //                   SingleChildScrollView(
  //                     child: Container(
  //                       //height: 350,
  //                       //width: 450,
  //                       width: MediaQuery.of(context).size.width - 120,
  //                       decoration: const BoxDecoration(
  //                         color: Colors.white,
  //                         borderRadius: BorderRadius.only(
  //                             topRight: Radius.circular(15.0),
  //                             bottomRight: Radius.circular(15.0),
  //                             topLeft: Radius.circular(15.0),
  //                             bottomLeft: Radius.circular(15.0)),
  //                       ),
  //                       child: Column(
  //                         children: [
  //                           Row(
  //                             children: [
  //                               Container(
  //                                 margin: EdgeInsets.all(10),
  //                                 height: 40,
  //                                 width: 40,
  //                                 decoration: const BoxDecoration(
  //                                   image: DecorationImage(
  //                                     image:
  //                                         AssetImage("assets/Quiz time ic.png"),
  //                                     fit: BoxFit.fill,
  //                                   ),
  //                                 ),
  //                               ),
  //                               Column(
  //                                 crossAxisAlignment: CrossAxisAlignment.start,
  //                                 children: [
  //                                   Container(
  //                                     height: 40,
  //                                     //width: 90,
  //                                     child: Center(
  //                                       child: Text(
  //                                         "Match the following",
  //                                         style: TextStyle(
  //                                             fontSize: 18,
  //                                             color: Colors.blue.shade800,
  //                                             fontWeight: FontWeight.bold),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                   Container(
  //                                     height: 20,
  //
  //                                     //width: 90,
  //                                     child: Text(
  //                                       "10 Questions",
  //                                       textAlign: TextAlign.start,
  //                                       style: TextStyle(
  //                                           fontSize: 14,
  //                                           color: Colors.blue.shade800,
  //                                           fontWeight: FontWeight.bold),
  //                                     ),
  //                                   ),
  //                                   const SizedBox(
  //                                     height: 6,
  //                                   ),
  //                                 ],
  //                               ),
  //                               const Spacer(),
  //                               InkWell(
  //                                 onTap: () {
  //                                   clear();
  //                                   Navigator.of(context).pop();
  //                                   Navigator.push(
  //                                       context,
  //                                       MaterialPageRoute(
  //                                           builder: (context) => ZoneHomeScreen()));
  //                                 },
  //                                 child: Container(
  //                                   height: 35,
  //                                   width: 35,
  //                                   margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
  //                                   decoration: const BoxDecoration(
  //                                     image: DecorationImage(
  //                                       image:
  //                                           AssetImage("assets/icon/close.png"),
  //                                       fit: BoxFit.fill,
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                           const Padding(
  //                             padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
  //                             child: Divider(
  //                               color: Colors.black45,
  //                               height: 0.5,
  //                             ),
  //                           ),
  //                           Container(
  //                             height: 250,
  //                             width: 350,
  //                             child: Center(
  //                               child: Column(
  //                                 mainAxisAlignment: MainAxisAlignment.center,
  //                                 children: [
  //                                   const Text(
  //                                     "Your Score",
  //                                     style: TextStyle(
  //                                         color: Color(0xff2474B9),
  //                                         fontSize: 30,
  //                                         fontWeight: FontWeight.w500),
  //                                   ),
  //                                   const SizedBox(
  //                                     height: 10,
  //                                   ),
  //                                   Text(
  //                                     widget.Score.toString() + "/10",
  //                                     style: const TextStyle(
  //                                         color: Color(0xff2474B9),
  //                                         fontSize: 48,
  //                                         fontWeight: FontWeight.bold),
  //                                   ),
  //                                   const SizedBox(
  //                                     height: 20,
  //                                   ),
  //                                   InkWell(
  //                                     onTap: () {
  //                                       clear();
  //                                       Navigator.of(context).pop();
  //                                       // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
  //                                       //     builder: (context) => Quiz_Screen()), (Route<dynamic> route) => false);
  //                                       Navigator.push(
  //                                           context,
  //                                           MaterialPageRoute(
  //                                               builder: (context) =>
  //                                                   Quiz_Screen()));
  //                                     },
  //                                     child: Row(
  //                                       mainAxisAlignment:
  //                                           MainAxisAlignment.center,
  //                                       children: [
  //                                         Container(
  //                                           height: 15,
  //                                           width: 15,
  //                                           margin: const EdgeInsets.all(12),
  //                                           decoration: const BoxDecoration(
  //                                             color: Colors.white,
  //                                             image: DecorationImage(
  //                                               image: AssetImage(
  //                                                   "assets/images/try again.png"),
  //                                               fit: BoxFit.contain,
  //                                             ),
  //                                           ),
  //                                         ),
  //                                         const Text(
  //                                           "Take Quiz Again    ",
  //                                           style: TextStyle(
  //                                               color: Color(0xff2474B9),
  //                                               fontSize: 18,
  //                                               fontWeight: FontWeight.bold),
  //                                         ),
  //                                       ],
  //                                     ),
  //                                   )
  //                                 ],
  //                               ),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                   const SizedBox(
  //                     height: 30,
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //     //       Positioned(
  //     //         top: 0.0,
  //     //         left: 10.0,
  //     //         right: 0.0,
  //     //         child: AppBar(
  //     //           title: const Text(''), // You can add title here
  //     //           leading: IconButton(
  //     //             icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
  //     //             onPressed: () => {
  //     //               clear(),
  //     //               Navigator.of(context).pop(),
  //     // Navigator.push(context,
  //     // MaterialPageRoute(builder: (context) => BannerScreen())),
  //     //             },
  //     //           ),
  //     //           backgroundColor:
  //     //               Colors.transparent, //You can make this transparent
  //     //           elevation: 0.0, //No shadow
  //     //         ),
  //     //       ),
  //           Positioned(
  //             top: 20.0,
  //             right: 30.0,
  //             child: InkWell(
  //               onTap: () {
  //                 clear();
  //                 Navigator.of(context).pop();
  //                 // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
  //                 //     builder: (context) => ZoneHomeScreen()), (Route<dynamic> route) => false);
  //
  //                 Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                     // builder: (context) => ChessGame()),
  //                       builder: (context) => ZoneHomeScreen()),
  //                 );
  //               },
  //               child: Container(
  //                 margin: const EdgeInsets.all(10),
  //                 height: 100,
  //                 width: 40,
  //                 decoration: const BoxDecoration(
  //                   image: DecorationImage(
  //                     image: AssetImage(
  //                         "assets/games/Home Icon.png"),
  //                     fit: BoxFit.contain,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //
  //
  //         ],
  //         // child: Container(
  //         //   width: MediaQuery.of(context).size.width,
  //         //   height: MediaQuery.of(context).size.height,
  //         //   decoration: const BoxDecoration(
  //         //     image: DecorationImage(
  //         //       image: AssetImage("assets/images/Background.png"),
  //         //       fit: BoxFit.fill,
  //         //     ),
  //         //   ),
  //         //   child: SingleChildScrollView(
  //         //     child: Column(
  //         //       children: [
  //         //
  //         //         SizedBox(
  //         //           height: 50,
  //         //         ),
  //         //
  //         //         Container(
  //         //           height: 70,
  //         //           width: 140,
  //         //           decoration: const BoxDecoration(
  //         //             color: Colors.white,
  //         //             borderRadius: BorderRadius.only(
  //         //                 topRight: Radius.circular(15.0),
  //         //                 bottomRight: Radius.circular(15.0),
  //         //                 topLeft: Radius.circular(15.0),
  //         //                 bottomLeft: Radius.circular(15.0)),
  //         //           ),
  //         //           child: Container(
  //         //             height: 50,
  //         //             width: 100,
  //         //             margin: const EdgeInsets.all(12),
  //         //             decoration: const BoxDecoration(
  //         //               color: Colors.white,
  //         //               image: DecorationImage(
  //         //                 image: AssetImage("assets/images/site-logo.png"),
  //         //                 fit: BoxFit.contain,
  //         //               ),
  //         //             ),
  //         //             child: null,
  //         //           ),
  //         //         ),
  //         //
  //         //         SizedBox(
  //         //           height: 50,
  //         //         ),
  //         //
  //         //         Container(
  //         //           //height: 350,
  //         //           width: 350,
  //         //           decoration: const BoxDecoration(
  //         //             color: Colors.white,
  //         //             borderRadius: BorderRadius.only(
  //         //                 topRight: Radius.circular(15.0),
  //         //                 bottomRight: Radius.circular(15.0),
  //         //                 topLeft: Radius.circular(15.0),
  //         //                 bottomLeft: Radius.circular(15.0)),
  //         //           ),
  //         //           child: Expanded(
  //         //             child: Column(
  //         //               children: [
  //         //                 Row(
  //         //                   children: [
  //         //                     Container(
  //         //                       margin: EdgeInsets.all(10),
  //         //                       height: 35,
  //         //                       width: 35,
  //         //                       decoration: const BoxDecoration(
  //         //                         image: DecorationImage(
  //         //                           image: AssetImage("assets/icon/fun facts ic.png"),
  //         //                           fit: BoxFit.fill,
  //         //                         ),
  //         //                       ),
  //         //                     ),
  //         //                     Container(
  //         //                       height: 40,
  //         //                       width: 90,
  //         //                       child: Center(
  //         //                         child: Text(
  //         //                           "Fun Facts",
  //         //                           style: TextStyle(fontSize: 18, color: Colors.blue,fontWeight: FontWeight.bold),
  //         //                         ),
  //         //                       ),
  //         //                     ),
  //         //                     Spacer(),
  //         //                     Container(
  //         //                       height: 35,
  //         //                       width: 35,
  //         //                       margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
  //         //                       decoration: const BoxDecoration(
  //         //                         image: DecorationImage(
  //         //                           image: AssetImage("assets/icon/close.png"),
  //         //                           fit: BoxFit.fill,
  //         //                         ),
  //         //                       ),
  //         //                     ),
  //         //                   ],
  //         //                 ),
  //         //
  //         //                 Padding(
  //         //                   padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
  //         //                   child: const Divider(
  //         //
  //         //                     color: Colors.black45,
  //         //                     height: 0.5,
  //         //                   ),
  //         //                 ),
  //         //
  //         //                 Container(
  //         //                   //height: 150,
  //         //                   width: MediaQuery.of(context).size.width,
  //         //                   margin: EdgeInsets.all(20),
  //         //                   decoration: const BoxDecoration(
  //         //                     color: Colors.white,
  //         //                     image: DecorationImage(
  //         //                       image: AssetImage("assets/icon/Background.png"),
  //         //                       fit: BoxFit.fill,
  //         //                     ),
  //         //                   ),
  //         //                   child: Container(
  //         //                     //height: 130,
  //         //                     width: 220,
  //         //                     margin: EdgeInsets.all(30),
  //         //                     padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
  //         //                     child: Center(
  //         //                       child: Text(
  //         //                         "•	The word 'insurance' is derived from the French word 'ensurer' and originally meant an 'engagement to marry'.",
  //         //                         style: TextStyle(fontSize: 18, color: Colors.blue),
  //         //                       ),
  //         //                     ),
  //         //                   ),
  //         //                 ),
  //         //
  //         //                 SizedBox(height: 10),
  //         //
  //         //                 Row(
  //         //                   children: [
  //         //                     Container(
  //         //                       margin: EdgeInsets.fromLTRB(20,0,0,0),
  //         //                       height: 45,
  //         //                       width: 100,
  //         //                       decoration: const BoxDecoration(
  //         //                         image: DecorationImage(
  //         //                           image: AssetImage("assets/icon/Previous.png"),
  //         //                           fit: BoxFit.fill,
  //         //                         ),
  //         //                       ),
  //         //                     ),
  //         //                     Spacer(),
  //         //                     Container(
  //         //                       margin: EdgeInsets.fromLTRB(0,0,20,0),
  //         //                       height: 45,
  //         //                       width: 100,
  //         //                       decoration: const BoxDecoration(
  //         //                         image: DecorationImage(
  //         //                           image: AssetImage("assets/icon/Next.png"),
  //         //                           fit: BoxFit.fill,
  //         //                         ),
  //         //                       ),
  //         //                     ),
  //         //                   ],
  //         //                 ),
  //         //
  //         //                 SizedBox(height: 20),
  //         //
  //         //               ],
  //         //             ),
  //         //           ),
  //         //         )
  //         //       ],
  //         //     ),
  //         //   ),
  //         // ),
  //       ),
  //     ),
  //   );
  // }

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

    // prefs.remove('StateData');
    // prefs.remove('DistrictData');
    // prefs.remove('SchoolData');
    // prefs.remove('Top10Data');
    // prefs.remove('last');
    // prefs.remove('token');
    // prefs.remove('allData');
    // prefs.remove('complete');
    // prefs.remove('DataOnly');
    // prefs.remove('chatSound');
    // prefs.remove('email_token');
    prefs.clear();
  }

}
