import 'dart:async';

import 'package:experiencezone/screens/banner_screen.dart';
import 'package:experiencezone/screens/scoreboard_screen.dart';
import 'package:experiencezone/screens/zonehome_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../cache/common.dart';

import 'dart:io' show Platform;

import '../utils/light_color.dart';

enum SingingCharacter { Yes, NO }

class Quiz_Screen extends StatefulWidget {
  const Quiz_Screen({Key? key}) : super(key: key);

  @override
  State<Quiz_Screen> createState() => _Quiz_ScreenState();
}

class Questionz {
  late bool matching;

  late String question;

  late String optionA;
  late String optionB;
  late String optionC;
  late String optionD;

  late String answerA;
  late String answerB;
  late String answerC;
  late String answerD;

  Questionz(
      this.matching,
      this.question,
      this.optionA,
      this.optionB,
      this.optionC,
      this.optionD,
      this.answerA,
      this.answerB,
      this.answerC,
      this.answerD);
}

class _Quiz_ScreenState extends State<Quiz_Screen> {
  List<Questionz> quizList = [
    Questionz(
      false,
      "Q1. What is the purpose of Life insurances ?",
      "Secure healthcare cover",
      "Secure Vehicles damage cover",
      "Secure Life cover",
      "Secure travel cover",
      "No",
      "No",
      "Yes",
      "No",
    ),
    Questionz(
        false,
        "Q2. What is the average duration of Term Life Insurance policy ?",
        "1 Year",
        "Between 5 years to 40 years or till age 99",
        "1-3 Year",
        "Less than 1 year (180 days limit) ",
        "No",
        "Yes",
        "No",
        "No"),
    Questionz(
        false,
        "Q3. Which of the following insurance policies are correctly matched with their purpose ?",
        "Health Insurance - Hospital Bills Payment",
        "Motor Insurance - Repair car dent",
        "Travel Insurance - Luggage Misplace",
        "All of the above",
        "No",
        "No",
        "No",
        "Yes"),
    Questionz(
        false,
        "Q4. Which of the following insurance policies are correctly categorized ?",
        "Term Life Insurance - Endowment Plans",
        "Education Insurance - Study related plans",
        "Financial Insurance - Business loss",
        "All of the above",
        "No",
        "No",
        "No",
        "Yes"),
    Questionz(
      false,
      "Q5. Choose Insurance plans you expect to have maximum coverage amount ?",
      "Term Life Insurance",
      "Health Insurance",
      "Motor Insurance",
      "Fire Insurance",
      "Yes",
      "No",
      "No",
      "No",
    ),
    Questionz(
      false,
      "Q6. Which Insurance plan that is most important to buy ?",
      "Travel Insurance",
      "Health Insurance",
      "Motor Insurance",
      "Fire Insurance",
      "No",
      "Yes",
      "No",
      "No",
    ),
    Questionz(
        false,
        "Q7. What is the purpose of cyber insurances ?",
        "Online Frauds or privacy breach",
        "Pregnancy based complications",
        "Business loss cover",
        "Domestic Animals cover	",
        "Yes",
        "No",
        "No",
        "No"),
    Questionz(
      false,
      "Q8. The main purpose of life insurance is to ?",
      "Meet an insured person’s debts and other financial commitments in the event of death.",
      "Make up for loss of earnings if an insured person is unable to ever work again.",
      "Pay for urgent medical expenses to save the life of an insured person if that is needed.",
      "Provide a lump sum if an insured person is diagnosed with a life-threatening illness.",
      "Yes",
      "No",
      "No",
      "No",
    ),
    Questionz(
      false,
      "Q9. The best time to apply for life insurance is ?",
      "Tomorrow, because you shouldn’t do now what you can put off until then.",
      "Today, because you don’t know what might happen to you tomorrow.",
      "As soon as you have any dependants, whenever in the future that might be.",
      "As soon as you develop a serious medical condition, so you can be covered for it.",
      "No",
      "Yes",
      "No",
      "No",
    ),
    Questionz(
      false,
      "Q10. _____ insurance is a contract where an insurance company provides medical coverage. It covers medical expenses incurred on hospitalization, surgeries, day care procedures, etc.",
      "Term Life",
      "Motor",
      "Health",
      "Travel",
      "No",
      "No",
      "Yes",
      "No",
    ),
  ];

  late int score = 0;
  late int index = 0;
  late int counter = index + 1;
  late Questionz quizObject = quizList[0];

  late List<String> AnswerValues;
  late String quizAnswerStatic;

  final List<String> _answers = ['A', 'B', 'C', 'D', '_'];

  late String _answerA = "", _answerB = "", _answerC = "", _answerD = "";

  late String _selectedAnswerA = '_';
  late bool _enabledA = true;

  late String _selectedAnswerB = '_';
  late bool _enabledB = true;

  late String _selectedAnswerC = '_';
  late bool _enabledC = true;

  late String _selectedAnswerD = '_';
  late bool _enabledD = true;

  late bool _correctA = false;
  late bool _correctB = false;
  late bool _correctC = false;
  late bool _correctD = false;

  late String pressed = '';
  late String previousValue = '';

  late var system_size;

  late Timer _timer;
  int _start = 300; // 5 minute

