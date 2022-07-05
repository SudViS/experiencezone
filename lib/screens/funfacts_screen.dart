import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_6.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:io' show Platform;

import '../utils/light_color.dart';
import 'banner_screen.dart';
import 'zonehome_screen.dart';

class Facts {
  late String title;
  late String description;

  Facts(this.title, this.description);
}

class FunFacts_Screen extends StatefulWidget {
  const FunFacts_Screen({Key? key}) : super(key: key);

  @override
  State<FunFacts_Screen> createState() => _FunFacts_ScreenState();
}

class _FunFacts_ScreenState extends State<FunFacts_Screen> {
  List<Facts> factsList = [
    Facts(
      "The word 'insurance' is derived from the French word 'ensurer' and originally meant an 'engagement to marry'.",
      "",
    ),
    Facts(
      "Starbucks pays more for employee health insurance than it pays for coffee.",
      "",
    ),
    Facts(
      "An insurance policy exists for death by excessive laughter.",
      "During the early 19th century, movie-goers were so scared of dying due to excessive laughter that they bought insurance through Lloyd’s of London.",
    ),
    Facts("The very first insurance contract was signed in 1347. ",
        "Although the concept of insurance can be traced back to ancient civilizations, the first known insurance contract was signed in 1347 in Genoa, Italy."),
    Facts(
      "The phenomenon of insuring body parts started in 1920.",
      "Silent movie star Ben Turpin began the trend of insuring body parts in 1920 when he bought a \$25,000 policy through Lloyd’s of London in case his signature crossed eyes ever uncrossed.",
    ),
    Facts(
        "According to Guinness Book of Records, the famous Irish dancer's legs, of Michael Flatley, were insured for 25 million dollars.",
        ""),
    Facts(
        "The most expensive insurance policy in the world belongs to the American director Steven Spielberg, his life was insured for '\$' 1.2 billion.",
        ""),
    Facts(
        "South African actress Kerry Mrs. Wellis, forced for shootings in the film 'Star Treck' to have a shaved bald haircut, and insured against the fact that her hair after this procedure will not grow.",
        ""),
    Facts(
        "A superstar (Rajnikant) from India has insured and copyrighted his voice. So, for anyone planning to mimic him; I just want you to stop right there. You do not want your big money going mate!",
        ""),
    Facts(
        "In 2003,Pepsi ran a campaign with the name of sweetcakes;the winning price was 1\$ billion. But later people know they had filled insurance for 10\$ million in case someone actually wins it.",
        ""),
    Facts(
      "No insurance company will underwrite Jackie Chan’s productions.",
      "In which he performs all his own stunts. After a number of stuntmen were injured during the making of Police Story, the star formed the Jackie Chan Stuntmen Association, training the stuntmen personally and paying for their medical bills out of his own pocket.",
    ),
    Facts(
      "An insurance company offered a cash reward to anyone who could capture the Loch Ness monster.",
      "In 1971, whiskey manufacturer Cutty Sark offered an award of one million pounds (\$2.4 million) to anyone who could capture the Loch Ness Monster.",
    ),
    Facts(
      "Astronauts aboard Apollo 11 did not get life insurance.",
      "It's a dangerous job, flying a quarter-million miles to the moon for the first time. The Apollo 11 astronauts couldn't get life insurance they could afford. So, they signed a bunch of postcards. A friend took them to the post office and had them all postmarked with key dates, such as the launch on July 16 or landing on July 20. If the astronauts somehow did not safely return, those postcards would become collector’s items that could be sold, with the money going to benefit their families.",
    ),
    Facts(
      "Taco bell once purchased taco insurance.",
      "When the Mir space station was intended to crash somewhere in the South Pacific Ocean in 2001, fast-food chain Taco Bell promised to provide everyone in America a free taco if the space station crashed within a tiny designated perimeter in the Pacific Ocean.",
    ),
    Facts(
      "Valentine Insurance.",
      "Now I would call it lovey-dovey insurance which ensures that you are not left out on a valentine’s Day. The valentine insurance concept is the brainchild of insurers of Japan.",
    ),
    Facts(
        "First Insurance Company Oriental Insurance Company started by Anita Bhavsar in Kolkata. It is established in 1818.",
        ""),
    Facts(
        "First Indian insurer is Bombay Mutual Life Assurance Society. It is started in 1870.",
        ""),
    Facts("Nearly  80% of Indian population is without life insurance cover.",
        ""),
  ];

  // late List<String> facts = [
  //   "The word 'insurance' is derived from the French word 'ensurer' and originally meant an 'engagement to marry'.",
  //   "Starbucks pays more for employee health insurance than it pays for coffee.",
  //   "An insurance policy exists for death by excessive laughter. \n (During the early 19th century, movie-goers were so scared of dying due to excessive laughter that they bought insurance through Lloyd’s of London.)",
  //   "The very first insurance contract was signed in 1347. \n (Although the concept of insurance can be traced back to ancient civilizations, the first known insurance contract was signed in 1347 in Genoa, Italy.)",
  //   "The phenomenon of insuring body parts started in 1920. \n (Silent movie star Ben Turpin began the trend of insuring body parts in 1920 when he bought a \$25,000 policy through Lloyd’s of London in case his signature crossed eyes ever uncrossed.)",
  //   "According to Guinness Book of Records, the famous Irish dancer's legs, of Michael Flatley, were insured for 25 million dollars.",
  //   "The most expensive insurance policy in the world belongs to the American director Steven Spielberg, his life was insured for '\$' 1.2 billion.",
  //   "South African actress Kerry Mrs. Wellis, forced for shootings in the film 'Star Treck' to have a shaved bald haircut, and insured against the fact that her hair after this procedure will not grow.",
  //   "A superstar (Rajnikant) from India has insured and copyrighted his voice. So, for anyone planning to mimic him; I just want you to stop right there. You do not want your big money going mate!",
  //   "In 2003,Pepsi ran a campaign with the name of sweetcakes;the winning price was 1\$ billion. But later people know they had filled insurance for 10\$ million in case someone actually wins it.",
  //   "No insurance company will underwrite Jackie Chan’s productions. \n ( in which he performs all his own stunts. After a number of stuntmen were injured during the making of Police Story, the star formed the Jackie Chan Stuntmen Association, training the stuntmen personally and paying for their medical bills out of his own pocket.)",
  //   "An insurance company offered a cash reward to anyone who could capture the Loch Ness monster. \n (In 1971, whiskey manufacturer Cutty Sark offered an award of one million pounds (\$2.4 million) to anyone who could capture the Loch Ness Monster.)",
  //   "Astronauts aboard Apollo 11 did not get life insurance. \n (It's a dangerous job, flying a quarter-million miles to the moon for the first time. The Apollo 11 astronauts couldn't get life insurance they could afford. So, they signed a bunch of postcards. A friend took them to the post office and had them all postmarked with key dates, such as the launch on July 16 or landing on July 20. If the astronauts somehow did not safely return, those postcards would become collector’s items that could be sold, with the money going to benefit their families.)",
  //   "Taco bell once purchased taco insurance. \n(When the Mir space station was intended to crash somewhere in the South Pacific Ocean in 2001, fast-food chain Taco Bell promised to provide everyone in America a free taco if the space station crashed within a tiny designated perimeter in the Pacific Ocean.)",
  //   "Valentine Insurance. \n(Now I would call it lovey-dovey insurance which ensures that you are not left out on a valentine’s Day. The valentine insurance concept is the brainchild of insurers of Japan.)",
  //   "First Insurance Company Oriental Insurance Company started by Anita Bhavsar in Kolkata. It is established in 1818.",
  //   "First Indian insurer is Bombay Mutual Life Assurance Society. It is started in 1870."
  //       "Nearly  80% of Indian population is without life insurance cover."
  // ];