    @override
  void initState() {
    startTimer();
    getInitQuizQuestion();
    super.initState();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            _timer.cancel();
            timer.cancel();
          });

          print("Quiz Screen Timer Cancelled ");
          showSnackBar(
              "5 Minute Limit Over");
          clear();
          Navigator.of(context).pop();
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => BannerScreen()));

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

  @override
  Widget build(BuildContext context) {
    final double heightSize = MediaQuery.of(context).size.height;
    final double widthSize = MediaQuery.of(context).size.width;
    print("Quiz Screen");
    var size = MediaQuery.of(context).size.width;
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.landscapeLeft,
    //   DeviceOrientation.landscapeRight,
    // ]);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        extendBodyBehindAppBar: false,
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

            widthSize < 900
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
                    //
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
                    // const SizedBox(
                    //   height: 10,
                    // ),

                    SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(0, 60, 0, 0),
                        margin: const EdgeInsets.all(0),
                        decoration: const BoxDecoration(
                          //color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(15.0),
                              bottomRight: Radius.circular(15.0),
                              topLeft: Radius.circular(15.0),
                              bottomLeft: Radius.circular(15.0)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 170,
                                  width: 160,
                                  padding: const EdgeInsets.fromLTRB(
                                      60, 0, 60, 20),
                                  decoration: const BoxDecoration(
                                    //color: Colors.white,
                                    image: DecorationImage(
                                      image: AssetImage(
                                          "assets/KBC logo.png"),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  child: null,
                                ),
                              ],
                            ),

                            const SizedBox(
                              height: 30,
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: CustomPaint(
                                    size: Size(
                                        size,
                                        (200 * 0.18461538461538463)
                                            .toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                                    painter: Counter(),
                                    child: Container(
                                      width: 50,
                                      margin: const EdgeInsets.fromLTRB(
                                          0, 15, 0, 15),
                                      //padding: EdgeInsets.fromLTRB(0, 0, 0, 45),
                                      child: Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            65, 0, 5, 0),
                                        child: Text(
                                          "Q." + counter.toString(),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                              fontWeight:
                                              FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 8,
                                  child: Container(),
                                ),
                              ],
                            ),

                            const SizedBox(
                              height: 20,
                            ),

                            /// question box
                            SizedBox(
                              width: size,
                              child: CustomPaint(
                                size: Size(
                                    size,
                                    (150 * 0.18461538461538463)
                                        .toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                                painter: QuestionCustomPainter(),
                                child: Container(
                                  width: 450,
                                  margin: const EdgeInsets.fromLTRB(
                                      0, 20, 0, 20),
                                  //padding: EdgeInsets.fromLTRB(0, 0, 0, 45),
                                  child: Padding(
                                    padding:
                                    EdgeInsets.fromLTRB(75, 0, 75, 0),
                                    child: Text(
                                      quizObject.question,
                                      //"What is the Purpose of Life insurance",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(
                              height: 20,
                            ),

                            Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (_enabledA) {
                                      setState(() {
                                        pressed = "A";

                                        _enabledA = false;
                                        _enabledB = false;
                                        _enabledC = false;
                                        _enabledD = false;

                                        if (quizObject.answerA == "Yes") {
                                          _answerA = quizObject.answerA;

                                          _correctA = true;
                                          _correctB = false;
                                          _correctC = false;
                                          _correctD = false;
                                        }
                                      });
                                    }
                                  },
                                  child: SizedBox(
                                    height: 55,
                                    width: size,
                                    child: CustomPaint(
                                      painter: AMobileOptionCustomPainter(
                                          _correctA, pressed),
                                      size: Size(
                                          size,
                                          (400 * 0.18461538461538463)
                                              .toDouble()),
                                      child: Center(
                                        child: Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              75, 0, 75, 0),
                                          child: Text(
                                            "A. " + quizObject.optionA,
                                            //"A. What is the Purpose of Life insurance",
                                            textAlign: TextAlign.center,
                                            maxLines: 3,
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: _correctA
                                                    ? Colors.white
                                                    : !_correctA &&
                                                    pressed == "A"
                                                    ? Colors.white
                                                    : Colors.blue
                                                    .shade800,
                                                fontWeight:
                                                FontWeight.w600),
                                            // style: TextStyle(
                                            //     fontSize: 14,
                                            //     color: Colors.white,
                                            //     fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                InkWell(
                                  onTap: () {
                                    if (_enabledB) {
                                      setState(() {
                                        pressed = "B";

                                        _enabledB = false;
                                        _enabledA = false;
                                        _enabledC = false;
                                        _enabledD = false;

                                        if (quizObject.answerB == "Yes") {
                                          _answerB = quizObject.answerB;

                                          _correctB = true;

                                          _correctA = false;
                                          _correctC = false;
                                          _correctD = false;
                                        }
                                      });
                                    }
                                  },
                                  child: SizedBox(
                                    height: 55,
                                    width: size,
                                    child: CustomPaint(
                                      size: Size(
                                          size,
                                          (400 * 0.18461538461538463)
                                              .toDouble()),
                                      painter: BMobileOptionCustomPainter(
                                          _correctB, pressed),
                                      child: Center(
                                        child: Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              75, 0, 75, 0),
                                          child: Text(
                                            "B. " + quizObject.optionB,
                                            //"A. What is the Purpose of Life insurance",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: _correctB
                                                    ? Colors.white
                                                //: !_enabledB && !_correctB
                                                    : !_correctB &&
                                                    pressed == "B"
                                                    ? Colors.white
                                                    : Colors.blue
                                                    .shade800,

                                                // ? Colors.blue.shade800
                                                //     : Colors.white,
                                                fontWeight:
                                                FontWeight.w600),
                                            // style: TextStyle(
                                            //     fontSize: 14,
                                            //     color: Colors.white,
                                            //     fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                InkWell(
                                  onTap: () {
                                    if (_enabledC) {
                                      setState(() {
                                        pressed = "C";

                                        _enabledC = false;
                                        _enabledA = false;
                                        _enabledB = false;
                                        _enabledD = false;

                                        if (quizObject.answerC == "Yes") {
                                          _answerC = quizObject.answerC;

                                          _correctC = true;

                                          _correctA = false;
                                          _correctB = false;
                                          _correctD = false;
                                        }
                                      });
                                    }
                                  },
                                  child: SizedBox(
                                    height: 55,
                                    width: size,
                                    child: CustomPaint(
                                      size: Size(
                                          size,
                                          (400 * 0.18461538461538463)
                                              .toDouble()),
                                      painter: CMobileOptionCustomPainter(
                                          _correctC, pressed),
                                      child: Center(
                                        child: Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              75, 0, 75, 0),
                                          child: Text(
                                            "C. " + quizObject.optionC,
                                            //"A. What is the Purpose of Life insurance",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: _correctC
                                                    ? Colors.white
                                                    : !_correctC &&
                                                    pressed == "C"
                                                    ? Colors.white
                                                    : Colors.blue
                                                    .shade800,
                                                fontWeight:
                                                FontWeight.w600),
                                            // style: TextStyle(
                                            //     fontSize: 14,
                                            //     color: Colors.white,
                                            //     fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                InkWell(
                                  onTap: () {
                                    if (_enabledD) {
                                      setState(() {
                                        pressed = "D";

                                        _enabledD = false;
                                        _enabledA = false;
                                        _enabledB = false;
                                        _enabledC = false;

                                        if (quizObject.answerD == "Yes") {
                                          _answerD = quizObject.answerD;

                                          _correctD = true;
                                          _correctA = false;
                                          _correctB = false;
                                          _correctC = false;
                                        }
                                      });
                                    }
                                  },
                                  child: SizedBox(
                                    height: 55,
                                    width: size,
                                    child: CustomPaint(
                                      size: Size(
                                          size,
                                          (400 * 0.18461538461538463)
                                              .toDouble()),
                                      painter: DMobileOptionCustomPainter(
                                          _correctD, pressed),
                                      child: Center(
                                        child: Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              75, 0, 75, 0),
                                          child: Text(
                                            "D. " + quizObject.optionD,
                                            //"A. What is the Purpose of Life insurance",
                                            textAlign: TextAlign.center,
                                            maxLines: 3,
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: _correctD
                                                    ? Colors.white
                                                    : !_correctD &&
                                                    pressed == "D"
                                                    ? Colors.white
                                                    : Colors.blue
                                                    .shade800,
                                                fontWeight:
                                                FontWeight.w600),
                                            // style: TextStyle(
                                            //     fontSize: 14,
                                            //     color: Colors.white,
                                            //     fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(
                              height: 20,
                            ),

                            Row(
                              children: [
                                index > 0
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
                                        backgroundColor:
                                        Colors.white,
                                        shape:
                                        RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius
                                                .circular(
                                                10.0)),
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
                                            ? getQuizQuestion(false)
                                            : Container();
                                      },
                                    ),
                                  ),
                                )
                                    : Container(),
                                const Spacer(),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      0, 0, 30, 0),
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: Color(0xff0F5A93),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(
                                              10.0)),
                                      side: const BorderSide(
                                        width: 1,
                                        color: Colors.white,
                                      ),
                                    ),
                                    child: Container(
                                      width: 60,
                                      height: 40,
                                      child: Center(
                                        child: Text(
                                          quizList.length - 1 != index
                                              ? 'Next'
                                              : 'Finish',
                                          style: const TextStyle(
                                              fontSize: 17,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    onPressed: () async {
                                      if (index == 0) {
                                        await Common.setQuestion0Pressed(
                                            pressed);
                                      } else if (index == 1) {
                                        await Common.setQuestion1Pressed(
                                            pressed);
                                      } else if (index == 2) {
                                        await Common.setQuestion2Pressed(
                                            pressed);
                                      } else if (index == 3) {
                                        await Common.setQuestion3Pressed(
                                            pressed);
                                      } else if (index == 4) {
                                        await Common.setQuestion4Pressed(
                                            pressed);
                                      } else if (index == 5) {
                                        await Common.setQuestion5Pressed(
                                            pressed);
                                      } else if (index == 6) {
                                        await Common.setQuestion6Pressed(
                                            pressed);
                                      } else if (index == 7) {
                                        await Common.setQuestion7Pressed(
                                            pressed);
                                      } else if (index == 8) {
                                        await Common.setQuestion8Pressed(
                                            pressed);
                                      } else if (index == 9) {
                                        await Common.setQuestion9Pressed(
                                            pressed);
                                      }

                                      if (pressed == "A") {
                                        if (quizObject.answerA == "Yes") {
                                          setState(() {
                                            score = score + 1;
                                          });
                                        } else {
                                          // if(score > 0 ){
                                          //   setState(() {
                                          //     score = score - 1;
                                          //   });
                                          // }
                                        }

                                        if (index == 0) {
                                          await Common
                                              .setQuestion0Pressed(
                                              pressed);

                                          if (quizObject.answerA ==
                                              "Yes") {
                                            await Common
                                                .setQuestion0CorrectedA(
                                                true);
                                          } else {
                                            await Common
                                                .setQuestion0CorrectedA(
                                                false);
                                          }
                                        } else if (index == 1) {
                                          await Common
                                              .setQuestion1Pressed(
                                              pressed);

                                          if (quizObject.answerA ==
                                              "Yes") {
                                            await Common
                                                .setQuestion1CorrectedA(
                                                true);
                                          } else {
                                            await Common
                                                .setQuestion1CorrectedA(
                                                false);
                                          }
                                        } else if (index == 2) {
                                          await Common
                                              .setQuestion2Pressed(
                                              pressed);

                                          if (quizObject.answerA ==
                                              "Yes") {
                                            await Common
                                                .setQuestion2CorrectedA(
                                                true);
                                          } else {
                                            await Common
                                                .setQuestion2CorrectedA(
                                                false);
                                          }
                                        } else if (index == 3) {
                                          await Common
                                              .setQuestion3Pressed(
                                              pressed);

                                          if (quizObject.answerA ==
                                              "Yes") {
                                            await Common
                                                .setQuestion3CorrectedA(
                                                true);
                                          } else {
                                            await Common
                                                .setQuestion3CorrectedA(
                                                false);
                                          }
                                        } else if (index == 4) {
                                          await Common
                                              .setQuestion4Pressed(
                                              pressed);

                                          if (quizObject.answerA ==
                                              "Yes") {
                                            await Common
                                                .setQuestion4CorrectedA(
                                                true);
                                          } else {
                                            await Common
                                                .setQuestion4CorrectedA(
                                                false);
                                          }
                                        } else if (index == 5) {
                                          await Common
                                              .setQuestion5Pressed(
                                              pressed);

                                          if (quizObject.answerA ==
                                              "Yes") {
                                            await Common
                                                .setQuestion5CorrectedA(
                                                true);
                                          } else {
                                            await Common
                                                .setQuestion5CorrectedA(
                                                false);
                                          }
                                        } else if (index == 6) {
                                          await Common
                                              .setQuestion6Pressed(
                                              pressed);

                                          if (quizObject.answerA ==
                                              "Yes") {
                                            await Common
                                                .setQuestion6CorrectedA(
                                                true);
                                          } else {
                                            await Common
                                                .setQuestion6CorrectedA(
                                                false);
                                          }
                                        } else if (index == 7) {
                                          await Common
                                              .setQuestion7Pressed(
                                              pressed);

                                          if (quizObject.answerA ==
                                              "Yes") {
                                            await Common
                                                .setQuestion7CorrectedA(
                                                true);
                                          } else {
                                            await Common
                                                .setQuestion7CorrectedA(
                                                false);
                                          }
                                        } else if (index == 8) {
                                          await Common
                                              .setQuestion8Pressed(
                                              pressed);

                                          if (quizObject.answerA ==
                                              "Yes") {
                                            await Common
                                                .setQuestion8CorrectedA(
                                                true);
                                          } else {
                                            await Common
                                                .setQuestion8CorrectedA(
                                                false);
                                          }
                                        } else if (index == 9) {
                                          await Common
                                              .setQuestion9Pressed(
                                              pressed);
                                          if (quizObject.answerA ==
                                              "Yes") {
                                            await Common
                                                .setQuestion9CorrectedA(
                                                true);
                                          } else {
                                            await Common
                                                .setQuestion9CorrectedA(
                                                false);
                                          }
                                        }
                                      } else if (pressed == "B") {
                                        if (quizObject.answerB == "Yes") {
                                          setState(() {
                                            score = score + 1;
                                          });
                                        } else {
                                          // if(score > 0 ){
                                          //   setState(() {
                                          //     score = score - 1;
                                          //   });
                                          // }
                                        }

                                        if (index == 0) {
                                          await Common
                                              .setQuestion0Pressed(
                                              pressed);

                                          if (quizObject.answerB ==
                                              "Yes") {
                                            await Common
                                                .setQuestion0CorrectedB(
                                                true);
                                          } else {
                                            await Common
                                                .setQuestion0CorrectedB(
                                                false);
                                          }
                                        } else if (index == 1) {
                                          await Common
                                              .setQuestion1Pressed(
                                              pressed);

                                          if (quizObject.answerB ==
                                              "Yes") {
                                            await Common
                                                .setQuestion1CorrectedB(
                                                true);
                                          } else {
                                            await Common
                                                .setQuestion1CorrectedB(
                                                false);
                                          }
                                        } else if (index == 2) {
                                          await Common
                                              .setQuestion2Pressed(
                                              pressed);

                                          if (quizObject.answerB ==
                                              "Yes") {
                                            await Common
                                                .setQuestion2CorrectedB(
                                                true);
                                          } else {
                                            await Common
                                                .setQuestion2CorrectedB(
                                                false);
                                          }
                                        } else if (index == 3) {
                                          await Common
                                              .setQuestion3Pressed(
                                              pressed);

                                          if (quizObject.answerB ==
                                              "Yes") {
                                            await Common
                                                .setQuestion3CorrectedB(
                                                true);
                                          } else {
                                            await Common
                                                .setQuestion3CorrectedB(
                                                false);
                                          }
                                        } else if (index == 4) {
                                          await Common
                                              .setQuestion4Pressed(
                                              pressed);

                                          if (quizObject.answerB ==
                                              "Yes") {
                                            await Common
                                                .setQuestion4CorrectedB(
                                                true);
                                          } else {
                                            await Common
                                                .setQuestion4CorrectedB(
                                                false);
                                          }
                                        } else if (index == 5) {
                                          await Common
                                              .setQuestion5Pressed(
                                              pressed);

                                          if (quizObject.answerB ==
                                              "Yes") {
                                            await Common
                                                .setQuestion5CorrectedB(
                                                true);
                                          } else {
                                            await Common
                                                .setQuestion5CorrectedB(
                                                false);
                                          }
                                        } else if (index == 6) {
                                          await Common
                                              .setQuestion6Pressed(
                                              pressed);

                                          if (quizObject.answerB ==
                                              "Yes") {
                                            await Common
                                                .setQuestion6CorrectedB(
                                                true);
                                          } else {
                                            await Common
                                                .setQuestion6CorrectedB(
                                                false);
                                          }
                                        } else if (index == 7) {
                                          await Common
                                              .setQuestion7Pressed(
                                              pressed);

                                          if (quizObject.answerB ==
                                              "Yes") {
                                            await Common
                                                .setQuestion7CorrectedB(
                                                true);
                                          } else {
                                            await Common
                                                .setQuestion7CorrectedB(
                                                false);
                                          }
                                        } else if (index == 8) {
                                          await Common
                                              .setQuestion8Pressed(
                                              pressed);

                                          if (quizObject.answerB ==
                                              "Yes") {
                                            await Common
                                                .setQuestion8CorrectedB(
                                                true);
                                          } else {
                                            await Common
                                                .setQuestion8CorrectedB(
                                                false);
                                          }
                                        } else if (index == 9) {
                                          await Common
                                              .setQuestion9Pressed(
                                              pressed);
                                          if (quizObject.answerB ==
                                              "Yes") {
                                            await Common
                                                .setQuestion9CorrectedB(
                                                true);
                                          } else {
                                            await Common
                                                .setQuestion9CorrectedB(
                                                false);
                                          }
                                        }
                                      } else if (pressed == "C") {
                                        if (quizObject.answerC == "Yes") {
                                          setState(() {
                                            score = score + 1;
                                          });
                                        } else {
                                          // if(score > 0 ){
                                          //   setState(() {
                                          //     score = score - 1;
                                          //   });
                                          // }
                                        }

                                        if (index == 0) {
                                          await Common
                                              .setQuestion0Pressed(
                                              pressed);

                                          if (quizObject.answerC ==
                                              "Yes") {
                                            await Common
                                                .setQuestion0CorrectedC(
                                                true);
                                          } else {
                                            await Common
                                                .setQuestion0CorrectedC(
                                                false);
                                          }
                                        } else if (index == 1) {
                                          await Common
                                              .setQuestion1Pressed(
                                              pressed);

                                          if (quizObject.answerC ==
                                              "Yes") {
                                            await Common
                                                .setQuestion1CorrectedC(
                                                true);
                                          } else {
                                            await Common
                                                .setQuestion1CorrectedC(
                                                false);
                                          }
                                        } else if (index == 2) {
                                          await Common
                                              .setQuestion2Pressed(
                                              pressed);

                                          if (quizObject.answerC ==
                                              "Yes") {
                                            await Common
                                                .setQuestion2CorrectedC(
                                                true);
                                          } else {
                                            await Common
                                                .setQuestion2CorrectedC(
                                                false);
                                          }
                                        } else if (index == 3) {
                                          await Common
                                              .setQuestion3Pressed(
                                              pressed);

                                          if (quizObject.answerC ==
                                              "Yes") {
                                            await Common
                                                .setQuestion3CorrectedC(
                                                true);
                                          } else {
                                            await Common
                                                .setQuestion3CorrectedC(
                                                false);
                                          }
                                        } else if (index == 4) {
                                          await Common
                                              .setQuestion4Pressed(
                                              pressed);

                                          if (quizObject.answerC ==
                                              "Yes") {
                                            await Common
                                                .setQuestion4CorrectedC(
                                                true);
                                          } else {
                                            await Common
                                                .setQuestion4CorrectedC(
                                                false);
                                          }
                                        } else if (index == 5) {
                                          await Common
                                              .setQuestion5Pressed(
                                              pressed);

                                          if (quizObject.answerC ==
                                              "Yes") {
                                            await Common
                                                .setQuestion5CorrectedC(
                                                true);
                                          } else {
                                            await Common
                                                .setQuestion5CorrectedC(
                                                false);
                                          }
                                        } else if (index == 6) {
                                          await Common
                                              .setQuestion6Pressed(
                                              pressed);

                                          if (quizObject.answerC ==
                                              "Yes") {
                                            await Common
                                                .setQuestion6CorrectedC(
                                                true);
                                          } else {
                                            await Common
                                                .setQuestion6CorrectedC(
                                                false);
                                          }
                                        } else if (index == 7) {
                                          await Common
                                              .setQuestion7Pressed(
                                              pressed);

                                          if (quizObject.answerC ==
                                              "Yes") {
                                            await Common
                                                .setQuestion7CorrectedC(
                                                true);
                                          } else {
                                            await Common
                                                .setQuestion7CorrectedC(
                                                false);
                                          }
                                        } else if (index == 8) {
                                          await Common
                                              .setQuestion8Pressed(
                                              pressed);

                                          if (quizObject.answerC ==
                                              "Yes") {
                                            await Common
                                                .setQuestion8CorrectedC(
                                                true);
                                          } else {
                                            await Common
                                                .setQuestion8CorrectedC(
                                                false);
                                          }
                                        } else if (index == 9) {
                                          await Common
                                              .setQuestion9Pressed(
                                              pressed);
                                          if (quizObject.answerC ==
                                              "Yes") {
                                            await Common
                                                .setQuestion9CorrectedC(
                                                true);
                                          } else {
                                            await Common
                                                .setQuestion9CorrectedC(
                                                false);
                                          }
                                        }
                                      } else if (pressed == "D") {
                                        if (quizObject.answerD == "Yes") {
                                          setState(() {
                                            score = score + 1;
                                          });
                                        } else {
                                          // if(score > 0 ){
                                          //   setState(() {
                                          //     score = score - 1;
                                          //   });
                                          // }
                                        }

                                        if (index == 0) {
                                          await Common
                                              .setQuestion0Pressed(
                                              pressed);

                                          if (quizObject.answerD ==
                                              "Yes") {
                                            await Common
                                                .setQuestion0CorrectedD(
                                                true);
                                          } else {
                                            await Common
                                                .setQuestion0CorrectedD(
                                                false);
                                          }
                                        } else if (index == 1) {
                                          await Common
                                              .setQuestion1Pressed(
                                              pressed);

                                          if (quizObject.answerD ==
                                              "Yes") {
                                            await Common
                                                .setQuestion1CorrectedD(
                                                true);
                                          } else {
                                            await Common
                                                .setQuestion1CorrectedD(
                                                false);
                                          }
                                        } else if (index == 2) {
                                          await Common
                                              .setQuestion2Pressed(
                                              pressed);

                                          if (quizObject.answerD ==
                                              "Yes") {
                                            await Common
                                                .setQuestion2CorrectedD(
                                                true);
                                          } else {
                                            await Common
                                                .setQuestion2CorrectedD(
                                                false);
                                          }
                                        } else if (index == 3) {
                                          await Common
                                              .setQuestion3Pressed(
                                              pressed);

                                          if (quizObject.answerD ==
                                              "Yes") {
                                            await Common
                                                .setQuestion3CorrectedD(
                                                true);
                                          } else {
                                            await Common
                                                .setQuestion3CorrectedD(
                                                false);
                                          }
                                        } else if (index == 4) {
                                          await Common
                                              .setQuestion4Pressed(
                                              pressed);

                                          if (quizObject.answerD ==
                                              "Yes") {
                                            await Common
                                                .setQuestion4CorrectedD(
                                                true);
                                          } else {
                                            await Common
                                                .setQuestion4CorrectedD(
                                                false);
                                          }
                                        } else if (index == 5) {
                                          await Common
                                              .setQuestion5Pressed(
                                              pressed);

                                          if (quizObject.answerD ==
                                              "Yes") {
                                            await Common
                                                .setQuestion5CorrectedD(
                                                true);
                                          } else {
                                            await Common
                                                .setQuestion5CorrectedD(
                                                false);
                                          }
                                        } else if (index == 6) {
                                          await Common
                                              .setQuestion6Pressed(
                                              pressed);

                                          if (quizObject.answerD ==
                                              "Yes") {
                                            await Common
                                                .setQuestion6CorrectedD(
                                                true);
                                          } else {
                                            await Common
                                                .setQuestion6CorrectedD(
                                                false);
                                          }
                                        } else if (index == 7) {
                                          await Common
                                              .setQuestion7Pressed(
                                              pressed);

                                          if (quizObject.answerD ==
                                              "Yes") {
                                            await Common
                                                .setQuestion7CorrectedD(
                                                true);
                                          } else {
                                            await Common
                                                .setQuestion7CorrectedD(
                                                false);
                                          }
                                        } else if (index == 8) {
                                          await Common
                                              .setQuestion8Pressed(
                                              pressed);

                                          if (quizObject.answerD ==
                                              "Yes") {
                                            await Common
                                                .setQuestion8CorrectedD(
                                                true);
                                          } else {
                                            await Common
                                                .setQuestion8CorrectedD(
                                                false);
                                          }
                                        } else if (index == 9) {
                                          await Common
                                              .setQuestion9Pressed(
                                              pressed);
                                          if (quizObject.answerD ==
                                              "Yes") {
                                            await Common
                                                .setQuestion9CorrectedD(
                                                true);
                                          } else {
                                            await Common
                                                .setQuestion9CorrectedD(
                                                false);
                                          }
                                        }
                                      }


                                      quizList.length - 1 != index
                                          ? getQuizQuestion(true)
                                          : nextScreen(score);
                                      // : Navigator.push(
                                      // context,
                                      // MaterialPageRoute(
                                      //   // builder: (context) => ChessGame()),
                                      //     builder: (context) =>
                                      //         ScoreBoardScreen(
                                      //           Score: score
                                      //               .toString(),
                                      //         )));
                                    },
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


                    SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(0, 60, 0, 0),
                        margin: const EdgeInsets.all(0),
                        decoration: const BoxDecoration(
                          //color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(15.0),
                              bottomRight: Radius.circular(15.0),
                              topLeft: Radius.circular(15.0),
                              bottomLeft: Radius.circular(15.0)),
                        ),


                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 170,
                                  width: 160,
                                  padding: const EdgeInsets.fromLTRB(
                                      60, 0, 60, 20),
                                  decoration: const BoxDecoration(
                                    //color: Colors.white,
                                    image: DecorationImage(
                                      image: AssetImage(
                                          "assets/KBC logo.png"),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  child: null,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 30,
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: CustomPaint(
                                    size: Size(
                                        size,
                                        (350 * 0.18461538461538463)
                                            .toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                                    painter: Counter(),
                                    child: Container(
                                      //width: 50,
                                      margin: const EdgeInsets.fromLTRB(
                                          0, 15, 0, 15),
                                      //padding: EdgeInsets.fromLTRB(0, 0, 0, 45),
                                      child: Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            165, 0, 5, 0),
                                        child: Text(
                                          "Q." + counter.toString(),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontSize: 22,
                                              color: Colors.white,
                                              fontWeight:
                                              FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 8,
                                  child: Container(),
                                ),
                              ],
                            ),

                            const SizedBox(
                              height: 20,
                            ),

                            SizedBox(
                              width: size,
                              child: CustomPaint(
                                size: Size(
                                    size,
                                    (450 * 0.18461538461538463)
                                        .toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                                painter: QuestionCustomPainter(),
                                child: Container(
                                  //width: 400,
                                  //height: 15,
                                  //margin: const EdgeInsets.all(25),
                                  padding: EdgeInsets.fromLTRB(
                                      200, 30, 200, 35),
                                  child: Text(
                                    quizObject.question,
                                    //"What is the Purpose of Life insurance",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 26,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  flex: 5,
                                  child: InkWell(
                                    onTap: () {
                                      if (_enabledA) {
                                        setState(() {
                                          pressed = "A";

                                          _enabledA = false;
                                          _enabledB = false;
                                          _enabledC = false;
                                          _enabledD = false;

                                          if (quizObject.answerA ==
                                              "Yes") {
                                            _answerA = quizObject.answerA;

                                            _correctA = true;

                                            _correctB = false;
                                            _correctC = false;
                                            _correctD = false;
                                          }
                                        });
                                      }
                                    },
                                    child: SizedBox(
                                      width: size,
                                      child: CustomPaint(
                                        size: Size(
                                            size,
                                            (400 * 0.18461538461538463)
                                                .toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                                        painter: AOptionCustomPainter(
                                            _correctA, pressed),
                                        child: Container(
                                          //width: 250,
                                          height: 80,
                                          //margin: const EdgeInsets.all(25),
                                          padding: EdgeInsets.fromLTRB(
                                              200, 0, 20, 0),
                                          child: Center(
                                            child: Text(
                                              "A. " + quizObject.optionA,
                                              //"A. What is the Purpose of Life insurance",
                                              textAlign: TextAlign.start,
                                              maxLines: 3,
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  color: _correctA
                                                      ? Colors.white
                                                      : !_correctA &&
                                                      pressed ==
                                                          "A"
                                                      ? Colors.white
                                                      : Colors.blue
                                                      .shade800,
                                                  fontWeight:
                                                  FontWeight.w600),
                                              // style: TextStyle(
                                              //     fontSize: 18,
                                              //     color: Colors.white,
                                              //     fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: InkWell(
                                    onTap: () {
                                      if (_enabledB) {
                                        setState(() {
                                          pressed = "B";

                                          _enabledB = false;
                                          _enabledA = false;
                                          _enabledC = false;
                                          _enabledD = false;

                                          if (quizObject.answerB ==
                                              "Yes") {
                                            _answerB = quizObject.answerB;

                                            _correctB = true;

                                            _correctA = false;
                                            _correctC = false;
                                            _correctD = false;
                                          }
                                        });
                                      }
                                    },
                                    child: SizedBox(
                                      width: size,
                                      child: CustomPaint(
                                        size: Size(
                                            size,
                                            (400 * 0.18461538461538463)
                                                .toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                                        painter: BOptionCustomPainter(
                                            _correctB, pressed),
                                        child: Container(
                                          height: 80,
                                          //margin: const EdgeInsets.all(25),
                                          padding: EdgeInsets.fromLTRB(
                                              30, 0, 170, 0),
                                          child: Center(
                                            child: Text(
                                              "B. " + quizObject.optionB,
                                              //"A. What is the Purpose of Life insurance",
                                              textAlign: TextAlign.start,
                                              maxLines: 3,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: _correctB
                                                      ? Colors.white
                                                      : !_correctB &&
                                                      pressed ==
                                                          "B"
                                                      ? Colors.white
                                                      : Colors.blue
                                                      .shade800,
                                                  fontWeight:
                                                  FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  flex: 5,
                                  child: InkWell(
                                    onTap: () {
                                      if (_enabledC) {
                                        setState(() {
                                          pressed = "C";

                                          _enabledC = false;
                                          _enabledA = false;
                                          _enabledB = false;
                                          _enabledD = false;

                                          if (quizObject.answerC ==
                                              "Yes") {
                                            _answerC = quizObject.answerC;

                                            _correctC = true;

                                            _correctA = false;
                                            _correctB = false;
                                            _correctD = false;
                                          }
                                        });
                                      }
                                    },
                                    child: SizedBox(
                                      width: size,
                                      child: CustomPaint(
                                        size: Size(
                                            size,
                                            (400 * 0.18461538461538463)
                                                .toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                                        painter: COptionCustomPainter(
                                            _correctC, pressed),
                                        child: Container(
                                          //width: 250,
                                          height: 80,
                                          //margin: const EdgeInsets.all(25),
                                          padding: EdgeInsets.fromLTRB(
                                              200, 0, 20, 0),
                                          child: Center(
                                            child: Text(
                                              "C. " + quizObject.optionC,
                                              textAlign: TextAlign.start,
                                              maxLines: 3,
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  color: _correctC
                                                      ? Colors.white
                                                      : !_correctC &&
                                                      pressed ==
                                                          "C"
                                                      ? Colors.white
                                                      : Colors.blue
                                                      .shade800,
                                                  fontWeight:
                                                  FontWeight.w600),
                                              // style: TextStyle(
                                              //     fontSize: 18,
                                              //     color: Colors.white,
                                              //     fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: InkWell(
                                    onTap: () {
                                      if (_enabledD) {
                                        setState(() {
                                          pressed = "D";

                                          _enabledD = false;
                                          _enabledA = false;
                                          _enabledB = false;
                                          _enabledC = false;

                                          if (quizObject.answerD ==
                                              "Yes") {
                                            _answerD = quizObject.answerD;

                                            _correctD = true;
                                            _correctA = false;
                                            _correctB = false;
                                            _correctC = false;
                                          }
                                        });
                                      }
                                    },
                                    child: SizedBox(
                                      width: size,
                                      child: CustomPaint(
                                        size: Size(
                                            size,
                                            (400 * 0.18461538461538463)
                                                .toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                                        painter: DOptionCustomPainter(
                                            _correctD, pressed),
                                        child: Container(
                                          //width: 250,
                                          height: 80,
                                          //margin: const EdgeInsets.all(25),
                                          padding: EdgeInsets.fromLTRB(
                                              30, 0, 170, 0),
                                          child: Center(
                                            child: Text(
                                              "D. " + quizObject.optionD,
                                              maxLines: 3,
                                              //"A. What is the Purpose of Life insurance",
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  color: _correctD
                                                      ? Colors.white
                                                      : !_correctD &&
                                                      pressed ==
                                                          "D"
                                                      ? Colors.white
                                                      : Colors.blue
                                                      .shade800,
                                                  fontWeight:
                                                  FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(
                              height: 20,
                            ),

                            Row(
                              children: [
                                index > 0
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
                                        backgroundColor:
                                        Colors.white,
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
                                            ? getQuizQuestion(false)
                                            : Container();
                                      },
                                    ),
                                  ),
                                )
                                    : Container(),
                                const Spacer(),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      0, 0, 30, 0),
                                  child: Container(
                                    height: 45,
                                    width: 120,
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor:
                                        Color(0xff0F5A93),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(
                                                15.0)),
                                        side: const BorderSide(
                                          width: 2,
                                          color: Colors.white,
                                        ),
                                      ),
                                      child: Text(
                                        quizList.length - 1 != index
                                            ? 'Next'
                                            : 'Finish',
                                        style: const TextStyle(
                                            fontSize: 17,
                                            color: Colors.white),
                                      ),
                                      onPressed: () async {
                                        if (index == 0) {
                                          await Common
                                              .setQuestion0Pressed(
                                              pressed);
                                        } else if (index == 1) {
                                          await Common
                                              .setQuestion1Pressed(
                                              pressed);
                                        } else if (index == 2) {
                                          await Common
                                              .setQuestion2Pressed(
                                              pressed);
                                        } else if (index == 3) {
                                          await Common
                                              .setQuestion3Pressed(
                                              pressed);
                                        } else if (index == 4) {
                                          await Common
                                              .setQuestion4Pressed(
                                              pressed);
                                        } else if (index == 5) {
                                          await Common
                                              .setQuestion5Pressed(
                                              pressed);
                                        } else if (index == 6) {
                                          await Common
                                              .setQuestion6Pressed(
                                              pressed);
                                        } else if (index == 7) {
                                          await Common
                                              .setQuestion7Pressed(
                                              pressed);
                                        } else if (index == 8) {
                                          await Common
                                              .setQuestion8Pressed(
                                              pressed);
                                        } else if (index == 9) {
                                          await Common
                                              .setQuestion9Pressed(
                                              pressed);
                                        }

                                        if (pressed == "A") {
                                          if (quizObject.answerA ==
                                              "Yes") {
                                            setState(() {
                                              score = score + 1;
                                            });
                                          } else {
                                            // if(score > 0 ){
                                            //   setState(() {
                                            //     score = score - 1;
                                            //   });
                                            // }
                                          }

                                          if (index == 0) {
                                            await Common
                                                .setQuestion0Pressed(
                                                pressed);

                                            if (quizObject.answerA ==
                                                "Yes") {
                                              await Common
                                                  .setQuestion0CorrectedA(
                                                  true);
                                            } else {
                                              await Common
                                                  .setQuestion0CorrectedA(
                                                  false);
                                            }
                                          } else if (index == 1) {
                                            await Common
                                                .setQuestion1Pressed(
                                                pressed);

                                            if (quizObject.answerA ==
                                                "Yes") {
                                              await Common
                                                  .setQuestion1CorrectedA(
                                                  true);
                                            } else {
                                              await Common
                                                  .setQuestion1CorrectedA(
                                                  false);
                                            }
                                          } else if (index == 2) {
                                            await Common
                                                .setQuestion2Pressed(
                                                pressed);

                                            if (quizObject.answerA ==
                                                "Yes") {
                                              await Common
                                                  .setQuestion2CorrectedA(
                                                  true);
                                            } else {
                                              await Common
                                                  .setQuestion2CorrectedA(
                                                  false);
                                            }
                                          } else if (index == 3) {
                                            await Common
                                                .setQuestion3Pressed(
                                                pressed);

                                            if (quizObject.answerA ==
                                                "Yes") {
                                              await Common
                                                  .setQuestion3CorrectedA(
                                                  true);
                                            } else {
                                              await Common
                                                  .setQuestion3CorrectedA(
                                                  false);
                                            }
                                          } else if (index == 4) {
                                            await Common
                                                .setQuestion4Pressed(
                                                pressed);

                                            if (quizObject.answerA ==
                                                "Yes") {
                                              await Common
                                                  .setQuestion4CorrectedA(
                                                  true);
                                            } else {
                                              await Common
                                                  .setQuestion4CorrectedA(
                                                  false);
                                            }
                                          } else if (index == 5) {
                                            await Common
                                                .setQuestion5Pressed(
                                                pressed);

                                            if (quizObject.answerA ==
                                                "Yes") {
                                              await Common
                                                  .setQuestion5CorrectedA(
                                                  true);
                                            } else {
                                              await Common
                                                  .setQuestion5CorrectedA(
                                                  false);
                                            }
                                          } else if (index == 6) {
                                            await Common
                                                .setQuestion6Pressed(
                                                pressed);

                                            if (quizObject.answerA ==
                                                "Yes") {
                                              await Common
                                                  .setQuestion6CorrectedA(
                                                  true);
                                            } else {
                                              await Common
                                                  .setQuestion6CorrectedA(
                                                  false);
                                            }
                                          } else if (index == 7) {
                                            await Common
                                                .setQuestion7Pressed(
                                                pressed);

                                            if (quizObject.answerA ==
                                                "Yes") {
                                              await Common
                                                  .setQuestion7CorrectedA(
                                                  true);
                                            } else {
                                              await Common
                                                  .setQuestion7CorrectedA(
                                                  false);
                                            }
                                          } else if (index == 8) {
                                            await Common
                                                .setQuestion8Pressed(
                                                pressed);

                                            if (quizObject.answerA ==
                                                "Yes") {
                                              await Common
                                                  .setQuestion8CorrectedA(
                                                  true);
                                            } else {
                                              await Common
                                                  .setQuestion8CorrectedA(
                                                  false);
                                            }
                                          } else if (index == 9) {
                                            await Common
                                                .setQuestion9Pressed(
                                                pressed);
                                            if (quizObject.answerA ==
                                                "Yes") {
                                              await Common
                                                  .setQuestion9CorrectedA(
                                                  true);
                                            } else {
                                              await Common
                                                  .setQuestion9CorrectedA(
                                                  false);
                                            }
                                          }
                                        } else if (pressed == "B") {
                                          if (quizObject.answerB ==
                                              "Yes") {
                                            setState(() {
                                              score = score + 1;
                                            });
                                          } else {
                                            // if(score > 0 ){
                                            //   setState(() {
                                            //     score = score - 1;
                                            //   });
                                            // }
                                          }

                                          if (index == 0) {
                                            await Common
                                                .setQuestion0Pressed(
                                                pressed);

                                            if (quizObject.answerB ==
                                                "Yes") {
                                              await Common
                                                  .setQuestion0CorrectedB(
                                                  true);
                                            } else {
                                              await Common
                                                  .setQuestion0CorrectedB(
                                                  false);
                                            }
                                          } else if (index == 1) {
                                            await Common
                                                .setQuestion1Pressed(
                                                pressed);

                                            if (quizObject.answerB ==
                                                "Yes") {
                                              await Common
                                                  .setQuestion1CorrectedB(
                                                  true);
                                            } else {
                                              await Common
                                                  .setQuestion1CorrectedB(
                                                  false);
                                            }
                                          } else if (index == 2) {
                                            await Common
                                                .setQuestion2Pressed(
                                                pressed);

                                            if (quizObject.answerB ==
                                                "Yes") {
                                              await Common
                                                  .setQuestion2CorrectedB(
                                                  true);
                                            } else {
                                              await Common
                                                  .setQuestion2CorrectedB(
                                                  false);
                                            }
                                          } else if (index == 3) {
                                            await Common
                                                .setQuestion3Pressed(
                                                pressed);

                                            if (quizObject.answerB ==
                                                "Yes") {
                                              await Common
                                                  .setQuestion3CorrectedB(
                                                  true);
                                            } else {
                                              await Common
                                                  .setQuestion3CorrectedB(
                                                  false);
                                            }
                                          } else if (index == 4) {
                                            await Common
                                                .setQuestion4Pressed(
                                                pressed);

                                            if (quizObject.answerB ==
                                                "Yes") {
                                              await Common
                                                  .setQuestion4CorrectedB(
                                                  true);
                                            } else {
                                              await Common
                                                  .setQuestion4CorrectedB(
                                                  false);
                                            }
                                          } else if (index == 5) {
                                            await Common
                                                .setQuestion5Pressed(
                                                pressed);

                                            if (quizObject.answerB ==
                                                "Yes") {
                                              await Common
                                                  .setQuestion5CorrectedB(
                                                  true);
                                            } else {
                                              await Common
                                                  .setQuestion5CorrectedB(
                                                  false);
                                            }
                                          } else if (index == 6) {
                                            await Common
                                                .setQuestion6Pressed(
                                                pressed);

                                            if (quizObject.answerB ==
                                                "Yes") {
                                              await Common
                                                  .setQuestion6CorrectedB(
                                                  true);
                                            } else {
                                              await Common
                                                  .setQuestion6CorrectedB(
                                                  false);
                                            }
                                          } else if (index == 7) {
                                            await Common
                                                .setQuestion7Pressed(
                                                pressed);

                                            if (quizObject.answerB ==
                                                "Yes") {
                                              await Common
                                                  .setQuestion7CorrectedB(
                                                  true);
                                            } else {
                                              await Common
                                                  .setQuestion7CorrectedB(
                                                  false);
                                            }
                                          } else if (index == 8) {
                                            await Common
                                                .setQuestion8Pressed(
                                                pressed);

                                            if (quizObject.answerB ==
                                                "Yes") {
                                              await Common
                                                  .setQuestion8CorrectedB(
                                                  true);
                                            } else {
                                              await Common
                                                  .setQuestion8CorrectedB(
                                                  false);
                                            }
                                          } else if (index == 9) {
                                            await Common
                                                .setQuestion9Pressed(
                                                pressed);
                                            if (quizObject.answerB ==
                                                "Yes") {
                                              await Common
                                                  .setQuestion9CorrectedB(
                                                  true);
                                            } else {
                                              await Common
                                                  .setQuestion9CorrectedB(
                                                  false);
                                            }
                                          }
                                        } else if (pressed == "C") {
                                          if (quizObject.answerC ==
                                              "Yes") {
                                            setState(() {
                                              score = score + 1;
                                            });
                                          } else {
                                            // if(score > 0 ){
                                            //   setState(() {
                                            //     score = score - 1;
                                            //   });
                                            // }
                                          }

                                          if (index == 0) {
                                            await Common
                                                .setQuestion0Pressed(
                                                pressed);

                                            if (quizObject.answerC ==
                                                "Yes") {
                                              await Common
                                                  .setQuestion0CorrectedC(
                                                  true);
                                            } else {
                                              await Common
                                                  .setQuestion0CorrectedC(
                                                  false);
                                            }
                                          } else if (index == 1) {
                                            await Common
                                                .setQuestion1Pressed(
                                                pressed);

                                            if (quizObject.answerC ==
                                                "Yes") {
                                              await Common
                                                  .setQuestion1CorrectedC(
                                                  true);
                                            } else {
                                              await Common
                                                  .setQuestion1CorrectedC(
                                                  false);
                                            }
                                          } else if (index == 2) {
                                            await Common
                                                .setQuestion2Pressed(
                                                pressed);

                                            if (quizObject.answerC ==
                                                "Yes") {
                                              await Common
                                                  .setQuestion2CorrectedC(
                                                  true);
                                            } else {
                                              await Common
                                                  .setQuestion2CorrectedC(
                                                  false);
                                            }
                                          } else if (index == 3) {
                                            await Common
                                                .setQuestion3Pressed(
                                                pressed);

                                            if (quizObject.answerC ==
                                                "Yes") {
                                              await Common
                                                  .setQuestion3CorrectedC(
                                                  true);
                                            } else {
                                              await Common
                                                  .setQuestion3CorrectedC(
                                                  false);
                                            }
                                          } else if (index == 4) {
                                            await Common
                                                .setQuestion4Pressed(
                                                pressed);

                                            if (quizObject.answerC ==
                                                "Yes") {
                                              await Common
                                                  .setQuestion4CorrectedC(
                                                  true);
                                            } else {
                                              await Common
                                                  .setQuestion4CorrectedC(
                                                  false);
                                            }
                                          } else if (index == 5) {
                                            await Common
                                                .setQuestion5Pressed(
                                                pressed);

                                            if (quizObject.answerC ==
                                                "Yes") {
                                              await Common
                                                  .setQuestion5CorrectedC(
                                                  true);
                                            } else {
                                              await Common
                                                  .setQuestion5CorrectedC(
                                                  false);
                                            }
                                          } else if (index == 6) {
                                            await Common
                                                .setQuestion6Pressed(
                                                pressed);

                                            if (quizObject.answerC ==
                                                "Yes") {
                                              await Common
                                                  .setQuestion6CorrectedC(
                                                  true);
                                            } else {
                                              await Common
                                                  .setQuestion6CorrectedC(
                                                  false);
                                            }
                                          } else if (index == 7) {
                                            await Common
                                                .setQuestion7Pressed(
                                                pressed);

                                            if (quizObject.answerC ==
                                                "Yes") {
                                              await Common
                                                  .setQuestion7CorrectedC(
                                                  true);
                                            } else {
                                              await Common
                                                  .setQuestion7CorrectedC(
                                                  false);
                                            }
                                          } else if (index == 8) {
                                            await Common
                                                .setQuestion8Pressed(
                                                pressed);

                                            if (quizObject.answerC ==
                                                "Yes") {
                                              await Common
                                                  .setQuestion8CorrectedC(
                                                  true);
                                            } else {
                                              await Common
                                                  .setQuestion8CorrectedC(
                                                  false);
                                            }
                                          } else if (index == 9) {
                                            await Common
                                                .setQuestion9Pressed(
                                                pressed);
                                            if (quizObject.answerC ==
                                                "Yes") {
                                              await Common
                                                  .setQuestion9CorrectedC(
                                                  true);
                                            } else {
                                              await Common
                                                  .setQuestion9CorrectedC(
                                                  false);
                                            }
                                          }
                                        } else if (pressed == "D") {
                                          if (quizObject.answerD ==
                                              "Yes") {
                                            setState(() {
                                              score = score + 1;
                                            });
                                          } else {
                                            // if(score > 0 ){
                                            //   setState(() {
                                            //     score = score - 1;
                                            //   });
                                            // }
                                          }

                                          if (index == 0) {
                                            await Common
                                                .setQuestion0Pressed(
                                                pressed);

                                            if (quizObject.answerD ==
                                                "Yes") {
                                              await Common
                                                  .setQuestion0CorrectedD(
                                                  true);
                                            } else {
                                              await Common
                                                  .setQuestion0CorrectedD(
                                                  false);
                                            }
                                          } else if (index == 1) {
                                            await Common
                                                .setQuestion1Pressed(
                                                pressed);

                                            if (quizObject.answerD ==
                                                "Yes") {
                                              await Common
                                                  .setQuestion1CorrectedD(
                                                  true);
                                            } else {
                                              await Common
                                                  .setQuestion1CorrectedD(
                                                  false);
                                            }
                                          } else if (index == 2) {
                                            await Common
                                                .setQuestion2Pressed(
                                                pressed);

                                            if (quizObject.answerD ==
                                                "Yes") {
                                              await Common
                                                  .setQuestion2CorrectedD(
                                                  true);
                                            } else {
                                              await Common
                                                  .setQuestion2CorrectedD(
                                                  false);
                                            }
                                          } else if (index == 3) {
                                            await Common
                                                .setQuestion3Pressed(
                                                pressed);

                                            if (quizObject.answerD ==
                                                "Yes") {
                                              await Common
                                                  .setQuestion3CorrectedD(
                                                  true);
                                            } else {
                                              await Common
                                                  .setQuestion3CorrectedD(
                                                  false);
                                            }
                                          } else if (index == 4) {
                                            await Common
                                                .setQuestion4Pressed(
                                                pressed);

                                            if (quizObject.answerD ==
                                                "Yes") {
                                              await Common
                                                  .setQuestion4CorrectedD(
                                                  true);
                                            } else {
                                              await Common
                                                  .setQuestion4CorrectedD(
                                                  false);
                                            }
                                          } else if (index == 5) {
                                            await Common
                                                .setQuestion5Pressed(
                                                pressed);

                                            if (quizObject.answerD ==
                                                "Yes") {
                                              await Common
                                                  .setQuestion5CorrectedD(
                                                  true);
                                            } else {
                                              await Common
                                                  .setQuestion5CorrectedD(
                                                  false);
                                            }
                                          } else if (index == 6) {
                                            await Common
                                                .setQuestion6Pressed(
                                                pressed);

                                            if (quizObject.answerD ==
                                                "Yes") {
                                              await Common
                                                  .setQuestion6CorrectedD(
                                                  true);
                                            } else {
                                              await Common
                                                  .setQuestion6CorrectedD(
                                                  false);
                                            }
                                          } else if (index == 7) {
                                            await Common
                                                .setQuestion7Pressed(
                                                pressed);

                                            if (quizObject.answerD ==
                                                "Yes") {
                                              await Common
                                                  .setQuestion7CorrectedD(
                                                  true);
                                            } else {
                                              await Common
                                                  .setQuestion7CorrectedD(
                                                  false);
                                            }
                                          } else if (index == 8) {
                                            await Common
                                                .setQuestion8Pressed(
                                                pressed);

                                            if (quizObject.answerD ==
                                                "Yes") {
                                              await Common
                                                  .setQuestion8CorrectedD(
                                                  true);
                                            } else {
                                              await Common
                                                  .setQuestion8CorrectedD(
                                                  false);
                                            }
                                          } else if (index == 9) {
                                            await Common
                                                .setQuestion9Pressed(
                                                pressed);
                                            if (quizObject.answerD ==
                                                "Yes") {
                                              await Common
                                                  .setQuestion9CorrectedD(
                                                  true);
                                            } else {
                                              await Common
                                                  .setQuestion9CorrectedD(
                                                  false);
                                            }
                                          }
                                        }

                                        quizList.length - 1 != index
                                            ? getQuizQuestion(true)
                                            : nextScreen(score);
                                        // : Navigator.push(
                                        // context,
                                        // MaterialPageRoute(
                                        //   // builder: (context) => ChessGame()),
                                        //     builder: (context) =>
                                        //         ScoreBoardScreen(
                                        //           Score: score
                                        //               .toString(),
                                        //         )));
                                      },
                                    ),
                                  ),

                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: [
                            //     CustomPaint(
                            //       size: Size(
                            //           size / 50,
                            //           (220 * 0.18461538461538463)
                            //               .toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                            //       painter: LeftRPSCustomPainter(),
                            //     ),
                            //     CustomPaint(
                            //       size: Size(
                            //           size / 50,
                            //           (220 * 0.18461538461538463)
                            //               .toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                            //       painter: RightRPSCustomPainter(),
                            //     ),
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                    )
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
            ),

          ],
        ),
      ),
    );
  }

  void nextScreen(int score){
    dispose();
    Navigator.of(context).pop();
    Navigator.push(
        context,
        MaterialPageRoute(
          // builder: (context) => ChessGame()),
            builder: (context) =>
                ScoreBoardScreen(
                  Score: score
                      .toString(),
                )));
  }

  @override
  void dispose() {
    super.dispose();
    if(_timer.isActive){
      _timer.cancel();
      print("QuizScreen Timer Canceled in Dispose() ");
    }
  }

  // Future<void> clear() async {
  //   var prefs = await SharedPreferences.getInstance();
  //
  //   prefs.remove('0correctA');
  //   prefs.remove('0correctB');
  //   prefs.remove('0correctC');
  //   prefs.remove('0correctD');
  //   prefs.remove('0pressed');
  //   prefs.remove('0answerA');
  //   prefs.remove('0answerB');
  //   prefs.remove('0answerC');
  //   prefs.remove('0answerD');
  //
  //   prefs.remove('1correctA');
  //   prefs.remove('1correctB');
  //   prefs.remove('1correctC');
  //   prefs.remove('1correctD');
  //   prefs.remove('1pressed');
  //   prefs.remove('1answerA');
  //   prefs.remove('1answerB');
  //   prefs.remove('1answerC');
  //   prefs.remove('1answerD');
  //
  //   prefs.remove('2correctA');
  //   prefs.remove('2correctB');
  //   prefs.remove('2correctC');
  //   prefs.remove('2correctD');
  //   prefs.remove('2pressed');
  //   prefs.remove('2answerA');
  //   prefs.remove('2answerB');
  //   prefs.remove('2answerC');
  //   prefs.remove('2answerD');
  //
  //   prefs.remove('3correctA');
  //   prefs.remove('3correctB');
  //   prefs.remove('3correctC');
  //   prefs.remove('3correctD');
  //   prefs.remove('3pressed');
  //   prefs.remove('3answerA');
  //   prefs.remove('3answerB');
  //   prefs.remove('3answerC');
  //   prefs.remove('3answerD');
  //
  //   prefs.remove('4correctA');
  //   prefs.remove('4correctB');
  //   prefs.remove('4correctC');
  //   prefs.remove('4correctD');
  //   prefs.remove('4pressed');
  //   prefs.remove('4answerA');
  //   prefs.remove('4answerB');
  //   prefs.remove('4answerC');
  //   prefs.remove('4answerD');
  //
  //   prefs.remove('5correctA');
  //   prefs.remove('5correctB');
  //   prefs.remove('5correctC');
  //   prefs.remove('5correctD');
  //   prefs.remove('5pressed');
  //   prefs.remove('5answerA');
  //   prefs.remove('5answerB');
  //   prefs.remove('5answerC');
  //   prefs.remove('5answerD');
  //
  //   prefs.remove('6correctA');
  //   prefs.remove('6correctB');
  //   prefs.remove('6correctC');
  //   prefs.remove('6correctD');
  //   prefs.remove('6pressed');
  //   prefs.remove('6answerA');
  //   prefs.remove('6answerB');
  //   prefs.remove('6answerC');
  //   prefs.remove('6answerD');
  //
  //   prefs.remove('7correctA');
  //   prefs.remove('7correctB');
  //   prefs.remove('7correctC');
  //   prefs.remove('7correctD');
  //   prefs.remove('7pressed');
  //   prefs.remove('7answerA');
  //   prefs.remove('7answerB');
  //   prefs.remove('7answerC');
  //   prefs.remove('7answerD');
  //
  //   prefs.remove('8correctA');
  //   prefs.remove('8correctB');
  //   prefs.remove('8correctC');
  //   prefs.remove('8correctD');
  //   prefs.remove('8pressed');
  //   prefs.remove('8answerA');
  //   prefs.remove('8answerB');
  //   prefs.remove('8answerC');
  //   prefs.remove('8answerD');
  //
  //   prefs.remove('9correctA');
  //   prefs.remove('9correctB');
  //   prefs.remove('9correctC');
  //   prefs.remove('9correctD');
  //   prefs.remove('9pressed');
  //   prefs.remove('9answerA');
  //   prefs.remove('9answerB');
  //   prefs.remove('9answerC');
  //   prefs.remove('9answerD');
  //
  //   prefs.remove('10correctA');
  //   prefs.remove('10correctB');
  //   prefs.remove('10correctC');
  //   prefs.remove('10correctD');
  //   prefs.remove('10pressed');
  //   prefs.remove('10answerA');
  //   prefs.remove('10answerB');
  //   prefs.remove('10answerC');
  //   prefs.remove('10answerD');
  //
  //   prefs.remove('11correctA');
  //   prefs.remove('11correctB');
  //   prefs.remove('11correctC');
  //   prefs.remove('11correctD');
  //   prefs.remove('11pressed');
  //   prefs.remove('11answerA');
  //   prefs.remove('11answerB');
  //   prefs.remove('11answerC');
  //   prefs.remove('11answerD');
  //
  //   // prefs.remove('StateData');
  //   // prefs.remove('DistrictData');
  //   // prefs.remove('SchoolData');
  //   // prefs.remove('Top10Data');
  //   // prefs.remove('last');
  //   // prefs.remove('token');
  //   // prefs.remove('allData');
  //   // prefs.remove('complete');
  //   // prefs.remove('DataOnly');
  //   // prefs.remove('chatSound');
  //   // prefs.remove('email_token');
  //   prefs.clear();
  // }
  //
  // void startTimer() {
  //   _start = 300;
  //   const oneSec = Duration(seconds: 1);
  //   _timer = Timer.periodic(
  //     oneSec,
  //     (Timer timer) {
  //       if (_start == 0) {
  //         setState(() {
  //           _timer.cancel();
  //           timer.cancel();
  //         });
  //
  //         showSnackBar(
  //             "5 Minute Limit Over");
  //         clear();
  //         Navigator.of(context).pop();
  //         Navigator.push(
  //             context, MaterialPageRoute(builder: (context) => BannerScreen()));
  //
  //         // setState(() {
  //         //   timer.cancel();
  //         //   _show = true;
  //         // });
  //       } else {
  //         setState(() {
  //           _start--;
  //         });
  //       }
  //     },
  //   );
  // }
  //
  // Future showSnackBar(String error) async {
  //   HapticFeedback.vibrate();
  //   final snackBar = SnackBar(
  //     backgroundColor: LightColor.appBlue,
  //     content: Text(
  //       error,
  //       style: const TextStyle(color: Colors.white, fontSize: 16),
  //     ),
  //     action: SnackBarAction(
  //       textColor: Colors.white,
  //       label: 'Okay',
  //       onPressed: () {
  //         // Some code to undo the change.
  //       },
  //     ),
  //   );
  //
  //   // Find the ScaffoldMessenger in the widget tree
  //   // and use it to show a SnackBar.
  //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //
  //   // flush = Flushbar<bool>(
  //   //   duration: Duration(seconds: 2),
  //   //   isDismissible: true,
  //   //   title: " ",
  //   //   //message: "Enter correct number!",
  //   //   message: error.toString(),
  //   //   showProgressIndicator: false,
  //   //   backgroundGradient: LinearGradient(
  //   //     colors: [LightColor.ypurple, Colors.white],
  //   //     stops: [0.6, 1],
  //   //   ),
  //   //   margin: EdgeInsets.all(20),
  //   //   icon: Icon(
  //   //     Icons.warning_rounded,
  //   //     color: Colors.white,
  //   //   ),
  //   // )
  //   //   ..show(context).then((result) {
  //   //   });
  //   // flush.duration;
  //   // HapticFeedback.vibrate();
  // }
  //
  // @override
  // void initState() {
  //   startTimer();
  //   getInitQuizQuestion();
  //   super.initState();
  // }
  //
  // @override
  // Widget build(BuildContext context) {
  //   final double heightSize = MediaQuery.of(context).size.height;
  //   final double widthSize = MediaQuery.of(context).size.width;
  //
  //   var size = MediaQuery.of(context).size.width;
  //   // SystemChrome.setPreferredOrientations([
  //   //   DeviceOrientation.landscapeLeft,
  //   //   DeviceOrientation.landscapeRight,
  //   // ]);
  //
  //   return WillPopScope(
  //     onWillPop: () async => false,
  //     child: Scaffold(
  //       extendBodyBehindAppBar: false,
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
  //           widthSize < 900
  //               ? Container(
  //                   width: MediaQuery.of(context).size.width,
  //                   height: MediaQuery.of(context).size.height,
  //                   decoration: const BoxDecoration(
  //                     image: DecorationImage(
  //                       image: AssetImage("assets/images/Background.png"),
  //                       fit: BoxFit.fill,
  //                     ),
  //                   ),
  //                   child: SingleChildScrollView(
  //                     child: Column(
  //                       children: [
  //                         //
  //                         // Padding(
  //                         //   padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
  //                         //   child: Row(
  //                         //     mainAxisAlignment: MainAxisAlignment.center,
  //                         //     children: [
  //                         //       Container(
  //                         //         // height: 70,
  //                         //         // width: 160,
  //                         //         padding: const EdgeInsets.all(14),
  //                         //         decoration: const BoxDecoration(
  //                         //           color: Colors.white,
  //                         //           borderRadius: BorderRadius.only(
  //                         //               topRight: Radius.circular(15.0),
  //                         //               bottomRight: Radius.circular(15.0),
  //                         //               topLeft: Radius.circular(15.0),
  //                         //               bottomLeft: Radius.circular(15.0)),
  //                         //         ),
  //                         //         child: Container(
  //                         //           // height: 50,
  //                         //           // width: 100,
  //                         //           padding:
  //                         //               const EdgeInsets.fromLTRB(60, 20, 60, 20),
  //                         //           decoration: const BoxDecoration(
  //                         //             color: Colors.white,
  //                         //             image: DecorationImage(
  //                         //               image: AssetImage(
  //                         //                   "assets/images/site-logo.png"),
  //                         //               fit: BoxFit.contain,
  //                         //             ),
  //                         //           ),
  //                         //           child: null,
  //                         //         ),
  //                         //       ),
  //                         //     ],
  //                         //   ),
  //                         // ),
  //                         // const SizedBox(
  //                         //   height: 10,
  //                         // ),
  //
  //                         SingleChildScrollView(
  //                           child: Container(
  //                             padding: EdgeInsets.fromLTRB(0, 60, 0, 0),
  //                             margin: const EdgeInsets.all(0),
  //                             decoration: const BoxDecoration(
  //                               //color: Colors.white,
  //                               borderRadius: BorderRadius.only(
  //                                   topRight: Radius.circular(15.0),
  //                                   bottomRight: Radius.circular(15.0),
  //                                   topLeft: Radius.circular(15.0),
  //                                   bottomLeft: Radius.circular(15.0)),
  //                             ),
  //                             child: Column(
  //                               crossAxisAlignment: CrossAxisAlignment.center,
  //                               mainAxisAlignment: MainAxisAlignment.end,
  //                               children: [
  //                                 Row(
  //                                   mainAxisAlignment: MainAxisAlignment.center,
  //                                   children: [
  //                                     Container(
  //                                       height: 170,
  //                                       width: 160,
  //                                       padding: const EdgeInsets.fromLTRB(
  //                                           60, 0, 60, 20),
  //                                       decoration: const BoxDecoration(
  //                                         //color: Colors.white,
  //                                         image: DecorationImage(
  //                                           image: AssetImage(
  //                                               "assets/KBC logo.png"),
  //                                           fit: BoxFit.contain,
  //                                         ),
  //                                       ),
  //                                       child: null,
  //                                     ),
  //                                   ],
  //                                 ),
  //
  //                                 const SizedBox(
  //                                   height: 30,
  //                                 ),
  //
  //                                 Row(
  //                                   mainAxisAlignment: MainAxisAlignment.start,
  //                                   children: [
  //                                     Expanded(
  //                                       flex: 3,
  //                                       child: CustomPaint(
  //                                         size: Size(
  //                                             size,
  //                                             (200 * 0.18461538461538463)
  //                                                 .toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
  //                                         painter: Counter(),
  //                                         child: Container(
  //                                           width: 50,
  //                                           margin: const EdgeInsets.fromLTRB(
  //                                               0, 15, 0, 15),
  //                                           //padding: EdgeInsets.fromLTRB(0, 0, 0, 45),
  //                                           child: Padding(
  //                                             padding: EdgeInsets.fromLTRB(
  //                                                 65, 0, 5, 0),
  //                                             child: Text(
  //                                               "Q." + counter.toString(),
  //                                               textAlign: TextAlign.center,
  //                                               style: const TextStyle(
  //                                                   fontSize: 16,
  //                                                   color: Colors.white,
  //                                                   fontWeight:
  //                                                       FontWeight.w600),
  //                                             ),
  //                                           ),
  //                                         ),
  //                                       ),
  //                                     ),
  //                                     Expanded(
  //                                       flex: 8,
  //                                       child: Container(),
  //                                     ),
  //                                   ],
  //                                 ),
  //
  //                                 const SizedBox(
  //                                   height: 20,
  //                                 ),
  //
  //                                 /// question box
  //                                 SizedBox(
  //                                   width: size,
  //                                   child: CustomPaint(
  //                                     size: Size(
  //                                         size,
  //                                         (150 * 0.18461538461538463)
  //                                             .toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
  //                                     painter: QuestionCustomPainter(),
  //                                     child: Container(
  //                                       width: 450,
  //                                       margin: const EdgeInsets.fromLTRB(
  //                                           0, 20, 0, 20),
  //                                       //padding: EdgeInsets.fromLTRB(0, 0, 0, 45),
  //                                       child: Padding(
  //                                         padding:
  //                                             EdgeInsets.fromLTRB(75, 0, 75, 0),
  //                                         child: Text(
  //                                           quizObject.question,
  //                                           //"What is the Purpose of Life insurance",
  //                                           textAlign: TextAlign.center,
  //                                           style: TextStyle(
  //                                               fontSize: 16,
  //                                               color: Colors.white,
  //                                               fontWeight: FontWeight.w600),
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ),
  //
  //                                 const SizedBox(
  //                                   height: 20,
  //                                 ),
  //
  //                                 Column(
  //                                   children: [
  //                                     InkWell(
  //                                       onTap: () {
  //                                         if (_enabledA) {
  //                                           setState(() {
  //                                             pressed = "A";
  //
  //                                             _enabledA = false;
  //                                             _enabledB = false;
  //                                             _enabledC = false;
  //                                             _enabledD = false;
  //
  //                                             if (quizObject.answerA == "Yes") {
  //                                               _answerA = quizObject.answerA;
  //
  //                                               _correctA = true;
  //                                               _correctB = false;
  //                                               _correctC = false;
  //                                               _correctD = false;
  //                                             }
  //                                           });
  //                                         }
  //                                       },
  //                                       child: SizedBox(
  //                                         height: 55,
  //                                         width: size,
  //                                         child: CustomPaint(
  //                                           painter: AMobileOptionCustomPainter(
  //                                               _correctA, pressed),
  //                                           size: Size(
  //                                               size,
  //                                               (400 * 0.18461538461538463)
  //                                                   .toDouble()),
  //                                           child: Center(
  //                                             child: Padding(
  //                                               padding: EdgeInsets.fromLTRB(
  //                                                   75, 0, 75, 0),
  //                                               child: Text(
  //                                                 "A. " + quizObject.optionA,
  //                                                 //"A. What is the Purpose of Life insurance",
  //                                                 textAlign: TextAlign.center,
  //                                                 maxLines: 3,
  //                                                 style: TextStyle(
  //                                                     fontSize: 14,
  //                                                     color: _correctA
  //                                                         ? Colors.white
  //                                                         : !_correctA &&
  //                                                                 pressed == "A"
  //                                                             ? Colors.white
  //                                                             : Colors.blue
  //                                                                 .shade800,
  //                                                     fontWeight:
  //                                                         FontWeight.w600),
  //                                                 // style: TextStyle(
  //                                                 //     fontSize: 14,
  //                                                 //     color: Colors.white,
  //                                                 //     fontWeight: FontWeight.w600),
  //                                               ),
  //                                             ),
  //                                           ),
  //                                         ),
  //                                       ),
  //                                     ),
  //                                     const SizedBox(
  //                                       height: 10,
  //                                     ),
  //                                     InkWell(
  //                                       onTap: () {
  //                                         if (_enabledB) {
  //                                           setState(() {
  //                                             pressed = "B";
  //
  //                                             _enabledB = false;
  //                                             _enabledA = false;
  //                                             _enabledC = false;
  //                                             _enabledD = false;
  //
  //                                             if (quizObject.answerB == "Yes") {
  //                                               _answerB = quizObject.answerB;
  //
  //                                               _correctB = true;
  //
  //                                               _correctA = false;
  //                                               _correctC = false;
  //                                               _correctD = false;
  //                                             }
  //                                           });
  //                                         }
  //                                       },
  //                                       child: SizedBox(
  //                                         height: 55,
  //                                         width: size,
  //                                         child: CustomPaint(
  //                                           size: Size(
  //                                               size,
  //                                               (400 * 0.18461538461538463)
  //                                                   .toDouble()),
  //                                           painter: BMobileOptionCustomPainter(
  //                                               _correctB, pressed),
  //                                           child: Center(
  //                                             child: Padding(
  //                                               padding: EdgeInsets.fromLTRB(
  //                                                   75, 0, 75, 0),
  //                                               child: Text(
  //                                                 "B. " + quizObject.optionB,
  //                                                 //"A. What is the Purpose of Life insurance",
  //                                                 textAlign: TextAlign.center,
  //                                                 style: TextStyle(
  //                                                     fontSize: 14,
  //                                                     color: _correctB
  //                                                         ? Colors.white
  //                                                         //: !_enabledB && !_correctB
  //                                                         : !_correctB &&
  //                                                                 pressed == "B"
  //                                                             ? Colors.white
  //                                                             : Colors.blue
  //                                                                 .shade800,
  //
  //                                                     // ? Colors.blue.shade800
  //                                                     //     : Colors.white,
  //                                                     fontWeight:
  //                                                         FontWeight.w600),
  //                                                 // style: TextStyle(
  //                                                 //     fontSize: 14,
  //                                                 //     color: Colors.white,
  //                                                 //     fontWeight: FontWeight.w600),
  //                                               ),
  //                                             ),
  //                                           ),
  //                                         ),
  //                                       ),
  //                                     ),
  //                                     const SizedBox(
  //                                       height: 10,
  //                                     ),
  //                                     InkWell(
  //                                       onTap: () {
  //                                         if (_enabledC) {
  //                                           setState(() {
  //                                             pressed = "C";
  //
  //                                             _enabledC = false;
  //                                             _enabledA = false;
  //                                             _enabledB = false;
  //                                             _enabledD = false;
  //
  //                                             if (quizObject.answerC == "Yes") {
  //                                               _answerC = quizObject.answerC;
  //
  //                                               _correctC = true;
  //
  //                                               _correctA = false;
  //                                               _correctB = false;
  //                                               _correctD = false;
  //                                             }
  //                                           });
  //                                         }
  //                                       },
  //                                       child: SizedBox(
  //                                         height: 55,
  //                                         width: size,
  //                                         child: CustomPaint(
  //                                           size: Size(
  //                                               size,
  //                                               (400 * 0.18461538461538463)
  //                                                   .toDouble()),
  //                                           painter: CMobileOptionCustomPainter(
  //                                               _correctC, pressed),
  //                                           child: Center(
  //                                             child: Padding(
  //                                               padding: EdgeInsets.fromLTRB(
  //                                                   75, 0, 75, 0),
  //                                               child: Text(
  //                                                 "C. " + quizObject.optionC,
  //                                                 //"A. What is the Purpose of Life insurance",
  //                                                 textAlign: TextAlign.center,
  //                                                 style: TextStyle(
  //                                                     fontSize: 14,
  //                                                     color: _correctC
  //                                                         ? Colors.white
  //                                                         : !_correctC &&
  //                                                                 pressed == "C"
  //                                                             ? Colors.white
  //                                                             : Colors.blue
  //                                                                 .shade800,
  //                                                     fontWeight:
  //                                                         FontWeight.w600),
  //                                                 // style: TextStyle(
  //                                                 //     fontSize: 14,
  //                                                 //     color: Colors.white,
  //                                                 //     fontWeight: FontWeight.w600),
  //                                               ),
  //                                             ),
  //                                           ),
  //                                         ),
  //                                       ),
  //                                     ),
  //                                     const SizedBox(
  //                                       height: 10,
  //                                     ),
  //                                     InkWell(
  //                                       onTap: () {
  //                                         if (_enabledD) {
  //                                           setState(() {
  //                                             pressed = "D";
  //
  //                                             _enabledD = false;
  //                                             _enabledA = false;
  //                                             _enabledB = false;
  //                                             _enabledC = false;
  //
  //                                             if (quizObject.answerD == "Yes") {
  //                                               _answerD = quizObject.answerD;
  //
  //                                               _correctD = true;
  //                                               _correctA = false;
  //                                               _correctB = false;
  //                                               _correctC = false;
  //                                             }
  //                                           });
  //                                         }
  //                                       },
  //                                       child: SizedBox(
  //                                         height: 55,
  //                                         width: size,
  //                                         child: CustomPaint(
  //                                           size: Size(
  //                                               size,
  //                                               (400 * 0.18461538461538463)
  //                                                   .toDouble()),
  //                                           painter: DMobileOptionCustomPainter(
  //                                               _correctD, pressed),
  //                                           child: Center(
  //                                             child: Padding(
  //                                               padding: EdgeInsets.fromLTRB(
  //                                                   75, 0, 75, 0),
  //                                               child: Text(
  //                                                 "D. " + quizObject.optionD,
  //                                                 //"A. What is the Purpose of Life insurance",
  //                                                 textAlign: TextAlign.center,
  //                                                 maxLines: 3,
  //                                                 style: TextStyle(
  //                                                     fontSize: 14,
  //                                                     color: _correctD
  //                                                         ? Colors.white
  //                                                         : !_correctD &&
  //                                                                 pressed == "D"
  //                                                             ? Colors.white
  //                                                             : Colors.blue
  //                                                                 .shade800,
  //                                                     fontWeight:
  //                                                         FontWeight.w600),
  //                                                 // style: TextStyle(
  //                                                 //     fontSize: 14,
  //                                                 //     color: Colors.white,
  //                                                 //     fontWeight: FontWeight.w600),
  //                                               ),
  //                                             ),
  //                                           ),
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 ),
  //
  //                                 const SizedBox(
  //                                   height: 20,
  //                                 ),
  //
  //                                 Row(
  //                                   children: [
  //                                     index > 0
  //                                         ? Padding(
  //                                             padding:
  //                                                 const EdgeInsets.fromLTRB(
  //                                                     30, 0, 0, 0),
  //                                             child: Container(
  //                                               height: 45,
  //                                               width: 120,
  //                                               child: OutlinedButton(
  //                                                 style:
  //                                                     OutlinedButton.styleFrom(
  //                                                   backgroundColor:
  //                                                       Colors.white,
  //                                                   shape:
  //                                                       RoundedRectangleBorder(
  //                                                           borderRadius:
  //                                                               BorderRadius
  //                                                                   .circular(
  //                                                                       10.0)),
  //                                                   side: const BorderSide(
  //                                                     width: 2,
  //                                                     color: Color(0xff0F5A93),
  //                                                   ),
  //                                                 ),
  //                                                 child: const Text(
  //                                                   "Previous",
  //                                                   style: TextStyle(
  //                                                     fontSize: 16,
  //                                                     fontWeight:
  //                                                         FontWeight.bold,
  //                                                     color: Color(0xff0F5A93),
  //                                                   ),
  //                                                 ),
  //                                                 onPressed: () {
  //                                                   index > 0
  //                                                       ? getQuizQuestion(false)
  //                                                       : Container();
  //                                                 },
  //                                               ),
  //                                             ),
  //                                           )
  //                                         : Container(),
  //                                     const Spacer(),
  //                                     Padding(
  //                                       padding: const EdgeInsets.fromLTRB(
  //                                           0, 0, 30, 0),
  //                                       child: OutlinedButton(
  //                                         style: OutlinedButton.styleFrom(
  //                                           backgroundColor: Color(0xff0F5A93),
  //                                           shape: RoundedRectangleBorder(
  //                                               borderRadius:
  //                                                   BorderRadius.circular(
  //                                                       10.0)),
  //                                           side: const BorderSide(
  //                                             width: 1,
  //                                             color: Colors.white,
  //                                           ),
  //                                         ),
  //                                         child: Container(
  //                                           width: 60,
  //                                           height: 40,
  //                                           child: Center(
  //                                             child: Text(
  //                                               quizList.length - 1 != index
  //                                                   ? 'Next'
  //                                                   : 'Finish',
  //                                               style: const TextStyle(
  //                                                   fontSize: 17,
  //                                                   color: Colors.white),
  //                                             ),
  //                                           ),
  //                                         ),
  //                                         onPressed: () async {
  //                                           if (index == 0) {
  //                                             await Common.setQuestion0Pressed(
  //                                                 pressed);
  //                                           } else if (index == 1) {
  //                                             await Common.setQuestion1Pressed(
  //                                                 pressed);
  //                                           } else if (index == 2) {
  //                                             await Common.setQuestion2Pressed(
  //                                                 pressed);
  //                                           } else if (index == 3) {
  //                                             await Common.setQuestion3Pressed(
  //                                                 pressed);
  //                                           } else if (index == 4) {
  //                                             await Common.setQuestion4Pressed(
  //                                                 pressed);
  //                                           } else if (index == 5) {
  //                                             await Common.setQuestion5Pressed(
  //                                                 pressed);
  //                                           } else if (index == 6) {
  //                                             await Common.setQuestion6Pressed(
  //                                                 pressed);
  //                                           } else if (index == 7) {
  //                                             await Common.setQuestion7Pressed(
  //                                                 pressed);
  //                                           } else if (index == 8) {
  //                                             await Common.setQuestion8Pressed(
  //                                                 pressed);
  //                                           } else if (index == 9) {
  //                                             await Common.setQuestion9Pressed(
  //                                                 pressed);
  //                                           }
  //
  //                                           if (pressed == "A") {
  //                                             if (quizObject.answerA == "Yes") {
  //                                               setState(() {
  //                                                 score = score + 1;
  //                                               });
  //                                             } else {
  //                                               // if(score > 0 ){
  //                                               //   setState(() {
  //                                               //     score = score - 1;
  //                                               //   });
  //                                               // }
  //                                             }
  //
  //                                             if (index == 0) {
  //                                               await Common
  //                                                   .setQuestion0Pressed(
  //                                                       pressed);
  //
  //                                               if (quizObject.answerA ==
  //                                                   "Yes") {
  //                                                 await Common
  //                                                     .setQuestion0CorrectedA(
  //                                                         true);
  //                                               } else {
  //                                                 await Common
  //                                                     .setQuestion0CorrectedA(
  //                                                         false);
  //                                               }
  //                                             } else if (index == 1) {
  //                                               await Common
  //                                                   .setQuestion1Pressed(
  //                                                       pressed);
  //
  //                                               if (quizObject.answerA ==
  //                                                   "Yes") {
  //                                                 await Common
  //                                                     .setQuestion1CorrectedA(
  //                                                         true);
  //                                               } else {
  //                                                 await Common
  //                                                     .setQuestion1CorrectedA(
  //                                                         false);
  //                                               }
  //                                             } else if (index == 2) {
  //                                               await Common
  //                                                   .setQuestion2Pressed(
  //                                                       pressed);
  //
  //                                               if (quizObject.answerA ==
  //                                                   "Yes") {
  //                                                 await Common
  //                                                     .setQuestion2CorrectedA(
  //                                                         true);
  //                                               } else {
  //                                                 await Common
  //                                                     .setQuestion2CorrectedA(
  //                                                         false);
  //                                               }
  //                                             } else if (index == 3) {
  //                                               await Common
  //                                                   .setQuestion3Pressed(
  //                                                       pressed);
  //
  //                                               if (quizObject.answerA ==
  //                                                   "Yes") {
  //                                                 await Common
  //                                                     .setQuestion3CorrectedA(
  //                                                         true);
  //                                               } else {
  //                                                 await Common
  //                                                     .setQuestion3CorrectedA(
  //                                                         false);
  //                                               }
  //                                             } else if (index == 4) {
  //                                               await Common
  //                                                   .setQuestion4Pressed(
  //                                                       pressed);
  //
  //                                               if (quizObject.answerA ==
  //                                                   "Yes") {
  //                                                 await Common
  //                                                     .setQuestion4CorrectedA(
  //                                                         true);
  //                                               } else {
  //                                                 await Common
  //                                                     .setQuestion4CorrectedA(
  //                                                         false);
  //                                               }
  //                                             } else if (index == 5) {
  //                                               await Common
  //                                                   .setQuestion5Pressed(
  //                                                       pressed);
  //
  //                                               if (quizObject.answerA ==
  //                                                   "Yes") {
  //                                                 await Common
  //                                                     .setQuestion5CorrectedA(
  //                                                         true);
  //                                               } else {
  //                                                 await Common
  //                                                     .setQuestion5CorrectedA(
  //                                                         false);
  //                                               }
  //                                             } else if (index == 6) {
  //                                               await Common
  //                                                   .setQuestion6Pressed(
  //                                                       pressed);
  //
  //                                               if (quizObject.answerA ==
  //                                                   "Yes") {
  //                                                 await Common
  //                                                     .setQuestion6CorrectedA(
  //                                                         true);
  //                                               } else {
  //                                                 await Common
  //                                                     .setQuestion6CorrectedA(
  //                                                         false);
  //                                               }
  //                                             } else if (index == 7) {
  //                                               await Common
  //                                                   .setQuestion7Pressed(
  //                                                       pressed);
  //
  //                                               if (quizObject.answerA ==
  //                                                   "Yes") {
  //                                                 await Common
  //                                                     .setQuestion7CorrectedA(
  //                                                         true);
  //                                               } else {
  //                                                 await Common
  //                                                     .setQuestion7CorrectedA(
  //                                                         false);
  //                                               }
  //                                             } else if (index == 8) {
  //                                               await Common
  //                                                   .setQuestion8Pressed(
  //                                                       pressed);
  //
  //                                               if (quizObject.answerA ==
  //                                                   "Yes") {
  //                                                 await Common
  //                                                     .setQuestion8CorrectedA(
  //                                                         true);
  //                                               } else {
  //                                                 await Common
  //                                                     .setQuestion8CorrectedA(
  //                                                         false);
  //                                               }
  //                                             } else if (index == 9) {
  //                                               await Common
  //                                                   .setQuestion9Pressed(
  //                                                       pressed);
  //                                               if (quizObject.answerA ==
  //                                                   "Yes") {
  //                                                 await Common
  //                                                     .setQuestion9CorrectedA(
  //                                                         true);
  //                                               } else {
  //                                                 await Common
  //                                                     .setQuestion9CorrectedA(
  //                                                         false);
  //                                               }
  //                                             }
  //                                           } else if (pressed == "B") {
  //                                             if (quizObject.answerB == "Yes") {
  //                                               setState(() {
  //                                                 score = score + 1;
  //                                               });
  //                                             } else {
  //                                               // if(score > 0 ){
  //                                               //   setState(() {
  //                                               //     score = score - 1;
  //                                               //   });
  //                                               // }
  //                                             }
  //
  //                                             if (index == 0) {
  //                                               await Common
  //                                                   .setQuestion0Pressed(
  //                                                       pressed);
  //
  //                                               if (quizObject.answerB ==
  //                                                   "Yes") {
  //                                                 await Common
  //                                                     .setQuestion0CorrectedB(
  //                                                         true);
  //                                               } else {
  //                                                 await Common
  //                                                     .setQuestion0CorrectedB(
  //                                                         false);
  //                                               }
  //                                             } else if (index == 1) {
  //                                               await Common
  //                                                   .setQuestion1Pressed(
  //                                                       pressed);
  //
  //                                               if (quizObject.answerB ==
  //                                                   "Yes") {
  //                                                 await Common
  //                                                     .setQuestion1CorrectedB(
  //                                                         true);
  //                                               } else {
  //                                                 await Common
  //                                                     .setQuestion1CorrectedB(
  //                                                         false);
  //                                               }
  //                                             } else if (index == 2) {
  //                                               await Common
  //                                                   .setQuestion2Pressed(
  //                                                       pressed);
  //
  //                                               if (quizObject.answerB ==
  //                                                   "Yes") {
  //                                                 await Common
  //                                                     .setQuestion2CorrectedB(
  //                                                         true);
  //                                               } else {
  //                                                 await Common
  //                                                     .setQuestion2CorrectedB(
  //                                                         false);
  //                                               }
  //                                             } else if (index == 3) {
  //                                               await Common
  //                                                   .setQuestion3Pressed(
  //                                                       pressed);
  //
  //                                               if (quizObject.answerB ==
  //                                                   "Yes") {
  //                                                 await Common
  //                                                     .setQuestion3CorrectedB(
  //                                                         true);
  //                                               } else {
  //                                                 await Common
  //                                                     .setQuestion3CorrectedB(
  //                                                         false);
  //                                               }
  //                                             } else if (index == 4) {
  //                                               await Common
  //                                                   .setQuestion4Pressed(
  //                                                       pressed);
  //
  //                                               if (quizObject.answerB ==
  //                                                   "Yes") {
  //                                                 await Common
  //                                                     .setQuestion4CorrectedB(
  //                                                         true);
  //                                               } else {
  //                                                 await Common
  //                                                     .setQuestion4CorrectedB(
  //                                                         false);
  //                                               }
  //                                             } else if (index == 5) {
  //                                               await Common
  //                                                   .setQuestion5Pressed(
  //                                                       pressed);
  //
  //                                               if (quizObject.answerB ==
  //                                                   "Yes") {
  //                                                 await Common
  //                                                     .setQuestion5CorrectedB(
  //                                                         true);
  //                                               } else {
  //                                                 await Common
  //                                                     .setQuestion5CorrectedB(
  //                                                         false);
  //                                               }
  //                                             } else if (index == 6) {
  //                                               await Common
  //                                                   .setQuestion6Pressed(
  //                                                       pressed);
  //
  //                                               if (quizObject.answerB ==
  //                                                   "Yes") {
  //                                                 await Common
  //                                                     .setQuestion6CorrectedB(
  //                                                         true);
  //                                               } else {
  //                                                 await Common
  //                                                     .setQuestion6CorrectedB(
  //                                                         false);
  //                                               }
  //                                             } else if (index == 7) {
  //                                               await Common
  //                                                   .setQuestion7Pressed(
  //                                                       pressed);
  //
  //                                               if (quizObject.answerB ==
  //                                                   "Yes") {
  //                                                 await Common
  //                                                     .setQuestion7CorrectedB(
  //                                                         true);
  //                                               } else {
  //                                                 await Common
  //                                                     .setQuestion7CorrectedB(
  //                                                         false);
  //                                               }
  //                                             } else if (index == 8) {
  //                                               await Common
  //                                                   .setQuestion8Pressed(
  //                                                       pressed);
  //
  //                                               if (quizObject.answerB ==
  //                                                   "Yes") {
  //                                                 await Common
  //                                                     .setQuestion8CorrectedB(
  //                                                         true);
  //                                               } else {
  //                                                 await Common
  //                                                     .setQuestion8CorrectedB(
  //                                                         false);
  //                                               }
  //                                             } else if (index == 9) {
  //                                               await Common
  //                                                   .setQuestion9Pressed(
  //                                                       pressed);
  //                                               if (quizObject.answerB ==
  //                                                   "Yes") {
  //                                                 await Common
  //                                                     .setQuestion9CorrectedB(
  //                                                         true);
  //                                               } else {
  //                                                 await Common
  //                                                     .setQuestion9CorrectedB(
  //                                                         false);
  //                                               }
  //                                             }
  //                                           } else if (pressed == "C") {
  //                                             if (quizObject.answerC == "Yes") {
  //                                               setState(() {
  //                                                 score = score + 1;
  //                                               });
  //                                             } else {
  //                                               // if(score > 0 ){
  //                                               //   setState(() {
  //                                               //     score = score - 1;
  //                                               //   });
  //                                               // }
  //                                             }
  //
  //                                             if (index == 0) {
  //                                               await Common
  //                                                   .setQuestion0Pressed(
  //                                                       pressed);
  //
  //                                               if (quizObject.answerC ==
  //                                                   "Yes") {
  //                                                 await Common
  //                                                     .setQuestion0CorrectedC(
  //                                                         true);
  //                                               } else {
  //                                                 await Common
  //                                                     .setQuestion0CorrectedC(
  //                                                         false);
  //                                               }
  //                                             } else if (index == 1) {
  //                                               await Common
  //                                                   .setQuestion1Pressed(
  //                                                       pressed);
  //
  //                                               if (quizObject.answerC ==
  //                                                   "Yes") {
  //                                                 await Common
  //                                                     .setQuestion1CorrectedC(
  //                                                         true);
  //                                               } else {
  //                                                 await Common
  //                                                     .setQuestion1CorrectedC(
  //                                                         false);
  //                                               }
  //                                             } else if (index == 2) {
  //                                               await Common
  //                                                   .setQuestion2Pressed(
  //                                                       pressed);
  //
  //                                               if (quizObject.answerC ==
  //                                                   "Yes") {
  //                                                 await Common
  //                                                     .setQuestion2CorrectedC(
  //                                                         true);
  //                                               } else {
  //                                                 await Common
  //                                                     .setQuestion2CorrectedC(
  //                                                         false);
  //                                               }
  //                                             } else if (index == 3) {
  //                                               await Common
  //                                                   .setQuestion3Pressed(
  //                                                       pressed);
  //
  //                                               if (quizObject.answerC ==
  //                                                   "Yes") {
  //                                                 await Common
  //                                                     .setQuestion3CorrectedC(
  //                                                         true);
  //                                               } else {
  //                                                 await Common
  //                                                     .setQuestion3CorrectedC(
  //                                                         false);
  //                                               }
  //                                             } else if (index == 4) {
  //                                               await Common
  //                                                   .setQuestion4Pressed(
  //                                                       pressed);
  //
  //                                               if (quizObject.answerC ==
  //                                                   "Yes") {
  //                                                 await Common
  //                                                     .setQuestion4CorrectedC(
  //                                                         true);
  //                                               } else {
  //                                                 await Common
  //                                                     .setQuestion4CorrectedC(
  //                                                         false);
  //                                               }
  //                                             } else if (index == 5) {
  //                                               await Common
  //                                                   .setQuestion5Pressed(
  //                                                       pressed);
  //
  //                                               if (quizObject.answerC ==
  //                                                   "Yes") {
  //                                                 await Common
  //                                                     .setQuestion5CorrectedC(
  //                                                         true);
  //                                               } else {
  //                                                 await Common
  //                                                     .setQuestion5CorrectedC(
  //                                                         false);
  //                                               }
  //                                             } else if (index == 6) {
  //                                               await Common
  //                                                   .setQuestion6Pressed(
  //                                                       pressed);
  //
  //                                               if (quizObject.answerC ==
  //                                                   "Yes") {
  //                                                 await Common
  //                                                     .setQuestion6CorrectedC(
  //                                                         true);
  //                                               } else {
  //                                                 await Common
  //                                                     .setQuestion6CorrectedC(
  //                                                         false);
  //                                               }
  //                                             } else if (index == 7) {
  //                                               await Common
  //                                                   .setQuestion7Pressed(
  //                                                       pressed);
  //
  //                                               if (quizObject.answerC ==
  //                                                   "Yes") {
  //                                                 await Common
  //                                                     .setQuestion7CorrectedC(
  //                                                         true);
  //                                               } else {
  //                                                 await Common
  //                                                     .setQuestion7CorrectedC(
  //                                                         false);
  //                                               }
  //                                             } else if (index == 8) {
  //                                               await Common
  //                                                   .setQuestion8Pressed(
  //                                                       pressed);
  //
  //                                               if (quizObject.answerC ==
  //                                                   "Yes") {
  //                                                 await Common
  //                                                     .setQuestion8CorrectedC(
  //                                                         true);
  //                                               } else {
  //                                                 await Common
  //                                                     .setQuestion8CorrectedC(
  //                                                         false);
  //                                               }
  //                                             } else if (index == 9) {
  //                                               await Common
  //                                                   .setQuestion9Pressed(
  //                                                       pressed);
  //                                               if (quizObject.answerC ==
  //                                                   "Yes") {
  //                                                 await Common
  //                                                     .setQuestion9CorrectedC(
  //                                                         true);
  //                                               } else {
  //                                                 await Common
  //                                                     .setQuestion9CorrectedC(
  //                                                         false);
  //                                               }
  //                                             }
  //                                           } else if (pressed == "D") {
  //                                             if (quizObject.answerD == "Yes") {
  //                                               setState(() {
  //                                                 score = score + 1;
  //                                               });
  //                                             } else {
  //                                               // if(score > 0 ){
  //                                               //   setState(() {
  //                                               //     score = score - 1;
  //                                               //   });
  //                                               // }
  //                                             }
  //
  //                                             if (index == 0) {
  //                                               await Common
  //                                                   .setQuestion0Pressed(
  //                                                       pressed);
  //
  //                                               if (quizObject.answerD ==
  //                                                   "Yes") {
  //                                                 await Common
  //                                                     .setQuestion0CorrectedD(
  //                                                         true);
  //                                               } else {
  //                                                 await Common
  //                                                     .setQuestion0CorrectedD(
  //                                                         false);
  //                                               }
  //                                             } else if (index == 1) {
  //                                               await Common
  //                                                   .setQuestion1Pressed(
  //                                                       pressed);
  //
  //                                               if (quizObject.answerD ==
  //                                                   "Yes") {
  //                                                 await Common
  //                                                     .setQuestion1CorrectedD(
  //                                                         true);
  //                                               } else {
  //                                                 await Common
  //                                                     .setQuestion1CorrectedD(
  //                                                         false);
  //                                               }
  //                                             } else if (index == 2) {
  //                                               await Common
  //                                                   .setQuestion2Pressed(
  //                                                       pressed);
  //
  //                                               if (quizObject.answerD ==
  //                                                   "Yes") {
  //                                                 await Common
  //                                                     .setQuestion2CorrectedD(
  //                                                         true);
  //                                               } else {
  //                                                 await Common
  //                                                     .setQuestion2CorrectedD(
  //                                                         false);
  //                                               }
  //                                             } else if (index == 3) {
  //                                               await Common
  //                                                   .setQuestion3Pressed(
  //                                                       pressed);
  //
  //                                               if (quizObject.answerD ==
  //                                                   "Yes") {
  //                                                 await Common
  //                                                     .setQuestion3CorrectedD(
  //                                                         true);
  //                                               } else {
  //                                                 await Common
  //                                                     .setQuestion3CorrectedD(
  //                                                         false);
  //                                               }
  //                                             } else if (index == 4) {
  //                                               await Common
  //                                                   .setQuestion4Pressed(
  //                                                       pressed);
  //
  //                                               if (quizObject.answerD ==
  //                                                   "Yes") {
  //                                                 await Common
  //                                                     .setQuestion4CorrectedD(
  //                                                         true);
  //                                               } else {
  //                                                 await Common
  //                                                     .setQuestion4CorrectedD(
  //                                                         false);
  //                                               }
  //                                             } else if (index == 5) {
  //                                               await Common
  //                                                   .setQuestion5Pressed(
  //                                                       pressed);
  //
  //                                               if (quizObject.answerD ==
  //                                                   "Yes") {
  //                                                 await Common
  //                                                     .setQuestion5CorrectedD(
  //                                                         true);
  //                                               } else {
  //                                                 await Common
  //                                                     .setQuestion5CorrectedD(
  //                                                         false);
  //                                               }
  //                                             } else if (index == 6) {
  //                                               await Common
  //                                                   .setQuestion6Pressed(
  //                                                       pressed);
  //
  //                                               if (quizObject.answerD ==
  //                                                   "Yes") {
  //                                                 await Common
  //                                                     .setQuestion6CorrectedD(
  //                                                         true);
  //                                               } else {
  //                                                 await Common
  //                                                     .setQuestion6CorrectedD(
  //                                                         false);
  //                                               }
  //                                             } else if (index == 7) {
  //                                               await Common
  //                                                   .setQuestion7Pressed(
  //                                                       pressed);
  //
  //                                               if (quizObject.answerD ==
  //                                                   "Yes") {
  //                                                 await Common
  //                                                     .setQuestion7CorrectedD(
  //                                                         true);
  //                                               } else {
  //                                                 await Common
  //                                                     .setQuestion7CorrectedD(
  //                                                         false);
  //                                               }
  //                                             } else if (index == 8) {
  //                                               await Common
  //                                                   .setQuestion8Pressed(
  //                                                       pressed);
  //
  //                                               if (quizObject.answerD ==
  //                                                   "Yes") {
  //                                                 await Common
  //                                                     .setQuestion8CorrectedD(
  //                                                         true);
  //                                               } else {
  //                                                 await Common
  //                                                     .setQuestion8CorrectedD(
  //                                                         false);
  //                                               }
  //                                             } else if (index == 9) {
  //                                               await Common
  //                                                   .setQuestion9Pressed(
  //                                                       pressed);
  //                                               if (quizObject.answerD ==
  //                                                   "Yes") {
  //                                                 await Common
  //                                                     .setQuestion9CorrectedD(
  //                                                         true);
  //                                               } else {
  //                                                 await Common
  //                                                     .setQuestion9CorrectedD(
  //                                                         false);
  //                                               }
  //                                             }
  //                                           }
  //
  //                                           // if (quizObject.matching) {
  //                                           //   if (_answerA ==
  //                                           //           quizObject.optionD &&
  //                                           //       _answerB ==
  //                                           //           quizObject.optionA &&
  //                                           //       _answerC ==
  //                                           //           quizObject.optionB &&
  //                                           //       _answerD ==
  //                                           //           quizObject.optionC) {
  //                                           //     setState(() {
  //                                           //       score = score + 1;
  //                                           //     });
  //                                           //   } else {
  //                                           //     setState(() {
  //                                           //       // if(!_enabledA || !_enabledB || !_enabledC || !_enabledD){
  //                                           //       //   if(score > 0 ){
  //                                           //       //       score = score - 1;
  //                                           //       //   }
  //                                           //       // }
  //                                           //     });
  //                                           //   }
  //                                           // } else {
  //                                           //
  //                                           //   if (pressed == "A") {
  //                                           //     if (quizObject.answerA ==
  //                                           //         "Yes") {
  //                                           //       setState(() {
  //                                           //         score = score + 1;
  //                                           //       });
  //                                           //     } else {
  //                                           //       // if(score > 0 ){
  //                                           //       //   setState(() {
  //                                           //       //     score = score - 1;
  //                                           //       //   });
  //                                           //       // }
  //                                           //     }
  //                                           //
  //                                           //     if (index == 7) {
  //                                           //       await Common
  //                                           //           .setQuestion7Pressed(
  //                                           //               pressed);
  //                                           //
  //                                           //       if (quizObject.answerA ==
  //                                           //           "Yes") {
  //                                           //         await Common
  //                                           //             .setQuestion7CorrectedA(
  //                                           //                 true);
  //                                           //       } else {
  //                                           //         await Common
  //                                           //             .setQuestion7CorrectedA(
  //                                           //                 false);
  //                                           //       }
  //                                           //     } else if (index == 8) {
  //                                           //       await Common
  //                                           //           .setQuestion8Pressed(
  //                                           //               pressed);
  //                                           //
  //                                           //       if (quizObject.answerA ==
  //                                           //           "Yes") {
  //                                           //         await Common
  //                                           //             .setQuestion8CorrectedA(
  //                                           //                 true);
  //                                           //       } else {
  //                                           //         await Common
  //                                           //             .setQuestion8CorrectedA(
  //                                           //                 false);
  //                                           //       }
  //                                           //     } else if (index == 9) {
  //                                           //       await Common
  //                                           //           .setQuestion9Pressed(
  //                                           //               pressed);
  //                                           //       if (quizObject.answerA ==
  //                                           //           "Yes") {
  //                                           //         await Common
  //                                           //             .setQuestion9CorrectedA(
  //                                           //                 true);
  //                                           //       } else {
  //                                           //         await Common
  //                                           //             .setQuestion9CorrectedA(
  //                                           //                 false);
  //                                           //       }
  //                                           //     }
  //                                           //   }
  //                                           //   else if (pressed == "B") {
  //                                           //     if (quizObject.answerB ==
  //                                           //         "Yes") {
  //                                           //       setState(() {
  //                                           //         score = score + 1;
  //                                           //       });
  //                                           //     } else {
  //                                           //       // if(score > 0 ){
  //                                           //       //   setState(() {
  //                                           //       //     score = score - 1;
  //                                           //       //   });
  //                                           //       // }
  //                                           //     }
  //                                           //
  //                                           //     if (index == 7) {
  //                                           //       await Common
  //                                           //           .setQuestion7Pressed(
  //                                           //               pressed);
  //                                           //
  //                                           //       if (quizObject.answerB ==
  //                                           //           "Yes") {
  //                                           //         await Common
  //                                           //             .setQuestion7CorrectedB(
  //                                           //                 true);
  //                                           //       } else {
  //                                           //         await Common
  //                                           //             .setQuestion7CorrectedB(
  //                                           //                 false);
  //                                           //       }
  //                                           //     } else if (index == 8) {
  //                                           //       await Common
  //                                           //           .setQuestion8Pressed(
  //                                           //               pressed);
  //                                           //
  //                                           //       if (quizObject.answerB ==
  //                                           //           "Yes") {
  //                                           //         await Common
  //                                           //             .setQuestion8CorrectedB(
  //                                           //                 true);
  //                                           //       } else {
  //                                           //         await Common
  //                                           //             .setQuestion8CorrectedB(
  //                                           //                 false);
  //                                           //       }
  //                                           //     } else if (index == 9) {
  //                                           //       await Common
  //                                           //           .setQuestion9Pressed(
  //                                           //               pressed);
  //                                           //       if (quizObject.answerB ==
  //                                           //           "Yes") {
  //                                           //         await Common
  //                                           //             .setQuestion9CorrectedB(
  //                                           //                 true);
  //                                           //       } else {
  //                                           //         await Common
  //                                           //             .setQuestion9CorrectedB(
  //                                           //                 false);
  //                                           //       }
  //                                           //     }
  //                                           //   }
  //                                           //   else if (pressed == "C") {
  //                                           //     if (quizObject.answerC ==
  //                                           //         "Yes") {
  //                                           //       setState(() {
  //                                           //         score = score + 1;
  //                                           //       });
  //                                           //     } else {
  //                                           //       // if(score > 0 ){
  //                                           //       //   setState(() {
  //                                           //       //     score = score - 1;
  //                                           //       //   });
  //                                           //       // }
  //                                           //     }
  //                                           //
  //                                           //     if (index == 7) {
  //                                           //       await Common
  //                                           //           .setQuestion7Pressed(
  //                                           //               pressed);
  //                                           //
  //                                           //       if (quizObject.answerC ==
  //                                           //           "Yes") {
  //                                           //         await Common
  //                                           //             .setQuestion7CorrectedC(
  //                                           //                 true);
  //                                           //       } else {
  //                                           //         await Common
  //                                           //             .setQuestion7CorrectedC(
  //                                           //                 false);
  //                                           //       }
  //                                           //     } else if (index == 8) {
  //                                           //       await Common
  //                                           //           .setQuestion8Pressed(
  //                                           //               pressed);
  //                                           //
  //                                           //       if (quizObject.answerC ==
  //                                           //           "Yes") {
  //                                           //         await Common
  //                                           //             .setQuestion8CorrectedC(
  //                                           //                 true);
  //                                           //       } else {
  //                                           //         await Common
  //                                           //             .setQuestion8CorrectedC(
  //                                           //                 false);
  //                                           //       }
  //                                           //     } else if (index == 9) {
  //                                           //       await Common
  //                                           //           .setQuestion9Pressed(
  //                                           //               pressed);
  //                                           //       if (quizObject.answerC ==
  //                                           //           "Yes") {
  //                                           //         await Common
  //                                           //             .setQuestion9CorrectedC(
  //                                           //                 true);
  //                                           //       } else {
  //                                           //         await Common
  //                                           //             .setQuestion9CorrectedC(
  //                                           //                 false);
  //                                           //       }
  //                                           //     }
  //                                           //   }
  //                                           //   else if (pressed == "D") {
  //                                           //     if (quizObject.answerD ==
  //                                           //         "Yes") {
  //                                           //       setState(() {
  //                                           //         score = score + 1;
  //                                           //       });
  //                                           //     } else {
  //                                           //       // if(score > 0 ){
  //                                           //       //   setState(() {
  //                                           //       //     score = score - 1;
  //                                           //       //   });
  //                                           //       // }
  //                                           //     }
  //                                           //
  //                                           //     if (index == 7) {
  //                                           //       await Common
  //                                           //           .setQuestion7Pressed(
  //                                           //               pressed);
  //                                           //
  //                                           //       if (quizObject.answerD ==
  //                                           //           "Yes") {
  //                                           //         await Common
  //                                           //             .setQuestion7CorrectedD(
  //                                           //                 true);
  //                                           //       } else {
  //                                           //         await Common
  //                                           //             .setQuestion7CorrectedD(
  //                                           //                 false);
  //                                           //       }
  //                                           //     } else if (index == 8) {
  //                                           //       await Common
  //                                           //           .setQuestion8Pressed(
  //                                           //               pressed);
  //                                           //
  //                                           //       if (quizObject.answerD ==
  //                                           //           "Yes") {
  //                                           //         await Common
  //                                           //             .setQuestion8CorrectedD(
  //                                           //                 true);
  //                                           //       } else {
  //                                           //         await Common
  //                                           //             .setQuestion8CorrectedD(
  //                                           //                 false);
  //                                           //       }
  //                                           //     } else if (index == 9) {
  //                                           //       await Common
  //                                           //           .setQuestion9Pressed(
  //                                           //               pressed);
  //                                           //       if (quizObject.answerD ==
  //                                           //           "Yes") {
  //                                           //         await Common
  //                                           //             .setQuestion9CorrectedD(
  //                                           //                 true);
  //                                           //       } else {
  //                                           //         await Common
  //                                           //             .setQuestion9CorrectedD(
  //                                           //                 false);
  //                                           //       }
  //                                           //     }
  //                                           //   }
  //                                           //
  //                                           // }
  //
  //                                           quizList.length - 1 != index
  //                                               ? getQuizQuestion(true)
  //                                               : nextScreen(score);
  //                                               // : Navigator.push(
  //                                               //     context,
  //                                               //     MaterialPageRoute(
  //                                               //         // builder: (context) => ChessGame()),
  //                                               //         builder: (context) =>
  //                                               //             ScoreBoardScreen(
  //                                               //               Score: score
  //                                               //                   .toString(),
  //                                               //             )));
  //                                         },
  //                                       ),
  //
  //                                     ),
  //                                   ],
  //                                 ),
  //                                 const SizedBox(height: 20),
  //                               ],
  //                             ),
  //                           ),
  //                         )
  //                       ],
  //                     ),
  //                   ),
  //                 )
  //
  //               : Container(
  //                   width: MediaQuery.of(context).size.width,
  //                   height: MediaQuery.of(context).size.height,
  //                   decoration: const BoxDecoration(
  //                     image: DecorationImage(
  //                       image: AssetImage("assets/images/Background.png"),
  //                       fit: BoxFit.fill,
  //                     ),
  //                   ),
  //                   child: SingleChildScrollView(
  //                     child: Column(
  //                       children: [
  //                         //
  //                         // Padding(
  //                         //   padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
  //                         //   child: Row(
  //                         //     mainAxisAlignment: MainAxisAlignment.center,
  //                         //     children: [
  //                         //       Container(
  //                         //         // height: 70,
  //                         //         // width: 160,
  //                         //         padding: const EdgeInsets.all(14),
  //                         //         decoration: const BoxDecoration(
  //                         //           color: Colors.white,
  //                         //           borderRadius: BorderRadius.only(
  //                         //               topRight: Radius.circular(15.0),
  //                         //               bottomRight: Radius.circular(15.0),
  //                         //               topLeft: Radius.circular(15.0),
  //                         //               bottomLeft: Radius.circular(15.0)),
  //                         //         ),
  //                         //         child: Container(
  //                         //           // height: 50,
  //                         //           // width: 100,
  //                         //           padding:
  //                         //               const EdgeInsets.fromLTRB(60, 20, 60, 20),
  //                         //           decoration: const BoxDecoration(
  //                         //             color: Colors.white,
  //                         //             image: DecorationImage(
  //                         //               image: AssetImage(
  //                         //                   "assets/images/site-logo.png"),
  //                         //               fit: BoxFit.contain,
  //                         //             ),
  //                         //           ),
  //                         //           child: null,
  //                         //         ),
  //                         //       ),
  //                         //     ],
  //                         //   ),
  //                         // ),
  //                         // const SizedBox(
  //                         //   height: 10,
  //                         // ),
  //
  //                         SingleChildScrollView(
  //                           child: Container(
  //                             padding: EdgeInsets.fromLTRB(0, 60, 0, 0),
  //                             margin: const EdgeInsets.all(0),
  //                             decoration: const BoxDecoration(
  //                               //color: Colors.white,
  //                               borderRadius: BorderRadius.only(
  //                                   topRight: Radius.circular(15.0),
  //                                   bottomRight: Radius.circular(15.0),
  //                                   topLeft: Radius.circular(15.0),
  //                                   bottomLeft: Radius.circular(15.0)),
  //                             ),
  //
  //                             // child: Column(
  //                             //   children: [
  //                             //     Row(
  //                             //       children: [
  //                             //         Container(
  //                             //           margin: EdgeInsets.all(10),
  //                             //           height: 40,
  //                             //           width: 40,
  //                             //           decoration: const BoxDecoration(
  //                             //             image: DecorationImage(
  //                             //               image: AssetImage(
  //                             //                   "assets/Quiz time ic.png"),
  //                             //               fit: BoxFit.fill,
  //                             //             ),
  //                             //           ),
  //                             //         ),
  //                             //         Column(
  //                             //           crossAxisAlignment:
  //                             //               CrossAxisAlignment.start,
  //                             //           children: [
  //                             //             Container(
  //                             //               height: 40,
  //                             //               //width: 90,
  //                             //               child: Center(
  //                             //                 child: Text(
  //                             //                   "Match the following",
  //                             //                   style: TextStyle(
  //                             //                       fontSize: 18,
  //                             //                       color: Colors.blue.shade800,
  //                             //                       fontWeight: FontWeight.bold),
  //                             //                 ),
  //                             //               ),
  //                             //             ),
  //                             //             Container(
  //                             //               height: 20,
  //                             //
  //                             //               //width: 90,
  //                             //               child: Text(
  //                             //                 "10 Questions",
  //                             //                 textAlign: TextAlign.start,
  //                             //                 style: TextStyle(
  //                             //                     fontSize: 14,
  //                             //                     color: Colors.blue.shade800,
  //                             //                     fontWeight: FontWeight.bold),
  //                             //               ),
  //                             //             ),
  //                             //             const SizedBox(
  //                             //               height: 6,
  //                             //             ),
  //                             //           ],
  //                             //         ),
  //                             //         const Spacer(),
  //                             //         InkWell(
  //                             //           onTap: () {
  //                             //             Navigator.of(context).pop();
  //                             //             Navigator.push(
  //                             //                 context,
  //                             //                 MaterialPageRoute(
  //                             //                     builder: (context) =>
  //                             //                         BannerScreen()));
  //                             //           },
  //                             //           child: Container(
  //                             //             height: 35,
  //                             //             width: 35,
  //                             //             margin:
  //                             //                 EdgeInsets.fromLTRB(0, 0, 10, 0),
  //                             //             decoration: const BoxDecoration(
  //                             //               image: DecorationImage(
  //                             //                 image: AssetImage(
  //                             //                     "assets/icon/close.png"),
  //                             //                 fit: BoxFit.fill,
  //                             //               ),
  //                             //             ),
  //                             //           ),
  //                             //         ),
  //                             //       ],
  //                             //     ),
  //                             //     const Padding(
  //                             //       padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
  //                             //       child: Divider(
  //                             //         color: Colors.black45,
  //                             //         height: 0.5,
  //                             //       ),
  //                             //     ),
  //                             //     Container(
  //                             //       width: MediaQuery.of(context).size.width,
  //                             //       margin: const EdgeInsets.all(5),
  //                             //       child: quizObject.matching
  //                             //           ? Column(
  //                             //               // crossAxisAlignment:
  //                             //               //     CrossAxisAlignment.start,
  //                             //               mainAxisAlignment:
  //                             //                   MainAxisAlignment.center,
  //                             //               children: [
  //                             //                 Container(
  //                             //                   //height: 130,
  //                             //                   width: MediaQuery.of(context)
  //                             //                       .size
  //                             //                       .width,
  //                             //                   //margin: const EdgeInsets.all(25),
  //                             //                   padding:
  //                             //                       const EdgeInsets.fromLTRB(
  //                             //                           20, 30, 0, 0),
  //                             //                   child: Text(
  //                             //                     quizObject.question,
  //                             //                     textAlign: TextAlign.start,
  //                             //                     style: TextStyle(
  //                             //                         fontSize: 20,
  //                             //                         color: Colors.blue.shade800,
  //                             //                         fontWeight:
  //                             //                             FontWeight.w700),
  //                             //                   ),
  //                             //                 ),
  //                             //                 const SizedBox(
  //                             //                   width: 20,
  //                             //                 ),
  //                             //                 Container(
  //                             //                   padding:
  //                             //                       const EdgeInsets.fromLTRB(
  //                             //                           20, 30, 0, 0),
  //                             //                   //color: Colors.green,
  //                             //                   child: Column(
  //                             //                     crossAxisAlignment:
  //                             //                         CrossAxisAlignment.center,
  //                             //                     mainAxisAlignment:
  //                             //                         MainAxisAlignment.center,
  //                             //                     children: [
  //                             //                       Padding(
  //                             //                         padding: EdgeInsets.all(10),
  //                             //                         child: Row(
  //                             //                           mainAxisAlignment:
  //                             //                               MainAxisAlignment
  //                             //                                   .center,
  //                             //                           children: [
  //                             //                             Container(
  //                             //                               width: 200,
  //                             //                               child: Text(
  //                             //                                 "A. " +
  //                             //                                     quizObject
  //                             //                                         .optionA,
  //                             //                                 style: TextStyle(
  //                             //                                     fontSize: 18,
  //                             //                                     color: Colors
  //                             //                                         .blue
  //                             //                                         .shade800,
  //                             //                                     fontWeight:
  //                             //                                         FontWeight
  //                             //                                             .w600),
  //                             //                               ),
  //                             //                             ),
  //                             //                             const SizedBox(
  //                             //                               width: 10,
  //                             //                             ),
  //                             //                             Container(
  //                             //                               width: 200,
  //                             //                               child: Text(
  //                             //                                 //_answerA,
  //                             //                                 quizObject.answerD,
  //                             //                                 style: TextStyle(
  //                             //                                     fontSize: 18,
  //                             //                                     color: Colors
  //                             //                                         .blue
  //                             //                                         .shade800,
  //                             //                                     fontWeight:
  //                             //                                         FontWeight
  //                             //                                             .w600),
  //                             //                               ),
  //                             //                             ),
  //                             //                             const SizedBox(
  //                             //                               width: 20,
  //                             //                             ),
  //                             //                             Container(
  //                             //                               height: 40,
  //                             //                               width: 60,
  //                             //                               decoration:
  //                             //                                   BoxDecoration(
  //                             //                                 border: Border.all(
  //                             //                                     color: Colors
  //                             //                                         .black45),
  //                             //                                 borderRadius:
  //                             //                                     const BorderRadius
  //                             //                                             .all(
  //                             //                                         Radius.circular(
  //                             //                                             5.0) //                 <--- border radius here
  //                             //                                         ),
  //                             //                               ),
  //                             //                               child: Center(
  //                             //                                 child:
  //                             //                                     DropdownButton(
  //                             //                                   underline:
  //                             //                                       const SizedBox(),
  //                             //                                   dropdownColor:
  //                             //                                       Colors.white,
  //                             //                                   value:
  //                             //                                       _selectedAnswerA,
  //                             //                                   icon:
  //                             //                                       const Visibility(
  //                             //                                           visible:
  //                             //                                               true,
  //                             //                                           child:
  //                             //                                               Icon(
  //                             //                                             Icons
  //                             //                                                 .keyboard_arrow_down_rounded,
  //                             //                                             color: Colors
  //                             //                                                 .black45,
  //                             //                                           )),
  //                             //                                   iconSize: 20.0,
  //                             //                                   // onChanged: (newValue) {
  //                             //                                   //   setState(() {
  //                             //                                   //     _selectedAnnswerA =
  //                             //                                   //         newValue.toString();
  //                             //                                   //   });
  //                             //                                   // },
  //                             //
  //                             //                                   onChanged: _enabledA
  //                             //                                       ? (selectedValue) {
  //                             //                                           setState(
  //                             //                                               () {
  //                             //                                             _selectedAnswerA =
  //                             //                                                 selectedValue.toString();
  //                             //
  //                             //                                             if (selectedValue ==
  //                             //                                                 "A") {
  //                             //                                               _answerA =
  //                             //                                                   quizObject.optionA;
  //                             //                                               _enabledA =
  //                             //                                                   false;
  //                             //                                             } else if (selectedValue ==
  //                             //                                                 "B") {
  //                             //                                               _answerA =
  //                             //                                                   quizObject.optionB;
  //                             //                                               _enabledA =
  //                             //                                                   false;
  //                             //                                             } else if (selectedValue ==
  //                             //                                                 "C") {
  //                             //                                               _answerA =
  //                             //                                                   quizObject.optionC;
  //                             //                                               _enabledA =
  //                             //                                                   false;
  //                             //                                             } else if (selectedValue ==
  //                             //                                                 "D") {
  //                             //                                               _answerA =
  //                             //                                                   quizObject.optionD;
  //                             //                                               _enabledA =
  //                             //                                                   false;
  //                             //                                             } else {
  //                             //                                               _answerA =
  //                             //                                                   '';
  //                             //                                             }
  //                             //                                           });
  //                             //                                         }
  //                             //                                       : null,
  //                             //
  //                             //                                   items: _answers
  //                             //                                       .map(
  //                             //                                           (answer) {
  //                             //                                     return DropdownMenuItem(
  //                             //                                       child: Text(
  //                             //                                         answer,
  //                             //                                         style: const TextStyle(
  //                             //                                             color: Colors
  //                             //                                                 .blueAccent,
  //                             //                                             fontSize:
  //                             //                                                 22),
  //                             //                                       ),
  //                             //                                       value: answer,
  //                             //                                     );
  //                             //                                   }).toList(),
  //                             //                                 ),
  //                             //                               ),
  //                             //                             ),
  //                             //                             const SizedBox(
  //                             //                               width: 20,
  //                             //                             ),
  //                             //                             !_enabledA
  //                             //                                 ? Container(
  //                             //                                     height: 30,
  //                             //                                     width: 30,
  //                             //                                     decoration:
  //                             //                                         BoxDecoration(
  //                             //                                       image:
  //                             //                                           DecorationImage(
  //                             //                                         image: _answerA ==
  //                             //                                                 quizObject
  //                             //                                                     .optionD
  //                             //                                             ? const AssetImage(
  //                             //                                                 "assets/icon/correct.png")
  //                             //                                             : const AssetImage(
  //                             //                                                 "assets/icon/wrong.png"),
  //                             //                                         fit: BoxFit
  //                             //                                             .fill,
  //                             //                                       ),
  //                             //                                     ),
  //                             //                                   )
  //                             //                                 : _answerA == ""
  //                             //                                     ? Container(
  //                             //                                         height: 30,
  //                             //                                         width: 30,
  //                             //                                       )
  //                             //                                     : Container(
  //                             //                                         height: 30,
  //                             //                                         width: 30,
  //                             //                                         decoration:
  //                             //                                             BoxDecoration(
  //                             //                                           image:
  //                             //                                               DecorationImage(
  //                             //                                             image: _answerA ==
  //                             //                                                     quizObject.optionD
  //                             //                                                 ? const AssetImage("assets/icon/correct.png")
  //                             //                                                 : const AssetImage("assets/icon/wrong.png"),
  //                             //                                             fit: BoxFit
  //                             //                                                 .fill,
  //                             //                                           ),
  //                             //                                         ),
  //                             //                                       ),
  //                             //                             // : Container(
  //                             //                             //     height: 30,
  //                             //                             //     width: 30,
  //                             //                             //   ),
  //                             //                           ],
  //                             //                         ),
  //                             //                       ),
  //                             //                       Padding(
  //                             //                         padding: EdgeInsets.all(10),
  //                             //                         child: Row(
  //                             //                           mainAxisAlignment:
  //                             //                               MainAxisAlignment
  //                             //                                   .center,
  //                             //                           children: [
  //                             //                             Container(
  //                             //                               width: 200,
  //                             //                               child: Text(
  //                             //                                 "B. " +
  //                             //                                     quizObject
  //                             //                                         .optionB,
  //                             //                                 style: TextStyle(
  //                             //                                     fontSize: 18,
  //                             //                                     color: Colors
  //                             //                                         .blue
  //                             //                                         .shade800,
  //                             //                                     fontWeight:
  //                             //                                         FontWeight
  //                             //                                             .w600),
  //                             //                               ),
  //                             //                             ),
  //                             //
  //                             //                             const SizedBox(
  //                             //                               width: 10,
  //                             //                             ),
  //                             //                             Container(
  //                             //                               width: 200,
  //                             //                               child: Text(
  //                             //                                 //_answerB,
  //                             //                                 quizObject.answerA,
  //                             //                                 style: TextStyle(
  //                             //                                     fontSize: 18,
  //                             //                                     color: Colors
  //                             //                                         .blue
  //                             //                                         .shade800,
  //                             //                                     fontWeight:
  //                             //                                         FontWeight
  //                             //                                             .w600),
  //                             //                               ),
  //                             //                             ),
  //                             //                             const SizedBox(
  //                             //                               width: 20,
  //                             //                             ),
  //                             //
  //                             //                             // Container(
  //                             //                             //   height: 40,
  //                             //                             //   width: 60,
  //                             //                             //   decoration: BoxDecoration(
  //                             //                             //     border: Border.all(
  //                             //                             //         color: Colors.black45),
  //                             //                             //     borderRadius: const BorderRadius.all(
  //                             //                             //         Radius.circular(
  //                             //                             //             5.0) //                 <--- border radius here
  //                             //                             //     ),
  //                             //                             //   ),
  //                             //                             //
  //                             //                             //   child: Center(
  //                             //                             //     child: DropdownButton(
  //                             //                             //       // hint: Text(
  //                             //                             //       //     'Please choose a location'), // Not necessary for Option 1
  //                             //                             //       underline: SizedBox(),
  //                             //                             //       value: _selectedAnswerB,
  //                             //                             //       icon: const Visibility(
  //                             //                             //           visible: true,
  //                             //                             //           child: Icon(
  //                             //                             //             Icons
  //                             //                             //                 .keyboard_arrow_down_rounded,
  //                             //                             //             color: Colors.black45,
  //                             //                             //           )),
  //                             //                             //       iconSize: 20.0,
  //                             //                             //       // onChanged: (newValue) {
  //                             //                             //       //   setState(() {
  //                             //                             //       //     _selectedAnnswerB =
  //                             //                             //       //         newValue.toString();
  //                             //                             //       //   });
  //                             //                             //       // },
  //                             //                             //
  //                             //                             //       onChanged: _enabledB ? (newValue) {
  //                             //                             //         setState(() {
  //                             //                             //           _enabledB = false;
  //                             //                             //           _selectedAnswerB =
  //                             //                             //               newValue.toString();
  //                             //                             //         });
  //                             //                             //       } : null,
  //                             //                             //
  //                             //                             //
  //                             //                             //       items: _answers
  //                             //                             //           .map((location) {
  //                             //                             //         return DropdownMenuItem(
  //                             //                             //           child: Text(
  //                             //                             //             location,
  //                             //                             //             style: const TextStyle(
  //                             //                             //                 color: Colors
  //                             //                             //                     .blueAccent,
  //                             //                             //                 fontSize: 22),
  //                             //                             //           ),
  //                             //                             //           value: location,
  //                             //                             //         );
  //                             //                             //       }).toList(),
  //                             //                             //     ),
  //                             //                             //   ),
  //                             //                             // ),
  //                             //                             Container(
  //                             //                               height: 40,
  //                             //                               width: 60,
  //                             //                               decoration:
  //                             //                                   BoxDecoration(
  //                             //                                 border: Border.all(
  //                             //                                     color: Colors
  //                             //                                         .black45),
  //                             //                                 borderRadius:
  //                             //                                     const BorderRadius
  //                             //                                             .all(
  //                             //                                         Radius.circular(
  //                             //                                             5.0) //                 <--- border radius here
  //                             //                                         ),
  //                             //                               ),
  //                             //                               child: Center(
  //                             //                                 child:
  //                             //                                     DropdownButton(
  //                             //                                   // hint: Text(
  //                             //                                   //     'Please choose a location'), // Not necessary for Option 1
  //                             //
  //                             //                                   underline:
  //                             //                                       SizedBox(),
  //                             //                                   dropdownColor:
  //                             //                                       Colors.white,
  //                             //                                   value:
  //                             //                                       _selectedAnswerB,
  //                             //                                   icon:
  //                             //                                       const Visibility(
  //                             //                                           visible:
  //                             //                                               true,
  //                             //                                           child:
  //                             //                                               Icon(
  //                             //                                             Icons
  //                             //                                                 .keyboard_arrow_down_rounded,
  //                             //                                             color: Colors
  //                             //                                                 .black45,
  //                             //                                           )),
  //                             //                                   iconSize: 20.0,
  //                             //                                   // onChanged: (newValue) {
  //                             //                                   //   setState(() {
  //                             //                                   //     _selectedAnnswerA =
  //                             //                                   //         newValue.toString();
  //                             //                                   //   });
  //                             //                                   // },
  //                             //
  //                             //                                   onChanged: _enabledB
  //                             //                                       ? (newValue) {
  //                             //                                           setState(
  //                             //                                               () {
  //                             //                                             if (newValue ==
  //                             //                                                 "A") {
  //                             //                                               _answerB =
  //                             //                                                   quizObject.optionA;
  //                             //                                               _enabledB =
  //                             //                                                   false;
  //                             //                                             } else if (newValue ==
  //                             //                                                 "B") {
  //                             //                                               _answerB =
  //                             //                                                   quizObject.optionB;
  //                             //                                               _enabledB =
  //                             //                                                   false;
  //                             //                                             } else if (newValue ==
  //                             //                                                 "C") {
  //                             //                                               _answerB =
  //                             //                                                   quizObject.optionC;
  //                             //                                               _enabledB =
  //                             //                                                   false;
  //                             //                                             } else if (newValue ==
  //                             //                                                 "D") {
  //                             //                                               _answerB =
  //                             //                                                   quizObject.optionD;
  //                             //                                               _enabledB =
  //                             //                                                   false;
  //                             //                                             } else {
  //                             //                                               _answerB =
  //                             //                                                   '';
  //                             //                                             }
  //                             //                                             _selectedAnswerB =
  //                             //                                                 newValue.toString();
  //                             //                                           });
  //                             //                                         }
  //                             //                                       : null,
  //                             //
  //                             //                                   items: _answers
  //                             //                                       .map(
  //                             //                                           (answer) {
  //                             //                                     return DropdownMenuItem(
  //                             //                                       child: Text(
  //                             //                                         answer,
  //                             //                                         style: const TextStyle(
  //                             //                                             color: Colors
  //                             //                                                 .blueAccent,
  //                             //                                             fontSize:
  //                             //                                                 22),
  //                             //                                       ),
  //                             //                                       value: answer,
  //                             //                                     );
  //                             //                                   }).toList(),
  //                             //                                 ),
  //                             //                               ),
  //                             //                             ),
  //                             //                             const SizedBox(
  //                             //                               width: 20,
  //                             //                             ),
  //                             //                             !_enabledB
  //                             //                                 ? Container(
  //                             //                                     height: 30,
  //                             //                                     width: 30,
  //                             //                                     decoration:
  //                             //                                         BoxDecoration(
  //                             //                                       image:
  //                             //                                           DecorationImage(
  //                             //                                         image: _answerB ==
  //                             //                                                 quizObject
  //                             //                                                     .optionA
  //                             //                                             ? const AssetImage(
  //                             //                                                 "assets/icon/correct.png")
  //                             //                                             : const AssetImage(
  //                             //                                                 "assets/icon/wrong.png"),
  //                             //                                         fit: BoxFit
  //                             //                                             .fill,
  //                             //                                       ),
  //                             //                                     ),
  //                             //                                   )
  //                             //                                 : _answerB == ""
  //                             //                                     ? Container(
  //                             //                                         height: 30,
  //                             //                                         width: 30,
  //                             //                                       )
  //                             //                                     : Container(
  //                             //                                         height: 30,
  //                             //                                         width: 30,
  //                             //                                         decoration:
  //                             //                                             BoxDecoration(
  //                             //                                           image:
  //                             //                                               DecorationImage(
  //                             //                                             image: _answerB ==
  //                             //                                                     quizObject.optionA
  //                             //                                                 ? const AssetImage("assets/icon/correct.png")
  //                             //                                                 : const AssetImage("assets/icon/wrong.png"),
  //                             //                                             fit: BoxFit
  //                             //                                                 .fill,
  //                             //                                           ),
  //                             //                                         ),
  //                             //                                       ),
  //                             //                             // : Container(
  //                             //                             //     height: 30,
  //                             //                             //     width: 30,
  //                             //                             //   ),
  //                             //                           ],
  //                             //                         ),
  //                             //                       ),
  //                             //                       Padding(
  //                             //                         padding: EdgeInsets.all(10),
  //                             //                         child: Row(
  //                             //                           mainAxisAlignment:
  //                             //                               MainAxisAlignment
  //                             //                                   .center,
  //                             //                           children: [
  //                             //                             Container(
  //                             //                               width: 200,
  //                             //                               child: Text(
  //                             //                                 "C. " +
  //                             //                                     quizObject
  //                             //                                         .optionC,
  //                             //                                 style: TextStyle(
  //                             //                                     fontSize: 18,
  //                             //                                     color: Colors
  //                             //                                         .blue
  //                             //                                         .shade800,
  //                             //                                     fontWeight:
  //                             //                                         FontWeight
  //                             //                                             .w600),
  //                             //                               ),
  //                             //                             ),
  //                             //                             const SizedBox(
  //                             //                               width: 10,
  //                             //                             ),
  //                             //                             Container(
  //                             //                               width: 200,
  //                             //                               child: Text(
  //                             //                                 quizObject.answerB,
  //                             //                                 //_answerC,
  //                             //                                 style: TextStyle(
  //                             //                                     fontSize: 18,
  //                             //                                     color: Colors
  //                             //                                         .blue
  //                             //                                         .shade800,
  //                             //                                     fontWeight:
  //                             //                                         FontWeight
  //                             //                                             .w600),
  //                             //                               ),
  //                             //                             ),
  //                             //                             const SizedBox(
  //                             //                               width: 20,
  //                             //                             ),
  //                             //                             Container(
  //                             //                               height: 40,
  //                             //                               width: 60,
  //                             //                               decoration:
  //                             //                                   BoxDecoration(
  //                             //                                 border: Border.all(
  //                             //                                     color: Colors
  //                             //                                         .black45),
  //                             //                                 borderRadius:
  //                             //                                     const BorderRadius
  //                             //                                             .all(
  //                             //                                         Radius.circular(
  //                             //                                             5.0) //                 <--- border radius here
  //                             //                                         ),
  //                             //                               ),
  //                             //                               child: Center(
  //                             //                                 child:
  //                             //                                     DropdownButton(
  //                             //                                   // hint: Text(
  //                             //                                   //     'Please choose a location'), // Not necessary for Option 1
  //                             //
  //                             //                                   underline:
  //                             //                                       SizedBox(),
  //                             //                                   dropdownColor:
  //                             //                                       Colors.white,
  //                             //                                   value:
  //                             //                                       _selectedAnswerC,
  //                             //                                   icon:
  //                             //                                       const Visibility(
  //                             //                                           visible:
  //                             //                                               true,
  //                             //                                           child:
  //                             //                                               Icon(
  //                             //                                             Icons
  //                             //                                                 .keyboard_arrow_down_rounded,
  //                             //                                             color: Colors
  //                             //                                                 .black45,
  //                             //                                           )),
  //                             //                                   iconSize: 20.0,
  //                             //                                   // onChanged: (newValue) {
  //                             //                                   //   setState(() {
  //                             //                                   //     _selectedAnnswerA =
  //                             //                                   //         newValue.toString();
  //                             //                                   //   });
  //                             //                                   // },
  //                             //
  //                             //                                   onChanged: _enabledC
  //                             //                                       ? (newValue) {
  //                             //                                           setState(
  //                             //                                               () {
  //                             //                                             if (newValue ==
  //                             //                                                 "A") {
  //                             //                                               _answerC =
  //                             //                                                   quizObject.optionA;
  //                             //                                               _enabledC =
  //                             //                                                   false;
  //                             //                                             } else if (newValue ==
  //                             //                                                 "B") {
  //                             //                                               _answerC =
  //                             //                                                   quizObject.optionB;
  //                             //                                               _enabledC =
  //                             //                                                   false;
  //                             //                                             } else if (newValue ==
  //                             //                                                 "C") {
  //                             //                                               _answerC =
  //                             //                                                   quizObject.optionC;
  //                             //                                               _enabledC =
  //                             //                                                   false;
  //                             //                                             } else if (newValue ==
  //                             //                                                 "D") {
  //                             //                                               _answerC =
  //                             //                                                   quizObject.optionD;
  //                             //                                               _enabledC =
  //                             //                                                   false;
  //                             //                                             } else {
  //                             //                                               _answerC =
  //                             //                                                   '';
  //                             //                                             }
  //                             //                                             _selectedAnswerC =
  //                             //                                                 newValue.toString();
  //                             //                                           });
  //                             //                                         }
  //                             //                                       : null,
  //                             //
  //                             //                                   items: _answers
  //                             //                                       .map(
  //                             //                                           (answer) {
  //                             //                                     return DropdownMenuItem(
  //                             //                                       child: Text(
  //                             //                                         answer,
  //                             //                                         style: const TextStyle(
  //                             //                                             color: Colors
  //                             //                                                 .blueAccent,
  //                             //                                             fontSize:
  //                             //                                                 22),
  //                             //                                       ),
  //                             //                                       value: answer,
  //                             //                                     );
  //                             //                                   }).toList(),
  //                             //                                 ),
  //                             //                               ),
  //                             //                             ),
  //                             //                             const SizedBox(
  //                             //                               width: 20,
  //                             //                             ),
  //                             //                             !_enabledC
  //                             //                                 ? Container(
  //                             //                                     height: 30,
  //                             //                                     width: 30,
  //                             //                                     decoration:
  //                             //                                         BoxDecoration(
  //                             //                                       image:
  //                             //                                           DecorationImage(
  //                             //                                         image: _answerC ==
  //                             //                                                 quizObject
  //                             //                                                     .optionB
  //                             //                                             ? const AssetImage(
  //                             //                                                 "assets/icon/correct.png")
  //                             //                                             : const AssetImage(
  //                             //                                                 "assets/icon/wrong.png"),
  //                             //                                         fit: BoxFit
  //                             //                                             .fill,
  //                             //                                       ),
  //                             //                                     ),
  //                             //                                   )
  //                             //                                 : _answerC == ""
  //                             //                                     ? Container(
  //                             //                                         height: 30,
  //                             //                                         width: 30,
  //                             //                                       )
  //                             //                                     : Container(
  //                             //                                         height: 30,
  //                             //                                         width: 30,
  //                             //                                         decoration:
  //                             //                                             BoxDecoration(
  //                             //                                           image:
  //                             //                                               DecorationImage(
  //                             //                                             image: _answerC ==
  //                             //                                                     quizObject.optionB
  //                             //                                                 ? const AssetImage("assets/icon/correct.png")
  //                             //                                                 : const AssetImage("assets/icon/wrong.png"),
  //                             //                                             fit: BoxFit
  //                             //                                                 .fill,
  //                             //                                           ),
  //                             //                                         ),
  //                             //                                       ),
  //                             //                           ],
  //                             //                         ),
  //                             //                       ),
  //                             //                       Padding(
  //                             //                         padding: EdgeInsets.all(10),
  //                             //                         child: Row(
  //                             //                           mainAxisAlignment:
  //                             //                               MainAxisAlignment
  //                             //                                   .center,
  //                             //                           children: [
  //                             //                             Container(
  //                             //                               width: 200,
  //                             //                               child: Text(
  //                             //                                 "D. " +
  //                             //                                     quizObject
  //                             //                                         .optionD,
  //                             //                                 style: TextStyle(
  //                             //                                     fontSize: 18,
  //                             //                                     color: Colors
  //                             //                                         .blue
  //                             //                                         .shade800,
  //                             //                                     fontWeight:
  //                             //                                         FontWeight
  //                             //                                             .w600),
  //                             //                               ),
  //                             //                             ),
  //                             //                             const SizedBox(
  //                             //                               width: 10,
  //                             //                             ),
  //                             //                             Container(
  //                             //                               width: 200,
  //                             //                               child: Text(
  //                             //                                 quizObject.answerC,
  //                             //                                 // _answerD,
  //                             //                                 style: TextStyle(
  //                             //                                     fontSize: 18,
  //                             //                                     color: Colors
  //                             //                                         .blue
  //                             //                                         .shade800,
  //                             //                                     fontWeight:
  //                             //                                         FontWeight
  //                             //                                             .w600),
  //                             //                               ),
  //                             //                             ),
  //                             //                             const SizedBox(
  //                             //                               width: 20,
  //                             //                             ),
  //                             //                             Container(
  //                             //                               height: 40,
  //                             //                               width: 60,
  //                             //                               decoration:
  //                             //                                   BoxDecoration(
  //                             //                                 border: Border.all(
  //                             //                                     color: Colors
  //                             //                                         .black45),
  //                             //                                 borderRadius:
  //                             //                                     const BorderRadius
  //                             //                                             .all(
  //                             //                                         Radius.circular(
  //                             //                                             5.0) //                 <--- border radius here
  //                             //                                         ),
  //                             //                               ),
  //                             //                               child: Center(
  //                             //                                 child:
  //                             //                                     DropdownButton(
  //                             //                                   underline:
  //                             //                                       const SizedBox(),
  //                             //                                   dropdownColor:
  //                             //                                       Colors.white,
  //                             //                                   value:
  //                             //                                       _selectedAnswerD,
  //                             //                                   icon:
  //                             //                                       const Visibility(
  //                             //                                           visible:
  //                             //                                               true,
  //                             //                                           child:
  //                             //                                               Icon(
  //                             //                                             Icons
  //                             //                                                 .keyboard_arrow_down_rounded,
  //                             //                                             color: Colors
  //                             //                                                 .black45,
  //                             //                                           )),
  //                             //                                   iconSize: 20.0,
  //                             //                                   // onChanged: (newValue) {
  //                             //                                   //   setState(() {
  //                             //                                   //     _selectedAnnswerA =
  //                             //                                   //         newValue.toString();
  //                             //                                   //   });
  //                             //                                   // },
  //                             //
  //                             //                                   onChanged: _enabledD
  //                             //                                       ? (newValue) {
  //                             //                                           setState(
  //                             //                                               () {
  //                             //                                             if (newValue ==
  //                             //                                                 "A") {
  //                             //                                               _answerD =
  //                             //                                                   quizObject.optionA;
  //                             //                                               _enabledD =
  //                             //                                                   false;
  //                             //                                             } else if (newValue ==
  //                             //                                                 "B") {
  //                             //                                               _answerD =
  //                             //                                                   quizObject.optionB;
  //                             //                                               _enabledD =
  //                             //                                                   false;
  //                             //                                             } else if (newValue ==
  //                             //                                                 "C") {
  //                             //                                               _answerD =
  //                             //                                                   quizObject.optionC;
  //                             //                                               _enabledD =
  //                             //                                                   false;
  //                             //                                             } else if (newValue ==
  //                             //                                                 "D") {
  //                             //                                               _answerD =
  //                             //                                                   quizObject.optionD;
  //                             //                                               _enabledD =
  //                             //                                                   false;
  //                             //                                             } else {
  //                             //                                               _answerD =
  //                             //                                                   '';
  //                             //                                             }
  //                             //                                             _selectedAnswerD =
  //                             //                                                 newValue.toString();
  //                             //                                           });
  //                             //                                         }
  //                             //                                       : null,
  //                             //
  //                             //                                   items: _answers
  //                             //                                       .map(
  //                             //                                           (answer) {
  //                             //                                     return DropdownMenuItem(
  //                             //                                       child: Text(
  //                             //                                         answer,
  //                             //                                         style: const TextStyle(
  //                             //                                             color: Colors
  //                             //                                                 .blueAccent,
  //                             //                                             fontSize:
  //                             //                                                 22),
  //                             //                                       ),
  //                             //                                       value: answer,
  //                             //                                     );
  //                             //                                   }).toList(),
  //                             //                                 ),
  //                             //                               ),
  //                             //                             ),
  //                             //                             const SizedBox(
  //                             //                               width: 20,
  //                             //                             ),
  //                             //                             !_enabledD
  //                             //                                 ? Container(
  //                             //                                     height: 30,
  //                             //                                     width: 30,
  //                             //                                     decoration:
  //                             //                                         BoxDecoration(
  //                             //                                       image:
  //                             //                                           DecorationImage(
  //                             //                                         image: _answerD ==
  //                             //                                                 quizObject
  //                             //                                                     .optionC
  //                             //                                             ? const AssetImage(
  //                             //                                                 "assets/icon/correct.png")
  //                             //                                             : const AssetImage(
  //                             //                                                 "assets/icon/wrong.png"),
  //                             //                                         fit: BoxFit
  //                             //                                             .fill,
  //                             //                                       ),
  //                             //                                     ),
  //                             //                                   )
  //                             //                                 : _answerD == ""
  //                             //                                     ? Container(
  //                             //                                         height: 30,
  //                             //                                         width: 30,
  //                             //                                       )
  //                             //                                     : Container(
  //                             //                                         height: 30,
  //                             //                                         width: 30,
  //                             //                                         decoration:
  //                             //                                             BoxDecoration(
  //                             //                                           image:
  //                             //                                               DecorationImage(
  //                             //                                             image: _answerD ==
  //                             //                                                     quizObject.optionC
  //                             //                                                 ? const AssetImage("assets/icon/correct.png")
  //                             //                                                 : const AssetImage("assets/icon/wrong.png"),
  //                             //                                             fit: BoxFit
  //                             //                                                 .fill,
  //                             //                                           ),
  //                             //                                         ),
  //                             //                                       ),
  //                             //                           ],
  //                             //                         ),
  //                             //                       ),
  //                             //                     ],
  //                             //                   ),
  //                             //                 )
  //                             //               ],
  //                             //             )
  //                             //           : Column(
  //                             //               crossAxisAlignment:
  //                             //                   CrossAxisAlignment.start,
  //                             //               mainAxisAlignment:
  //                             //                   MainAxisAlignment.center,
  //                             //               children: [
  //                             //                 Container(
  //                             //                   margin: const EdgeInsets.all(25),
  //                             //                   child: Text(
  //                             //                     quizObject.question,
  //                             //                     textAlign: TextAlign.start,
  //                             //                     style: TextStyle(
  //                             //                         fontSize: 18,
  //                             //                         color: Colors.blue.shade800,
  //                             //                         fontWeight:
  //                             //                             FontWeight.w600),
  //                             //                   ),
  //                             //                 ),
  //                             //                 Container(
  //                             //                   margin: const EdgeInsets.all(25),
  //                             //                   child: Center(
  //                             //                     child: Column(
  //                             //                       crossAxisAlignment:
  //                             //                           CrossAxisAlignment.start,
  //                             //                       mainAxisAlignment:
  //                             //                           MainAxisAlignment.center,
  //                             //                       children: [
  //                             //                         InkWell(
  //                             //                           onTap: () {
  //                             //                             if (_enabledA) {
  //                             //                               setState(() {
  //                             //                                 pressed = "A";
  //                             //
  //                             //                                 _enabledA = false;
  //                             //                                 _enabledB = false;
  //                             //                                 _enabledC = false;
  //                             //                                 _enabledD = false;
  //                             //
  //                             //                                 if (quizObject
  //                             //                                         .answerA ==
  //                             //                                     "Yes") {
  //                             //                                   _answerA =
  //                             //                                       quizObject
  //                             //                                           .answerA;
  //                             //
  //                             //                                   _correctA = true;
  //                             //
  //                             //                                   _correctB = false;
  //                             //                                   _correctC = false;
  //                             //                                   _correctD = false;
  //                             //                                 }
  //                             //
  //                             //                                 // else {
  //                             //                                 //   if (quizObject
  //                             //                                 //           .answerB ==
  //                             //                                 //       "Yes") {
  //                             //                                 //     _correctB =
  //                             //                                 //         true;
  //                             //                                 //
  //                             //                                 //     _correctA =
  //                             //                                 //         false;
  //                             //                                 //     _correctC =
  //                             //                                 //         false;
  //                             //                                 //     _correctD =
  //                             //                                 //         false;
  //                             //                                 //   } else if (quizObject
  //                             //                                 //           .answerC ==
  //                             //                                 //       "Yes") {
  //                             //                                 //     _correctC =
  //                             //                                 //         true;
  //                             //                                 //
  //                             //                                 //     _correctA =
  //                             //                                 //         false;
  //                             //                                 //     _correctB =
  //                             //                                 //         false;
  //                             //                                 //     _correctD =
  //                             //                                 //         false;
  //                             //                                 //   } else {
  //                             //                                 //     _correctD =
  //                             //                                 //         true;
  //                             //                                 //
  //                             //                                 //     _correctA =
  //                             //                                 //         false;
  //                             //                                 //     _correctB =
  //                             //                                 //         false;
  //                             //                                 //     _correctC =
  //                             //                                 //         false;
  //                             //                                 //   }
  //                             //                                 // }
  //                             //                               });
  //                             //                             }
  //                             //                           },
  //                             //                           child: Container(
  //                             //                             margin: const EdgeInsets
  //                             //                                     .fromLTRB(
  //                             //                                 10, 10, 10, 10),
  //                             //                             height: 100,
  //                             //                             decoration:
  //                             //                                 BoxDecoration(
  //                             //                               color: _correctA
  //                             //                                   ? Color(
  //                             //                                       0xff002DB18)
  //                             //                                   : !_correctA &&
  //                             //                                           pressed ==
  //                             //                                               "A"
  //                             //                                       ? Color(
  //                             //                                           0xff0BB0000)
  //                             //                                       : Color(
  //                             //                                           0xff0F6F6F6),
  //                             //                               borderRadius: const BorderRadius
  //                             //                                       .only(
  //                             //                                   topRight:
  //                             //                                       Radius
  //                             //                                           .circular(
  //                             //                                               15.0),
  //                             //                                   bottomRight: Radius
  //                             //                                       .circular(
  //                             //                                           15.0),
  //                             //                                   topLeft: Radius
  //                             //                                       .circular(
  //                             //                                           15.0),
  //                             //                                   bottomLeft: Radius
  //                             //                                       .circular(
  //                             //                                           15.0)),
  //                             //                               boxShadow: [
  //                             //                                 BoxShadow(
  //                             //                                   color: Colors.grey
  //                             //                                       .withOpacity(
  //                             //                                           0.2),
  //                             //                                   spreadRadius: 1,
  //                             //                                   blurRadius: 1,
  //                             //                                   offset: const Offset(
  //                             //                                       0,
  //                             //                                       3), // changes position of shadow
  //                             //                                 ),
  //                             //                               ],
  //                             //                             ),
  //                             //                             child: Row(
  //                             //                               children: [
  //                             //                                 const SizedBox(
  //                             //                                   width: 40,
  //                             //                                 ),
  //                             //                                 Row(
  //                             //                                   children: [
  //                             //                                     Container(
  //                             //                                       width:
  //                             //                                           widthSize -
  //                             //                                               300,
  //                             //                                       child: Text(
  //                             //                                         "A. " +
  //                             //                                             quizObject
  //                             //                                                 .optionA,
  //                             //                                         maxLines: 3,
  //                             //                                         style: TextStyle(
  //                             //                                             fontSize: 18,
  //                             //                                             color: _correctA
  //                             //                                                 ? Colors.white
  //                             //                                                 : !_correctA && pressed == "A"
  //                             //                                                     ? Colors.white
  //                             //                                                     : Colors.blue.shade800,
  //                             //                                             fontWeight: FontWeight.w600),
  //                             //                                       ),
  //                             //                                     ),
  //                             //                                   ],
  //                             //                                 ),
  //                             //                               ],
  //                             //                             ),
  //                             //                           ),
  //                             //                         ),
  //                             //                         InkWell(
  //                             //                           onTap: () {
  //                             //                             // setState(() {
  //                             //                             //   if (quizObject
  //                             //                             //           .answerB ==
  //                             //                             //       "Yes") {
  //                             //                             //     _answerB =
  //                             //                             //         quizObject
  //                             //                             //             .answerB;
  //                             //                             //     _enabledB = false;
  //                             //                             //     _correctB = true;
  //                             //                             //     //_radioSelected = 2;
  //                             //                             //   } else {
  //                             //                             //     _enabledB = false;
  //                             //                             //     //_radioSelected = 2;
  //                             //                             //   }
  //                             //                             // });
  //                             //
  //                             //                             if (_enabledB) {
  //                             //                               setState(() {
  //                             //                                 pressed = "B";
  //                             //
  //                             //                                 _enabledB = false;
  //                             //                                 _enabledA = false;
  //                             //                                 _enabledC = false;
  //                             //                                 _enabledD = false;
  //                             //
  //                             //                                 if (quizObject
  //                             //                                         .answerB ==
  //                             //                                     "Yes") {
  //                             //                                   _answerB =
  //                             //                                       quizObject
  //                             //                                           .answerB;
  //                             //
  //                             //                                   _correctB = true;
  //                             //
  //                             //                                   _correctA = false;
  //                             //                                   _correctC = false;
  //                             //                                   _correctD = false;
  //                             //                                 }
  //                             //                                 // else {
  //                             //                                 //   if (quizObject
  //                             //                                 //           .answerA ==
  //                             //                                 //       "Yes") {
  //                             //                                 //     _correctA =
  //                             //                                 //         true;
  //                             //                                 //
  //                             //                                 //     _correctB =
  //                             //                                 //         false;
  //                             //                                 //     _correctC =
  //                             //                                 //         false;
  //                             //                                 //     _correctD =
  //                             //                                 //         false;
  //                             //                                 //   } else if (quizObject
  //                             //                                 //           .answerC ==
  //                             //                                 //       "Yes") {
  //                             //                                 //     _correctC =
  //                             //                                 //         true;
  //                             //                                 //
  //                             //                                 //     _correctA =
  //                             //                                 //         false;
  //                             //                                 //     _correctB =
  //                             //                                 //         false;
  //                             //                                 //     _correctD =
  //                             //                                 //         false;
  //                             //                                 //   } else {
  //                             //                                 //     _correctD =
  //                             //                                 //         true;
  //                             //                                 //
  //                             //                                 //     _correctA =
  //                             //                                 //         false;
  //                             //                                 //     _correctB =
  //                             //                                 //         false;
  //                             //                                 //     _correctC =
  //                             //                                 //         false;
  //                             //                                 //   }
  //                             //                                 // }
  //                             //                               });
  //                             //                             }
  //                             //                           },
  //                             //                           child: Container(
  //                             //                             margin: const EdgeInsets
  //                             //                                     .fromLTRB(
  //                             //                                 10, 10, 10, 10),
  //                             //                             height: 100,
  //                             //                             //color: Colors.amber,
  //                             //
  //                             //                             decoration:
  //                             //                                 BoxDecoration(
  //                             //                               color: _correctB
  //                             //                                   ? Color(
  //                             //                                       0xff002DB18)
  //                             //                                   : !_correctB &&
  //                             //                                           pressed ==
  //                             //                                               "B"
  //                             //                                       ? Color(
  //                             //                                           0xff0BB0000)
  //                             //                                       : Color(
  //                             //                                           0xff0F6F6F6),
  //                             //                               borderRadius: const BorderRadius
  //                             //                                       .only(
  //                             //                                   topRight:
  //                             //                                       Radius
  //                             //                                           .circular(
  //                             //                                               15.0),
  //                             //                                   bottomRight: Radius
  //                             //                                       .circular(
  //                             //                                           15.0),
  //                             //                                   topLeft: Radius
  //                             //                                       .circular(
  //                             //                                           15.0),
  //                             //                                   bottomLeft: Radius
  //                             //                                       .circular(
  //                             //                                           15.0)),
  //                             //                               boxShadow: [
  //                             //                                 BoxShadow(
  //                             //                                   color: Colors.grey
  //                             //                                       .withOpacity(
  //                             //                                           0.2),
  //                             //                                   spreadRadius: 1,
  //                             //                                   blurRadius: 1,
  //                             //                                   offset: const Offset(
  //                             //                                       0,
  //                             //                                       3), // changes position of shadow
  //                             //                                 ),
  //                             //                               ],
  //                             //                             ),
  //                             //
  //                             //                             // color: _correctB
  //                             //                             //     ? Color(0xff002DB18)
  //                             //                             //     : !_enabledB &&
  //                             //                             //             !_correctB
  //                             //                             //         ? Color(
  //                             //                             //             0xff0BB0000)
  //                             //                             //         : Color(
  //                             //                             //             0xff0F6F6F6),
  //                             //
  //                             //                             child: Row(
  //                             //                               children: [
  //                             //                                 const SizedBox(
  //                             //                                   width: 40,
  //                             //                                 ),
  //                             //                                 Row(
  //                             //                                   children: [
  //                             //                                     Container(
  //                             //                                       width:
  //                             //                                           widthSize -
  //                             //                                               300,
  //                             //                                       child: Text(
  //                             //                                         "B. " +
  //                             //                                             quizObject
  //                             //                                                 .optionB,
  //                             //                                         // style: TextStyle(
  //                             //                                         //     fontSize: 18,
  //                             //                                         //     color: _correctB
  //                             //                                         //         ? Colors.white
  //                             //                                         //         : !_enabledB && !_correctB
  //                             //                                         //             ? Colors.white
  //                             //                                         //             : Colors.blue.shade800,
  //                             //                                         //     fontWeight: FontWeight.w600),
  //                             //                                         style: TextStyle(
  //                             //                                             fontSize: 18,
  //                             //                                             color: _correctB
  //                             //                                                 ? Colors.white
  //                             //                                                 //: !_enabledB && !_correctB
  //                             //                                                 : !_correctB && pressed == "B"
  //                             //                                                     ? Colors.white
  //                             //                                                     : Colors.blue.shade800,
  //                             //
  //                             //                                             // ? Colors.blue.shade800
  //                             //                                             //     : Colors.white,
  //                             //                                             fontWeight: FontWeight.w600),
  //                             //                                       ),
  //                             //                                     ),
  //                             //                                   ],
  //                             //                                 ),
  //                             //                               ],
  //                             //                             ),
  //                             //                           ),
  //                             //                         ),
  //                             //                         InkWell(
  //                             //                           onTap: () {
  //                             //                             if (_enabledC) {
  //                             //                               setState(() {
  //                             //                                 pressed = "C";
  //                             //
  //                             //                                 _enabledC = false;
  //                             //                                 _enabledA = false;
  //                             //                                 _enabledB = false;
  //                             //                                 _enabledD = false;
  //                             //
  //                             //                                 if (quizObject
  //                             //                                         .answerC ==
  //                             //                                     "Yes") {
  //                             //                                   _answerC =
  //                             //                                       quizObject
  //                             //                                           .answerC;
  //                             //
  //                             //                                   _correctC = true;
  //                             //
  //                             //                                   _correctA = false;
  //                             //                                   _correctB = false;
  //                             //                                   _correctD = false;
  //                             //                                 }
  //                             //
  //                             //                                 // else {
  //                             //                                 //   if (quizObject
  //                             //                                 //           .answerA ==
  //                             //                                 //       "Yes") {
  //                             //                                 //     _correctA =
  //                             //                                 //         true;
  //                             //                                 //
  //                             //                                 //     _correctB =
  //                             //                                 //         false;
  //                             //                                 //     _correctC =
  //                             //                                 //         false;
  //                             //                                 //     _correctD =
  //                             //                                 //         false;
  //                             //                                 //   } else if (quizObject
  //                             //                                 //           .answerB ==
  //                             //                                 //       "Yes") {
  //                             //                                 //     _correctB =
  //                             //                                 //         true;
  //                             //                                 //
  //                             //                                 //     _correctC =
  //                             //                                 //         false;
  //                             //                                 //     _correctB =
  //                             //                                 //         false;
  //                             //                                 //     _correctD =
  //                             //                                 //         false;
  //                             //                                 //   } else {
  //                             //                                 //     _correctD =
  //                             //                                 //         true;
  //                             //                                 //
  //                             //                                 //     _correctA =
  //                             //                                 //         false;
  //                             //                                 //     _correctB =
  //                             //                                 //         false;
  //                             //                                 //     _correctC =
  //                             //                                 //         false;
  //                             //                                 //   }
  //                             //                                 // }
  //                             //                               });
  //                             //                             }
  //                             //                           },
  //                             //                           child: Container(
  //                             //                             margin: const EdgeInsets
  //                             //                                     .fromLTRB(
  //                             //                                 10, 10, 10, 10),
  //                             //                             height: 100,
  //                             //                             decoration:
  //                             //                                 BoxDecoration(
  //                             //                               color: _correctC
  //                             //                                   ? Color(
  //                             //                                       0xff002DB18)
  //                             //                                   // : !_enabledC && !_correctC
  //                             //                                   : !_correctC &&
  //                             //                                           pressed ==
  //                             //                                               "C"
  //                             //                                       ? Color(
  //                             //                                           0xff0BB0000)
  //                             //                                       : Color(
  //                             //                                           0xff0F6F6F6),
  //                             //                               borderRadius: const BorderRadius
  //                             //                                       .only(
  //                             //                                   topRight:
  //                             //                                       Radius
  //                             //                                           .circular(
  //                             //                                               15.0),
  //                             //                                   bottomRight: Radius
  //                             //                                       .circular(
  //                             //                                           15.0),
  //                             //                                   topLeft: Radius
  //                             //                                       .circular(
  //                             //                                           15.0),
  //                             //                                   bottomLeft: Radius
  //                             //                                       .circular(
  //                             //                                           15.0)),
  //                             //                               boxShadow: [
  //                             //                                 BoxShadow(
  //                             //                                   color: Colors.grey
  //                             //                                       .withOpacity(
  //                             //                                           0.2),
  //                             //                                   spreadRadius: 1,
  //                             //                                   blurRadius: 1,
  //                             //                                   offset: const Offset(
  //                             //                                       0,
  //                             //                                       3), // changes position of shadow
  //                             //                                 ),
  //                             //                               ],
  //                             //                             ),
  //                             //                             child: Row(
  //                             //                               children: [
  //                             //                                 const SizedBox(
  //                             //                                   width: 40,
  //                             //                                 ),
  //                             //                                 Row(
  //                             //                                   children: [
  //                             //                                     Container(
  //                             //                                       width:
  //                             //                                           widthSize -
  //                             //                                               300,
  //                             //                                       child: Text(
  //                             //                                         "C. " +
  //                             //                                             quizObject
  //                             //                                                 .optionC,
  //                             //                                         style: TextStyle(
  //                             //                                             fontSize: 18,
  //                             //                                             color: _correctC
  //                             //                                                 ? Colors.white
  //                             //                                                 //: !_enabledC && !_correctC
  //                             //                                                 : !_correctC && pressed == "C"
  //                             //                                                     ? Colors.white
  //                             //                                                     : Colors.blue.shade800,
  //                             //
  //                             //                                             // ? Colors.blue.shade800
  //                             //                                             //     : Colors.white,
  //                             //                                             fontWeight: FontWeight.w600),
  //                             //
  //                             //                                         // style: TextStyle(
  //                             //                                         //     fontSize: 18,
  //                             //                                         //     // color: _correctC
  //                             //                                         //     //     ? Colors
  //                             //                                         //     //     .white
  //                             //                                         //     //     : Colors
  //                             //                                         //     //     .blue
  //                             //                                         //     //     .shade800,
  //                             //                                         //     color: _correctC
  //                             //                                         //         ? Colors.white
  //                             //                                         //         : !_enabledC && !_correctC
  //                             //                                         //             ? Colors.white
  //                             //                                         //             : Colors.blue.shade800,
  //                             //                                         //     fontWeight: FontWeight.w600),
  //                             //                                       ),
  //                             //                                     ),
  //                             //                                   ],
  //                             //                                 ),
  //                             //                               ],
  //                             //                             ),
  //                             //                           ),
  //                             //                         ),
  //                             //                         InkWell(
  //                             //                           onTap: () {
  //                             //                             if (_enabledD) {
  //                             //                               setState(() {
  //                             //                                 pressed = "D";
  //                             //
  //                             //                                 _enabledD = false;
  //                             //                                 _enabledA = false;
  //                             //                                 _enabledB = false;
  //                             //                                 _enabledC = false;
  //                             //
  //                             //                                 if (quizObject
  //                             //                                         .answerD ==
  //                             //                                     "Yes") {
  //                             //                                   _answerD =
  //                             //                                       quizObject
  //                             //                                           .answerD;
  //                             //
  //                             //                                   _correctD = true;
  //                             //                                   _correctA = false;
  //                             //                                   _correctB = false;
  //                             //                                   _correctC = false;
  //                             //                                 }
  //                             //
  //                             //                                 // else {
  //                             //                                 //   if (quizObject
  //                             //                                 //           .answerA ==
  //                             //                                 //       "Yes") {
  //                             //                                 //     _correctA =
  //                             //                                 //         true;
  //                             //                                 //
  //                             //                                 //     _correctB =
  //                             //                                 //         false;
  //                             //                                 //     _correctC =
  //                             //                                 //         false;
  //                             //                                 //     _correctD =
  //                             //                                 //         false;
  //                             //                                 //   } else if (quizObject
  //                             //                                 //           .answerC ==
  //                             //                                 //       "Yes") {
  //                             //                                 //     _correctC =
  //                             //                                 //         true;
  //                             //                                 //
  //                             //                                 //     _correctA =
  //                             //                                 //         false;
  //                             //                                 //     _correctB =
  //                             //                                 //         false;
  //                             //                                 //     _correctD =
  //                             //                                 //         false;
  //                             //                                 //   } else {
  //                             //                                 //     _correctB =
  //                             //                                 //         true;
  //                             //                                 //
  //                             //                                 //     _correctA =
  //                             //                                 //         false;
  //                             //                                 //     _correctD =
  //                             //                                 //         false;
  //                             //                                 //     _correctC =
  //                             //                                 //         false;
  //                             //                                 //   }
  //                             //                                 // }
  //                             //                               });
  //                             //                             }
  //                             //                           },
  //                             //                           child: Container(
  //                             //                             margin: const EdgeInsets
  //                             //                                     .fromLTRB(
  //                             //                                 10, 10, 10, 10),
  //                             //                             height: 100,
  //                             //                             decoration:
  //                             //                                 BoxDecoration(
  //                             //                               color: _correctD
  //                             //                                   ? Color(
  //                             //                                       0xff002DB18)
  //                             //                                   //: !_enabledD && !_correctD
  //                             //                                   : !_correctD &&
  //                             //                                           pressed ==
  //                             //                                               "D"
  //                             //                                       ? Color(
  //                             //                                           0xff0BB0000)
  //                             //                                       : Color(
  //                             //                                           0xff0F6F6F6),
  //                             //                               borderRadius: const BorderRadius
  //                             //                                       .only(
  //                             //                                   topRight:
  //                             //                                       Radius
  //                             //                                           .circular(
  //                             //                                               15.0),
  //                             //                                   bottomRight: Radius
  //                             //                                       .circular(
  //                             //                                           15.0),
  //                             //                                   topLeft: Radius
  //                             //                                       .circular(
  //                             //                                           15.0),
  //                             //                                   bottomLeft: Radius
  //                             //                                       .circular(
  //                             //                                           15.0)),
  //                             //                               boxShadow: [
  //                             //                                 BoxShadow(
  //                             //                                   color: Colors.grey
  //                             //                                       .withOpacity(
  //                             //                                           0.2),
  //                             //                                   spreadRadius: 1,
  //                             //                                   blurRadius: 1,
  //                             //                                   offset: const Offset(
  //                             //                                       0,
  //                             //                                       3), // changes position of shadow
  //                             //                                 ),
  //                             //                               ],
  //                             //                             ),
  //                             //                             child: Row(
  //                             //                               children: [
  //                             //                                 const SizedBox(
  //                             //                                   width: 40,
  //                             //                                 ),
  //                             //                                 Row(
  //                             //                                   children: [
  //                             //                                     Container(
  //                             //                                       width:
  //                             //                                           widthSize -
  //                             //                                               300,
  //                             //                                       child: Text(
  //                             //                                         "D. " +
  //                             //                                             quizObject
  //                             //                                                 .optionD,
  //                             //                                         // style: TextStyle(
  //                             //                                         //     fontSize: 18,
  //                             //                                         //     color: _correctD
  //                             //                                         //         ? Colors.white
  //                             //                                         //         : !_enabledD && !_correctD
  //                             //                                         //             ? Colors.white
  //                             //                                         //             : Colors.blue.shade800,
  //                             //                                         //     fontWeight: FontWeight.w600),
  //                             //                                         style: TextStyle(
  //                             //                                             fontSize: 18,
  //                             //                                             color: _correctD
  //                             //                                                 ? Colors.white
  //                             //                                                 //: !_enabledD && !_correctD
  //                             //                                                 : !_correctD && pressed == "D"
  //                             //                                                     // ? Colors.blue.shade800
  //                             //                                                     //     : Colors.white,
  //                             //                                                     ? Colors.white
  //                             //                                                     : Colors.blue.shade800,
  //                             //                                             fontWeight: FontWeight.w600),
  //                             //                                       ),
  //                             //                                     ),
  //                             //                                   ],
  //                             //                                 ),
  //                             //                               ],
  //                             //                             ),
  //                             //                           ),
  //                             //                         ),
  //                             //                       ],
  //                             //                     ),
  //                             //                   ),
  //                             //                 )
  //                             //               ],
  //                             //             ),
  //                             //     ),
  //                             //     const SizedBox(height: 10),
  //                             //     Row(
  //                             //       children: [
  //                             //         index != 0
  //                             //             ? Padding(
  //                             //                 padding: const EdgeInsets.fromLTRB(
  //                             //                     30, 0, 0, 0),
  //                             //                 child: Container(
  //                             //                   height: 45,
  //                             //                   width: 120,
  //                             //                   child: OutlineButton(
  //                             //                     shape: RoundedRectangleBorder(
  //                             //                         borderRadius:
  //                             //                             BorderRadius.circular(
  //                             //                                 15.0)),
  //                             //                     child: const Text(
  //                             //                       "Previous",
  //                             //                       style: TextStyle(
  //                             //                         fontSize: 16,
  //                             //                         fontWeight: FontWeight.bold,
  //                             //                         color: Color(0xff0F5A93),
  //                             //                       ),
  //                             //                     ),
  //                             //                     borderSide: const BorderSide(
  //                             //                       width: 2,
  //                             //                       color: Color(0xff0F5A93),
  //                             //                     ),
  //                             //                     onPressed: () {
  //                             //                       index > 0
  //                             //                           ? getQuizQuestion(false)
  //                             //                           : Container();
  //                             //                     },
  //                             //                   ),
  //                             //                 ),
  //                             //               )
  //                             //             : Container(),
  //                             //         const Spacer(),
  //                             //         Padding(
  //                             //           padding: const EdgeInsets.fromLTRB(
  //                             //               0, 0, 30, 0),
  //                             //           child: Container(
  //                             //             height: 45,
  //                             //             width: 120,
  //                             //             decoration: const BoxDecoration(
  //                             //               color: Color(0xff0F5A93),
  //                             //               borderRadius: BorderRadius.only(
  //                             //                   topRight: Radius.circular(15.0),
  //                             //                   bottomRight:
  //                             //                       Radius.circular(15.0),
  //                             //                   topLeft: Radius.circular(15.0),
  //                             //                   bottomLeft:
  //                             //                       Radius.circular(15.0)),
  //                             //             ),
  //                             //             child: TextButton(
  //                             //               style: TextButton.styleFrom(
  //                             //                 primary: Color(0xff0F5A93),
  //                             //               ),
  //                             //               onPressed: () async {
  //                             //                 if (quizObject.matching) {
  //                             //                   if (index == 0) {
  //                             //                     await Common
  //                             //                         .setQuestion0AnswerA(
  //                             //                             _answerA);
  //                             //                     await Common
  //                             //                         .setQuestion0AnswerB(
  //                             //                             _answerB);
  //                             //                     await Common
  //                             //                         .setQuestion0AnswerC(
  //                             //                             _answerC);
  //                             //                     await Common
  //                             //                         .setQuestion0AnswerD(
  //                             //                             _answerD);
  //                             //                   } else if (index == 1) {
  //                             //                     await Common
  //                             //                         .setQuestion1AnswerA(
  //                             //                             _answerA);
  //                             //                     await Common
  //                             //                         .setQuestion1AnswerB(
  //                             //                             _answerB);
  //                             //                     await Common
  //                             //                         .setQuestion1AnswerC(
  //                             //                             _answerC);
  //                             //                     await Common
  //                             //                         .setQuestion1AnswerD(
  //                             //                             _answerD);
  //                             //                   } else if (index == 2) {
  //                             //                     await Common
  //                             //                         .setQuestion2AnswerA(
  //                             //                             _answerA);
  //                             //                     await Common
  //                             //                         .setQuestion2AnswerB(
  //                             //                             _answerB);
  //                             //                     await Common
  //                             //                         .setQuestion2AnswerC(
  //                             //                             _answerC);
  //                             //                     await Common
  //                             //                         .setQuestion2AnswerD(
  //                             //                             _answerD);
  //                             //                   } else if (index == 3) {
  //                             //                     await Common
  //                             //                         .setQuestion3AnswerA(
  //                             //                             _answerA);
  //                             //                     await Common
  //                             //                         .setQuestion3AnswerB(
  //                             //                             _answerB);
  //                             //                     await Common
  //                             //                         .setQuestion3AnswerC(
  //                             //                             _answerC);
  //                             //                     await Common
  //                             //                         .setQuestion3AnswerD(
  //                             //                             _answerD);
  //                             //                   } else if (index == 4) {
  //                             //                     await Common
  //                             //                         .setQuestion4AnswerA(
  //                             //                             _answerA);
  //                             //                     await Common
  //                             //                         .setQuestion4AnswerB(
  //                             //                             _answerB);
  //                             //                     await Common
  //                             //                         .setQuestion4AnswerC(
  //                             //                             _answerC);
  //                             //                     await Common
  //                             //                         .setQuestion4AnswerD(
  //                             //                             _answerD);
  //                             //                   } else if (index == 5) {
  //                             //                     await Common
  //                             //                         .setQuestion5AnswerA(
  //                             //                             _answerA);
  //                             //                     await Common
  //                             //                         .setQuestion5AnswerB(
  //                             //                             _answerB);
  //                             //                     await Common
  //                             //                         .setQuestion5AnswerC(
  //                             //                             _answerC);
  //                             //                     await Common
  //                             //                         .setQuestion5AnswerD(
  //                             //                             _answerD);
  //                             //                   } else if (index == 6) {
  //                             //                     await Common
  //                             //                         .setQuestion6AnswerA(
  //                             //                             _answerA);
  //                             //                     await Common
  //                             //                         .setQuestion6AnswerB(
  //                             //                             _answerB);
  //                             //                     await Common
  //                             //                         .setQuestion6AnswerC(
  //                             //                             _answerC);
  //                             //                     await Common
  //                             //                         .setQuestion6AnswerD(
  //                             //                             _answerD);
  //                             //                   }
  //                             //                   // else if (index == 7) {
  //                             //                   //   await Common
  //                             //                   //       .setQuestion7AnswerA(
  //                             //                   //           _answerA);
  //                             //                   //   await Common
  //                             //                   //       .setQuestion7AnswerB(
  //                             //                   //           _answerB);
  //                             //                   //   await Common
  //                             //                   //       .setQuestion7AnswerC(
  //                             //                   //           _answerC);
  //                             //                   //   await Common
  //                             //                   //       .setQuestion7AnswerD(
  //                             //                   //           _answerD);
  //                             //                   // }
  //                             //                   // else if (index == 8) {
  //                             //                   //   await Common
  //                             //                   //       .setQuestion8AnswerA(
  //                             //                   //           _answerA);
  //                             //                   //   await Common
  //                             //                   //       .setQuestion8AnswerA(
  //                             //                   //           _answerB);
  //                             //                   //   await Common
  //                             //                   //       .setQuestion8AnswerA(
  //                             //                   //           _answerC);
  //                             //                   //   await Common
  //                             //                   //       .setQuestion8AnswerA(
  //                             //                   //           _answerD);
  //                             //                   // } else if (index == 9) {
  //                             //                   //   await Common
  //                             //                   //       .setQuestion9AnswerA(
  //                             //                   //           _answerA);
  //                             //                   //   await Common
  //                             //                   //       .setQuestion9AnswerA(
  //                             //                   //           _answerB);
  //                             //                   //   await Common
  //                             //                   //       .setQuestion9AnswerA(
  //                             //                   //           _answerC);
  //                             //                   //   await Common
  //                             //                   //       .setQuestion9AnswerA(
  //                             //                   //           _answerD);
  //                             //                   // } else if (index == 10) {
  //                             //                   //   await Common
  //                             //                   //       .setQuestion10AnswerA(
  //                             //                   //           _answerA);
  //                             //                   //   await Common
  //                             //                   //       .setQuestion10AnswerA(
  //                             //                   //           _answerB);
  //                             //                   //   await Common
  //                             //                   //       .setQuestion10AnswerA(
  //                             //                   //           _answerC);
  //                             //                   //   await Common
  //                             //                   //       .setQuestion10AnswerA(
  //                             //                   //           _answerD);
  //                             //                   // } else if (index == 11) {
  //                             //                   //   await Common
  //                             //                   //       .setQuestion11AnswerA(
  //                             //                   //           _answerA);
  //                             //                   //   await Common
  //                             //                   //       .setQuestion11AnswerA(
  //                             //                   //           _answerB);
  //                             //                   //   await Common
  //                             //                   //       .setQuestion11AnswerA(
  //                             //                   //           _answerC);
  //                             //                   //   await Common
  //                             //                   //       .setQuestion11AnswerA(
  //                             //                   //           _answerD);
  //                             //                   // }
  //                             //                   else {}
  //                             //                 } else {
  //                             //                   // if (index == 7) {
  //                             //                   //   await Common
  //                             //                   //       .setQuestion7Pressed(
  //                             //                   //           pressed);
  //                             //                   //   // await Common
  //                             //                   //   //     .setQuestion7AnswerA(
  //                             //                   //   //     _answerA);
  //                             //                   //   // await Common
  //                             //                   //   //     .setQuestion7AnswerB(
  //                             //                   //   //     _answerB);
  //                             //                   //   // await Common
  //                             //                   //   //     .setQuestion7AnswerC(
  //                             //                   //   //     _answerC);
  //                             //                   //   // await Common
  //                             //                   //   //     .setQuestion7AnswerD(
  //                             //                   //   //     _answerD);
  //                             //                   // } else if (index == 8) {
  //                             //                   //   await Common
  //                             //                   //       .setQuestion8Pressed(
  //                             //                   //           pressed);
  //                             //                   //   // await Common
  //                             //                   //   //     .setQuestion8AnswerA(
  //                             //                   //   //     _answerA);
  //                             //                   //   // await Common
  //                             //                   //   //     .setQuestion8AnswerB(
  //                             //                   //   //     _answerB);
  //                             //                   //   // await Common
  //                             //                   //   //     .setQuestion8AnswerC(
  //                             //                   //   //     _answerC);
  //                             //                   //   // await Common
  //                             //                   //   //     .setQuestion8AnswerD(
  //                             //                   //   //     _answerD);
  //                             //                   // } else if (index == 9) {
  //                             //                   //   await Common
  //                             //                   //       .setQuestion9Pressed(
  //                             //                   //           pressed);
  //                             //                   //   // await Common
  //                             //                   //   //     .setQuestion9AnswerA(
  //                             //                   //   //     _answerA);
  //                             //                   //   // await Common
  //                             //                   //   //     .setQuestion9AnswerB(
  //                             //                   //   //     _answerB);
  //                             //                   //   // await Common
  //                             //                   //   //     .setQuestion9AnswerC(
  //                             //                   //   //     _answerC);
  //                             //                   //   // await Common
  //                             //                   //   //     .setQuestion9AnswerD(
  //                             //                   //   //     _answerD);
  //                             //                   // }
  //                             //                 }
  //                             //
  //                             //                 if (quizObject.matching) {
  //                             //                   if (_answerA ==
  //                             //                           quizObject.optionD &&
  //                             //                       _answerB ==
  //                             //                           quizObject.optionA &&
  //                             //                       _answerC ==
  //                             //                           quizObject.optionB &&
  //                             //                       _answerD ==
  //                             //                           quizObject.optionC) {
  //                             //                     setState(() {
  //                             //                       score = score + 1;
  //                             //                     });
  //                             //                   } else {
  //                             //                     setState(() {
  //                             //                       // if(!_enabledA || !_enabledB || !_enabledC || !_enabledD){
  //                             //                       //   if(score > 0 ){
  //                             //                       //       score = score - 1;
  //                             //                       //   }
  //                             //                       // }
  //                             //                     });
  //                             //                   }
  //                             //                 } else {
  //                             //                   if (pressed == "A") {
  //                             //                     if (quizObject.answerA ==
  //                             //                         "Yes") {
  //                             //                       setState(() {
  //                             //                         score = score + 1;
  //                             //                       });
  //                             //                     } else {
  //                             //                       // if(score > 0 ){
  //                             //                       //   setState(() {
  //                             //                       //     score = score - 1;
  //                             //                       //   });
  //                             //                       // }
  //                             //                     }
  //                             //
  //                             //                     if (index == 7) {
  //                             //                       await Common
  //                             //                           .setQuestion7Pressed(
  //                             //                               pressed);
  //                             //
  //                             //                       if (quizObject.answerA ==
  //                             //                           "Yes") {
  //                             //                         await Common
  //                             //                             .setQuestion7CorrectedA(
  //                             //                                 true);
  //                             //                       } else {
  //                             //                         await Common
  //                             //                             .setQuestion7CorrectedA(
  //                             //                                 false);
  //                             //                       }
  //                             //                     } else if (index == 8) {
  //                             //                       await Common
  //                             //                           .setQuestion8Pressed(
  //                             //                               pressed);
  //                             //
  //                             //                       if (quizObject.answerA ==
  //                             //                           "Yes") {
  //                             //                         await Common
  //                             //                             .setQuestion8CorrectedA(
  //                             //                                 true);
  //                             //                       } else {
  //                             //                         await Common
  //                             //                             .setQuestion8CorrectedA(
  //                             //                                 false);
  //                             //                       }
  //                             //                     } else if (index == 9) {
  //                             //                       await Common
  //                             //                           .setQuestion9Pressed(
  //                             //                               pressed);
  //                             //                       if (quizObject.answerA ==
  //                             //                           "Yes") {
  //                             //                         await Common
  //                             //                             .setQuestion9CorrectedA(
  //                             //                                 true);
  //                             //                       } else {
  //                             //                         await Common
  //                             //                             .setQuestion9CorrectedA(
  //                             //                                 false);
  //                             //                       }
  //                             //                     }
  //                             //                   } else if (pressed == "B") {
  //                             //                     if (quizObject.answerB ==
  //                             //                         "Yes") {
  //                             //                       setState(() {
  //                             //                         score = score + 1;
  //                             //                       });
  //                             //                     } else {
  //                             //                       // if(score > 0 ){
  //                             //                       //   setState(() {
  //                             //                       //     score = score - 1;
  //                             //                       //   });
  //                             //                       // }
  //                             //                     }
  //                             //
  //                             //                     if (index == 7) {
  //                             //                       await Common
  //                             //                           .setQuestion7Pressed(
  //                             //                               pressed);
  //                             //
  //                             //                       if (quizObject.answerB ==
  //                             //                           "Yes") {
  //                             //                         await Common
  //                             //                             .setQuestion7CorrectedB(
  //                             //                                 true);
  //                             //                       } else {
  //                             //                         await Common
  //                             //                             .setQuestion7CorrectedB(
  //                             //                                 false);
  //                             //                       }
  //                             //                     } else if (index == 8) {
  //                             //                       await Common
  //                             //                           .setQuestion8Pressed(
  //                             //                               pressed);
  //                             //
  //                             //                       if (quizObject.answerB ==
  //                             //                           "Yes") {
  //                             //                         await Common
  //                             //                             .setQuestion8CorrectedB(
  //                             //                                 true);
  //                             //                       } else {
  //                             //                         await Common
  //                             //                             .setQuestion8CorrectedB(
  //                             //                                 false);
  //                             //                       }
  //                             //                     } else if (index == 9) {
  //                             //                       await Common
  //                             //                           .setQuestion9Pressed(
  //                             //                               pressed);
  //                             //                       if (quizObject.answerB ==
  //                             //                           "Yes") {
  //                             //                         await Common
  //                             //                             .setQuestion9CorrectedB(
  //                             //                                 true);
  //                             //                       } else {
  //                             //                         await Common
  //                             //                             .setQuestion9CorrectedB(
  //                             //                                 false);
  //                             //                       }
  //                             //                     }
  //                             //                   } else if (pressed == "C") {
  //                             //                     if (quizObject.answerC ==
  //                             //                         "Yes") {
  //                             //                       setState(() {
  //                             //                         score = score + 1;
  //                             //                       });
  //                             //                     } else {
  //                             //                       // if(score > 0 ){
  //                             //                       //   setState(() {
  //                             //                       //     score = score - 1;
  //                             //                       //   });
  //                             //                       // }
  //                             //                     }
  //                             //
  //                             //                     if (index == 7) {
  //                             //                       await Common
  //                             //                           .setQuestion7Pressed(
  //                             //                               pressed);
  //                             //
  //                             //                       if (quizObject.answerC ==
  //                             //                           "Yes") {
  //                             //                         await Common
  //                             //                             .setQuestion7CorrectedC(
  //                             //                                 true);
  //                             //                       } else {
  //                             //                         await Common
  //                             //                             .setQuestion7CorrectedC(
  //                             //                                 false);
  //                             //                       }
  //                             //                     } else if (index == 8) {
  //                             //                       await Common
  //                             //                           .setQuestion8Pressed(
  //                             //                               pressed);
  //                             //
  //                             //                       if (quizObject.answerC ==
  //                             //                           "Yes") {
  //                             //                         await Common
  //                             //                             .setQuestion8CorrectedC(
  //                             //                                 true);
  //                             //                       } else {
  //                             //                         await Common
  //                             //                             .setQuestion8CorrectedC(
  //                             //                                 false);
  //                             //                       }
  //                             //                     } else if (index == 9) {
  //                             //                       await Common
  //                             //                           .setQuestion9Pressed(
  //                             //                               pressed);
  //                             //                       if (quizObject.answerC ==
  //                             //                           "Yes") {
  //                             //                         await Common
  //                             //                             .setQuestion9CorrectedC(
  //                             //                                 true);
  //                             //                       } else {
  //                             //                         await Common
  //                             //                             .setQuestion9CorrectedC(
  //                             //                                 false);
  //                             //                       }
  //                             //                     }
  //                             //                   } else if (pressed == "D") {
  //                             //                     if (quizObject.answerD ==
  //                             //                         "Yes") {
  //                             //                       setState(() {
  //                             //                         score = score + 1;
  //                             //                       });
  //                             //                     } else {
  //                             //                       // if(score > 0 ){
  //                             //                       //   setState(() {
  //                             //                       //     score = score - 1;
  //                             //                       //   });
  //                             //                       // }
  //                             //                     }
  //                             //
  //                             //                     if (index == 7) {
  //                             //                       await Common
  //                             //                           .setQuestion7Pressed(
  //                             //                               pressed);
  //                             //
  //                             //                       if (quizObject.answerD ==
  //                             //                           "Yes") {
  //                             //                         await Common
  //                             //                             .setQuestion7CorrectedD(
  //                             //                                 true);
  //                             //                       } else {
  //                             //                         await Common
  //                             //                             .setQuestion7CorrectedD(
  //                             //                                 false);
  //                             //                       }
  //                             //                     } else if (index == 8) {
  //                             //                       await Common
  //                             //                           .setQuestion8Pressed(
  //                             //                               pressed);
  //                             //
  //                             //                       if (quizObject.answerD ==
  //                             //                           "Yes") {
  //                             //                         await Common
  //                             //                             .setQuestion8CorrectedD(
  //                             //                                 true);
  //                             //                       } else {
  //                             //                         await Common
  //                             //                             .setQuestion8CorrectedD(
  //                             //                                 false);
  //                             //                       }
  //                             //                     } else if (index == 9) {
  //                             //                       await Common
  //                             //                           .setQuestion9Pressed(
  //                             //                               pressed);
  //                             //                       if (quizObject.answerD ==
  //                             //                           "Yes") {
  //                             //                         await Common
  //                             //                             .setQuestion9CorrectedD(
  //                             //                                 true);
  //                             //                       } else {
  //                             //                         await Common
  //                             //                             .setQuestion9CorrectedD(
  //                             //                                 false);
  //                             //                       }
  //                             //                     }
  //                             //                   }
  //                             //                 }
  //                             //
  //                             //                 quizList.length - 1 != index
  //                             //                     ? getQuizQuestion(true)
  //                             //                     : Navigator.push(
  //                             //                         context,
  //                             //                         MaterialPageRoute(
  //                             //                             // builder: (context) => ChessGame()),
  //                             //                             builder: (context) =>
  //                             //                                 ScoreBoardScreen(
  //                             //                                   Score: score
  //                             //                                       .toString(),
  //                             //                                 )));
  //                             //               },
  //                             //               child: Text(
  //                             //                 quizList.length - 1 != index
  //                             //                     ? 'Next'
  //                             //                     : 'Finish',
  //                             //                 style: const TextStyle(
  //                             //                     color: Colors.white),
  //                             //               ),
  //                             //             ),
  //                             //           ),
  //                             //         ),
  //                             //       ],
  //                             //     ),
  //                             //     const SizedBox(height: 20),
  //                             //   ],
  //                             // ),
  //
  //                             child: Column(
  //                               crossAxisAlignment: CrossAxisAlignment.center,
  //                               mainAxisAlignment: MainAxisAlignment.end,
  //                               children: [
  //                                 Row(
  //                                   mainAxisAlignment: MainAxisAlignment.center,
  //                                   children: [
  //                                     Container(
  //                                       height: 170,
  //                                       width: 160,
  //                                       padding: const EdgeInsets.fromLTRB(
  //                                           60, 0, 60, 20),
  //                                       decoration: const BoxDecoration(
  //                                         //color: Colors.white,
  //                                         image: DecorationImage(
  //                                           image: AssetImage(
  //                                               "assets/KBC logo.png"),
  //                                           fit: BoxFit.contain,
  //                                         ),
  //                                       ),
  //                                       child: null,
  //                                     ),
  //                                   ],
  //                                 ),
  //                                 const SizedBox(
  //                                   height: 30,
  //                                 ),
  //
  //                                 Row(
  //                                   mainAxisAlignment: MainAxisAlignment.start,
  //                                   children: [
  //                                     Expanded(
  //                                       flex: 3,
  //                                       child: CustomPaint(
  //                                         size: Size(
  //                                             size,
  //                                             (350 * 0.18461538461538463)
  //                                                 .toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
  //                                         painter: Counter(),
  //                                         child: Container(
  //                                           //width: 50,
  //                                           margin: const EdgeInsets.fromLTRB(
  //                                               0, 15, 0, 15),
  //                                           //padding: EdgeInsets.fromLTRB(0, 0, 0, 45),
  //                                           child: Padding(
  //                                             padding: EdgeInsets.fromLTRB(
  //                                                 165, 0, 5, 0),
  //                                             child: Text(
  //                                               "Q." + counter.toString(),
  //                                               textAlign: TextAlign.center,
  //                                               style: const TextStyle(
  //                                                   fontSize: 22,
  //                                                   color: Colors.white,
  //                                                   fontWeight:
  //                                                       FontWeight.w600),
  //                                             ),
  //                                           ),
  //                                         ),
  //                                       ),
  //                                     ),
  //                                     Expanded(
  //                                       flex: 8,
  //                                       child: Container(),
  //                                     ),
  //                                   ],
  //                                 ),
  //
  //                                 const SizedBox(
  //                                   height: 20,
  //                                 ),
  //
  //                                 SizedBox(
  //                                   width: size,
  //                                   child: CustomPaint(
  //                                     size: Size(
  //                                         size,
  //                                         (450 * 0.18461538461538463)
  //                                             .toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
  //                                     painter: QuestionCustomPainter(),
  //                                     child: Container(
  //                                       //width: 400,
  //                                       //height: 15,
  //                                       //margin: const EdgeInsets.all(25),
  //                                       padding: EdgeInsets.fromLTRB(
  //                                           200, 30, 200, 35),
  //                                       child: Text(
  //                                         quizObject.question,
  //                                         //"What is the Purpose of Life insurance",
  //                                         textAlign: TextAlign.center,
  //                                         style: const TextStyle(
  //                                             fontSize: 26,
  //                                             color: Colors.white,
  //                                             fontWeight: FontWeight.w600),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ),
  //
  //                                 const SizedBox(
  //                                   height: 20,
  //                                 ),
  //                                 Row(
  //                                   mainAxisAlignment: MainAxisAlignment.center,
  //                                   children: <Widget>[
  //                                     Expanded(
  //                                       flex: 5,
  //                                       child: InkWell(
  //                                         onTap: () {
  //                                           if (_enabledA) {
  //                                             setState(() {
  //                                               pressed = "A";
  //
  //                                               _enabledA = false;
  //                                               _enabledB = false;
  //                                               _enabledC = false;
  //                                               _enabledD = false;
  //
  //                                               if (quizObject.answerA ==
  //                                                   "Yes") {
  //                                                 _answerA = quizObject.answerA;
  //
  //                                                 _correctA = true;
  //
  //                                                 _correctB = false;
  //                                                 _correctC = false;
  //                                                 _correctD = false;
  //                                               }
  //                                             });
  //                                           }
  //                                         },
  //                                         child: SizedBox(
  //                                           width: size,
  //                                           child: CustomPaint(
  //                                             size: Size(
  //                                                 size,
  //                                                 (400 * 0.18461538461538463)
  //                                                     .toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
  //                                             painter: AOptionCustomPainter(
  //                                                 _correctA, pressed),
  //                                             child: Container(
  //                                               //width: 250,
  //                                               height: 80,
  //                                               //margin: const EdgeInsets.all(25),
  //                                               padding: EdgeInsets.fromLTRB(
  //                                                   200, 0, 20, 0),
  //                                               child: Center(
  //                                                 child: Text(
  //                                                   "A. " + quizObject.optionA,
  //                                                   //"A. What is the Purpose of Life insurance",
  //                                                   textAlign: TextAlign.start,
  //                                                   maxLines: 3,
  //                                                   style: TextStyle(
  //                                                       fontSize: 17,
  //                                                       color: _correctA
  //                                                           ? Colors.white
  //                                                           : !_correctA &&
  //                                                                   pressed ==
  //                                                                       "A"
  //                                                               ? Colors.white
  //                                                               : Colors.blue
  //                                                                   .shade800,
  //                                                       fontWeight:
  //                                                           FontWeight.w600),
  //                                                   // style: TextStyle(
  //                                                   //     fontSize: 18,
  //                                                   //     color: Colors.white,
  //                                                   //     fontWeight: FontWeight.w600),
  //                                                 ),
  //                                               ),
  //                                             ),
  //                                           ),
  //                                         ),
  //                                       ),
  //                                     ),
  //                                     Expanded(
  //                                       flex: 5,
  //                                       child: InkWell(
  //                                         onTap: () {
  //                                           if (_enabledB) {
  //                                             setState(() {
  //                                               pressed = "B";
  //
  //                                               _enabledB = false;
  //                                               _enabledA = false;
  //                                               _enabledC = false;
  //                                               _enabledD = false;
  //
  //                                               if (quizObject.answerB ==
  //                                                   "Yes") {
  //                                                 _answerB = quizObject.answerB;
  //
  //                                                 _correctB = true;
  //
  //                                                 _correctA = false;
  //                                                 _correctC = false;
  //                                                 _correctD = false;
  //                                               }
  //                                             });
  //                                           }
  //                                         },
  //                                         child: SizedBox(
  //                                           width: size,
  //                                           child: CustomPaint(
  //                                             size: Size(
  //                                                 size,
  //                                                 (400 * 0.18461538461538463)
  //                                                     .toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
  //                                             painter: BOptionCustomPainter(
  //                                                 _correctB, pressed),
  //                                             child: Container(
  //                                               height: 80,
  //                                               //margin: const EdgeInsets.all(25),
  //                                               padding: EdgeInsets.fromLTRB(
  //                                                   30, 0, 170, 0),
  //                                               child: Center(
  //                                                 child: Text(
  //                                                   "B. " + quizObject.optionB,
  //                                                   //"A. What is the Purpose of Life insurance",
  //                                                   textAlign: TextAlign.start,
  //                                                   maxLines: 3,
  //                                                   style: TextStyle(
  //                                                       fontSize: 18,
  //                                                       color: _correctB
  //                                                           ? Colors.white
  //                                                           : !_correctB &&
  //                                                                   pressed ==
  //                                                                       "B"
  //                                                               ? Colors.white
  //                                                               : Colors.blue
  //                                                                   .shade800,
  //                                                       fontWeight:
  //                                                           FontWeight.w600),
  //                                                 ),
  //                                               ),
  //                                             ),
  //                                           ),
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 ),
  //
  //                                 const SizedBox(
  //                                   height: 20,
  //                                 ),
  //                                 Row(
  //                                   mainAxisAlignment: MainAxisAlignment.center,
  //                                   children: <Widget>[
  //                                     Expanded(
  //                                       flex: 5,
  //                                       child: InkWell(
  //                                         onTap: () {
  //                                           if (_enabledC) {
  //                                             setState(() {
  //                                               pressed = "C";
  //
  //                                               _enabledC = false;
  //                                               _enabledA = false;
  //                                               _enabledB = false;
  //                                               _enabledD = false;
  //
  //                                               if (quizObject.answerC ==
  //                                                   "Yes") {
  //                                                 _answerC = quizObject.answerC;
  //
  //                                                 _correctC = true;
  //
  //                                                 _correctA = false;
  //                                                 _correctB = false;
  //                                                 _correctD = false;
  //                                               }
  //                                             });
  //                                           }
  //                                         },
  //                                         child: SizedBox(
  //                                           width: size,
  //                                           child: CustomPaint(
  //                                             size: Size(
  //                                                 size,
  //                                                 (400 * 0.18461538461538463)
  //                                                     .toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
  //                                             painter: COptionCustomPainter(
  //                                                 _correctC, pressed),
  //                                             child: Container(
  //                                               //width: 250,
  //                                               height: 80,
  //                                               //margin: const EdgeInsets.all(25),
  //                                               padding: EdgeInsets.fromLTRB(
  //                                                   200, 0, 20, 0),
  //                                               child: Center(
  //                                                 child: Text(
  //                                                   "C. " + quizObject.optionC,
  //                                                   textAlign: TextAlign.start,
  //                                                   maxLines: 3,
  //                                                   style: TextStyle(
  //                                                       fontSize: 17,
  //                                                       color: _correctC
  //                                                           ? Colors.white
  //                                                           : !_correctC &&
  //                                                                   pressed ==
  //                                                                       "C"
  //                                                               ? Colors.white
  //                                                               : Colors.blue
  //                                                                   .shade800,
  //                                                       fontWeight:
  //                                                           FontWeight.w600),
  //                                                   // style: TextStyle(
  //                                                   //     fontSize: 18,
  //                                                   //     color: Colors.white,
  //                                                   //     fontWeight: FontWeight.w600),
  //                                                 ),
  //                                               ),
  //                                             ),
  //                                           ),
  //                                         ),
  //                                       ),
  //                                     ),
  //                                     Expanded(
  //                                       flex: 5,
  //                                       child: InkWell(
  //                                         onTap: () {
  //                                           if (_enabledD) {
  //                                             setState(() {
  //                                               pressed = "D";
  //
  //                                               _enabledD = false;
  //                                               _enabledA = false;
  //                                               _enabledB = false;
  //                                               _enabledC = false;
  //
  //                                               if (quizObject.answerD ==
  //                                                   "Yes") {
  //                                                 _answerD = quizObject.answerD;
  //
  //                                                 _correctD = true;
  //                                                 _correctA = false;
  //                                                 _correctB = false;
  //                                                 _correctC = false;
  //                                               }
  //                                             });
  //                                           }
  //                                         },
  //                                         child: SizedBox(
  //                                           width: size,
  //                                           child: CustomPaint(
  //                                             size: Size(
  //                                                 size,
  //                                                 (400 * 0.18461538461538463)
  //                                                     .toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
  //                                             painter: DOptionCustomPainter(
  //                                                 _correctD, pressed),
  //                                             child: Container(
  //                                               //width: 250,
  //                                               height: 80,
  //                                               //margin: const EdgeInsets.all(25),
  //                                               padding: EdgeInsets.fromLTRB(
  //                                                   30, 0, 170, 0),
  //                                               child: Center(
  //                                                 child: Text(
  //                                                   "D. " + quizObject.optionD,
  //                                                   maxLines: 3,
  //                                                   //"A. What is the Purpose of Life insurance",
  //                                                   textAlign: TextAlign.start,
  //                                                   style: TextStyle(
  //                                                       fontSize: 17,
  //                                                       color: _correctD
  //                                                           ? Colors.white
  //                                                           : !_correctD &&
  //                                                                   pressed ==
  //                                                                       "D"
  //                                                               ? Colors.white
  //                                                               : Colors.blue
  //                                                                   .shade800,
  //                                                       fontWeight:
  //                                                           FontWeight.w600),
  //                                                 ),
  //                                               ),
  //                                             ),
  //                                           ),
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 ),
  //
  //                                 const SizedBox(
  //                                   height: 20,
  //                                 ),
  //
  //                                 Row(
  //                                   children: [
  //                                     index > 0
  //                                         ? Padding(
  //                                             padding:
  //                                                 const EdgeInsets.fromLTRB(
  //                                                     30, 0, 0, 0),
  //                                             child: Container(
  //                                               height: 45,
  //                                               width: 120,
  //                                               child: OutlinedButton(
  //                                                 style:
  //                                                     OutlinedButton.styleFrom(
  //                                                   backgroundColor:
  //                                                       Colors.white,
  //                                                   shape:
  //                                                       RoundedRectangleBorder(
  //                                                           borderRadius:
  //                                                               BorderRadius
  //                                                                   .circular(
  //                                                                       15.0)),
  //                                                   side: const BorderSide(
  //                                                     width: 2,
  //                                                     color: Color(0xff0F5A93),
  //                                                   ),
  //                                                 ),
  //                                                 child: const Text(
  //                                                   "Previous",
  //                                                   style: TextStyle(
  //                                                     fontSize: 16,
  //                                                     fontWeight:
  //                                                         FontWeight.bold,
  //                                                     color: Color(0xff0F5A93),
  //                                                   ),
  //                                                 ),
  //                                                 onPressed: () {
  //                                                   index > 0
  //                                                       ? getQuizQuestion(false)
  //                                                       : Container();
  //                                                 },
  //                                               ),
  //                                             ),
  //                                           )
  //                                         : Container(),
  //                                     const Spacer(),
  //                                     Padding(
  //                                       padding: const EdgeInsets.fromLTRB(
  //                                           0, 0, 30, 0),
  //                                       child: Container(
  //                                         height: 45,
  //                                         width: 120,
  //                                         child: OutlinedButton(
  //                                           style: OutlinedButton.styleFrom(
  //                                             backgroundColor:
  //                                                 Color(0xff0F5A93),
  //                                             shape: RoundedRectangleBorder(
  //                                                 borderRadius:
  //                                                     BorderRadius.circular(
  //                                                         15.0)),
  //                                             side: const BorderSide(
  //                                               width: 2,
  //                                               color: Colors.white,
  //                                             ),
  //                                           ),
  //                                           child: Text(
  //                                             quizList.length - 1 != index
  //                                                 ? 'Next'
  //                                                 : 'Finish',
  //                                             style: const TextStyle(
  //                                                 fontSize: 17,
  //                                                 color: Colors.white),
  //                                           ),
  //                                           onPressed: () async {
  //                                             if (index == 0) {
  //                                               await Common
  //                                                   .setQuestion0Pressed(
  //                                                       pressed);
  //                                             } else if (index == 1) {
  //                                               await Common
  //                                                   .setQuestion1Pressed(
  //                                                       pressed);
  //                                             } else if (index == 2) {
  //                                               await Common
  //                                                   .setQuestion2Pressed(
  //                                                       pressed);
  //                                             } else if (index == 3) {
  //                                               await Common
  //                                                   .setQuestion3Pressed(
  //                                                       pressed);
  //                                             } else if (index == 4) {
  //                                               await Common
  //                                                   .setQuestion4Pressed(
  //                                                       pressed);
  //                                             } else if (index == 5) {
  //                                               await Common
  //                                                   .setQuestion5Pressed(
  //                                                       pressed);
  //                                             } else if (index == 6) {
  //                                               await Common
  //                                                   .setQuestion6Pressed(
  //                                                       pressed);
  //                                             } else if (index == 7) {
  //                                               await Common
  //                                                   .setQuestion7Pressed(
  //                                                       pressed);
  //                                             } else if (index == 8) {
  //                                               await Common
  //                                                   .setQuestion8Pressed(
  //                                                       pressed);
  //                                             } else if (index == 9) {
  //                                               await Common
  //                                                   .setQuestion9Pressed(
  //                                                       pressed);
  //                                             }
  //
  //                                             if (pressed == "A") {
  //                                               if (quizObject.answerA ==
  //                                                   "Yes") {
  //                                                 setState(() {
  //                                                   score = score + 1;
  //                                                 });
  //                                               } else {
  //                                                 // if(score > 0 ){
  //                                                 //   setState(() {
  //                                                 //     score = score - 1;
  //                                                 //   });
  //                                                 // }
  //                                               }
  //
  //                                               if (index == 0) {
  //                                                 await Common
  //                                                     .setQuestion0Pressed(
  //                                                         pressed);
  //
  //                                                 if (quizObject.answerA ==
  //                                                     "Yes") {
  //                                                   await Common
  //                                                       .setQuestion0CorrectedA(
  //                                                           true);
  //                                                 } else {
  //                                                   await Common
  //                                                       .setQuestion0CorrectedA(
  //                                                           false);
  //                                                 }
  //                                               } else if (index == 1) {
  //                                                 await Common
  //                                                     .setQuestion1Pressed(
  //                                                         pressed);
  //
  //                                                 if (quizObject.answerA ==
  //                                                     "Yes") {
  //                                                   await Common
  //                                                       .setQuestion1CorrectedA(
  //                                                           true);
  //                                                 } else {
  //                                                   await Common
  //                                                       .setQuestion1CorrectedA(
  //                                                           false);
  //                                                 }
  //                                               } else if (index == 2) {
  //                                                 await Common
  //                                                     .setQuestion2Pressed(
  //                                                         pressed);
  //
  //                                                 if (quizObject.answerA ==
  //                                                     "Yes") {
  //                                                   await Common
  //                                                       .setQuestion2CorrectedA(
  //                                                           true);
  //                                                 } else {
  //                                                   await Common
  //                                                       .setQuestion2CorrectedA(
  //                                                           false);
  //                                                 }
  //                                               } else if (index == 3) {
  //                                                 await Common
  //                                                     .setQuestion3Pressed(
  //                                                         pressed);
  //
  //                                                 if (quizObject.answerA ==
  //                                                     "Yes") {
  //                                                   await Common
  //                                                       .setQuestion3CorrectedA(
  //                                                           true);
  //                                                 } else {
  //                                                   await Common
  //                                                       .setQuestion3CorrectedA(
  //                                                           false);
  //                                                 }
  //                                               } else if (index == 4) {
  //                                                 await Common
  //                                                     .setQuestion4Pressed(
  //                                                         pressed);
  //
  //                                                 if (quizObject.answerA ==
  //                                                     "Yes") {
  //                                                   await Common
  //                                                       .setQuestion4CorrectedA(
  //                                                           true);
  //                                                 } else {
  //                                                   await Common
  //                                                       .setQuestion4CorrectedA(
  //                                                           false);
  //                                                 }
  //                                               } else if (index == 5) {
  //                                                 await Common
  //                                                     .setQuestion5Pressed(
  //                                                         pressed);
  //
  //                                                 if (quizObject.answerA ==
  //                                                     "Yes") {
  //                                                   await Common
  //                                                       .setQuestion5CorrectedA(
  //                                                           true);
  //                                                 } else {
  //                                                   await Common
  //                                                       .setQuestion5CorrectedA(
  //                                                           false);
  //                                                 }
  //                                               } else if (index == 6) {
  //                                                 await Common
  //                                                     .setQuestion6Pressed(
  //                                                         pressed);
  //
  //                                                 if (quizObject.answerA ==
  //                                                     "Yes") {
  //                                                   await Common
  //                                                       .setQuestion6CorrectedA(
  //                                                           true);
  //                                                 } else {
  //                                                   await Common
  //                                                       .setQuestion6CorrectedA(
  //                                                           false);
  //                                                 }
  //                                               } else if (index == 7) {
  //                                                 await Common
  //                                                     .setQuestion7Pressed(
  //                                                         pressed);
  //
  //                                                 if (quizObject.answerA ==
  //                                                     "Yes") {
  //                                                   await Common
  //                                                       .setQuestion7CorrectedA(
  //                                                           true);
  //                                                 } else {
  //                                                   await Common
  //                                                       .setQuestion7CorrectedA(
  //                                                           false);
  //                                                 }
  //                                               } else if (index == 8) {
  //                                                 await Common
  //                                                     .setQuestion8Pressed(
  //                                                         pressed);
  //
  //                                                 if (quizObject.answerA ==
  //                                                     "Yes") {
  //                                                   await Common
  //                                                       .setQuestion8CorrectedA(
  //                                                           true);
  //                                                 } else {
  //                                                   await Common
  //                                                       .setQuestion8CorrectedA(
  //                                                           false);
  //                                                 }
  //                                               } else if (index == 9) {
  //                                                 await Common
  //                                                     .setQuestion9Pressed(
  //                                                         pressed);
  //                                                 if (quizObject.answerA ==
  //                                                     "Yes") {
  //                                                   await Common
  //                                                       .setQuestion9CorrectedA(
  //                                                           true);
  //                                                 } else {
  //                                                   await Common
  //                                                       .setQuestion9CorrectedA(
  //                                                           false);
  //                                                 }
  //                                               }
  //                                             } else if (pressed == "B") {
  //                                               if (quizObject.answerB ==
  //                                                   "Yes") {
  //                                                 setState(() {
  //                                                   score = score + 1;
  //                                                 });
  //                                               } else {
  //                                                 // if(score > 0 ){
  //                                                 //   setState(() {
  //                                                 //     score = score - 1;
  //                                                 //   });
  //                                                 // }
  //                                               }
  //
  //                                               if (index == 0) {
  //                                                 await Common
  //                                                     .setQuestion0Pressed(
  //                                                         pressed);
  //
  //                                                 if (quizObject.answerB ==
  //                                                     "Yes") {
  //                                                   await Common
  //                                                       .setQuestion0CorrectedB(
  //                                                           true);
  //                                                 } else {
  //                                                   await Common
  //                                                       .setQuestion0CorrectedB(
  //                                                           false);
  //                                                 }
  //                                               } else if (index == 1) {
  //                                                 await Common
  //                                                     .setQuestion1Pressed(
  //                                                         pressed);
  //
  //                                                 if (quizObject.answerB ==
  //                                                     "Yes") {
  //                                                   await Common
  //                                                       .setQuestion1CorrectedB(
  //                                                           true);
  //                                                 } else {
  //                                                   await Common
  //                                                       .setQuestion1CorrectedB(
  //                                                           false);
  //                                                 }
  //                                               } else if (index == 2) {
  //                                                 await Common
  //                                                     .setQuestion2Pressed(
  //                                                         pressed);
  //
  //                                                 if (quizObject.answerB ==
  //                                                     "Yes") {
  //                                                   await Common
  //                                                       .setQuestion2CorrectedB(
  //                                                           true);
  //                                                 } else {
  //                                                   await Common
  //                                                       .setQuestion2CorrectedB(
  //                                                           false);
  //                                                 }
  //                                               } else if (index == 3) {
  //                                                 await Common
  //                                                     .setQuestion3Pressed(
  //                                                         pressed);
  //
  //                                                 if (quizObject.answerB ==
  //                                                     "Yes") {
  //                                                   await Common
  //                                                       .setQuestion3CorrectedB(
  //                                                           true);
  //                                                 } else {
  //                                                   await Common
  //                                                       .setQuestion3CorrectedB(
  //                                                           false);
  //                                                 }
  //                                               } else if (index == 4) {
  //                                                 await Common
  //                                                     .setQuestion4Pressed(
  //                                                         pressed);
  //
  //                                                 if (quizObject.answerB ==
  //                                                     "Yes") {
  //                                                   await Common
  //                                                       .setQuestion4CorrectedB(
  //                                                           true);
  //                                                 } else {
  //                                                   await Common
  //                                                       .setQuestion4CorrectedB(
  //                                                           false);
  //                                                 }
  //                                               } else if (index == 5) {
  //                                                 await Common
  //                                                     .setQuestion5Pressed(
  //                                                         pressed);
  //
  //                                                 if (quizObject.answerB ==
  //                                                     "Yes") {
  //                                                   await Common
  //                                                       .setQuestion5CorrectedB(
  //                                                           true);
  //                                                 } else {
  //                                                   await Common
  //                                                       .setQuestion5CorrectedB(
  //                                                           false);
  //                                                 }
  //                                               } else if (index == 6) {
  //                                                 await Common
  //                                                     .setQuestion6Pressed(
  //                                                         pressed);
  //
  //                                                 if (quizObject.answerB ==
  //                                                     "Yes") {
  //                                                   await Common
  //                                                       .setQuestion6CorrectedB(
  //                                                           true);
  //                                                 } else {
  //                                                   await Common
  //                                                       .setQuestion6CorrectedB(
  //                                                           false);
  //                                                 }
  //                                               } else if (index == 7) {
  //                                                 await Common
  //                                                     .setQuestion7Pressed(
  //                                                         pressed);
  //
  //                                                 if (quizObject.answerB ==
  //                                                     "Yes") {
  //                                                   await Common
  //                                                       .setQuestion7CorrectedB(
  //                                                           true);
  //                                                 } else {
  //                                                   await Common
  //                                                       .setQuestion7CorrectedB(
  //                                                           false);
  //                                                 }
  //                                               } else if (index == 8) {
  //                                                 await Common
  //                                                     .setQuestion8Pressed(
  //                                                         pressed);
  //
  //                                                 if (quizObject.answerB ==
  //                                                     "Yes") {
  //                                                   await Common
  //                                                       .setQuestion8CorrectedB(
  //                                                           true);
  //                                                 } else {
  //                                                   await Common
  //                                                       .setQuestion8CorrectedB(
  //                                                           false);
  //                                                 }
  //                                               } else if (index == 9) {
  //                                                 await Common
  //                                                     .setQuestion9Pressed(
  //                                                         pressed);
  //                                                 if (quizObject.answerB ==
  //                                                     "Yes") {
  //                                                   await Common
  //                                                       .setQuestion9CorrectedB(
  //                                                           true);
  //                                                 } else {
  //                                                   await Common
  //                                                       .setQuestion9CorrectedB(
  //                                                           false);
  //                                                 }
  //                                               }
  //                                             } else if (pressed == "C") {
  //                                               if (quizObject.answerC ==
  //                                                   "Yes") {
  //                                                 setState(() {
  //                                                   score = score + 1;
  //                                                 });
  //                                               } else {
  //                                                 // if(score > 0 ){
  //                                                 //   setState(() {
  //                                                 //     score = score - 1;
  //                                                 //   });
  //                                                 // }
  //                                               }
  //
  //                                               if (index == 0) {
  //                                                 await Common
  //                                                     .setQuestion0Pressed(
  //                                                         pressed);
  //
  //                                                 if (quizObject.answerC ==
  //                                                     "Yes") {
  //                                                   await Common
  //                                                       .setQuestion0CorrectedC(
  //                                                           true);
  //                                                 } else {
  //                                                   await Common
  //                                                       .setQuestion0CorrectedC(
  //                                                           false);
  //                                                 }
  //                                               } else if (index == 1) {
  //                                                 await Common
  //                                                     .setQuestion1Pressed(
  //                                                         pressed);
  //
  //                                                 if (quizObject.answerC ==
  //                                                     "Yes") {
  //                                                   await Common
  //                                                       .setQuestion1CorrectedC(
  //                                                           true);
  //                                                 } else {
  //                                                   await Common
  //                                                       .setQuestion1CorrectedC(
  //                                                           false);
  //                                                 }
  //                                               } else if (index == 2) {
  //                                                 await Common
  //                                                     .setQuestion2Pressed(
  //                                                         pressed);
  //
  //                                                 if (quizObject.answerC ==
  //                                                     "Yes") {
  //                                                   await Common
  //                                                       .setQuestion2CorrectedC(
  //                                                           true);
  //                                                 } else {
  //                                                   await Common
  //                                                       .setQuestion2CorrectedC(
  //                                                           false);
  //                                                 }
  //                                               } else if (index == 3) {
  //                                                 await Common
  //                                                     .setQuestion3Pressed(
  //                                                         pressed);
  //
  //                                                 if (quizObject.answerC ==
  //                                                     "Yes") {
  //                                                   await Common
  //                                                       .setQuestion3CorrectedC(
  //                                                           true);
  //                                                 } else {
  //                                                   await Common
  //                                                       .setQuestion3CorrectedC(
  //                                                           false);
  //                                                 }
  //                                               } else if (index == 4) {
  //                                                 await Common
  //                                                     .setQuestion4Pressed(
  //                                                         pressed);
  //
  //                                                 if (quizObject.answerC ==
  //                                                     "Yes") {
  //                                                   await Common
  //                                                       .setQuestion4CorrectedC(
  //                                                           true);
  //                                                 } else {
  //                                                   await Common
  //                                                       .setQuestion4CorrectedC(
  //                                                           false);
  //                                                 }
  //                                               } else if (index == 5) {
  //                                                 await Common
  //                                                     .setQuestion5Pressed(
  //                                                         pressed);
  //
  //                                                 if (quizObject.answerC ==
  //                                                     "Yes") {
  //                                                   await Common
  //                                                       .setQuestion5CorrectedC(
  //                                                           true);
  //                                                 } else {
  //                                                   await Common
  //                                                       .setQuestion5CorrectedC(
  //                                                           false);
  //                                                 }
  //                                               } else if (index == 6) {
  //                                                 await Common
  //                                                     .setQuestion6Pressed(
  //                                                         pressed);
  //
  //                                                 if (quizObject.answerC ==
  //                                                     "Yes") {
  //                                                   await Common
  //                                                       .setQuestion6CorrectedC(
  //                                                           true);
  //                                                 } else {
  //                                                   await Common
  //                                                       .setQuestion6CorrectedC(
  //                                                           false);
  //                                                 }
  //                                               } else if (index == 7) {
  //                                                 await Common
  //                                                     .setQuestion7Pressed(
  //                                                         pressed);
  //
  //                                                 if (quizObject.answerC ==
  //                                                     "Yes") {
  //                                                   await Common
  //                                                       .setQuestion7CorrectedC(
  //                                                           true);
  //                                                 } else {
  //                                                   await Common
  //                                                       .setQuestion7CorrectedC(
  //                                                           false);
  //                                                 }
  //                                               } else if (index == 8) {
  //                                                 await Common
  //                                                     .setQuestion8Pressed(
  //                                                         pressed);
  //
  //                                                 if (quizObject.answerC ==
  //                                                     "Yes") {
  //                                                   await Common
  //                                                       .setQuestion8CorrectedC(
  //                                                           true);
  //                                                 } else {
  //                                                   await Common
  //                                                       .setQuestion8CorrectedC(
  //                                                           false);
  //                                                 }
  //                                               } else if (index == 9) {
  //                                                 await Common
  //                                                     .setQuestion9Pressed(
  //                                                         pressed);
  //                                                 if (quizObject.answerC ==
  //                                                     "Yes") {
  //                                                   await Common
  //                                                       .setQuestion9CorrectedC(
  //                                                           true);
  //                                                 } else {
  //                                                   await Common
  //                                                       .setQuestion9CorrectedC(
  //                                                           false);
  //                                                 }
  //                                               }
  //                                             } else if (pressed == "D") {
  //                                               if (quizObject.answerD ==
  //                                                   "Yes") {
  //                                                 setState(() {
  //                                                   score = score + 1;
  //                                                 });
  //                                               } else {
  //                                                 // if(score > 0 ){
  //                                                 //   setState(() {
  //                                                 //     score = score - 1;
  //                                                 //   });
  //                                                 // }
  //                                               }
  //
  //                                               if (index == 0) {
  //                                                 await Common
  //                                                     .setQuestion0Pressed(
  //                                                         pressed);
  //
  //                                                 if (quizObject.answerD ==
  //                                                     "Yes") {
  //                                                   await Common
  //                                                       .setQuestion0CorrectedD(
  //                                                           true);
  //                                                 } else {
  //                                                   await Common
  //                                                       .setQuestion0CorrectedD(
  //                                                           false);
  //                                                 }
  //                                               } else if (index == 1) {
  //                                                 await Common
  //                                                     .setQuestion1Pressed(
  //                                                         pressed);
  //
  //                                                 if (quizObject.answerD ==
  //                                                     "Yes") {
  //                                                   await Common
  //                                                       .setQuestion1CorrectedD(
  //                                                           true);
  //                                                 } else {
  //                                                   await Common
  //                                                       .setQuestion1CorrectedD(
  //                                                           false);
  //                                                 }
  //                                               } else if (index == 2) {
  //                                                 await Common
  //                                                     .setQuestion2Pressed(
  //                                                         pressed);
  //
  //                                                 if (quizObject.answerD ==
  //                                                     "Yes") {
  //                                                   await Common
  //                                                       .setQuestion2CorrectedD(
  //                                                           true);
  //                                                 } else {
  //                                                   await Common
  //                                                       .setQuestion2CorrectedD(
  //                                                           false);
  //                                                 }
  //                                               } else if (index == 3) {
  //                                                 await Common
  //                                                     .setQuestion3Pressed(
  //                                                         pressed);
  //
  //                                                 if (quizObject.answerD ==
  //                                                     "Yes") {
  //                                                   await Common
  //                                                       .setQuestion3CorrectedD(
  //                                                           true);
  //                                                 } else {
  //                                                   await Common
  //                                                       .setQuestion3CorrectedD(
  //                                                           false);
  //                                                 }
  //                                               } else if (index == 4) {
  //                                                 await Common
  //                                                     .setQuestion4Pressed(
  //                                                         pressed);
  //
  //                                                 if (quizObject.answerD ==
  //                                                     "Yes") {
  //                                                   await Common
  //                                                       .setQuestion4CorrectedD(
  //                                                           true);
  //                                                 } else {
  //                                                   await Common
  //                                                       .setQuestion4CorrectedD(
  //                                                           false);
  //                                                 }
  //                                               } else if (index == 5) {
  //                                                 await Common
  //                                                     .setQuestion5Pressed(
  //                                                         pressed);
  //
  //                                                 if (quizObject.answerD ==
  //                                                     "Yes") {
  //                                                   await Common
  //                                                       .setQuestion5CorrectedD(
  //                                                           true);
  //                                                 } else {
  //                                                   await Common
  //                                                       .setQuestion5CorrectedD(
  //                                                           false);
  //                                                 }
  //                                               } else if (index == 6) {
  //                                                 await Common
  //                                                     .setQuestion6Pressed(
  //                                                         pressed);
  //
  //                                                 if (quizObject.answerD ==
  //                                                     "Yes") {
  //                                                   await Common
  //                                                       .setQuestion6CorrectedD(
  //                                                           true);
  //                                                 } else {
  //                                                   await Common
  //                                                       .setQuestion6CorrectedD(
  //                                                           false);
  //                                                 }
  //                                               } else if (index == 7) {
  //                                                 await Common
  //                                                     .setQuestion7Pressed(
  //                                                         pressed);
  //
  //                                                 if (quizObject.answerD ==
  //                                                     "Yes") {
  //                                                   await Common
  //                                                       .setQuestion7CorrectedD(
  //                                                           true);
  //                                                 } else {
  //                                                   await Common
  //                                                       .setQuestion7CorrectedD(
  //                                                           false);
  //                                                 }
  //                                               } else if (index == 8) {
  //                                                 await Common
  //                                                     .setQuestion8Pressed(
  //                                                         pressed);
  //
  //                                                 if (quizObject.answerD ==
  //                                                     "Yes") {
  //                                                   await Common
  //                                                       .setQuestion8CorrectedD(
  //                                                           true);
  //                                                 } else {
  //                                                   await Common
  //                                                       .setQuestion8CorrectedD(
  //                                                           false);
  //                                                 }
  //                                               } else if (index == 9) {
  //                                                 await Common
  //                                                     .setQuestion9Pressed(
  //                                                         pressed);
  //                                                 if (quizObject.answerD ==
  //                                                     "Yes") {
  //                                                   await Common
  //                                                       .setQuestion9CorrectedD(
  //                                                           true);
  //                                                 } else {
  //                                                   await Common
  //                                                       .setQuestion9CorrectedD(
  //                                                           false);
  //                                                 }
  //                                               }
  //                                             }
  //
  //
  //                                             quizList.length - 1 != index
  //                                                 ? getQuizQuestion(true)
  //                                                 : nextScreen(score);
  //                                                 // : Navigator.push(
  //                                                 //     context,
  //                                                 //     MaterialPageRoute(
  //                                                 //         // builder: (context) => ChessGame()),
  //                                                 //         builder: (context) =>
  //                                                 //             ScoreBoardScreen(
  //                                                 //               Score: score
  //                                                 //                   .toString(),
  //                                                 //             )));
  //                                           },
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 ),
  //                                 const SizedBox(height: 20),
  //
  //
  //                               ],
  //                             ),
  //                           ),
  //                         )
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //           TargetPlatform.android == defaultTargetPlatform
  //               ? Positioned(
  //                   top: 20.0,
  //                   right: 30.0,
  //                   child: InkWell(
  //                     onTap: () {
  //                       Navigator.of(context).pop();
  //                       Navigator.push(
  //                         context,
  //                         MaterialPageRoute(
  //                             // builder: (context) => ChessGame()),
  //                             builder: (context) => ZoneHomeScreen()),
  //                       );
  //                     },
  //                     child: Container(
  //                       margin: const EdgeInsets.all(10),
  //                       height: 100,
  //                       width: 40,
  //                       decoration: const BoxDecoration(
  //                         image: DecorationImage(
  //                           image: AssetImage("assets/games/Home Icon.png"),
  //                           fit: BoxFit.contain,
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 )
  //               : Positioned(
  //                   top: 30.0,
  //                   right: 30.0,
  //                   child: InkWell(
  //                     onTap: () {
  //                       Navigator.of(context).pop();
  //                       Navigator.push(
  //                         context,
  //                         MaterialPageRoute(
  //                             // builder: (context) => ChessGame()),
  //                             builder: (context) => ZoneHomeScreen()),
  //                       );
  //                     },
  //                     child: Container(
  //                       margin: const EdgeInsets.all(10),
  //                       height: 100,
  //                       width: 40,
  //                       decoration: const BoxDecoration(
  //                         image: DecorationImage(
  //                           image: AssetImage("assets/games/Home Icon.png"),
  //                           fit: BoxFit.contain,
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //
  //
  //         ],
  //       ),
  //     ),
  //   );
  // }
  //
  //
  // void nextScreen(int score){
  //   Navigator.of(context).pop();
  //   Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         // builder: (context) => ChessGame()),
  //           builder: (context) =>
  //               ScoreBoardScreen(
  //                 Score: score
  //                     .toString(),
  //               )));
  // }
  //
  // void restartTime(){
  //   if(mounted){
  //
  //     setState(() {
  //       _timer.cancel();
  //       startTimer();
  //     });
  //   }
  // }
  //
  // @override
  // void dispose() {
  //   super.dispose();
  //   _timer.cancel();
  // }



  Future<void> getQuizQuestion(bool value) async {
    /// false for PREVIOUS and true for NEXT

    if (value) {
      print(index);

      setState(() {
        index = index + 1;
        counter = index + 1;
        quizObject = quizList[index];
      });

      //if (index >= 7) {

      if (index == 0) {
        await Common.getQuestion0Pressed().then((value) => {
              setState(() {
                if (value == null) {
                  pressed = "";
                } else {
                  pressed = value;
                }
              }),
            });
        if (pressed == "A") {
          setState(() {
            _enabledA = false;
            _enabledB = false;
            _enabledC = false;
            _enabledD = false;
          });
          if (score > 0) {
            setState(() {
              score = score - 1;
            });
          }
        } else {
          setState(() {
            // _enabledA = true;
            // _enabledB = true;
            // _enabledC = true;
            // _enabledD = true;
          });
        }
        await Common.getQuestion0CorrectedA().then((value) => {
              setState(() {
                if (value == null) {
                  _correctA = false;
                } else {
                  _correctA = value;
                }
              }),
            });
        await Common.getQuestion0CorrectedB().then((value) => {
              setState(() {
                if (value == null) {
                  _correctB = false;
                } else {
                  _correctB = value;
                }
              }),
            });
        await Common.getQuestion0CorrectedC().then((value) => {
              setState(() {
                if (value == null) {
                  _correctC = false;
                } else {
                  _correctC = value;
                }
              }),
            });
        await Common.getQuestion0CorrectedD().then((value) => {
              setState(() {
                if (value == null) {
                  _correctD = false;
                } else {
                  _correctD = value;
                }
              }),
            });
      } else if (index == 1) {
        await Common.getQuestion1Pressed().then((value) => {
              setState(() {
                if (value == null) {
                  pressed = "";
                } else {
                  pressed = value;
                }
              }),
            });
        if (pressed == "B") {
          setState(() {
            _enabledA = false;
            _enabledB = false;
            _enabledC = false;
            _enabledD = false;
          });
          if (score > 0) {
            setState(() {
              score = score - 1;
            });
          }
        } else {
          setState(() {
            // _enabledA = true;
            // _enabledB = true;
            // _enabledC = true;
            // _enabledD = true;
          });
        }
        await Common.getQuestion1CorrectedA().then((value) => {
              setState(() {
                if (value == null) {
                  _correctA = false;
                } else {
                  _correctA = value;
                }
              }),
            });
        await Common.getQuestion1CorrectedB().then((value) => {
              setState(() {
                if (value == null) {
                  _correctB = false;
                } else {
                  _correctB = value;
                }
              }),
            });
        await Common.getQuestion1CorrectedC().then((value) => {
              setState(() {
                if (value == null) {
                  _correctC = false;
                } else {
                  _correctC = value;
                }
              }),
            });
        await Common.getQuestion1CorrectedD().then((value) => {
              setState(() {
                if (value == null) {
                  _correctD = false;
                } else {
                  _correctD = value;
                }
              }),
            });
      } else if (index == 2) {
        await Common.getQuestion2Pressed().then((value) => {
              setState(() {
                if (value == null) {
                  pressed = "";
                } else {
                  pressed = value;
                }
              }),
            });
        if (pressed == "D") {
          setState(() {
            _enabledA = false;
            _enabledB = false;
            _enabledC = false;
            _enabledD = false;
          });
          if (score > 0) {
            setState(() {
              score = score - 1;
            });
          }
        } else {
          setState(() {
            // _enabledA = true;
            // _enabledB = true;
            // _enabledC = true;
            // _enabledD = true;
          });
        }
        await Common.getQuestion2CorrectedA().then((value) => {
              setState(() {
                if (value == null) {
                  _correctA = false;
                } else {
                  _correctA = value;
                }
              }),
            });
        await Common.getQuestion2CorrectedB().then((value) => {
              setState(() {
                if (value == null) {
                  _correctB = false;
                } else {
                  _correctB = value;
                }
              }),
            });
        await Common.getQuestion2CorrectedC().then((value) => {
              setState(() {
                if (value == null) {
                  _correctC = false;
                } else {
                  _correctC = value;
                }
              }),
            });
        await Common.getQuestion2CorrectedD().then((value) => {
              setState(() {
                if (value == null) {
                  _correctD = false;
                } else {
                  _correctD = value;
                }
              }),
            });
      } else if (index == 3) {
        await Common.getQuestion3Pressed().then((value) => {
              setState(() {
                if (value == null) {
                  pressed = "";
                } else {
                  pressed = value;
                }
              }),
            });
        if (pressed == "D") {
          setState(() {
            _enabledA = false;
            _enabledB = false;
            _enabledC = false;
            _enabledD = false;
          });
          if (score > 0) {
            setState(() {
              score = score - 1;
            });
          }
        } else {
          setState(() {
            // _enabledA = true;
            // _enabledB = true;
            // _enabledC = true;
            // _enabledD = true;
          });
        }
        await Common.getQuestion3CorrectedA().then((value) => {
              setState(() {
                if (value == null) {
                  _correctA = false;
                } else {
                  _correctA = value;
                }
              }),
            });
        await Common.getQuestion3CorrectedB().then((value) => {
              setState(() {
                if (value == null) {
                  _correctB = false;
                } else {
                  _correctB = value;
                }
              }),
            });
        await Common.getQuestion3CorrectedC().then((value) => {
              setState(() {
                if (value == null) {
                  _correctC = false;
                } else {
                  _correctC = value;
                }
              }),
            });
        await Common.getQuestion3CorrectedD().then((value) => {
              setState(() {
                if (value == null) {
                  _correctD = false;
                } else {
                  _correctD = value;
                }
              }),
            });
      } else if (index == 4) {
        await Common.getQuestion4Pressed().then((value) => {
              setState(() {
                if (value == null) {
                  pressed = "";
                } else {
                  pressed = value;
                }
              }),
            });
        if (pressed == "A") {
          setState(() {
            _enabledA = false;
            _enabledB = false;
            _enabledC = false;
            _enabledD = false;
          });
          if (score > 0) {
            setState(() {
              score = score - 1;
            });
          }
        } else {
          setState(() {
            // _enabledA = true;
            // _enabledB = true;
            // _enabledC = true;
            // _enabledD = true;
          });
        }
        await Common.getQuestion4CorrectedA().then((value) => {
              setState(() {
                if (value == null) {
                  _correctA = false;
                } else {
                  _correctA = value;
                }
              }),
            });
        await Common.getQuestion4CorrectedB().then((value) => {
              setState(() {
                if (value == null) {
                  _correctB = false;
                } else {
                  _correctB = value;
                }
              }),
            });
        await Common.getQuestion4CorrectedC().then((value) => {
              setState(() {
                if (value == null) {
                  _correctC = false;
                } else {
                  _correctC = value;
                }
              }),
            });
        await Common.getQuestion4CorrectedD().then((value) => {
              setState(() {
                if (value == null) {
                  _correctD = false;
                } else {
                  _correctD = value;
                }
              }),
            });
      } else if (index == 5) {
        await Common.getQuestion5Pressed().then((value) => {
              setState(() {
                if (value == null) {
                  pressed = "";
                } else {
                  pressed = value;
                }
              }),
            });
        if (pressed == "B") {
          setState(() {
            _enabledA = false;
            _enabledB = false;
            _enabledC = false;
            _enabledD = false;
          });
          if (score > 0) {
            setState(() {
              score = score - 1;
            });
          }
        } else {
          setState(() {
            // _enabledA = true;
            // _enabledB = true;
            // _enabledC = true;
            // _enabledD = true;
          });
        }
        await Common.getQuestion5CorrectedA().then((value) => {
              setState(() {
                if (value == null) {
                  _correctA = false;
                } else {
                  _correctA = value;
                }
              }),
            });
        await Common.getQuestion5CorrectedB().then((value) => {
              setState(() {
                if (value == null) {
                  _correctB = false;
                } else {
                  _correctB = value;
                }
              }),
            });
        await Common.getQuestion5CorrectedC().then((value) => {
              setState(() {
                if (value == null) {
                  _correctC = false;
                } else {
                  _correctC = value;
                }
              }),
            });
        await Common.getQuestion5CorrectedD().then((value) => {
              setState(() {
                if (value == null) {
                  _correctD = false;
                } else {
                  _correctD = value;
                }
              }),
            });
      } else if (index == 6) {
        await Common.getQuestion6Pressed().then((value) => {
              setState(() {
                if (value == null) {
                  pressed = "";
                } else {
                  pressed = value;
                }
              }),
            });
        if (pressed == "A") {
          setState(() {
            _enabledA = false;
            _enabledB = false;
            _enabledC = false;
            _enabledD = false;
          });
          if (score > 0) {
            setState(() {
              score = score - 1;
            });
          }
        } else {
          setState(() {
            // _enabledA = true;
            // _enabledB = true;
            // _enabledC = true;
            // _enabledD = true;
          });
        }
        await Common.getQuestion6CorrectedA().then((value) => {
              setState(() {
                if (value == null) {
                  _correctA = false;
                } else {
                  _correctA = value;
                }
              }),
            });
        await Common.getQuestion6CorrectedB().then((value) => {
              setState(() {
                if (value == null) {
                  _correctB = false;
                } else {
                  _correctB = value;
                }
              }),
            });
        await Common.getQuestion6CorrectedC().then((value) => {
              setState(() {
                if (value == null) {
                  _correctC = false;
                } else {
                  _correctC = value;
                }
              }),
            });
        await Common.getQuestion6CorrectedD().then((value) => {
              setState(() {
                if (value == null) {
                  _correctD = false;
                } else {
                  _correctD = value;
                }
              }),
            });
      } else if (index == 7) {
        await Common.getQuestion7Pressed().then((value) => {
              setState(() {
                if (value == null) {
                  pressed = "";
                } else {
                  pressed = value;
                }
              }),
            });
        if (pressed == "A") {
          setState(() {
            _enabledA = false;
            _enabledB = false;
            _enabledC = false;
            _enabledD = false;
          });
          if (score > 0) {
            setState(() {
              score = score - 1;
            });
          }
        } else {
          setState(() {
            // _enabledA = true;
            // _enabledB = true;
            // _enabledC = true;
            // _enabledD = true;
          });
        }
        await Common.getQuestion7CorrectedA().then((value) => {
              setState(() {
                if (value == null) {
                  _correctA = false;
                } else {
                  _correctA = value;
                }
              }),
            });
        await Common.getQuestion7CorrectedB().then((value) => {
              setState(() {
                if (value == null) {
                  _correctB = false;
                } else {
                  _correctB = value;
                }
              }),
            });
        await Common.getQuestion7CorrectedC().then((value) => {
              setState(() {
                if (value == null) {
                  _correctC = false;
                } else {
                  _correctC = value;
                }
              }),
            });
        await Common.getQuestion7CorrectedD().then((value) => {
              setState(() {
                if (value == null) {
                  _correctD = false;
                } else {
                  _correctD = value;
                }
              }),
            });
      } else if (index == 8) {
        await Common.getQuestion8Pressed().then((value) => {
              setState(() {
                if (value == null) {
                  pressed = "";
                } else {
                  pressed = value;
                }
              }),
            });
        if (pressed == "B") {
          setState(() {
            _enabledA = false;
            _enabledB = false;
            _enabledC = false;
            _enabledD = false;
          });
          if (score > 0) {
            setState(() {
              score = score - 1;
            });
          }
        } else {
          setState(() {
            // _enabledA = true;
            // _enabledB = true;
            // _enabledC = true;
            // _enabledD = true;
          });
        }
        await Common.getQuestion8CorrectedA().then((value) => {
              setState(() {
                if (value == null) {
                  _correctA = false;
                } else {
                  _correctA = value;
                }
              }),
            });
        await Common.getQuestion8CorrectedB().then((value) => {
              setState(() {
                if (value == null) {
                  _correctB = false;
                } else {
                  _correctB = value;
                }
              }),
            });
        await Common.getQuestion8CorrectedC().then((value) => {
              setState(() {
                if (value == null) {
                  _correctC = false;
                } else {
                  _correctC = value;
                }
              }),
            });
        await Common.getQuestion8CorrectedD().then((value) => {
              setState(() {
                if (value == null) {
                  _correctD = false;
                } else {
                  _correctD = value;
                }
              }),
            });
      } else if (index == 9) {
        await Common.getQuestion9Pressed().then((value) => {
              setState(() {
                if (value == null) {
                  pressed = "";
                } else {
                  pressed = value;
                }
              }),
            });
        if (pressed == "C") {
          setState(() {
            _enabledA = false;
            _enabledB = false;
            _enabledC = false;
            _enabledD = false;
          });
          if (score > 0) {
            setState(() {
              score = score - 1;
            });
          }
        } else {
          setState(() {
            // _enabledA = true;
            // _enabledB = true;
            // _enabledC = true;
            // _enabledD = true;
          });
        }
        await Common.getQuestion9CorrectedA().then((value) => {
              setState(() {
                if (value == null) {
                  _correctA = false;
                } else {
                  _correctA = value;
                }
              }),
            });
        await Common.getQuestion9CorrectedB().then((value) => {
              setState(() {
                if (value == null) {
                  _correctB = false;
                } else {
                  _correctB = value;
                }
              }),
            });
        await Common.getQuestion9CorrectedC().then((value) => {
              setState(() {
                if (value == null) {
                  _correctC = false;
                } else {
                  _correctC = value;
                }
              }),
            });
        await Common.getQuestion9CorrectedD().then((value) => {
              setState(() {
                if (value == null) {
                  _correctD = false;
                } else {
                  _correctD = value;
                }
              }),
            });
      }

      setState(() {
        _selectedAnswerA = '_';
        _enabledA = true;
        //_correctA = false;

        _selectedAnswerB = '_';
        _enabledB = true;
        //_correctB = false;

        _selectedAnswerC = '_';
        _enabledC = true;
        //_correctC = false;

        _selectedAnswerD = '_';
        _enabledD = true;
        //_correctD = false;
      });
    } else {
      print(index);

      setState(() {
        index = index - 1;
        counter = counter - 1;
        quizObject = quizList[index];
      });

      if (index == 0) {
        await Common.getQuestion0Pressed().then((value) => {
              setState(() {
                if (value == null) {
                  pressed = "";
                } else {
                  pressed = value;
                }
              }),
            });
        if (pressed == "A") {
          setState(() {
            _enabledA = false;
            _enabledB = false;
            _enabledC = false;
            _enabledD = false;
          });
          if (score > 0) {
            setState(() {
              score = score - 1;
            });
          }
        } else if (pressed == "B" || pressed == "C" || pressed == "D") {
          setState(() {
            _enabledA = false;
            _enabledB = false;
            _enabledC = false;
            _enabledD = false;
          });
        } else {}

        await Common.getQuestion0CorrectedA().then((value) => {
              setState(() {
                if (value == null) {
                  _correctA = false;
                } else {
                  _correctA = value;
                }
              }),
            });
        await Common.getQuestion0CorrectedB().then((value) => {
              setState(() {
                if (value == null) {
                  _correctB = false;
                } else {
                  _correctB = value;
                }
              }),
            });
        await Common.getQuestion0CorrectedC().then((value) => {
              setState(() {
                if (value == null) {
                  _correctC = false;
                } else {
                  _correctC = value;
                }
              }),
            });
        await Common.getQuestion0CorrectedD().then((value) => {
              setState(() {
                if (value == null) {
                  _correctD = false;
                } else {
                  _correctD = value;
                }
              }),
            });
      } else if (index == 1) {
        await Common.getQuestion1Pressed().then((value) => {
              setState(() {
                if (value == null) {
                  pressed = "";
                } else {
                  pressed = value;
                }
              }),
            });
        if (pressed == "B") {
          setState(() {
            _enabledA = false;
            _enabledB = false;
            _enabledC = false;
            _enabledD = false;
          });
          if (score > 0) {
            setState(() {
              score = score - 1;
            });
          }
        } else if (pressed == "A" || pressed == "C" || pressed == "D") {
          setState(() {
            _enabledA = false;
            _enabledB = false;
            _enabledC = false;
            _enabledD = false;
          });
        } else {}
        await Common.getQuestion1CorrectedA().then((value) => {
              setState(() {
                if (value == null) {
                  _correctA = false;
                } else {
                  _correctA = value;
                }
              }),
            });
        await Common.getQuestion1CorrectedB().then((value) => {
              setState(() {
                if (value == null) {
                  _correctB = false;
                } else {
                  _correctB = value;
                }
              }),
            });
        await Common.getQuestion1CorrectedC().then((value) => {
              setState(() {
                if (value == null) {
                  _correctC = false;
                } else {
                  _correctC = value;
                }
              }),
            });
        await Common.getQuestion1CorrectedD().then((value) => {
              setState(() {
                if (value == null) {
                  _correctD = false;
                } else {
                  _correctD = value;
                }
              }),
            });
      } else if (index == 2) {
        await Common.getQuestion2Pressed().then((value) => {
              setState(() {
                if (value == null) {
                  pressed = "";
                } else {
                  pressed = value;
                }
              }),
            });
        if (pressed == "D") {
          setState(() {
            _enabledA = false;
            _enabledB = false;
            _enabledC = false;
            _enabledD = false;
          });
          if (score > 0) {
            setState(() {
              score = score - 1;
            });
          }
        } else if (pressed == "B" || pressed == "C" || pressed == "A") {
          setState(() {
            _enabledA = false;
            _enabledB = false;
            _enabledC = false;
            _enabledD = false;
          });
        } else {}
        await Common.getQuestion2CorrectedA().then((value) => {
              setState(() {
                if (value == null) {
                  _correctA = false;
                } else {
                  _correctA = value;
                }
              }),
            });
        await Common.getQuestion2CorrectedB().then((value) => {
              setState(() {
                if (value == null) {
                  _correctB = false;
                } else {
                  _correctB = value;
                }
              }),
            });
        await Common.getQuestion2CorrectedC().then((value) => {
              setState(() {
                if (value == null) {
                  _correctC = false;
                } else {
                  _correctC = value;
                }
              }),
            });
        await Common.getQuestion2CorrectedD().then((value) => {
              setState(() {
                if (value == null) {
                  _correctD = false;
                } else {
                  _correctD = value;
                }
              }),
            });
      } else if (index == 3) {
        await Common.getQuestion3Pressed().then((value) => {
              setState(() {
                if (value == null) {
                  pressed = "";
                } else {
                  pressed = value;
                }
              }),
            });
        if (pressed == "D") {
          setState(() {
            _enabledA = false;
            _enabledB = false;
            _enabledC = false;
            _enabledD = false;
          });
          if (score > 0) {
            setState(() {
              score = score - 1;
            });
          }
        } else if (pressed == "B" || pressed == "C" || pressed == "A") {
          setState(() {
            _enabledA = false;
            _enabledB = false;
            _enabledC = false;
            _enabledD = false;
          });
        } else {}
        await Common.getQuestion3CorrectedA().then((value) => {
              setState(() {
                if (value == null) {
                  _correctA = false;
                } else {
                  _correctA = value;
                }
              }),
            });
        await Common.getQuestion3CorrectedB().then((value) => {
              setState(() {
                if (value == null) {
                  _correctB = false;
                } else {
                  _correctB = value;
                }
              }),
            });
        await Common.getQuestion3CorrectedC().then((value) => {
              setState(() {
                if (value == null) {
                  _correctC = false;
                } else {
                  _correctC = value;
                }
              }),
            });
        await Common.getQuestion3CorrectedD().then((value) => {
              setState(() {
                if (value == null) {
                  _correctD = false;
                } else {
                  _correctD = value;
                }
              }),
            });
      } else if (index == 4) {
        await Common.getQuestion4Pressed().then((value) => {
              setState(() {
                if (value == null) {
                  pressed = "";
                } else {
                  pressed = value;
                }
              }),
            });
        if (pressed == "A") {
          setState(() {
            _enabledA = false;
            _enabledB = false;
            _enabledC = false;
            _enabledD = false;
          });
          if (score > 0) {
            setState(() {
              score = score - 1;
            });
          }
        } else if (pressed == "B" || pressed == "C" || pressed == "D") {
          setState(() {
            _enabledA = false;
            _enabledB = false;
            _enabledC = false;
            _enabledD = false;
          });
        } else {}
        await Common.getQuestion4CorrectedA().then((value) => {
              setState(() {
                if (value == null) {
                  _correctA = false;
                } else {
                  _correctA = value;
                }
              }),
            });
        await Common.getQuestion4CorrectedB().then((value) => {
              setState(() {
                if (value == null) {
                  _correctB = false;
                } else {
                  _correctB = value;
                }
              }),
            });
        await Common.getQuestion4CorrectedC().then((value) => {
              setState(() {
                if (value == null) {
                  _correctC = false;
                } else {
                  _correctC = value;
                }
              }),
            });
        await Common.getQuestion4CorrectedD().then((value) => {
              setState(() {
                if (value == null) {
                  _correctD = false;
                } else {
                  _correctD = value;
                }
              }),
            });
      } else if (index == 5) {
        await Common.getQuestion5Pressed().then((value) => {
              setState(() {
                if (value == null) {
                  pressed = "";
                } else {
                  pressed = value;
                }
              }),
            });
        if (pressed == "B") {
          setState(() {
            _enabledA = false;
            _enabledB = false;
            _enabledC = false;
            _enabledD = false;
          });
          if (score > 0) {
            setState(() {
              score = score - 1;
            });
          }
        } else if (pressed == "A" || pressed == "C" || pressed == "D") {
          setState(() {
            _enabledA = false;
            _enabledB = false;
            _enabledC = false;
            _enabledD = false;
          });
        } else {}
        await Common.getQuestion5CorrectedA().then((value) => {
              setState(() {
                if (value == null) {
                  _correctA = false;
                } else {
                  _correctA = value;
                }
              }),
            });
        await Common.getQuestion5CorrectedB().then((value) => {
              setState(() {
                if (value == null) {
                  _correctB = false;
                } else {
                  _correctB = value;
                }
              }),
            });
        await Common.getQuestion5CorrectedC().then((value) => {
              setState(() {
                if (value == null) {
                  _correctC = false;
                } else {
                  _correctC = value;
                }
              }),
            });
        await Common.getQuestion5CorrectedD().then((value) => {
              setState(() {
                if (value == null) {
                  _correctD = false;
                } else {
                  _correctD = value;
                }
              }),
            });
      } else if (index == 6) {
        await Common.getQuestion6Pressed().then((value) => {
              setState(() {
                if (value == null) {
                  pressed = "";
                } else {
                  pressed = value;
                }
              }),
            });
        if (pressed == "A") {
          setState(() {
            _enabledA = false;
            _enabledB = false;
            _enabledC = false;
            _enabledD = false;
          });
          if (score > 0) {
            setState(() {
              score = score - 1;
            });
          }
        } else if (pressed == "B" || pressed == "C" || pressed == "D") {
          setState(() {
            _enabledA = false;
            _enabledB = false;
            _enabledC = false;
            _enabledD = false;
          });
        } else {}
        await Common.getQuestion6CorrectedA().then((value) => {
              setState(() {
                if (value == null) {
                  _correctA = false;
                } else {
                  _correctA = value;
                }
              }),
            });
        await Common.getQuestion6CorrectedB().then((value) => {
              setState(() {
                if (value == null) {
                  _correctB = false;
                } else {
                  _correctB = value;
                }
              }),
            });
        await Common.getQuestion6CorrectedC().then((value) => {
              setState(() {
                if (value == null) {
                  _correctC = false;
                } else {
                  _correctC = value;
                }
              }),
            });
        await Common.getQuestion6CorrectedD().then((value) => {
              setState(() {
                if (value == null) {
                  _correctD = false;
                } else {
                  _correctD = value;
                }
              }),
            });
      } else if (index == 7) {
        await Common.getQuestion7Pressed().then((value) => {
              setState(() {
                if (value == null) {
                  pressed = "";
                } else {
                  pressed = value;
                }
              }),
            });
        if (pressed == "A") {
          setState(() {
            _enabledA = false;
            _enabledB = false;
            _enabledC = false;
            _enabledD = false;
          });
          if (score > 0) {
            setState(() {
              score = score - 1;
            });
          }
        } else if (pressed == "B" || pressed == "C" || pressed == "D") {
          setState(() {
            _enabledA = false;
            _enabledB = false;
            _enabledC = false;
            _enabledD = false;
          });
        } else {}
        await Common.getQuestion7CorrectedA().then((value) => {
              setState(() {
                if (value == null) {
                  _correctA = false;
                } else {
                  _correctA = value;
                }
              }),
            });
        await Common.getQuestion7CorrectedB().then((value) => {
              setState(() {
                if (value == null) {
                  _correctB = false;
                } else {
                  _correctB = value;
                }
              }),
            });
        await Common.getQuestion7CorrectedC().then((value) => {
              setState(() {
                if (value == null) {
                  _correctC = false;
                } else {
                  _correctC = value;
                }
              }),
            });
        await Common.getQuestion7CorrectedD().then((value) => {
              setState(() {
                if (value == null) {
                  _correctD = false;
                } else {
                  _correctD = value;
                }
              }),
            });
      } else if (index == 8) {
        await Common.getQuestion8Pressed().then((value) => {
              setState(() {
                if (value == null) {
                  pressed = "";
                } else {
                  pressed = value;
                }
              }),
            });
        if (pressed == "B") {
          setState(() {
            _enabledA = false;
            _enabledB = false;
            _enabledC = false;
            _enabledD = false;
          });
          if (score > 0) {
            setState(() {
              score = score - 1;
            });
          }
        } else if (pressed == "A" || pressed == "C" || pressed == "D") {
          setState(() {
            _enabledA = false;
            _enabledB = false;
            _enabledC = false;
            _enabledD = false;
          });
        } else {}
        await Common.getQuestion8CorrectedA().then((value) => {
              setState(() {
                if (value == null) {
                  _correctA = false;
                } else {
                  _correctA = value;
                }
              }),
            });
        await Common.getQuestion8CorrectedB().then((value) => {
              setState(() {
                if (value == null) {
                  _correctB = false;
                } else {
                  _correctB = value;
                }
              }),
            });
        await Common.getQuestion8CorrectedC().then((value) => {
              setState(() {
                if (value == null) {
                  _correctC = false;
                } else {
                  _correctC = value;
                }
              }),
            });
        await Common.getQuestion8CorrectedD().then((value) => {
              setState(() {
                if (value == null) {
                  _correctD = false;
                } else {
                  _correctD = value;
                }
              }),
            });
      } else if (index == 9) {
        await Common.getQuestion9Pressed().then((value) => {
              setState(() {
                if (value == null) {
                  pressed = "";
                } else {
                  pressed = value;
                }
              }),
            });
        if (pressed == "C") {
          setState(() {
            _enabledA = false;
            _enabledB = false;
            _enabledC = false;
            _enabledD = false;
          });
          if (score > 0) {
            setState(() {
              score = score - 1;
            });
          }
        } else if (pressed == "B" || pressed == "A" || pressed == "D") {
          setState(() {
            _enabledA = false;
            _enabledB = false;
            _enabledC = false;
            _enabledD = false;
          });
        } else {}
        await Common.getQuestion9CorrectedA().then((value) => {
              setState(() {
                if (value == null) {
                  _correctA = false;
                } else {
                  _correctA = value;
                }
              }),
            });
        await Common.getQuestion9CorrectedB().then((value) => {
              setState(() {
                if (value == null) {
                  _correctB = false;
                } else {
                  _correctB = value;
                }
              }),
            });
        await Common.getQuestion9CorrectedC().then((value) => {
              setState(() {
                if (value == null) {
                  _correctC = false;
                } else {
                  _correctC = value;
                }
              }),
            });
        await Common.getQuestion9CorrectedD().then((value) => {
              setState(() {
                if (value == null) {
                  _correctD = false;
                } else {
                  _correctD = value;
                }
              }),
            });
      }
    }
  }

  void getInitQuizQuestion() {
    setState(() {
      quizObject = quizList[0];

      // _answerA = quizObject.answerD;
      // _answerB = quizObject.answerC;
      // _answerC = quizObject.answerA;
      // _answerD = quizObject.answerB;

      _selectedAnswerA = '_';

      _selectedAnswerB = '_';

      _selectedAnswerC = '_';

      _selectedAnswerD = '_';
    });
  }
}

class Counter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_0_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.008908686;
    paint_0_stroke.color = Colors.white.withOpacity(1.0);
    canvas.drawLine(
        Offset(size.width * -0.02672606, size.height * 0.5000000),
        Offset(size.width * 0.6971047, size.height * 0.5000000),
        paint_0_stroke);
    Path path_1 = Path();
    path_1.moveTo(size.width * 0.5813207, size.height * 0.1032120);
    path_1.cubicTo(
        size.width * 0.5930356,
        size.height * 0.04996710,
        size.width * 0.6090111,
        size.height * 0.02000000,
        size.width * 0.6256815,
        size.height * 0.02000000);
    path_1.lineTo(size.width * 0.8620690, size.height * 0.02000000);
    path_1.cubicTo(
        size.width * 0.8787394,
        size.height * 0.02000000,
        size.width * 0.8947149,
        size.height * 0.04996720,
        size.width * 0.9064298,
        size.height * 0.1032120);
    path_1.lineTo(size.width * 0.9937394, size.height * 0.5000000);
    path_1.lineTo(size.width * 0.9064298, size.height * 0.8967880);
    path_1.cubicTo(
        size.width * 0.8947149,
        size.height * 0.9500330,
        size.width * 0.8787394,
        size.height * 0.9800000,
        size.width * 0.8620690,
        size.height * 0.9800000);
    path_1.lineTo(size.width * 0.6256815, size.height * 0.9800000);
    path_1.cubicTo(
        size.width * 0.6090111,
        size.height * 0.9800000,
        size.width * 0.5930356,
        size.height * 0.9500330,
        size.width * 0.5813207,
        size.height * 0.8967880);
    path_1.lineTo(size.width * 0.4940111, size.height * 0.5000000);
    path_1.lineTo(size.width * 0.5813207, size.height * 0.1032120);
    path_1.close();
    Paint paint_1_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.008908686;
    paint_1_stroke.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_1, paint_1_stroke);
    Paint paint_1_fill = Paint()..style = PaintingStyle.fill;
    paint_1_fill.color = Color(0xff0375BC).withOpacity(1.0);
    canvas.drawPath(path_1, paint_1_fill);

    // Path path_2 = Path();
    // path_2.moveTo(size.width * 0.7187817, size.height * 0.7290400);
    // path_2.lineTo(size.width * 0.7074499, size.height * 0.6680800);
    // path_2.cubicTo(
    //     size.width * 0.7043140,
    //     size.height * 0.6716000,
    //     size.width * 0.7011069,
    //     size.height * 0.6733600,
    //     size.width * 0.6978285,
    //     size.height * 0.6733600);
    // path_2.cubicTo(
    //     size.width * 0.6908441,
    //     size.height * 0.6733600,
    //     size.width * 0.6844298,
    //     size.height * 0.6660000,
    //     size.width * 0.6785857,
    //     size.height * 0.6512800);
    // path_2.cubicTo(
    //     size.width * 0.6727416,
    //     size.height * 0.6365600,
    //     size.width * 0.6681091,
    //     size.height * 0.6162400,
    //     size.width * 0.6646882,
    //     size.height * 0.5903200);
    // path_2.cubicTo(
    //     size.width * 0.6612673,
    //     size.height * 0.5640800,
    //     size.width * 0.6595568,
    //     size.height * 0.5344800,
    //     size.width * 0.6595568,
    //     size.height * 0.5015200);
    // path_2.cubicTo(
    //     size.width * 0.6595568,
    //     size.height * 0.4688800,
    //     size.width * 0.6612673,
    //     size.height * 0.4396000,
    //     size.width * 0.6646882,
    //     size.height * 0.4136800);
    // path_2.cubicTo(
    //     size.width * 0.6681091,
    //     size.height * 0.3874400,
    //     size.width * 0.6727416,
    //     size.height * 0.3669600,
    //     size.width * 0.6785857,
    //     size.height * 0.3522400);
    // path_2.cubicTo(
    //     size.width * 0.6844298,
    //     size.height * 0.3375200,
    //     size.width * 0.6908441,
    //     size.height * 0.3301600,
    //     size.width * 0.6978285,
    //     size.height * 0.3301600);
    // path_2.cubicTo(
    //     size.width * 0.7048842,
    //     size.height * 0.3301600,
    //     size.width * 0.7112984,
    //     size.height * 0.3375200,
    //     size.width * 0.7170713,
    //     size.height * 0.3522400);
    // path_2.cubicTo(
    //     size.width * 0.7229154,
    //     size.height * 0.3669600,
    //     size.width * 0.7275122,
    //     size.height * 0.3874400,
    //     size.width * 0.7308619,
    //     size.height * 0.4136800);
    // path_2.cubicTo(
    //     size.width * 0.7342829,
    //     size.height * 0.4396000,
    //     size.width * 0.7359933,
    //     size.height * 0.4688800,
    //     size.width * 0.7359933,
    //     size.height * 0.5015200);
    // path_2.cubicTo(
    //     size.width * 0.7359933,
    //     size.height * 0.5312800,
    //     size.width * 0.7345679,
    //     size.height * 0.5584800,
    //     size.width * 0.7317171,
    //     size.height * 0.5831200);
    // path_2.cubicTo(
    //     size.width * 0.7289376,
    //     size.height * 0.6074400,
    //     size.width * 0.7251247,
    //     size.height * 0.6272800,
    //     size.width * 0.7202784,
    //     size.height * 0.6426400);
    // path_2.lineTo(size.width * 0.7373831, size.height * 0.7290400);
    // path_2.lineTo(size.width * 0.7187817, size.height * 0.7290400);
    // path_2.close();
    // path_2.moveTo(size.width * 0.6749510, size.height * 0.5015200);
    // path_2.cubicTo(
    //     size.width * 0.6749510,
    //     size.height * 0.5239200,
    //     size.width * 0.6759131,
    //     size.height * 0.5436000,
    //     size.width * 0.6778374,
    //     size.height * 0.5605600);
    // path_2.cubicTo(
    //     size.width * 0.6797617,
    //     size.height * 0.5775200,
    //     size.width * 0.6824343,
    //     size.height * 0.5906400,
    //     size.width * 0.6858552,
    //     size.height * 0.5999200);
    // path_2.cubicTo(
    //     size.width * 0.6893474,
    //     size.height * 0.6088800,
    //     size.width * 0.6933385,
    //     size.height * 0.6133600,
    //     size.width * 0.6978285,
    //     size.height * 0.6133600);
    // path_2.cubicTo(
    //     size.width * 0.7023185,
    //     size.height * 0.6133600,
    //     size.width * 0.7062739,
    //     size.height * 0.6088800,
    //     size.width * 0.7096949,
    //     size.height * 0.5999200);
    // path_2.cubicTo(
    //     size.width * 0.7131158,
    //     size.height * 0.5906400,
    //     size.width * 0.7157884,
    //     size.height * 0.5775200,
    //     size.width * 0.7177127,
    //     size.height * 0.5605600);
    // path_2.cubicTo(
    //     size.width * 0.7196370,
    //     size.height * 0.5436000,
    //     size.width * 0.7205991,
    //     size.height * 0.5239200,
    //     size.width * 0.7205991,
    //     size.height * 0.5015200);
    // path_2.cubicTo(
    //     size.width * 0.7205991,
    //     size.height * 0.4791200,
    //     size.width * 0.7196370,
    //     size.height * 0.4596000,
    //     size.width * 0.7177127,
    //     size.height * 0.4429600);
    // path_2.cubicTo(
    //     size.width * 0.7157884,
    //     size.height * 0.4260000,
    //     size.width * 0.7131158,
    //     size.height * 0.4130400,
    //     size.width * 0.7096949,
    //     size.height * 0.4040800);
    // path_2.cubicTo(
    //     size.width * 0.7062739,
    //     size.height * 0.3951200,
    //     size.width * 0.7023185,
    //     size.height * 0.3906400,
    //     size.width * 0.6978285,
    //     size.height * 0.3906400);
    // path_2.cubicTo(
    //     size.width * 0.6933385,
    //     size.height * 0.3906400,
    //     size.width * 0.6893474,
    //     size.height * 0.3951200,
    //     size.width * 0.6858552,
    //     size.height * 0.4040800);
    // path_2.cubicTo(
    //     size.width * 0.6824343,
    //     size.height * 0.4130400,
    //     size.width * 0.6797617,
    //     size.height * 0.4260000,
    //     size.width * 0.6778374,
    //     size.height * 0.4429600);
    // path_2.cubicTo(
    //     size.width * 0.6759131,
    //     size.height * 0.4596000,
    //     size.width * 0.6749510,
    //     size.height * 0.4791200,
    //     size.width * 0.6749510,
    //     size.height * 0.5015200);
    // path_2.close();
    // path_2.moveTo(size.width * 0.7692829, size.height * 0.3820000);
    // path_2.lineTo(size.width * 0.7692829, size.height * 0.3200800);
    // path_2.lineTo(size.width * 0.7950468, size.height * 0.3200800);
    // path_2.lineTo(size.width * 0.7950468, size.height * 0.6700000);
    // path_2.lineTo(size.width * 0.7796526, size.height * 0.6700000);
    // path_2.lineTo(size.width * 0.7796526, size.height * 0.3820000);
    // path_2.lineTo(size.width * 0.7692829, size.height * 0.3820000);
    // path_2.close();
    // path_2.moveTo(size.width * 0.8181693, size.height * 0.6733600);
    // path_2.cubicTo(
    //     size.width * 0.8154610,
    //     size.height * 0.6733600,
    //     size.width * 0.8132160,
    //     size.height * 0.6696800,
    //     size.width * 0.8114343,
    //     size.height * 0.6623200);
    // path_2.cubicTo(
    //     size.width * 0.8097238,
    //     size.height * 0.6546400,
    //     size.width * 0.8088686,
    //     size.height * 0.6452000,
    //     size.width * 0.8088686,
    //     size.height * 0.6340000);
    // path_2.cubicTo(
    //     size.width * 0.8088686,
    //     size.height * 0.6228000,
    //     size.width * 0.8097238,
    //     size.height * 0.6135200,
    //     size.width * 0.8114343,
    //     size.height * 0.6061600);
    // path_2.cubicTo(
    //     size.width * 0.8132160,
    //     size.height * 0.5984800,
    //     size.width * 0.8154610,
    //     size.height * 0.5946400,
    //     size.width * 0.8181693,
    //     size.height * 0.5946400);
    // path_2.cubicTo(
    //     size.width * 0.8208062,
    //     size.height * 0.5946400,
    //     size.width * 0.8229800,
    //     size.height * 0.5984800,
    //     size.width * 0.8246904,
    //     size.height * 0.6061600);
    // path_2.cubicTo(
    //     size.width * 0.8264009,
    //     size.height * 0.6135200,
    //     size.width * 0.8272561,
    //     size.height * 0.6228000,
    //     size.width * 0.8272561,
    //     size.height * 0.6340000);
    // path_2.cubicTo(
    //     size.width * 0.8272561,
    //     size.height * 0.6452000,
    //     size.width * 0.8264009,
    //     size.height * 0.6546400,
    //     size.width * 0.8246904,
    //     size.height * 0.6623200);
    // path_2.cubicTo(
    //     size.width * 0.8229800,
    //     size.height * 0.6696800,
    //     size.width * 0.8208062,
    //     size.height * 0.6733600,
    //     size.width * 0.8181693,
    //     size.height * 0.6733600);
    // path_2.close();
    // Paint paint_2_fill = Paint()..style = PaintingStyle.fill;
    // paint_2_fill.color = Colors.white.withOpacity(1.0);
    // canvas.drawPath(path_2, paint_2_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class QuestionCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_0_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.002298851;
    paint_0_stroke.color = Colors.white.withOpacity(1.0);
    canvas.drawLine(
        Offset(size.width * -0.006896552, size.height * 0.5000000),
        Offset(size.width * 0.1281609, size.height * 0.5000000),
        paint_0_stroke);

    Paint paint_1_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.002298851;
    paint_1_stroke.color = Colors.white.withOpacity(1.0);
    canvas.drawLine(Offset(size.width * 0.8706897, size.height * 0.5000000),
        Offset(size.width * 1.005747, size.height * 0.5000000), paint_1_stroke);

    Path path_2 = Path();
    path_2.moveTo(size.width * 0.1582023, size.height * 0.1155887);
    path_2.cubicTo(
        size.width * 0.1634218,
        size.height * 0.05038347,
        size.width * 0.1707466,
        size.height * 0.01333333,
        size.width * 0.1784172,
        size.height * 0.01333333);
    path_2.lineTo(size.width * 0.8204310, size.height * 0.01333333);
    path_2.cubicTo(
        size.width * 0.8281034,
        size.height * 0.01333333,
        size.width * 0.8354310,
        size.height * 0.05038353,
        size.width * 0.8406494,
        size.height * 0.1155893);
    path_2.lineTo(size.width * 0.8714195, size.height * 0.5000000);
    path_2.lineTo(size.width * 0.8406494, size.height * 0.8844133);
    path_2.cubicTo(
        size.width * 0.8354310,
        size.height * 0.9496133,
        size.width * 0.8281034,
        size.height * 0.9866667,
        size.width * 0.8204310,
        size.height * 0.9866667);
    path_2.lineTo(size.width * 0.1784172, size.height * 0.9866667);
    path_2.cubicTo(
        size.width * 0.1707466,
        size.height * 0.9866667,
        size.width * 0.1634218,
        size.height * 0.9496133,
        size.width * 0.1582023,
        size.height * 0.8844133);
    path_2.lineTo(size.width * 0.1274305, size.height * 0.5000000);
    path_2.lineTo(size.width * 0.1582023, size.height * 0.1155887);
    path_2.close();

    Paint paint_2_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.002298851;
    paint_2_stroke.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_2, paint_2_stroke);

    Paint paint_2_fill = Paint()..style = PaintingStyle.fill;
    paint_2_fill.color = Color(0xff0375BC).withOpacity(1.0);
    canvas.drawPath(path_2, paint_2_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class AOptionCustomPainter extends CustomPainter {
  late bool _correctA;
  late String pressed;
  AOptionCustomPainter(this._correctA, this.pressed);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_0_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004602992;
    paint_0_stroke.color = Colors.white.withOpacity(1.0);
    canvas.drawLine(
        Offset(size.width * -0.01380898, size.height * 0.5000000),
        Offset(size.width * 0.2577675, size.height * 0.5000000),
        paint_0_stroke);

    Path path_1 = Path();
    path_1.moveTo(size.width * 0.3303188, size.height * 0.01666667);
    path_1.lineTo(size.width * 0.9216951, size.height * 0.01666667);
    path_1.cubicTo(
        size.width * 0.9307445,
        size.height * 0.01666667,
        size.width * 0.9393774,
        size.height * 0.04422767,
        size.width * 0.9454810,
        size.height * 0.09261000);
    path_1.lineTo(size.width * 0.9968826, size.height * 0.5000000);
    path_1.lineTo(size.width * 0.9454810, size.height * 0.9073917);
    path_1.cubicTo(
        size.width * 0.9393774,
        size.height * 0.9557750,
        size.width * 0.9307445,
        size.height * 0.9833333,
        size.width * 0.9216951,
        size.height * 0.9833333);
    path_1.lineTo(size.width * 0.3303188, size.height * 0.9833333);
    path_1.cubicTo(
        size.width * 0.3212693,
        size.height * 0.9833333,
        size.width * 0.3126364,
        size.height * 0.9557750,
        size.width * 0.3065328,
        size.height * 0.9073917);
    path_1.lineTo(size.width * 0.2551312, size.height * 0.5000000);
    path_1.lineTo(size.width * 0.3065328, size.height * 0.09261000);
    path_1.cubicTo(
        size.width * 0.3126364,
        size.height * 0.04422775,
        size.width * 0.3212693,
        size.height * 0.01666667,
        size.width * 0.3303188,
        size.height * 0.01666667);
    path_1.close();

    Paint paint_1_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004602992;
    paint_1_stroke.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_1, paint_1_stroke);

    Paint paint_1_fill = Paint()..style = PaintingStyle.fill;
    //paint_1_fill.color = Color(0xff0375BC).withOpacity(1.0);
    paint_1_fill.color = _correctA
        ? LightColor.colorOne
        : !_correctA && pressed == "A"
            ? LightColor.colorTwo
            : LightColor.colorThr.withOpacity(1.0);
    canvas.drawPath(path_1, paint_1_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class COptionCustomPainter extends CustomPainter {
  late bool _correctC;
  late String pressed;
  COptionCustomPainter(this._correctC, this.pressed);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_0_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004602992;
    paint_0_stroke.color = Colors.white.withOpacity(1.0);
    canvas.drawLine(
        Offset(size.width * -0.01380898, size.height * 0.5000000),
        Offset(size.width * 0.2577675, size.height * 0.5000000),
        paint_0_stroke);

    Path path_1 = Path();
    path_1.moveTo(size.width * 0.3303188, size.height * 0.01666667);
    path_1.lineTo(size.width * 0.9216951, size.height * 0.01666667);
    path_1.cubicTo(
        size.width * 0.9307445,
        size.height * 0.01666667,
        size.width * 0.9393774,
        size.height * 0.04422767,
        size.width * 0.9454810,
        size.height * 0.09261000);
    path_1.lineTo(size.width * 0.9968826, size.height * 0.5000000);
    path_1.lineTo(size.width * 0.9454810, size.height * 0.9073917);
    path_1.cubicTo(
        size.width * 0.9393774,
        size.height * 0.9557750,
        size.width * 0.9307445,
        size.height * 0.9833333,
        size.width * 0.9216951,
        size.height * 0.9833333);
    path_1.lineTo(size.width * 0.3303188, size.height * 0.9833333);
    path_1.cubicTo(
        size.width * 0.3212693,
        size.height * 0.9833333,
        size.width * 0.3126364,
        size.height * 0.9557750,
        size.width * 0.3065328,
        size.height * 0.9073917);
    path_1.lineTo(size.width * 0.2551312, size.height * 0.5000000);
    path_1.lineTo(size.width * 0.3065328, size.height * 0.09261000);
    path_1.cubicTo(
        size.width * 0.3126364,
        size.height * 0.04422775,
        size.width * 0.3212693,
        size.height * 0.01666667,
        size.width * 0.3303188,
        size.height * 0.01666667);
    path_1.close();

    Paint paint_1_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004602992;
    paint_1_stroke.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_1, paint_1_stroke);

    Paint paint_1_fill = Paint()..style = PaintingStyle.fill;
    //paint_1_fill.color = Color(0xff0375BC).withOpacity(1.0);
    paint_1_fill.color = _correctC
        ? LightColor.colorOne
        : !_correctC && pressed == "C"
            ? LightColor.colorTwo
            : LightColor.colorThr.withOpacity(1.0);
    canvas.drawPath(path_1, paint_1_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class BOptionCustomPainter extends CustomPainter {
  late bool _correctB;
  late String pressed;
  BOptionCustomPainter(this._correctB, this.pressed);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_0_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004592423;
    paint_0_stroke.color = Colors.white.withOpacity(1.0);
    canvas.drawLine(Offset(size.width * 0.7382319, size.height * 0.5000000),
        Offset(size.width, size.height * 0.5000000), paint_0_stroke);

    Path path_1 = Path();
    path_1.moveTo(size.width * 0.07812572, size.height * 0.01666667);
    path_1.lineTo(size.width * 0.6580195, size.height * 0.01666667);
    path_1.cubicTo(
        size.width * 0.6734983,
        size.height * 0.01666667,
        size.width * 0.6882629,
        size.height * 0.06391408,
        size.width * 0.6987038,
        size.height * 0.1468550);
    path_1.lineTo(size.width * 0.7431584, size.height * 0.5000000);
    path_1.lineTo(size.width * 0.6987038, size.height * 0.8531417);
    path_1.cubicTo(
        size.width * 0.6882629,
        size.height * 0.9360833,
        size.width * 0.6734983,
        size.height * 0.9833333,
        size.width * 0.6580195,
        size.height * 0.9833333);
    path_1.lineTo(size.width * 0.07812572, size.height * 0.9833333);
    path_1.cubicTo(
        size.width * 0.06909656,
        size.height * 0.9833333,
        size.width * 0.06048370,
        size.height * 0.9557750,
        size.width * 0.05439323,
        size.height * 0.9073917);
    path_1.lineTo(size.width * 0.003110356, size.height * 0.5000000);
    path_1.lineTo(size.width * 0.05439323, size.height * 0.09261000);
    path_1.cubicTo(
        size.width * 0.06048370,
        size.height * 0.04422775,
        size.width * 0.06909656,
        size.height * 0.01666667,
        size.width * 0.07812572,
        size.height * 0.01666667);
    path_1.close();

    Paint paint_1_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004592423;
    paint_1_stroke.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_1, paint_1_stroke);

    Paint paint_1_fill = Paint()..style = PaintingStyle.fill;
    //paint_1_fill.color = Color(0xff0375BC).withOpacity(1.0);
    paint_1_fill.color = _correctB
        ? LightColor.colorOne
        : !_correctB && pressed == "B"
            ? LightColor.colorTwo
            : LightColor.colorThr.withOpacity(1.0);
    canvas.drawPath(path_1, paint_1_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class DOptionCustomPainter extends CustomPainter {
  late bool _correctD;
  late String pressed;
  DOptionCustomPainter(this._correctD, this.pressed);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_0_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004592423;
    paint_0_stroke.color = Colors.white.withOpacity(1.0);
    canvas.drawLine(Offset(size.width * 0.7382319, size.height * 0.5000000),
        Offset(size.width, size.height * 0.5000000), paint_0_stroke);

    Path path_1 = Path();
    path_1.moveTo(size.width * 0.07812572, size.height * 0.01666667);
    path_1.lineTo(size.width * 0.6580195, size.height * 0.01666667);
    path_1.cubicTo(
        size.width * 0.6734983,
        size.height * 0.01666667,
        size.width * 0.6882629,
        size.height * 0.06391408,
        size.width * 0.6987038,
        size.height * 0.1468550);
    path_1.lineTo(size.width * 0.7431584, size.height * 0.5000000);
    path_1.lineTo(size.width * 0.6987038, size.height * 0.8531417);
    path_1.cubicTo(
        size.width * 0.6882629,
        size.height * 0.9360833,
        size.width * 0.6734983,
        size.height * 0.9833333,
        size.width * 0.6580195,
        size.height * 0.9833333);
    path_1.lineTo(size.width * 0.07812572, size.height * 0.9833333);
    path_1.cubicTo(
        size.width * 0.06909656,
        size.height * 0.9833333,
        size.width * 0.06048370,
        size.height * 0.9557750,
        size.width * 0.05439323,
        size.height * 0.9073917);
    path_1.lineTo(size.width * 0.003110356, size.height * 0.5000000);
    path_1.lineTo(size.width * 0.05439323, size.height * 0.09261000);
    path_1.cubicTo(
        size.width * 0.06048370,
        size.height * 0.04422775,
        size.width * 0.06909656,
        size.height * 0.01666667,
        size.width * 0.07812572,
        size.height * 0.01666667);
    path_1.close();

    Paint paint_1_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004592423;
    paint_1_stroke.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_1, paint_1_stroke);

    Paint paint_1_fill = Paint()..style = PaintingStyle.fill;
    //paint_1_fill.color = Color(0xff0375BC).withOpacity(1.0);
    paint_1_fill.color = _correctD
        ? LightColor.colorOne
        : !_correctD && pressed == "D"
            ? LightColor.colorTwo
            : LightColor.colorThr.withOpacity(1.0);
    canvas.drawPath(path_1, paint_1_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class QuestionMobileCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_0_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.02603538;
    paint_0_stroke.color = Color(0xff0375BC).withOpacity(1.0);
    canvas.drawLine(
        Offset(size.width * -1.128205, size.height * 0.4807120),
        Offset(size.width * 0.9871795, size.height * 0.4807120),
        paint_0_stroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class AMobileOptionCustomPainter extends CustomPainter {
  late bool _correctA;
  late String pressed;
  AMobileOptionCustomPainter(this._correctA, this.pressed);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_0_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.002298851;
    paint_0_stroke.color = Colors.white.withOpacity(1.0);
    canvas.drawLine(
        Offset(size.width * -0.006896552, size.height * 0.5000000),
        Offset(size.width * 0.1281609, size.height * 0.5000000),
        paint_0_stroke);

    Paint paint_1_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.002298851;
    paint_1_stroke.color = Colors.white.withOpacity(1.0);
    canvas.drawLine(Offset(size.width * 0.8706897, size.height * 0.5000000),
        Offset(size.width * 1.005747, size.height * 0.5000000), paint_1_stroke);

    Path path_2 = Path();
    path_2.moveTo(size.width * 0.1582023, size.height * 0.1155887);
    path_2.cubicTo(
        size.width * 0.1634218,
        size.height * 0.05038347,
        size.width * 0.1707466,
        size.height * 0.01333333,
        size.width * 0.1784172,
        size.height * 0.01333333);
    path_2.lineTo(size.width * 0.8204310, size.height * 0.01333333);
    path_2.cubicTo(
        size.width * 0.8281034,
        size.height * 0.01333333,
        size.width * 0.8354310,
        size.height * 0.05038353,
        size.width * 0.8406494,
        size.height * 0.1155893);
    path_2.lineTo(size.width * 0.8714195, size.height * 0.5000000);
    path_2.lineTo(size.width * 0.8406494, size.height * 0.8844133);
    path_2.cubicTo(
        size.width * 0.8354310,
        size.height * 0.9496133,
        size.width * 0.8281034,
        size.height * 0.9866667,
        size.width * 0.8204310,
        size.height * 0.9866667);
    path_2.lineTo(size.width * 0.1784172, size.height * 0.9866667);
    path_2.cubicTo(
        size.width * 0.1707466,
        size.height * 0.9866667,
        size.width * 0.1634218,
        size.height * 0.9496133,
        size.width * 0.1582023,
        size.height * 0.8844133);
    path_2.lineTo(size.width * 0.1274305, size.height * 0.5000000);
    path_2.lineTo(size.width * 0.1582023, size.height * 0.1155887);
    path_2.close();

    Paint paint_2_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.002298851;
    paint_2_stroke.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_2, paint_2_stroke);

    Paint paint_2_fill = Paint()..style = PaintingStyle.fill;
    //paint_2_fill.color = Color(0xff0375BC).withOpacity(1.0);
    paint_2_fill.color = _correctA
        ? LightColor.colorOne
        : !_correctA && pressed == "A"
            ? LightColor.colorTwo
            : LightColor.colorThr.withOpacity(1.0);
    canvas.drawPath(path_2, paint_2_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class BMobileOptionCustomPainter extends CustomPainter {
  bool _correctB;
  String pressed;
  BMobileOptionCustomPainter(this._correctB, this.pressed);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_0_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.002298851;
    paint_0_stroke.color = Colors.white.withOpacity(1.0);
    canvas.drawLine(
        Offset(size.width * -0.006896552, size.height * 0.5000000),
        Offset(size.width * 0.1281609, size.height * 0.5000000),
        paint_0_stroke);

    Paint paint_1_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.002298851;
    paint_1_stroke.color = Colors.white.withOpacity(1.0);
    canvas.drawLine(Offset(size.width * 0.8706897, size.height * 0.5000000),
        Offset(size.width * 1.005747, size.height * 0.5000000), paint_1_stroke);

    Path path_2 = Path();
    path_2.moveTo(size.width * 0.1582023, size.height * 0.1155887);
    path_2.cubicTo(
        size.width * 0.1634218,
        size.height * 0.05038347,
        size.width * 0.1707466,
        size.height * 0.01333333,
        size.width * 0.1784172,
        size.height * 0.01333333);
    path_2.lineTo(size.width * 0.8204310, size.height * 0.01333333);
    path_2.cubicTo(
        size.width * 0.8281034,
        size.height * 0.01333333,
        size.width * 0.8354310,
        size.height * 0.05038353,
        size.width * 0.8406494,
        size.height * 0.1155893);
    path_2.lineTo(size.width * 0.8714195, size.height * 0.5000000);
    path_2.lineTo(size.width * 0.8406494, size.height * 0.8844133);
    path_2.cubicTo(
        size.width * 0.8354310,
        size.height * 0.9496133,
        size.width * 0.8281034,
        size.height * 0.9866667,
        size.width * 0.8204310,
        size.height * 0.9866667);
    path_2.lineTo(size.width * 0.1784172, size.height * 0.9866667);
    path_2.cubicTo(
        size.width * 0.1707466,
        size.height * 0.9866667,
        size.width * 0.1634218,
        size.height * 0.9496133,
        size.width * 0.1582023,
        size.height * 0.8844133);
    path_2.lineTo(size.width * 0.1274305, size.height * 0.5000000);
    path_2.lineTo(size.width * 0.1582023, size.height * 0.1155887);
    path_2.close();

    Paint paint_2_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.002298851;
    paint_2_stroke.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_2, paint_2_stroke);

    Paint paint_2_fill = Paint()..style = PaintingStyle.fill;
    //paint_2_fill.color = Color(0xff0375BC).withOpacity(1.0);
    paint_2_fill.color = _correctB
        ? LightColor.colorOne
        : !_correctB && pressed == "B"
            ? LightColor.colorTwo
            : LightColor.colorThr.withOpacity(1.0);
    canvas.drawPath(path_2, paint_2_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class CMobileOptionCustomPainter extends CustomPainter {
  bool _correctC;
  String pressed;
  CMobileOptionCustomPainter(this._correctC, this.pressed);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_0_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.002298851;
    paint_0_stroke.color = Colors.white.withOpacity(1.0);
    canvas.drawLine(
        Offset(size.width * -0.006896552, size.height * 0.5000000),
        Offset(size.width * 0.1281609, size.height * 0.5000000),
        paint_0_stroke);

    Paint paint_1_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.002298851;
    paint_1_stroke.color = Colors.white.withOpacity(1.0);
    canvas.drawLine(Offset(size.width * 0.8706897, size.height * 0.5000000),
        Offset(size.width * 1.005747, size.height * 0.5000000), paint_1_stroke);

    Path path_2 = Path();
    path_2.moveTo(size.width * 0.1582023, size.height * 0.1155887);
    path_2.cubicTo(
        size.width * 0.1634218,
        size.height * 0.05038347,
        size.width * 0.1707466,
        size.height * 0.01333333,
        size.width * 0.1784172,
        size.height * 0.01333333);
    path_2.lineTo(size.width * 0.8204310, size.height * 0.01333333);
    path_2.cubicTo(
        size.width * 0.8281034,
        size.height * 0.01333333,
        size.width * 0.8354310,
        size.height * 0.05038353,
        size.width * 0.8406494,
        size.height * 0.1155893);
    path_2.lineTo(size.width * 0.8714195, size.height * 0.5000000);
    path_2.lineTo(size.width * 0.8406494, size.height * 0.8844133);
    path_2.cubicTo(
        size.width * 0.8354310,
        size.height * 0.9496133,
        size.width * 0.8281034,
        size.height * 0.9866667,
        size.width * 0.8204310,
        size.height * 0.9866667);
    path_2.lineTo(size.width * 0.1784172, size.height * 0.9866667);
    path_2.cubicTo(
        size.width * 0.1707466,
        size.height * 0.9866667,
        size.width * 0.1634218,
        size.height * 0.9496133,
        size.width * 0.1582023,
        size.height * 0.8844133);
    path_2.lineTo(size.width * 0.1274305, size.height * 0.5000000);
    path_2.lineTo(size.width * 0.1582023, size.height * 0.1155887);
    path_2.close();

    Paint paint_2_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.002298851;
    paint_2_stroke.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_2, paint_2_stroke);

    Paint paint_2_fill = Paint()..style = PaintingStyle.fill;
    //paint_2_fill.color = Color(0xff0375BC).withOpacity(1.0);
    paint_2_fill.color = _correctC
        ? LightColor.colorOne
        : !_correctC && pressed == "C"
            ? LightColor.colorTwo
            : LightColor.colorThr.withOpacity(1.0);
    canvas.drawPath(path_2, paint_2_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class DMobileOptionCustomPainter extends CustomPainter {
  bool _correctD;
  String pressed;
  DMobileOptionCustomPainter(this._correctD, this.pressed);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_0_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.002298851;
    paint_0_stroke.color = Colors.white.withOpacity(1.0);
    canvas.drawLine(
        Offset(size.width * -0.006896552, size.height * 0.5000000),
        Offset(size.width * 0.1281609, size.height * 0.5000000),
        paint_0_stroke);

    Paint paint_1_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.002298851;
    paint_1_stroke.color = Colors.white.withOpacity(1.0);
    canvas.drawLine(Offset(size.width * 0.8706897, size.height * 0.5000000),
        Offset(size.width * 1.005747, size.height * 0.5000000), paint_1_stroke);

    Path path_2 = Path();
    path_2.moveTo(size.width * 0.1582023, size.height * 0.1155887);
    path_2.cubicTo(
        size.width * 0.1634218,
        size.height * 0.05038347,
        size.width * 0.1707466,
        size.height * 0.01333333,
        size.width * 0.1784172,
        size.height * 0.01333333);
    path_2.lineTo(size.width * 0.8204310, size.height * 0.01333333);
    path_2.cubicTo(
        size.width * 0.8281034,
        size.height * 0.01333333,
        size.width * 0.8354310,
        size.height * 0.05038353,
        size.width * 0.8406494,
        size.height * 0.1155893);
    path_2.lineTo(size.width * 0.8714195, size.height * 0.5000000);
    path_2.lineTo(size.width * 0.8406494, size.height * 0.8844133);
    path_2.cubicTo(
        size.width * 0.8354310,
        size.height * 0.9496133,
        size.width * 0.8281034,
        size.height * 0.9866667,
        size.width * 0.8204310,
        size.height * 0.9866667);
    path_2.lineTo(size.width * 0.1784172, size.height * 0.9866667);
    path_2.cubicTo(
        size.width * 0.1707466,
        size.height * 0.9866667,
        size.width * 0.1634218,
        size.height * 0.9496133,
        size.width * 0.1582023,
        size.height * 0.8844133);
    path_2.lineTo(size.width * 0.1274305, size.height * 0.5000000);
    path_2.lineTo(size.width * 0.1582023, size.height * 0.1155887);
    path_2.close();

    Paint paint_2_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.002298851;
    paint_2_stroke.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_2, paint_2_stroke);

    Paint paint_2_fill = Paint()..style = PaintingStyle.fill;
    //paint_2_fill.color = Color(0xff0375BC).withOpacity(1.0);
    paint_2_fill.color = _correctD
        ? LightColor.colorOne
        : !_correctD && pressed == "D"
            ? LightColor.colorTwo
            : LightColor.colorThr.withOpacity(1.0);
    canvas.drawPath(path_2, paint_2_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