  late int index = 0;
  late Facts factString = factsList[0];

  late Timer _timer;
  int _start = 300; // 5 minute

  void startTimer() {
    _start = 300;
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            _timer.cancel();
            timer.cancel();
          });

          showSnackBar("5 Minute Limit Over");
          clear();
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => BannerScreen()));

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
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double height_size = MediaQuery.of(context).size.height;
    final double width_size = MediaQuery.of(context).size.width;
    //print(height_size.toString() + " * " + width_size.toString());
    print("FunFacts Screen");

    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.landscapeLeft,
    //   DeviceOrientation.landscapeRight,
    // ]);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        // body: Stack(
        //   children: [
        //     width_size < 900
        //         ? Container(
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
        //                     height: 100,
        //                   ),
        //                   // // Container(
        //                   // //   height: 70,
        //                   // //   width: 160,
        //                   // //   decoration: const BoxDecoration(
        //                   // //     color: Colors.white,
        //                   // //     borderRadius: BorderRadius.only(
        //                   // //         topRight: Radius.circular(15.0),
        //                   // //         bottomRight: Radius.circular(15.0),
        //                   // //         topLeft: Radius.circular(15.0),
        //                   // //         bottomLeft: Radius.circular(15.0)),
        //                   // //   ),
        //                   // //   child: Container(
        //                   // //     height: 50,
        //                   // //     width: 100,
        //                   // //     margin: const EdgeInsets.all(12),
        //                   // //     decoration: const BoxDecoration(
        //                   // //       color: Colors.white,
        //                   // //       image: DecorationImage(
        //                   // //         image:
        //                   // //             AssetImage("assets/images/site-logo.png"),
        //                   // //         fit: BoxFit.contain,
        //                   // //       ),
        //                   // //     ),
        //                   // //     child: null,
        //                   // //   ),
        //                   // // ),
        //                   // Padding(
        //                   //   padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
        //                   //   child: Row(
        //                   //     mainAxisAlignment: MainAxisAlignment.center,
        //                   //     children: [
        //                   //       Container(
        //                   //         // height: 70,
        //                   //         // width: 160,
        //                   //         padding: const EdgeInsets.all(14),
        //                   //         decoration: const BoxDecoration(
        //                   //           color: Colors.white,
        //                   //           borderRadius: BorderRadius.only(
        //                   //               topRight: Radius.circular(15.0),
        //                   //               bottomRight: Radius.circular(15.0),
        //                   //               topLeft: Radius.circular(15.0),
        //                   //               bottomLeft: Radius.circular(15.0)),
        //                   //         ),
        //                   //         child: Container(
        //                   //           // height: 50,
        //                   //           // width: 100,
        //                   //           padding: const EdgeInsets.fromLTRB(60,20,60,20),
        //                   //           decoration: const BoxDecoration(
        //                   //             color: Colors.white,
        //                   //             image: DecorationImage(
        //                   //               image:
        //                   //               AssetImage("assets/images/site-logo.png"),
        //                   //               fit: BoxFit.contain,
        //                   //             ),
        //                   //           ),
        //                   //           child: null,
        //                   //         ),
        //                   //       ),
        //                   //     ],
        //                   //   ),
        //                   // ),
        //                   const SizedBox(
        //                     height: 50,
        //                   ),
        //                   SingleChildScrollView(
        //                     child: Container(
        //                       //height: 350,
        //                       //width: 450,
        //                       margin: EdgeInsets.fromLTRB(40, 0, 40, 0),
        //                       //width: MediaQuery.of(context).size.width - 100,
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
        //                                 height: 35,
        //                                 width: 35,
        //                                 decoration: const BoxDecoration(
        //                                   image: DecorationImage(
        //                                     image: AssetImage(
        //                                         "assets/icon/fun facts ic.png"),
        //                                     fit: BoxFit.fill,
        //                                   ),
        //                                 ),
        //                               ),
        //                               Container(
        //                                 height: 40,
        //                                 //width: 90,
        //                                 margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
        //                                 child: Center(
        //                                   child: Text(
        //                                     "Fun Facts",
        //                                     style: TextStyle(
        //                                         fontSize: 20,
        //                                         color: Colors.blue.shade800,
        //                                         fontWeight: FontWeight.bold),
        //                                   ),
        //                                 ),
        //                               ),
        //                               const Spacer(),
        //                               InkWell(
        //                                 onTap: () {
        //                                   Navigator.of(context).pop();
        //                                 },
        //                                 child: Container(
        //                                   height: 35,
        //                                   width: 35,
        //                                   margin:
        //                                       EdgeInsets.fromLTRB(0, 0, 10, 0),
        //                                   decoration: const BoxDecoration(
        //                                     image: DecorationImage(
        //                                       image: AssetImage(
        //                                           "assets/icon/close.png"),
        //                                       fit: BoxFit.fill,
        //                                     ),
        //                                   ),
        //                                 ),
        //                               ),
        //                             ],
        //                           ),
        //
        //                           const Padding(
        //                             padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
        //                             child: Divider(
        //                               color: Colors.black45,
        //                               height: 0.5,
        //                             ),
        //                           ),
        //
        //                           Container(
        //                             margin: const EdgeInsets.all(20),
        //                             child: ChatBubble(
        //                               clipper: ChatBubbleClipper6(
        //                                   type: BubbleType.sendBubble),
        //                               alignment: Alignment.topRight,
        //                               margin: const EdgeInsets.only(top: 20),
        //                               //backGroundColor: Colors.blue.shade800,
        //                               backGroundColor: Color(0xff0F5A93),
        //                               child: Container(
        //                                 // constraints: BoxConstraints(
        //                                 //   maxWidth: MediaQuery.of(context).size.width * 0.7,
        //                                 // ),
        //                                 width: MediaQuery.of(context).size.width,
        //                                 child: Container(
        //                                   margin: const EdgeInsets.all(10),
        //                                   padding: const EdgeInsets.fromLTRB(
        //                                       0, 0, 0, 0),
        //                                   child: Column(
        //                                     children: [
        //                                       Center(
        //                                         child: Text(
        //                                           factString.title,
        //                                           //" The word 'insurance' is derived from the French word 'ensurer' and originally meant an 'engagement to marry'.",
        //                                           style: TextStyle(
        //                                               fontSize: 18,
        //                                               //color: Colors.blue.shade800,
        //                                               color: Colors.white,
        //                                               fontWeight:
        //                                                   FontWeight.w600),
        //                                         ),
        //                                       ),
        //                                       Container(
        //                                         padding: EdgeInsets.fromLTRB(
        //                                             10, 10, 0, 0),
        //                                         child: Center(
        //                                           child: Text(
        //                                             "   " +
        //                                                 factString.description,
        //                                             //" The word 'insurance' is derived from the French word 'ensurer' and originally meant an 'engagement to marry'.",
        //                                             style: TextStyle(
        //                                                 fontSize: 14,
        //                                                 color: Colors.white,
        //                                                 fontWeight:
        //                                                     FontWeight.w400),
        //                                           ),
        //                                         ),
        //                                       ),
        //                                     ],
        //                                   ),
        //                                 ),
        //                               ),
        //                             ),
        //                           ),
        //
        //                           // Container(
        //                           //   //height: 150,
        //                           //   width: MediaQuery.of(context).size.width,
        //                           //   margin: const EdgeInsets.all(20),
        //                           //   decoration: const BoxDecoration(
        //                           //     color: Colors.white,
        //                           //     image: DecorationImage(
        //                           //       image: AssetImage(
        //                           //           "assets/icon/Background.png"),
        //                           //       fit: BoxFit.fill,
        //                           //     ),
        //                           //   ),
        //                           //   child: Container(
        //                           //     margin: const EdgeInsets.all(30),
        //                           //     padding:
        //                           //         const EdgeInsets.fromLTRB(0, 0, 0, 70),
        //                           //     child: Column(
        //                           //       children: [
        //                           //         Center(
        //                           //           child: Text(
        //                           //             factString.title,
        //                           //             //" The word 'insurance' is derived from the French word 'ensurer' and originally meant an 'engagement to marry'.",
        //                           //             style: TextStyle(
        //                           //                 fontSize: 18,
        //                           //                 color: Colors.blue.shade800,
        //                           //                 fontWeight: FontWeight.w600),
        //                           //           ),
        //                           //         ),
        //                           //         Container(
        //                           //           padding:
        //                           //               EdgeInsets.fromLTRB(20, 20, 0, 0),
        //                           //           child: Center(
        //                           //             child: Text(
        //                           //               "   " + factString.description,
        //                           //               //" The word 'insurance' is derived from the French word 'ensurer' and originally meant an 'engagement to marry'.",
        //                           //               style: TextStyle(
        //                           //                   fontSize: 14,
        //                           //                   color: Colors.blue.shade800,
        //                           //                   fontWeight: FontWeight.w400),
        //                           //             ),
        //                           //           ),
        //                           //         ),
        //                           //       ],
        //                           //     ),
        //                           //   ),
        //                           // ),
        //
        //                           const SizedBox(height: 10),
        //
        //                           // Row(
        //                           //   children: [
        //                           //     index != 0
        //                           //         ? InkWell(
        //                           //             onTap: () {
        //                           //               getFactText(false);
        //                           //             },
        //                           //             child: Container(
        //                           //               margin: const EdgeInsets.fromLTRB(
        //                           //                   20, 0, 0, 0),
        //                           //               height: 45,
        //                           //               width: 100,
        //                           //               decoration: const BoxDecoration(
        //                           //                 image: DecorationImage(
        //                           //                   image: AssetImage(
        //                           //                       "assets/icon/Previous.png"),
        //                           //                   fit: BoxFit.fill,
        //                           //                 ),
        //                           //               ),
        //                           //             ),
        //                           //           )
        //                           //         : Container(
        //                           //             margin: const EdgeInsets.fromLTRB(
        //                           //                 20, 0, 0, 0),
        //                           //             height: 45,
        //                           //             width: 100,
        //                           //           ),
        //                           //     const Spacer(),
        //                           //     InkWell(
        //                           //       onTap: () {
        //                           //         getFactText(true);
        //                           //       },
        //                           //       child: Container(
        //                           //         margin:
        //                           //             const EdgeInsets.fromLTRB(0, 0, 20, 0),
        //                           //         height: 45,
        //                           //         width: 100,
        //                           //         decoration: const BoxDecoration(
        //                           //           image: DecorationImage(
        //                           //             image: AssetImage("assets/icon/Next.png"),
        //                           //             fit: BoxFit.fill,
        //                           //           ),
        //                           //         ),
        //                           //       ),
        //                           //     ),
        //                           //   ],
        //                           // ),
        //
        //                           Row(
        //                             children: [
        //                               index != 0
        //                                   ? Padding(
        //                                       padding: const EdgeInsets.fromLTRB(
        //                                           30, 0, 0, 0),
        //                                       child: Container(
        //                                         height: 45,
        //                                         width: 120,
        //                                         // child: OutlineButton(
        //                                         //   shape: RoundedRectangleBorder(
        //                                         //       borderRadius:
        //                                         //           BorderRadius.circular(
        //                                         //               15.0)),
        //                                         //   child: const Text(
        //                                         //     "Previous",
        //                                         //     style: TextStyle(
        //                                         //       fontSize: 16,
        //                                         //       fontWeight: FontWeight.bold,
        //                                         //       color: Color(0xff0F5A93),
        //                                         //     ),
        //                                         //   ),
        //                                         //   borderSide: const BorderSide(
        //                                         //     width: 2,
        //                                         //     color: Color(0xff0F5A93),
        //                                         //   ),
        //                                         //   onPressed: () {
        //                                         //     index > 0
        //                                         //         ? getFactText(false)
        //                                         //         : Container();
        //                                         //   },
        //                                         // ),
        //
        //                                         child: OutlinedButton(
        //                                           style: OutlinedButton.styleFrom(
        //                                             shape: RoundedRectangleBorder(
        //                                                 borderRadius:
        //                                                     BorderRadius.circular(
        //                                                         15.0)),
        //                                             side: const BorderSide(
        //                                               width: 2,
        //                                               color: Color(0xff0F5A93),
        //                                             ),
        //                                           ),
        //                                           child: const Text(
        //                                             "Previous",
        //                                             style: TextStyle(
        //                                               fontSize: 16,
        //                                               fontWeight: FontWeight.bold,
        //                                               color: Color(0xff0F5A93),
        //                                             ),
        //                                           ),
        //                                           onPressed: () {
        //                                             index > 0
        //                                                 ? getFactText(false)
        //                                                 : Container();
        //                                           },
        //                                         ),
        //                                       ),
        //                                     )
        //                                   : Container(
        //                                       margin: const EdgeInsets.fromLTRB(
        //                                           20, 0, 0, 0),
        //                                       height: 45,
        //                                       width: 100,
        //                                     ),
        //                               const Spacer(),
        //                               Padding(
        //                                 padding: const EdgeInsets.fromLTRB(
        //                                     0, 0, 30, 0),
        //                                 child: Container(
        //                                   height: 45,
        //                                   width: 120,
        //                                   decoration: const BoxDecoration(
        //                                     color: Color(0xff0F5A93),
        //                                     borderRadius: BorderRadius.only(
        //                                         topRight: Radius.circular(15.0),
        //                                         bottomRight:
        //                                             Radius.circular(15.0),
        //                                         topLeft: Radius.circular(15.0),
        //                                         bottomLeft:
        //                                             Radius.circular(15.0)),
        //                                   ),
        //                                   child: TextButton(
        //                                     style: TextButton.styleFrom(
        //                                       primary: const Color(0xff0F5A93),
        //                                     ),
        //                                     onPressed: () {
        //                                       factString = factsList[index];
        //                                       factsList.length - 1 != index
        //                                           ? getFactText(true)
        //                                           : Navigator.of(context).pop();
        //                                     },
        //                                     child: Text(
        //                                       factsList.length - 1 != index
        //                                           ? 'Next'
        //                                           : 'Finish',
        //                                       style: const TextStyle(
        //                                         fontSize: 16,
        //                                         fontWeight: FontWeight.bold,
        //                                         color: Colors.white,
        //                                       ),
        //                                       // style:
        //                                       //     const TextStyle(color: Colors.white),
        //                                     ),
        //                                   ),
        //                                 ),
        //                               ),
        //                             ],
        //                           ),
        //
        //                           const SizedBox(height: 20),
        //                         ],
        //                       ),
        //                     ),
        //                   )
        //                 ],
        //               ),
        //             ),
        //           )
        //         : Container(
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
        //
        //                   // Padding(
        //                   //   padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
        //                   //   child: Row(
        //                   //     mainAxisAlignment: MainAxisAlignment.center,
        //                   //     children: [
        //                   //       Container(
        //                   //         // height: 70,
        //                   //         // width: 160,
        //                   //         padding: const EdgeInsets.all(14),
        //                   //         decoration: const BoxDecoration(
        //                   //           color: Colors.white,
        //                   //           borderRadius: BorderRadius.only(
        //                   //               topRight: Radius.circular(15.0),
        //                   //               bottomRight: Radius.circular(15.0),
        //                   //               topLeft: Radius.circular(15.0),
        //                   //               bottomLeft: Radius.circular(15.0)),
        //                   //         ),
        //                   //         child: Container(
        //                   //           // height: 50,
        //                   //           // width: 100,
        //                   //           padding:
        //                   //               const EdgeInsets.fromLTRB(60, 20, 60, 20),
        //                   //           decoration: const BoxDecoration(
        //                   //             color: Colors.white,
        //                   //             image: DecorationImage(
        //                   //               image: AssetImage(
        //                   //                   "assets/images/site-logo.png"),
        //                   //               fit: BoxFit.contain,
        //                   //             ),
        //                   //           ),
        //                   //           child: null,
        //                   //         ),
        //                   //       ),
        //                   //     ],
        //                   //   ),
        //                   // ),
        //
        //                   // Container(
        //                   //   height: 70,
        //                   //   width: 140,
        //                   //   decoration: const BoxDecoration(
        //                   //     color: Colors.white,
        //                   //     borderRadius: BorderRadius.only(
        //                   //         topRight: Radius.circular(15.0),
        //                   //         bottomRight: Radius.circular(15.0),
        //                   //         topLeft: Radius.circular(15.0),
        //                   //         bottomLeft: Radius.circular(15.0)),
        //                   //   ),
        //                   //   child: Container(
        //                   //     height: 50,
        //                   //     width: 100,
        //                   //     margin: const EdgeInsets.all(12),
        //                   //     decoration: const BoxDecoration(
        //                   //       color: Colors.white,
        //                   //       image: DecorationImage(
        //                   //         image:
        //                   //             AssetImage("assets/images/site-logo.png"),
        //                   //         fit: BoxFit.contain,
        //                   //       ),
        //                   //     ),
        //                   //     child: null,
        //                   //   ),
        //                   // ),
        //
        //                   const SizedBox(
        //                     height: 100,
        //                   ),
        //
        //                   SingleChildScrollView(
        //                     child: Container(
        //                       //height: 350,
        //                       //width: 450,
        //                       margin: EdgeInsets.fromLTRB(140, 40, 140, 0),
        //                       //width: MediaQuery.of(context).size.width - 100,
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
        //                                 height: 35,
        //                                 width: 35,
        //                                 decoration: const BoxDecoration(
        //                                   image: DecorationImage(
        //                                     image: AssetImage(
        //                                         "assets/icon/fun facts ic.png"),
        //                                     fit: BoxFit.fill,
        //                                   ),
        //                                 ),
        //                               ),
        //                               Container(
        //                                 height: 40,
        //                                 width: 90,
        //                                 child: Center(
        //                                   child: Text(
        //                                     "Fun Facts",
        //                                     style: TextStyle(
        //                                         fontSize: 18,
        //                                         color: Colors.blue.shade800,
        //                                         fontWeight: FontWeight.bold),
        //                                   ),
        //                                 ),
        //                               ),
        //                               const Spacer(),
        //                               InkWell(
        //                                 onTap: () {
        //                                   Navigator.of(context).pop();
        //                                 },
        //                                 child: Container(
        //                                   height: 35,
        //                                   width: 35,
        //                                   margin:
        //                                       EdgeInsets.fromLTRB(0, 0, 10, 0),
        //                                   decoration: const BoxDecoration(
        //                                     image: DecorationImage(
        //                                       image: AssetImage(
        //                                           "assets/icon/close.png"),
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
        //                             margin: const EdgeInsets.all(20),
        //                             child: ChatBubble(
        //                               clipper: ChatBubbleClipper6(
        //                                   type: BubbleType.sendBubble),
        //                               alignment: Alignment.topRight,
        //                               margin: const EdgeInsets.only(top: 20),
        //                               //backGroundColor: Colors.yellow.shade500,
        //                               //backGroundColor: Colors.blue.shade800,
        //                               backGroundColor: Color(0xff0F5A93),
        //                               child: Container(
        //                                 // constraints: BoxConstraints(
        //                                 //   maxWidth: MediaQuery.of(context).size.width * 0.7,
        //                                 // ),
        //                                 width: MediaQuery.of(context).size.width,
        //                                 child: Container(
        //                                   margin: const EdgeInsets.all(10),
        //                                   padding:
        //                                       EdgeInsets.fromLTRB(0, 0, 0, 0),
        //                                   child: Column(
        //                                     children: [
        //                                       Center(
        //                                         child: Text(
        //                                           factString.title,
        //                                           //" The word 'insurance' is derived from the French word 'ensurer' and originally meant an 'engagement to marry'.",
        //                                           style: TextStyle(
        //                                               fontSize: 18,
        //                                               //color: Colors.blue.shade800,
        //                                               color: Colors.white,
        //                                               fontWeight:
        //                                                   FontWeight.w600),
        //                                         ),
        //                                       ),
        //                                       Container(
        //                                         padding: EdgeInsets.fromLTRB(
        //                                             10, 10, 0, 0),
        //                                         child: Center(
        //                                           child: Text(
        //                                             "   " +
        //                                                 factString.description,
        //                                             //" The word 'insurance' is derived from the French word 'ensurer' and originally meant an 'engagement to marry'.",
        //                                             style: TextStyle(
        //                                                 fontSize: 14,
        //                                                 //color: Colors.blue.shade800,
        //                                                 color: Colors.white,
        //                                                 fontWeight:
        //                                                     FontWeight.w400),
        //                                           ),
        //                                         ),
        //                                       ),
        //                                     ],
        //                                   ),
        //                                 ),
        //                               ),
        //                             ),
        //                           ),
        //                           const SizedBox(height: 10),
        //                           Row(
        //                             children: [
        //                               index != 0
        //                                   ? Padding(
        //                                       padding: const EdgeInsets.fromLTRB(
        //                                           30, 0, 0, 0),
        //                                       child: Container(
        //                                         height: 45,
        //                                         width: 120,
        //                                         child: OutlinedButton(
        //                                           style: OutlinedButton.styleFrom(
        //                                             shape: RoundedRectangleBorder(
        //                                                 borderRadius:
        //                                                     BorderRadius.circular(
        //                                                         15.0)),
        //                                             side: const BorderSide(
        //                                               width: 2,
        //                                               color: Color(0xff0F5A93),
        //                                             ),
        //                                           ),
        //                                           child: const Text(
        //                                             "Previous",
        //                                             style: TextStyle(
        //                                               fontSize: 16,
        //                                               fontWeight: FontWeight.bold,
        //                                               color: Color(0xff0F5A93),
        //                                             ),
        //                                           ),
        //                                           onPressed: () {
        //                                             restartTime();
        //                                             index > 0
        //                                                 ? getFactText(false)
        //                                                 : Container();
        //                                           },
        //                                         ),
        //                                       ),
        //                                     )
        //                                   : Container(
        //                                       margin: const EdgeInsets.fromLTRB(
        //                                           20, 0, 0, 0),
        //                                       height: 45,
        //                                       width: 100,
        //                                     ),
        //                               const Spacer(),
        //                               Padding(
        //                                 padding: const EdgeInsets.fromLTRB(
        //                                     0, 0, 30, 0),
        //                                 child: Container(
        //                                   height: 45,
        //                                   width: 120,
        //                                   decoration: const BoxDecoration(
        //                                     color: Color(0xff0F5A93),
        //                                     borderRadius: BorderRadius.only(
        //                                         topRight: Radius.circular(15.0),
        //                                         bottomRight:
        //                                             Radius.circular(15.0),
        //                                         topLeft: Radius.circular(15.0),
        //                                         bottomLeft:
        //                                             Radius.circular(15.0)),
        //                                   ),
        //                                   child: TextButton(
        //                                     style: TextButton.styleFrom(
        //                                       primary: const Color(0xff0F5A93),
        //                                     ),
        //                                     onPressed: () {
        //
        //                                       restartTime();
        //                                       factString = factsList[index];
        //                                       factsList.length - 1 != index
        //                                           ? getFactText(true)
        //                                           : Navigator.of(context).pop();
        //                                     },
        //                                     child: Text(
        //                                       factsList.length - 1 != index
        //                                           ? 'Next'
        //                                           : 'Finish',
        //                                       style: const TextStyle(
        //                                         fontSize: 16,
        //                                         fontWeight: FontWeight.bold,
        //                                         color: Colors.white,
        //                                       ),
        //                                       // style:
        //                                       //     const TextStyle(color: Colors.white),
        //                                     ),
        //                                   ),
        //                                 ),
        //                               ),
        //                             ],
        //                           ),
        //                           const SizedBox(height: 20),
        //                         ],
        //                       ),
        //                     ),
        //                   )
        //                 ],
        //               ),
        //             ),
        //           ),
        //
        //     TargetPlatform.android == defaultTargetPlatform
        //         ? Positioned(
        //             top: 20.0,
        //             right: 30.0,
        //             child: InkWell(
        //               onTap: () {
        //                 Navigator.of(context).pop();
        //                 Navigator.of(context).pop();
        //                 // Navigator.push(
        //                 //   context,
        //                 //   MaterialPageRoute(
        //                 //     // builder: (context) => ChessGame()),
        //                 //       builder: (context) => ZoneHomeScreen()),
        //                 // );
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
        //           )
        //         : Positioned(
        //             top: 30.0,
        //             right: 30.0,
        //             child: InkWell(
        //               onTap: () {
        //                 Navigator.of(context).pop();
        //                 Navigator.of(context).pop();
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
        //     TargetPlatform.android == defaultTargetPlatform
        //         ? Positioned(
        //             top: 60.0,
        //             left: 0.0,
        //             right: 0.0,
        //             child: Padding(
        //               padding: EdgeInsets.fromLTRB(30, 0, 30, 30),
        //               child: Row(
        //                 mainAxisAlignment: MainAxisAlignment.center,
        //                 children: [
        //                   Container(
        //                     // height: 70,
        //                     // width: 160,
        //                     padding: const EdgeInsets.all(14),
        //                     decoration: const BoxDecoration(
        //                       color: Colors.white,
        //                       borderRadius: BorderRadius.only(
        //                           topRight: Radius.circular(15.0),
        //                           bottomRight: Radius.circular(15.0),
        //                           topLeft: Radius.circular(15.0),
        //                           bottomLeft: Radius.circular(15.0)),
        //                     ),
        //                     child: Container(
        //                       // height: 50,
        //                       // width: 100,
        //                       padding: const EdgeInsets.fromLTRB(60, 15, 60, 15),
        //                       decoration: const BoxDecoration(
        //                         color: Colors.white,
        //                         image: DecorationImage(
        //                           image:
        //                               AssetImage("assets/images/site-logo.png"),
        //                           fit: BoxFit.contain,
        //                         ),
        //                       ),
        //                       child: null,
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //             ),
        //           )
        //         : Positioned(
        //             top: 60.0,
        //             left: 0.0,
        //             right: 0.0,
        //             child: Padding(
        //               padding: EdgeInsets.fromLTRB(30, 0, 30, 30),
        //               child: Row(
        //                 mainAxisAlignment: MainAxisAlignment.center,
        //                 children: [
        //                   Container(
        //                     // height: 70,
        //                     // width: 160,
        //                     padding: const EdgeInsets.all(14),
        //                     decoration: const BoxDecoration(
        //                       color: Colors.white,
        //                       borderRadius: BorderRadius.only(
        //                           topRight: Radius.circular(15.0),
        //                           bottomRight: Radius.circular(15.0),
        //                           topLeft: Radius.circular(15.0),
        //                           bottomLeft: Radius.circular(15.0)),
        //                     ),
        //                     child: Container(
        //                       // height: 50,
        //                       // width: 100,
        //                       padding: const EdgeInsets.fromLTRB(60, 15, 60, 15),
        //                       decoration: const BoxDecoration(
        //                         color: Colors.white,
        //                         image: DecorationImage(
        //                           image:
        //                               AssetImage("assets/images/site-logo.png"),
        //                           fit: BoxFit.contain,
        //                         ),
        //                       ),
        //                       child: null,
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //             ),
        //           ),
        //   ],
        //
        // ),

        body: Stack(
          children: [
            width_size < 900
                ? Container(
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
                          // const SizedBox(
                          //   height: 100,
                          // ),
                          // // // Container(
                          // // //   height: 70,
                          // // //   width: 160,
                          // // //   decoration: const BoxDecoration(
                          // // //     color: Colors.white,
                          // // //     borderRadius: BorderRadius.only(
                          // // //         topRight: Radius.circular(15.0),
                          // // //         bottomRight: Radius.circular(15.0),
                          // // //         topLeft: Radius.circular(15.0),
                          // // //         bottomLeft: Radius.circular(15.0)),
                          // // //   ),
                          // // //   child: Container(
                          // // //     height: 50,
                          // // //     width: 100,
                          // // //     margin: const EdgeInsets.all(12),
                          // // //     decoration: const BoxDecoration(
                          // // //       color: Colors.white,
                          // // //       image: DecorationImage(
                          // // //         image:
                          // // //             AssetImage("assets/images/site-logo.png"),
                          // // //         fit: BoxFit.contain,
                          // // //       ),
                          // // //     ),
                          // // //     child: null,
                          // // //   ),
                          // // // ),
                          // // Padding(
                          // //   padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
                          // //   child: Row(
                          // //     mainAxisAlignment: MainAxisAlignment.center,
                          // //     children: [
                          // //       Container(
                          // //         // height: 70,
                          // //         // width: 160,
                          // //         padding: const EdgeInsets.all(14),
                          // //         decoration: const BoxDecoration(
                          // //           color: Colors.white,
                          // //           borderRadius: BorderRadius.only(
                          // //               topRight: Radius.circular(15.0),
                          // //               bottomRight: Radius.circular(15.0),
                          // //               topLeft: Radius.circular(15.0),
                          // //               bottomLeft: Radius.circular(15.0)),
                          // //         ),
                          // //         child: Container(
                          // //           // height: 50,
                          // //           // width: 100,
                          // //           padding: const EdgeInsets.fromLTRB(60,20,60,20),
                          // //           decoration: const BoxDecoration(
                          // //             color: Colors.white,
                          // //             image: DecorationImage(
                          // //               image:
                          // //               AssetImage("assets/images/site-logo.png"),
                          // //               fit: BoxFit.contain,
                          // //             ),
                          // //           ),
                          // //           child: null,
                          // //         ),
                          // //       ),
                          // //     ],
                          // //   ),
                          // // ),
                          // const SizedBox(
                          //   height: 50,
                          // ),
                          SingleChildScrollView(
                            child: Container(
                              //height: 350,
                              //width: 450,
                              margin: EdgeInsets.fromLTRB(40, 190, 40, 0),
                              //width: MediaQuery.of(context).size.width - 100,
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
                                        height: 35,
                                        width: 35,
                                        decoration: const BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                                "assets/icon/fun facts ic.png"),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 40,
                                        //width: 90,
                                        margin:
                                            EdgeInsets.fromLTRB(10, 0, 10, 0),
                                        child: Center(
                                          child: Text(
                                            "Fun Facts",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.blue.shade800,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Container(
                                          height: 35,
                                          width: 35,
                                          margin:
                                              EdgeInsets.fromLTRB(0, 0, 10, 0),
                                          decoration: const BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/icon/close.png"),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const Padding(
                                    padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                                    child: Divider(
                                      color: Colors.black45,
                                      height: 0.5,
                                    ),
                                  ),

                                  Container(
                                    margin: const EdgeInsets.all(20),
                                    child: ChatBubble(
                                      clipper: ChatBubbleClipper6(
                                          type: BubbleType.sendBubble),
                                      alignment: Alignment.topRight,
                                      margin: const EdgeInsets.only(top: 20),
                                      //backGroundColor: Colors.blue.shade800,
                                      backGroundColor: Color(0xff0F5A93),
                                      child: Container(
                                        // constraints: BoxConstraints(
                                        //   maxWidth: MediaQuery.of(context).size.width * 0.7,
                                        // ),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Container(
                                          margin: const EdgeInsets.all(10),
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 0, 0),
                                          child: Column(
                                            children: [
                                              Center(
                                                child: Text(
                                                  factString.title,
                                                  //" The word 'insurance' is derived from the French word 'ensurer' and originally meant an 'engagement to marry'.",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      //color: Colors.blue.shade800,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    10, 10, 0, 0),
                                                child: Center(
                                                  child: Text(
                                                    "   " +
                                                        factString.description,
                                                    //" The word 'insurance' is derived from the French word 'ensurer' and originally meant an 'engagement to marry'.",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Container(
                                  //   //height: 150,
                                  //   width: MediaQuery.of(context).size.width,
                                  //   margin: const EdgeInsets.all(20),
                                  //   decoration: const BoxDecoration(
                                  //     color: Colors.white,
                                  //     image: DecorationImage(
                                  //       image: AssetImage(
                                  //           "assets/icon/Background.png"),
                                  //       fit: BoxFit.fill,
                                  //     ),
                                  //   ),
                                  //   child: Container(
                                  //     margin: const EdgeInsets.all(30),
                                  //     padding:
                                  //         const EdgeInsets.fromLTRB(0, 0, 0, 70),
                                  //     child: Column(
                                  //       children: [
                                  //         Center(
                                  //           child: Text(
                                  //             factString.title,
                                  //             //" The word 'insurance' is derived from the French word 'ensurer' and originally meant an 'engagement to marry'.",
                                  //             style: TextStyle(
                                  //                 fontSize: 18,
                                  //                 color: Colors.blue.shade800,
                                  //                 fontWeight: FontWeight.w600),
                                  //           ),
                                  //         ),
                                  //         Container(
                                  //           padding:
                                  //               EdgeInsets.fromLTRB(20, 20, 0, 0),
                                  //           child: Center(
                                  //             child: Text(
                                  //               "   " + factString.description,
                                  //               //" The word 'insurance' is derived from the French word 'ensurer' and originally meant an 'engagement to marry'.",
                                  //               style: TextStyle(
                                  //                   fontSize: 14,
                                  //                   color: Colors.blue.shade800,
                                  //                   fontWeight: FontWeight.w400),
                                  //             ),
                                  //           ),
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   ),
                                  // ),

                                  const SizedBox(height: 10),

                                  // Row(
                                  //   children: [
                                  //     index != 0
                                  //         ? InkWell(
                                  //             onTap: () {
                                  //               getFactText(false);
                                  //             },
                                  //             child: Container(
                                  //               margin: const EdgeInsets.fromLTRB(
                                  //                   20, 0, 0, 0),
                                  //               height: 45,
                                  //               width: 100,
                                  //               decoration: const BoxDecoration(
                                  //                 image: DecorationImage(
                                  //                   image: AssetImage(
                                  //                       "assets/icon/Previous.png"),
                                  //                   fit: BoxFit.fill,
                                  //                 ),
                                  //               ),
                                  //             ),
                                  //           )
                                  //         : Container(
                                  //             margin: const EdgeInsets.fromLTRB(
                                  //                 20, 0, 0, 0),
                                  //             height: 45,
                                  //             width: 100,
                                  //           ),
                                  //     const Spacer(),
                                  //     InkWell(
                                  //       onTap: () {
                                  //         getFactText(true);
                                  //       },
                                  //       child: Container(
                                  //         margin:
                                  //             const EdgeInsets.fromLTRB(0, 0, 20, 0),
                                  //         height: 45,
                                  //         width: 100,
                                  //         decoration: const BoxDecoration(
                                  //           image: DecorationImage(
                                  //             image: AssetImage("assets/icon/Next.png"),
                                  //             fit: BoxFit.fill,
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),

                                  Row(
                                    children: [
                                      index != 0
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      30, 0, 0, 0),
                                              child: Container(
                                                height: 45,
                                                width: 120,
                                                // child: OutlineButton(
                                                //   shape: RoundedRectangleBorder(
                                                //       borderRadius:
                                                //           BorderRadius.circular(
                                                //               15.0)),
                                                //   child: const Text(
                                                //     "Previous",
                                                //     style: TextStyle(
                                                //       fontSize: 16,
                                                //       fontWeight: FontWeight.bold,
                                                //       color: Color(0xff0F5A93),
                                                //     ),
                                                //   ),
                                                //   borderSide: const BorderSide(
                                                //     width: 2,
                                                //     color: Color(0xff0F5A93),
                                                //   ),
                                                //   onPressed: () {
                                                //     index > 0
                                                //         ? getFactText(false)
                                                //         : Container();
                                                //   },
                                                // ),

                                                child: OutlinedButton(
                                                  style:
                                                      OutlinedButton.styleFrom(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15.0)),
                                                    side: const BorderSide(
                                                      width: 2,
                                                      color: Color(0xff0F5A93),
                                                    ),
                                                  ),
                                                  child: const Text(
                                                    "Previous",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color(0xff0F5A93),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    index > 0
                                                        ? getFactText(false)
                                                        : Container();
                                                  },
                                                ),
                                              ),
                                            )
                                          : Container(
                                              margin: const EdgeInsets.fromLTRB(
                                                  20, 0, 0, 0),
                                              height: 45,
                                              width: 100,
                                            ),
                                      const Spacer(),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 30, 0),
                                        child: Container(
                                          height: 45,
                                          width: 120,
                                          decoration: const BoxDecoration(
                                            color: Color(0xff0F5A93),
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(15.0),
                                                bottomRight:
                                                    Radius.circular(15.0),
                                                topLeft: Radius.circular(15.0),
                                                bottomLeft:
                                                    Radius.circular(15.0)),
                                          ),
                                          child: TextButton(
                                            style: TextButton.styleFrom(
                                              primary: const Color(0xff0F5A93),
                                            ),
                                            onPressed: () {
                                              factString = factsList[index];
                                              factsList.length - 1 != index
                                                  ? getFactText(true)
                                                  : Navigator.of(context).pop();
                                            },
                                            child: Text(
                                              factsList.length - 1 != index
                                                  ? 'Next'
                                                  : 'Finish',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                              // style:
                                              //     const TextStyle(color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                : Container(
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
                          // Padding(
                          //   padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     children: [
                          //       Container(
                          //         // height: 70,
                          //         // width: 160,
                          //         padding: const EdgeInsets.all(14),
                          //         decoration: const BoxDecoration(
                          //           color: Colors.white,
                          //           borderRadius: BorderRadius.only(
                          //               topRight: Radius.circular(15.0),
                          //               bottomRight: Radius.circular(15.0),
                          //               topLeft: Radius.circular(15.0),
                          //               bottomLeft: Radius.circular(15.0)),
                          //         ),
                          //         child: Container(
                          //           // height: 50,
                          //           // width: 100,
                          //           padding:
                          //               const EdgeInsets.fromLTRB(60, 20, 60, 20),
                          //           decoration: const BoxDecoration(
                          //             color: Colors.white,
                          //             image: DecorationImage(
                          //               image: AssetImage(
                          //                   "assets/images/site-logo.png"),
                          //               fit: BoxFit.contain,
                          //             ),
                          //           ),
                          //           child: null,
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),

                          // Container(
                          //   height: 70,
                          //   width: 140,
                          //   decoration: const BoxDecoration(
                          //     color: Colors.white,
                          //     borderRadius: BorderRadius.only(
                          //         topRight: Radius.circular(15.0),
                          //         bottomRight: Radius.circular(15.0),
                          //         topLeft: Radius.circular(15.0),
                          //         bottomLeft: Radius.circular(15.0)),
                          //   ),
                          //   child: Container(
                          //     height: 50,
                          //     width: 100,
                          //     margin: const EdgeInsets.all(12),
                          //     decoration: const BoxDecoration(
                          //       color: Colors.white,
                          //       image: DecorationImage(
                          //         image:
                          //             AssetImage("assets/images/site-logo.png"),
                          //         fit: BoxFit.contain,
                          //       ),
                          //     ),
                          //     child: null,
                          //   ),
                          // ),

                          // const SizedBox(
                          //   height: 100,
                          // ),

                          SingleChildScrollView(
                            child: Container(
                              //height: 350,
                              //width: 450,
                              margin:
                                  const EdgeInsets.fromLTRB(140, 170, 140, 0),
                              //width: MediaQuery.of(context).size.width - 100,
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
                                        height: 35,
                                        width: 35,
                                        decoration: const BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                                "assets/icon/fun facts ic.png"),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 40,
                                        width: 90,
                                        child: Center(
                                          child: Text(
                                            "Fun Facts",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.blue.shade800,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Container(
                                          height: 35,
                                          width: 35,
                                          margin:
                                              EdgeInsets.fromLTRB(0, 0, 10, 0),
                                          decoration: const BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/icon/close.png"),
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
                                    margin: const EdgeInsets.all(20),
                                    child: ChatBubble(
                                      clipper: ChatBubbleClipper6(
                                          type: BubbleType.sendBubble),
                                      alignment: Alignment.topRight,
                                      margin: const EdgeInsets.only(top: 20),
                                      //backGroundColor: Colors.yellow.shade500,
                                      //backGroundColor: Colors.blue.shade800,
                                      backGroundColor: Color(0xff0F5A93),
                                      child: Container(
                                        // constraints: BoxConstraints(
                                        //   maxWidth: MediaQuery.of(context).size.width * 0.7,
                                        // ),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Container(
                                          margin: const EdgeInsets.all(10),
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 0, 0),
                                          child: Column(
                                            children: [
                                              Center(
                                                child: Text(
                                                  factString.title,
                                                  //" The word 'insurance' is derived from the French word 'ensurer' and originally meant an 'engagement to marry'.",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      //color: Colors.blue.shade800,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    10, 10, 0, 0),
                                                child: Center(
                                                  child: Text(
                                                    "   " +
                                                        factString.description,
                                                    //" The word 'insurance' is derived from the French word 'ensurer' and originally meant an 'engagement to marry'.",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        //color: Colors.blue.shade800,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      index != 0
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      30, 0, 0, 0),
                                              child: Container(
                                                height: 45,
                                                width: 120,
                                                child: OutlinedButton(
                                                  style:
                                                      OutlinedButton.styleFrom(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15.0)),
                                                    side: const BorderSide(
                                                      width: 2,
                                                      color: Color(0xff0F5A93),
                                                    ),
                                                  ),
                                                  child: const Text(
                                                    "Previous",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color(0xff0F5A93),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    restartTime();
                                                    index > 0
                                                        ? getFactText(false)
                                                        : Container();
                                                  },
                                                ),
                                              ),
                                            )
                                          : Container(
                                              margin: const EdgeInsets.fromLTRB(
                                                  20, 0, 0, 0),
                                              height: 45,
                                              width: 100,
                                            ),
                                      const Spacer(),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 30, 0),
                                        child: Container(
                                          height: 45,
                                          width: 120,
                                          decoration: const BoxDecoration(
                                            color: Color(0xff0F5A93),
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(15.0),
                                                bottomRight:
                                                    Radius.circular(15.0),
                                                topLeft: Radius.circular(15.0),
                                                bottomLeft:
                                                    Radius.circular(15.0)),
                                          ),
                                          child: TextButton(
                                            style: TextButton.styleFrom(
                                              primary: const Color(0xff0F5A93),
                                            ),
                                            onPressed: () {
                                              factsList.length - 1 != index
                                                  ? restartTime()
                                                  : dispose();
                                              factString = factsList[index];
                                              factsList.length - 1 != index
                                                  ? getFactText(true)
                                                  : Navigator.of(context).pop();
                                            },
                                            child: Text(
                                              factsList.length - 1 != index
                                                  ? 'Next'
                                                  : 'Finish',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                              // style:
                                              //     const TextStyle(color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

            width_size < 900
                ? Positioned(
                    top: 60.0,
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
                                  image:
                                      AssetImage("assets/images/site-logo.png"),
                                  fit: BoxFit.contain,
                                ),
                              ),
                              child: null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Positioned(
                    top: 60.0,
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
                              //padding: const EdgeInsets.fromLTRB(60, 15, 60, 15),
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
                        ],
                      ),
                    ),
                  ),

            TargetPlatform.android == defaultTargetPlatform
                ? Positioned(
                    top: 20.0,
                    right: 30.0,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
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
                            image: AssetImage("assets/games/Home Icon.png"),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  )
                : Positioned(
                    top: 30.0,
                    right: 30.0,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     // builder: (context) => ChessGame()),
                        //       builder: (context) => ZoneHomeScreen()),
                        // );
                      },
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        height: 100,
                        width: 40,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/games/Home Icon.png"),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),

            // TargetPlatform.android == defaultTargetPlatform
            //     ? Positioned(
            //   top: 60.0,
            //   left: 0.0,
            //   right: 0.0,
            //   child: Padding(
            //     padding: EdgeInsets.fromLTRB(30, 0, 30, 30),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Container(
            //           // height: 70,
            //           // width: 160,
            //           padding: const EdgeInsets.all(14),
            //           decoration: const BoxDecoration(
            //             color: Colors.white,
            //             borderRadius: BorderRadius.only(
            //                 topRight: Radius.circular(15.0),
            //                 bottomRight: Radius.circular(15.0),
            //                 topLeft: Radius.circular(15.0),
            //                 bottomLeft: Radius.circular(15.0)),
            //           ),
            //           child: Container(
            //             // height: 50,
            //             // width: 100,
            //             padding: const EdgeInsets.fromLTRB(60, 15, 60, 15),
            //             decoration: const BoxDecoration(
            //               color: Colors.white,
            //               image: DecorationImage(
            //                 image:
            //                 AssetImage("assets/images/site-logo.png"),
            //                 fit: BoxFit.contain,
            //               ),
            //             ),
            //             child: null,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // )
            //     : Positioned(
            //   top: 60.0,
            //   left: 0.0,
            //   right: 0.0,
            //   child: Padding(
            //     padding: EdgeInsets.fromLTRB(30, 0, 30, 30),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Container(
            //           // height: 70,
            //           // width: 160,
            //           padding: const EdgeInsets.all(14),
            //           decoration: const BoxDecoration(
            //             color: Colors.white,
            //             borderRadius: BorderRadius.only(
            //                 topRight: Radius.circular(15.0),
            //                 bottomRight: Radius.circular(15.0),
            //                 topLeft: Radius.circular(15.0),
            //                 bottomLeft: Radius.circular(15.0)),
            //           ),
            //           child: Container(
            //             // height: 50,
            //             // width: 100,
            //             padding: const EdgeInsets.fromLTRB(80, 20, 80, 20),
            //             //padding: const EdgeInsets.fromLTRB(60, 15, 60, 15),
            //             decoration: const BoxDecoration(
            //               color: Colors.white,
            //               image: DecorationImage(
            //                 image:
            //                 AssetImage("assets/images/site-logo.png"),
            //                 fit: BoxFit.contain,
            //               ),
            //             ),
            //             child: null,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
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

  void restartTime() {
    if (_timer.isActive) {
      _timer.cancel();
      startTimer();
      print("FunFacts Timer Canceled and ReStart ");
    } else {
      print("FunFacts Timer ReStart");
      startTimer();
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer.isActive) {
      _timer.cancel();
      print("FunFacts Timer Canceled and Start in Dispose() ");
    }
  }

  void getFactText(bool value) {
    if (value) {
      setState(() {
        print(index);
        index = index + 1;
        factString = factsList[index];
      });
    } else {
      setState(() {
        print(index);
        index = index - 1;
        factString = factsList[index];
      });
    }
  }
}
