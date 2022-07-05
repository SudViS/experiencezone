import 'dart:async';
import 'dart:io';
import 'package:animated_widgets/widgets/opacity_animated.dart';
import 'package:animated_widgets/widgets/rotation_animated.dart';
import 'package:animated_widgets/widgets/shake_animated_widget.dart';
import 'package:animations/animations.dart';
import 'package:experiencezone/screens/funfacts_screen.dart';
import 'package:experiencezone/screens/quiz_screen.dart';
import 'package:experiencezone/screens/zonehome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../animation/fadeAnimation.dart';
import '../main.dart';
import '../utils/light_color.dart';

class BannerScreen extends StatefulWidget {
  @override
  BannerScreenState createState() {
    return BannerScreenState();
  }
}

final imageAsset = AssetImage("assets/images/new.png");

class BannerScreenState extends State<BannerScreen>
    with TickerProviderStateMixin {
  //with SingleTickerProviderStateMixin {

  String url = "";
  double progress = 0;
  num _stackToView = 1;
  bool _policyChecked = false;
  bool _otpSent = false;
  late CurvedAnimation curve;
  late AnimationController controller;
  late Animation<double> curtainOffset;

  String defaultFontFamily = 'Montserrat';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  final TextEditingController _firstDigitOtp = TextEditingController();
  final TextEditingController _secondDigitOtp = TextEditingController();
  final TextEditingController _thirdDigitOtp = TextEditingController();
  final TextEditingController _fourthDigitOtp = TextEditingController();
  final TextEditingController _fifthDigitOtp = TextEditingController();
  final TextEditingController _sixthDigitOtp = TextEditingController();

  final TextEditingController textController = TextEditingController();

  late AnimationController _controller;
  late final Animation<Offset> _offsetAnimation;
  late Animation<double> _animation;

  late bool autoFocus;
  late String verification_id;
  late ConfirmationResult NewConfirmationResult;

  late Timer _timer;
  int _start = 120; // 2 minute
  late bool _show = false;

  late DateTime timeOfActivationInBackground ;
  late DateTime timeOfActivationInResume ;
  late Duration diff ;
  late int _currentTimer;

  void startTimer() {
    setState(() {
      _show = false;
      _start = 120;
    });

    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            _show = true;
            //_otpSent = false;
            _timer.cancel();
            timer.cancel();
          });
        } else {
          setState(() {
            _show = false;
            _start--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    clear();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: false);
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );

    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);

    // curve = CurvedAnimation(parent: controller, curve: Curves.elasticIn);
    //
    // curtainOffset = Tween(begin: 0.0, end: 500.0).animate(controller)
    //   ..addListener(() {
    //     setState(() {});
    //   });
    //
    // Future.delayed(
    //     const Duration(milliseconds: 300), () => controller.forward());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.landscapeLeft,
    //   DeviceOrientation.landscapeRight,
    // ]);

    final double heightSize = MediaQuery.of(context).size.height;
    final double widthSize = MediaQuery.of(context).size.width;
    //print(heightSize.toString() + " * " + widthSize.toString());

    print("Banner Screen");

    // final Animation<double> offsetAnimation =
    // Tween(begin: 0.0, end: 24.0).chain(CurveTween(curve: Curves.elasticIn)).animate(controller)
    //   ..addStatusListener((status) {
    //     if (status == AnimationStatus.completed) {
    //       controller.reverse();
    //     }
    //   });
    //
    // controller.forward(from: 0.0);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: LightColor.buttonground,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            this.controller.isCompleted
                ? this.controller.reverse()
                : this.controller.forward();
          },
          child: widthSize < 900
              ? SingleChildScrollView(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      image: widthSize < 500
                          ? const DecorationImage(
                              image:
                                  //AssetImage("assets/images/mobile_new.png"),
                                  AssetImage("assets/images/EX Mob Bag.png"),
                              fit: BoxFit.fill,
                            )
                          : const DecorationImage(
                              image: AssetImage(
                                  "assets/images/Text Background.png"),
                              fit: BoxFit.fill,
                            ),
                    ),
                    child: widthSize < 500
                        ? Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(30, 50, 30, 0),
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
                                          padding: const EdgeInsets.fromLTRB(80, 20, 80, 20),
                                        // padding: const EdgeInsets.fromLTRB(
                                        //     60, 15, 60, 15),
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
                              Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  !_otpSent
                                      ? Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: Colors
                                                    .white, // Set border color
                                                width: 0.2),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          margin: const EdgeInsets.fromLTRB(
                                              40, 10, 40, 10),
                                          child: Column(
                                            children: [
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              FadeAnimation(
                                                  1.1,
                                                  Padding(
                                                    padding:
                                                      const EdgeInsets.fromLTRB(
                                                            40, 0, 0, 0),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          "Enter Your Details",
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  defaultFontFamily,
                                                              color: Colors
                                                                  .blueAccent,
                                                              //Color.fromRGBO(113, 56, 208, 1.0),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontSize: 18),
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              FadeAnimation(
                                                  1.1,
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.fromLTRB(
                                                            40, 0, 0, 0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Name",
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  defaultFontFamily,
                                                              color: Colors
                                                                  .blueAccent,
                                                              //Color.fromRGBO(113, 56, 208, 1.0),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontSize: 15),
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              FadeAnimation(
                                                0.5,
                                                Container(
                                                  height: 53,
                                                  margin: const EdgeInsets.fromLTRB(
                                                      40, 0, 40, 0),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        color: (Colors.grey[
                                                            800])!, // Set border color
                                                        width: 0.2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.3),
                                                        spreadRadius: 1,
                                                        blurRadius: 19,
                                                        offset: const Offset(0,
                                                            3), // changes position of shadow
                                                      ),
                                                    ],
                                                  ),
                                                  child: TextField(
                                                    minLines: 1,
                                                    maxLength: 30,
                                                    controller: _nameController,
                                                    inputFormatters: <
                                                        TextInputFormatter>[
                                                      FilteringTextInputFormatter
                                                          .allow(RegExp(
                                                              "[a-z A-Z]")),
                                                    ],
                                                    textAlignVertical:
                                                        TextAlignVertical
                                                            .center,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.black87,
                                                      fontFamily:
                                                          defaultFontFamily,
                                                    ),
                                                    decoration: const InputDecoration(
                                                        counter: SizedBox.shrink(),
                                                        border: InputBorder.none,
                                                        hintText: "  Enter Your Full Name",
                                                        filled: false,
                                                        // fillColor: LightColor.yboxbackpurple,
                                                        hintStyle: TextStyle(
                                                            fontSize: 14,
                                                            // fontFamily:
                                                            // defaultFontFamily,
                                                            color: Colors.grey)),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              FadeAnimation(
                                                  1.1,
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.fromLTRB(
                                                            40, 0, 0, 0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Mobile Number",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  defaultFontFamily,
                                                              color: Colors
                                                                  .blueAccent,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontSize: 15),
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              FadeAnimation(
                                                0.5,
                                                Container(
                                                  height: 53,
                                                  margin:
                                                      const EdgeInsets.fromLTRB(
                                                          40, 0, 40, 0),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        color: (Colors.grey[
                                                            800])!, // Set border color
                                                        width: 0.2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.3),
                                                        spreadRadius: 1,
                                                        blurRadius: 19,
                                                        offset: const Offset(0,
                                                            3), // changes position of shadow
                                                      ),
                                                    ],
                                                  ),
                                                  child: TextField(
                                                    keyboardType:
                                                        TextInputType.number,
                                                    inputFormatters: <
                                                        TextInputFormatter>[
                                                      FilteringTextInputFormatter
                                                          .digitsOnly
                                                    ],
                                                    minLines: 1,
                                                    maxLength: 10,
                                                    controller:
                                                        _phoneController,
                                                    textAlignVertical:
                                                        TextAlignVertical
                                                            .center,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.black87,
                                                      fontFamily:
                                                          defaultFontFamily,
                                                    ),
                                                    decoration: const InputDecoration(
                                                        counter: SizedBox.shrink(),
                                                        border: InputBorder.none,
                                                        // prefixIcon: Container(
                                                        //   padding:
                                                        //   EdgeInsets.all(11),
                                                        //   height: 15,
                                                        //   width: 15,
                                                        //   child: Image.asset(
                                                        //     'assets/icons/icons/email.png',
                                                        //   ),
                                                        // ),
                                                        hintText: "  Enter 10 Digit Mobile Number",
                                                        filled: false,
                                                        // fillColor: LightColor.yboxbackpurple,
                                                        hintStyle: TextStyle(
                                                            fontSize: 14,
                                                            // fontFamily:
                                                            // defaultFontFamily,
                                                            color: Colors.grey)),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(
                                                    0, 20, 0, 10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.fromLTRB(
                                                              30, 0, 0, 0),
                                                      child: Theme(
                                                        data: Theme.of(context)
                                                            .copyWith(
                                                          unselectedWidgetColor:
                                                              Colors.grey,
                                                        ),
                                                        child: Checkbox(
                                                          checkColor:
                                                              Colors.blueAccent,
                                                          activeColor:
                                                              Colors.white,
                                                          value: _policyChecked,
                                                          onChanged: (value) {
                                                            setState(() =>
                                                                _policyChecked =
                                                                    value!);
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    Flexible(
                                                      child: FadeAnimation(
                                                          1.1,
                                                          Padding(
                                                            padding: const EdgeInsets
                                                                .fromLTRB(10, 0,
                                                                    40, 0),
                                                            child: Text(
                                                              "I hereby consent to receive policy related  communication from SUD Life Insurance  Ltd or its authorized representatives via Call, SMS, Email & Voice over Internet Protocol (VoIP) including WhatsApp and agree to waive my registration on NCPR (National Customer Preference Registry) in this regard.",
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              maxLines: 9,
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      defaultFontFamily,
                                                                  color: Colors
                                                                      .blueAccent,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  fontSize: 10),
                                                            ),
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  HapticFeedback.vibrate();
                                                  if (_nameController.text ==
                                                      "") {
                                                    showSnackBar(
                                                        "Please Enter Name");
                                                  } else if (_phoneController
                                                          .text ==
                                                      "") {
                                                    showSnackBar(
                                                        "Please Enter Phone Number");
                                                  } else if (!_policyChecked) {
                                                    showSnackBar(
                                                        "Please Accept the policy ");
                                                  } else if (int.tryParse(
                                                          _phoneController
                                                              .text) ==
                                                      null) {
                                                    showSnackBar(
                                                        "Only Number are allowed");
                                                  } else {
                                                    showSnackBar(
                                                        "Processing...");
                                                    _submitPhoneNumber();
                                                  }

                                                },
                                                child: Container(
                                                  margin:
                                                      const EdgeInsets.fromLTRB(
                                                          40, 10, 40, 20),

                                                  // height: height_size - 360,
                                                  // width: width_size - 470,
                                                  height: 50,
                                                  //width: 260,
                                                  decoration: BoxDecoration(
                                                    color: LightColor.appBlue,

                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      'Enter the zone',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontFamily:
                                                              defaultFontFamily,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: Colors
                                                    .white, // Set border color
                                                width: 0.2),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          margin: EdgeInsets.fromLTRB(
                                              40, 10, 40, 10),
                                          child: Column(
                                            children: [
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: Row(
                                                  children: [
                                                    IconButton(
                                                      icon: const Icon(
                                                          Icons.arrow_back_ios,
                                                          color: Colors.grey),
                                                      onPressed: () {
                                                        HapticFeedback
                                                            .vibrate();

                                                        setState(() {
                                                          _otpSent = false;
                                                          _timer.cancel();
                                                          _show = false;
                                                          _firstDigitOtp
                                                              .clear();
                                                          _secondDigitOtp
                                                              .clear();
                                                          _thirdDigitOtp
                                                              .clear();
                                                          _fourthDigitOtp
                                                              .clear();
                                                          _fifthDigitOtp
                                                              .clear();
                                                          _sixthDigitOtp
                                                              .clear();
                                                        });
                                                      },
                                                    ),
                                                    // Text(
                                                    //   "Back",
                                                    //   textAlign:
                                                    //   TextAlign.left,
                                                    //   style: TextStyle(
                                                    //       fontFamily:
                                                    //       defaultFontFamily,
                                                    //       color: Colors
                                                    //           .blueAccent,
                                                    //       fontWeight:
                                                    //       FontWeight
                                                    //           .normal,
                                                    //       fontSize: 18),
                                                    // ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              FadeAnimation(
                                                  1.1,
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            40, 0, 0, 0),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          "Mobile Verification",
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  defaultFontFamily,
                                                              color: Colors
                                                                  .blueAccent,
                                                              //Color.fromRGBO(113, 56, 208, 1.0),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontSize: 18),
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              FadeAnimation(
                                                  1.1,
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            40, 0, 0, 0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Enter 06 Digit OTP",
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  defaultFontFamily,
                                                              color: Colors
                                                                  .blueAccent,
                                                              //Color.fromRGBO(113, 56, 208, 1.0),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontSize: 12),
                                                        ),
                                                        Spacer(),
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                                  0, 0, 40, 0),
                                                          child: Text(
                                                            _start.toString() ==
                                                                    "0"
                                                                ? ''
                                                                : '$_start',
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    defaultFontFamily,
                                                                color: Colors
                                                                    .blueAccent,
                                                                //Color.fromRGBO(113, 56, 208, 1.0),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                fontSize: 12),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              FadeAnimation(
                                                0.5,
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 35,
                                                    ),
                                                    OtpInput(
                                                        _firstDigitOtp, true),
                                                    OtpInput(
                                                        _secondDigitOtp, false),
                                                    OtpInput(
                                                        _thirdDigitOtp, false),
                                                    OtpInput(
                                                        _fourthDigitOtp, false),
                                                    OtpInput(
                                                        _fifthDigitOtp, false),
                                                    OtpInput(
                                                        _sixthDigitOtp, false),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              FadeAnimation(
                                                  1.1,
                                                  InkWell(
                                                    onTap: () {
                                                      if (_show) {
                                                        setState(() {
                                                          _show = false;
                                                          _timer.cancel();
                                                        });
                                                        HapticFeedback
                                                            .vibrate();
                                                        startTimer();
                                                        _resubmitPhoneNumber();
                                                      }
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(0, 0, 0, 0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            _show
                                                                ? "Resend Otp"
                                                                : '',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    defaultFontFamily,
                                                                color: Colors
                                                                    .blueAccent,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                fontSize: 10),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )),
                                              const SizedBox(
                                                height: 40,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  HapticFeedback.vibrate();
                                                  _submitOTP(verification_id);

                                                  //   Navigator.of(context).push(CustomPageRoute(ZoneScreen()));

                                                  //   Navigator.of(context).push(_createRoute());

                                                  // Navigator.push(
                                                  //   context,
                                                  //   MaterialPageRoute(
                                                  //       builder: (context) => ZoneScreen()),
                                                  // );
                                                },
                                                child: Container(
                                                  margin:
                                                      const EdgeInsets.fromLTRB(
                                                          50, 10, 50, 20),

                                                  // height: height_size - 360,
                                                  // width: width_size - 470,
                                                  height: 50,
                                                  //width: 260,
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Colors.blueAccent,
                                                    borderRadius: BorderRadius
                                                        .only(
                                                            topRight: Radius
                                                                .circular(20.0),
                                                            bottomRight: Radius
                                                                .circular(20.0),
                                                            topLeft:
                                                                Radius.circular(
                                                                    20.0),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    20.0)),
                                                    // boxShadow: [
                                                    //   BoxShadow(
                                                    //     color:
                                                    //     Colors.black.withOpacity(0.4),
                                                    //     spreadRadius: 10,
                                                    //     blurRadius: 9,
                                                    //     offset: const Offset(0,
                                                    //         3), // changes position of shadow
                                                    //   ),
                                                    // ],
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      'Continue',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontFamily:
                                                              defaultFontFamily,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  FadeAnimation(
                                      1.1,
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .center,
                                        children: const [
                                          Text(
                                            "Protecting Families, Enriching Lives",
                                            textAlign:
                                            TextAlign
                                                .center,
                                            style: TextStyle(
                                              //fontFamily: defaultFontFamily,
                                                color: Colors
                                                    .white,
                                                //Color.fromRGBO(113, 56, 208, 1.0),
                                                fontWeight:
                                                FontWeight
                                                    .bold,
                                                fontSize: 20),
                                          ),
                                        ],
                                      )),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const SizedBox(
                                        width: 40,
                                      ),

                                      // ShakeAnimatedWidget(
                                      //   enabled: true,
                                      //   duration: const Duration(milliseconds: 450),
                                      //   shakeAngle: Rotation.deg(z: 4),
                                      //   curve: Curves.linear,
                                      //   child: InkWell(
                                      //     onTap: () {
                                      //       Navigator.push(
                                      //         context,
                                      //         MaterialPageRoute(
                                      //             builder: (context) => const ChessGame()),
                                      //       );
                                      //     },
                                      //     child: Container(
                                      //       margin: const EdgeInsets.all(10),
                                      //       // height: height_size - 320,
                                      //       // width: width_size - 665,
                                      //
                                      //       height: 120,
                                      //       width: 100,
                                      //       decoration: const BoxDecoration(
                                      //         image: DecorationImage(
                                      //           image: AssetImage("assets/games/Chesss.png"),
                                      //           fit: BoxFit.fill,
                                      //         ),
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),

                                      // ShakeAnimatedWidget(
                                      //   enabled: true,
                                      //   duration: Duration(milliseconds: 450),
                                      //   shakeAngle: Rotation.deg(z: 4),
                                      //   curve: Curves.linear,
                                      //   child: InkWell(
                                      //     onTap: () {
                                      //       Navigator.push(
                                      //         context,
                                      //         MaterialPageRoute(
                                      //             // builder: (context) => ChessGame()),
                                      //             builder: (context) => SplashScrenn()),
                                      //       );
                                      //     },
                                      //     child: Container(
                                      //       margin: const EdgeInsets.all(10),
                                      //       height: 80,
                                      //       width: 65,
                                      //       decoration: const BoxDecoration(
                                      //         image: DecorationImage(
                                      //           image: AssetImage(
                                      //               "assets/games/Covi KIll.png"),
                                      //           fit: BoxFit.fill,
                                      //         ),
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),

                                      ShakeAnimatedWidget(
                                        enabled: true,
                                        duration: Duration(milliseconds: 450),
                                        shakeAngle: Rotation.deg(z: 4),
                                        curve: Curves.linear,
                                        child: InkWell(
                                          onTap: () {
                                            HapticFeedback.vibrate();
                                            _otpSent
                                                ? showSnackBar("Please Click on Continue !")
                                                : showSnackBar(
                                                "Please Click on the Enter The Zone !");
                                            // Navigator.push(
                                            //   context,
                                            //   MaterialPageRoute(
                                            //       // builder: (context) => ChessGame()),
                                            //       builder: (context) =>
                                            //           const FunFacts_Screen()),
                                            // );
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.all(10),
                                            height: 80,
                                            width: 65,
                                            decoration: const BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage(
                                                    "assets/games/Fun Facts.png"),
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      ShakeAnimatedWidget(
                                        enabled: true,
                                        duration: Duration(milliseconds: 450),
                                        shakeAngle: Rotation.deg(z: 4),
                                        curve: Curves.linear,
                                        child: InkWell(
                                          onTap: () {
                                            HapticFeedback.vibrate();
                                            _otpSent
                                                ? showSnackBar("Please Click on Continue !")
                                                : showSnackBar(
                                                "Please Click on the Enter The Zone !");
                                            // Navigator.push(
                                            //   context,
                                            //   MaterialPageRoute(
                                            //       // builder: (context) => ChessGame()),
                                            //       builder: (context) =>
                                            //           const Quiz_Screen()),
                                            // );
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.all(10),
                                            height: 80,
                                            width: 65,
                                            decoration: const BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage(
                                                    "assets/games/Quiz Time.png"),
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      const SizedBox(
                                        width: 40,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                ],
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
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
                                        padding: const EdgeInsets.fromLTRB(
                                            60, 20, 60, 20),
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
                              Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  // InkWell(
                                  //   onTap: () {
                                  //     Navigator.of(context).push(
                                  //         PageRouteBuilder(
                                  //             pageBuilder: (context,
                                  //                 animation,
                                  //                 secondaryAnimation) {
                                  //               return ZoneHomeScreen();
                                  //             },
                                  //             transitionDuration:
                                  //                 const Duration(
                                  //                     milliseconds: 500),
                                  //             transitionsBuilder: (context,
                                  //                 animation,
                                  //                 secondaryAnimation,
                                  //                 child) {
                                  //               return FadeTransition(
                                  //                 opacity: animation,
                                  //                 child: child,
                                  //               );
                                  //             }));
                                  //
                                  //     //   Navigator.of(context).push(CustomPageRoute(ZoneScreen()));
                                  //
                                  //     //   Navigator.of(context).push(_createRoute());
                                  //
                                  //     // Navigator.push(
                                  //     //   context,
                                  //     //   MaterialPageRoute(
                                  //     //       builder: (context) => ZoneScreen()),
                                  //     // );
                                  //   },
                                  //   child: Container(
                                  //     margin: const EdgeInsets.all(10),
                                  //     // height: height_size - 360,
                                  //     // width: width_size - 470,
                                  //     height: 60,
                                  //     width: 160,
                                  //     decoration: BoxDecoration(
                                  //       color: Colors.white,
                                  //       borderRadius: const BorderRadius.only(
                                  //           topRight: Radius.circular(20.0),
                                  //           bottomRight:
                                  //               Radius.circular(20.0),
                                  //           topLeft: Radius.circular(20.0),
                                  //           bottomLeft:
                                  //               Radius.circular(20.0)),
                                  //       boxShadow: [
                                  //         BoxShadow(
                                  //           color:
                                  //               Colors.black.withOpacity(0.4),
                                  //           spreadRadius: 10,
                                  //           blurRadius: 9,
                                  //           offset: const Offset(0,
                                  //               3), // changes position of shadow
                                  //         ),
                                  //       ],
                                  //     ),
                                  //     child: Center(
                                  //       child: Text(
                                  //         'Enter the zone',
                                  //         style: TextStyle(
                                  //             fontSize: 16,
                                  //             fontFamily: defaultFontFamily,
                                  //             fontWeight: FontWeight.bold,
                                  //             color:
                                  //                 Colors.blueAccent.shade400),
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),

                                  !_otpSent
                                      ? Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: Colors
                                                    .white, // Set border color
                                                width: 0.2),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          margin: EdgeInsets.fromLTRB(
                                              40, 10, 40, 10),
                                          child: Column(
                                            children: [
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              FadeAnimation(
                                                  1.1,
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            40, 0, 0, 0),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          "Enter Your Details",
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  defaultFontFamily,
                                                              color: Colors
                                                                  .blueAccent,
                                                              //Color.fromRGBO(113, 56, 208, 1.0),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontSize: 18),
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              FadeAnimation(
                                                  1.1,
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            40, 0, 0, 0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Name",
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  defaultFontFamily,
                                                              color: Colors
                                                                  .blueAccent,
                                                              //Color.fromRGBO(113, 56, 208, 1.0),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontSize: 15),
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              FadeAnimation(
                                                0.5,
                                                Container(
                                                  height: 53,
                                                  // width: MediaQuery.of(context)
                                                  //     .size
                                                  //     .width -
                                                  //     180,
                                                  margin: EdgeInsets.fromLTRB(
                                                      40, 0, 40, 0),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        color: (Colors.grey[
                                                            800])!, // Set border color
                                                        width: 0.2),
                                                    // gradient: const LinearGradient(
                                                    //   // begin: Alignment.centerLeft,
                                                    //   // end: Alignment.centerRight,
                                                    //   colors: <Color>[
                                                    //     Color.fromRGBO(
                                                    //         255, 241, 255, 1.0),
                                                    //     Color.fromRGBO(
                                                    //         243, 231, 255, 1.0),
                                                    //   ],
                                                    // ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.3),
                                                        spreadRadius: 1,
                                                        blurRadius: 19,
                                                        offset: const Offset(0,
                                                            3), // changes position of shadow
                                                      ),
                                                    ],
                                                  ),
                                                  child: TextField(
                                                    controller: _nameController,
                                                    minLines: 1,
                                                    maxLength: 30,
                                                    inputFormatters: <
                                                        TextInputFormatter>[
                                                      FilteringTextInputFormatter
                                                          .allow(RegExp(
                                                          "[a-z A-Z]")),
                                                    ],
                                                    textAlignVertical:
                                                        TextAlignVertical
                                                            .center,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.black87,
                                                      fontFamily:
                                                          defaultFontFamily,
                                                    ),
                                                    decoration: const InputDecoration(
                                                        border: InputBorder.none,
                                                        hintText: "  Enter Your Full Name",
                                                        filled: false,
                                                        hintStyle: TextStyle(
                                                            fontSize: 14,
                                                            // fontFamily:
                                                            // defaultFontFamily,
                                                            color: Colors.grey)),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              FadeAnimation(
                                                  1.1,
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            40, 0, 0, 0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Mobile Number",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  defaultFontFamily,
                                                              color: Colors
                                                                  .blueAccent,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontSize: 15),
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              FadeAnimation(
                                                0.5,
                                                Container(
                                                  height: 53,
                                                  // width: MediaQuery.of(context)
                                                  //     .size
                                                  //     .width -
                                                  //     180,
                                                  margin: EdgeInsets.fromLTRB(
                                                      40, 0, 40, 0),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        color: (Colors.grey[
                                                            800])!, // Set border color
                                                        width: 0.2),
                                                    // gradient: const LinearGradient(
                                                    //   // begin: Alignment.centerLeft,
                                                    //   // end: Alignment.centerRight,
                                                    //   colors: <Color>[
                                                    //     Color.fromRGBO(
                                                    //         255, 241, 255, 1.0),
                                                    //     Color.fromRGBO(
                                                    //         243, 231, 255, 1.0),
                                                    //   ],
                                                    // ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.3),
                                                        spreadRadius: 1,
                                                        blurRadius: 19,
                                                        offset: const Offset(0,
                                                            3), // changes position of shadow
                                                      ),
                                                    ],
                                                  ),
                                                  child: TextField(
                                                    minLines: 1,
                                                    controller:
                                                        _phoneController,
                                                    textAlignVertical:
                                                        TextAlignVertical
                                                            .center,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.black87,
                                                      fontFamily:
                                                          defaultFontFamily,
                                                    ),
                                                    decoration: const InputDecoration(
                                                        border: InputBorder.none,
                                                        // prefixIcon: Container(
                                                        //   padding:
                                                        //   EdgeInsets.all(11),
                                                        //   height: 15,
                                                        //   width: 15,
                                                        //   child: Image.asset(
                                                        //     'assets/icons/icons/email.png',
                                                        //   ),
                                                        // ),
                                                        hintText: "  Enter 10 Digit Mobile Number",
                                                        filled: false,
                                                        // fillColor: LightColor.yboxbackpurple,
                                                        hintStyle: TextStyle(
                                                            fontSize: 14,
                                                            // fontFamily:
                                                            // defaultFontFamily,
                                                            color: Colors.grey)),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 20, 0, 10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              30, 0, 0, 0),
                                                      child: Theme(
                                                        data: Theme.of(context)
                                                            .copyWith(
                                                          unselectedWidgetColor:
                                                              Colors.grey,
                                                        ),
                                                        child: Checkbox(
                                                          checkColor:
                                                              Colors.blueAccent,
                                                          activeColor:
                                                              Colors.white,
                                                          value: _policyChecked,
                                                          onChanged: (value) {
                                                            setState(() =>
                                                                _policyChecked =
                                                                    value!);
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: FadeAnimation(
                                                          1.1,
                                                          Padding(
                                                            padding: EdgeInsets
                                                                .fromLTRB(10, 0,
                                                                    40, 0),
                                                            child: Text(
                                                              "I hereby consent to receive policy related  communication from SUD Life Insurance  Ltd or its authorized representatives via Call, SMS, Email & Voice over Internet Protocol (VoIP) including WhatsApp and agree to waive my registration on NCPR (National Customer Preference Registry) in this regard.",
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              maxLines: 6,
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      defaultFontFamily,
                                                                  color: Colors
                                                                      .blueAccent,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  fontSize: 10),
                                                            ),
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  HapticFeedback.vibrate();
                                                  if (_nameController.text ==
                                                      "") {
                                                    showSnackBar(
                                                        "Please Enter Name");
                                                  } else if (_phoneController
                                                          .text ==
                                                      "") {
                                                    showSnackBar(
                                                        "Please Enter Phone Number");
                                                  } else if (!_policyChecked) {
                                                    showSnackBar(
                                                        "Please Accept the policy ");
                                                  } else if (int.tryParse(
                                                          _phoneController
                                                              .text) ==
                                                      null) {
                                                    showSnackBar(
                                                        "Only Number are allowed");
                                                  } else {
                                                    showSnackBar(
                                                        "Processing...");
                                                    _submitPhoneNumber();
                                                  }

                                                  // if (_nameController.text ==
                                                  //     "") {
                                                  //   showSnackBar("Enter Name");
                                                  // } else if (_phoneController
                                                  //         .text ==
                                                  //     "") {
                                                  //   showSnackBar(
                                                  //       "Enter Phone Number");
                                                  // } else {
                                                  //
                                                  //   _submitPhoneNumber();
                                                  // }
                                                },
                                                child: Container(
                                                  margin:
                                                      const EdgeInsets.fromLTRB(
                                                          40, 10, 40, 20),

                                                  // height: height_size - 360,
                                                  // width: width_size - 470,
                                                  height: 50,
                                                  //width: 260,
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Colors.blueAccent,
                                                    borderRadius: BorderRadius
                                                        .only(
                                                            topRight: Radius
                                                                .circular(20.0),
                                                            bottomRight: Radius
                                                                .circular(20.0),
                                                            topLeft:
                                                                Radius.circular(
                                                                    20.0),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    20.0)),
                                                    // boxShadow: [
                                                    //   BoxShadow(
                                                    //     color:
                                                    //     Colors.black.withOpacity(0.4),
                                                    //     spreadRadius: 10,
                                                    //     blurRadius: 9,
                                                    //     offset: const Offset(0,
                                                    //         3), // changes position of shadow
                                                    //   ),
                                                    // ],
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      'Enter the zone',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontFamily:
                                                              defaultFontFamily,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: Colors
                                                    .white, // Set border color
                                                width: 0.2),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          margin: EdgeInsets.fromLTRB(
                                              40, 10, 40, 10),
                                          child: Column(
                                            children: [
                                              // const SizedBox(
                                              //   height: 20,
                                              // ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: Row(
                                                  children: [
                                                    IconButton(
                                                      icon: const Icon(
                                                          Icons.arrow_back_ios,
                                                          color: Colors.grey),
                                                      onPressed: () {
                                                        HapticFeedback
                                                            .vibrate();

                                                        setState(() {
                                                          _otpSent = false;
                                                          _timer.cancel();
                                                          _show = false;
                                                          _firstDigitOtp
                                                              .clear();
                                                          _secondDigitOtp
                                                              .clear();
                                                          _thirdDigitOtp
                                                              .clear();
                                                          _fourthDigitOtp
                                                              .clear();
                                                          _fifthDigitOtp
                                                              .clear();
                                                          _sixthDigitOtp
                                                              .clear();
                                                        });
                                                      },
                                                    ),
                                                    // Text(
                                                    //   "Back",
                                                    //   textAlign:
                                                    //   TextAlign.left,
                                                    //   style: TextStyle(
                                                    //       fontFamily:
                                                    //       defaultFontFamily,
                                                    //       color: Colors
                                                    //           .blueAccent,
                                                    //       fontWeight:
                                                    //       FontWeight
                                                    //           .normal,
                                                    //       fontSize: 18),
                                                    // ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              FadeAnimation(
                                                  1.1,
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            40, 0, 0, 0),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          "Mobile Verification",
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  defaultFontFamily,
                                                              color: Colors
                                                                  .blueAccent,
                                                              //Color.fromRGBO(113, 56, 208, 1.0),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontSize: 18),
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              FadeAnimation(
                                                  1.1,
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            40, 0, 0, 0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Enter 06 Digit OTP",
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  defaultFontFamily,
                                                              color: Colors
                                                                  .blueAccent,
                                                              //Color.fromRGBO(113, 56, 208, 1.0),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontSize: 12),
                                                        ),
                                                        Spacer(),
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                                  0, 0, 40, 0),
                                                          child: Text(
                                                            '$_start',
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    defaultFontFamily,
                                                                color: Colors
                                                                    .blueAccent,
                                                                //Color.fromRGBO(113, 56, 208, 1.0),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                fontSize: 12),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              FadeAnimation(
                                                0.5,
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 35,
                                                    ),
                                                    OtpInput(
                                                        _firstDigitOtp, true),
                                                    OtpInput(
                                                        _secondDigitOtp, false),
                                                    OtpInput(
                                                        _thirdDigitOtp, false),
                                                    OtpInput(
                                                        _fourthDigitOtp, false),
                                                    OtpInput(
                                                        _fifthDigitOtp, false),
                                                    OtpInput(
                                                        _sixthDigitOtp, false),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              FadeAnimation(
                                                  1.1,
                                                  InkWell(
                                                    onTap: () {
                                                      if (_show) {
                                                        _submitPhoneNumber();
                                                      } else {}
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              0, 0, 0, 0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            _show
                                                                ? "Resend Otp"
                                                                : '',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    defaultFontFamily,
                                                                color: Colors
                                                                    .blueAccent,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                fontSize: 10),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )),

                                              const SizedBox(
                                                height: 40,
                                              ),

                                              InkWell(
                                                onTap: () {
                                                  _submitOTP(verification_id);
                                                  // Navigator.of(context).push(
                                                  //     PageRouteBuilder(
                                                  //         pageBuilder: (context,
                                                  //             animation,
                                                  //             secondaryAnimation) {
                                                  //           return ZoneHomeScreen();
                                                  //         },
                                                  //         transitionDuration:
                                                  //             const Duration(
                                                  //                 milliseconds:
                                                  //                     500),
                                                  //         transitionsBuilder:
                                                  //             (context,
                                                  //                 animation,
                                                  //                 secondaryAnimation,
                                                  //                 child) {
                                                  //           return FadeTransition(
                                                  //             opacity: animation,
                                                  //             child: child,
                                                  //           );
                                                  //         }));
                                                  ///
                                                  //   Navigator.of(context).push(CustomPageRoute(ZoneScreen()));

                                                  //   Navigator.of(context).push(_createRoute());

                                                  // Navigator.push(
                                                  //   context,
                                                  //   MaterialPageRoute(
                                                  //       builder: (context) => ZoneScreen()),
                                                  // );
                                                },
                                                child: Container(
                                                  margin:
                                                      const EdgeInsets.fromLTRB(
                                                          50, 10, 50, 20),

                                                  // height: height_size - 360,
                                                  // width: width_size - 470,
                                                  height: 50,
                                                  //width: 260,
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Colors.blueAccent,
                                                    borderRadius: BorderRadius
                                                        .only(
                                                            topRight: Radius
                                                                .circular(20.0),
                                                            bottomRight: Radius
                                                                .circular(20.0),
                                                            topLeft:
                                                                Radius.circular(
                                                                    20.0),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    20.0)),
                                                    // boxShadow: [
                                                    //   BoxShadow(
                                                    //     color:
                                                    //     Colors.black.withOpacity(0.4),
                                                    //     spreadRadius: 10,
                                                    //     blurRadius: 9,
                                                    //     offset: const Offset(0,
                                                    //         3), // changes position of shadow
                                                    //   ),
                                                    // ],
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      'Continue',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontFamily:
                                                              defaultFontFamily,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                  const SizedBox(
                                    height: 20,
                                  ),

                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const SizedBox(
                                        width: 40,
                                      ),

                                      // ShakeAnimatedWidget(
                                      //   enabled: true,
                                      //   duration: const Duration(milliseconds: 450),
                                      //   shakeAngle: Rotation.deg(z: 4),
                                      //   curve: Curves.linear,
                                      //   child: InkWell(
                                      //     onTap: () {
                                      //       Navigator.push(
                                      //         context,
                                      //         MaterialPageRoute(
                                      //             builder: (context) => const ChessGame()),
                                      //       );
                                      //     },
                                      //     child: Container(
                                      //       margin: const EdgeInsets.all(10),
                                      //       // height: height_size - 320,
                                      //       // width: width_size - 665,
                                      //
                                      //       height: 120,
                                      //       width: 100,
                                      //       decoration: const BoxDecoration(
                                      //         image: DecorationImage(
                                      //           image: AssetImage("assets/games/Chesss.png"),
                                      //           fit: BoxFit.fill,
                                      //         ),
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),

                                      // ShakeAnimatedWidget(
                                      //   enabled: true,
                                      //   duration: Duration(milliseconds: 450),
                                      //   shakeAngle: Rotation.deg(z: 4),
                                      //   curve: Curves.linear,
                                      //   child: InkWell(
                                      //     onTap: () {
                                      //       Navigator.push(
                                      //         context,
                                      //         MaterialPageRoute(
                                      //             // builder: (context) => ChessGame()),
                                      //             builder: (context) => SplashScrenn()),
                                      //       );
                                      //     },
                                      //     child: Container(
                                      //       margin: const EdgeInsets.all(10),
                                      //       height: 80,
                                      //       width: 65,
                                      //       decoration: const BoxDecoration(
                                      //         image: DecorationImage(
                                      //           image: AssetImage(
                                      //               "assets/games/Covi KIll.png"),
                                      //           fit: BoxFit.fill,
                                      //         ),
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),

                                      ShakeAnimatedWidget(
                                        enabled: true,
                                        duration: Duration(milliseconds: 450),
                                        shakeAngle: Rotation.deg(z: 4),
                                        curve: Curves.linear,
                                        child: InkWell(
                                          onTap: () {
                                            HapticFeedback.vibrate();
                                            _otpSent
                                                ? showSnackBar("Please Click on Continue !")
                                                : showSnackBar(
                                                "Please Click on the Enter The Zone !");
                                            // showSnackBar(
                                            //     "Please Click on the Enter The Zone !");
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.all(10),
                                            height: 80,
                                            width: 65,
                                            decoration: const BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage(
                                                    "assets/games/Fun Facts.png"),
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      ShakeAnimatedWidget(
                                        enabled: true,
                                        duration: Duration(milliseconds: 450),
                                        shakeAngle: Rotation.deg(z: 4),
                                        curve: Curves.linear,
                                        child: InkWell(
                                          onTap: () {
                                            HapticFeedback.vibrate();
                                            _otpSent
                                                ? showSnackBar("Please Click on Continue !")
                                                : showSnackBar(
                                                "Please Click on the Enter The Zone !");

                                            // Navigator.push(
                                            //   context,
                                            //   MaterialPageRoute(
                                            //       // builder: (context) => ChessGame()),
                                            //       builder: (context) =>
                                            //           const Quiz_Screen()),
                                            //);
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.all(10),
                                            height: 80,
                                            width: 65,
                                            decoration: const BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage(
                                                    "assets/games/Quiz Time.png"),
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      const SizedBox(
                                        width: 40,
                                      ),
                                    ],
                                  ),

                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              )
                            ],
                          ),
                  ),
                )
              : SingleChildScrollView(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        //image: AssetImage("assets/images/new.png"),
                        //image: AssetImage("assets/images/Exz Tab Bag.png"),
                        image: AssetImage("assets/images/Text Background.png"),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
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
                                      const EdgeInsets.fromLTRB(60, 15, 60, 15),
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
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: Column(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                400,
                                        height:
                                            MediaQuery.of(context).size.height -
                                                430,
                                        decoration: const BoxDecoration(
                                          image: DecorationImage(
                                            //image: AssetImage("assets/images/new.png"),
                                            //image: AssetImage("assets/images/Exz Tab Bag.png"),
                                            image: AssetImage(
                                                "assets/images/shutterstock_18.png"),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 40,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const SizedBox(
                                            width: 40,
                                          ),

                                          // ShakeAnimatedWidget(
                                          //   enabled: true,
                                          //   duration: const Duration(milliseconds: 450),
                                          //   shakeAngle: Rotation.deg(z: 4),
                                          //   curve: Curves.linear,
                                          //   child: InkWell(
                                          //     onTap: () {
                                          //       Navigator.push(
                                          //         context,
                                          //         MaterialPageRoute(
                                          //             builder: (context) => const ChessGame()),
                                          //       );
                                          //     },
                                          //     child: Container(
                                          //       margin: const EdgeInsets.all(10),
                                          //       // height: height_size - 320,
                                          //       // width: width_size - 665,
                                          //
                                          //       height: 120,
                                          //       width: 100,
                                          //       decoration: const BoxDecoration(
                                          //         image: DecorationImage(
                                          //           image: AssetImage("assets/games/Chesss.png"),
                                          //           fit: BoxFit.fill,
                                          //         ),
                                          //       ),
                                          //     ),
                                          //   ),
                                          // ),

                                          // ShakeAnimatedWidget(
                                          //   enabled: true,
                                          //   duration: Duration(milliseconds: 450),
                                          //   shakeAngle: Rotation.deg(z: 4),
                                          //   curve: Curves.linear,
                                          //   child: InkWell(
                                          //     onTap: () {
                                          //       Navigator.push(
                                          //         context,
                                          //         MaterialPageRoute(
                                          //             // builder: (context) => ChessGame()),
                                          //             builder: (context) => SplashScrenn()),
                                          //       );
                                          //     },
                                          //     child: Container(
                                          //       margin: const EdgeInsets.all(10),
                                          //       height: 100,
                                          //       width: 80,
                                          //       decoration: const BoxDecoration(
                                          //         image: DecorationImage(
                                          //           image: AssetImage(
                                          //               "assets/games/Covi KIll.png"),
                                          //           fit: BoxFit.fill,
                                          //         ),
                                          //       ),
                                          //     ),
                                          //   ),
                                          // ),

                                          ShakeAnimatedWidget(
                                            enabled: true,
                                            duration:
                                                Duration(milliseconds: 450),
                                            shakeAngle: Rotation.deg(z: 4),
                                            curve: Curves.linear,
                                            child: InkWell(
                                              onTap: () {
                                                HapticFeedback.vibrate();
                                                _otpSent
                                                    ? showSnackBar("Please Click on Continue !")
                                                    : showSnackBar(
                                                    "Please Click on the Enter The Zone !");
                                                //showSnackBar("Please Enter The Details to Play !");
                                                // Navigator.push(
                                                //   context,
                                                //   MaterialPageRoute(
                                                //       // builder: (context) => ChessGame()),
                                                //       builder: (context) =>
                                                //           const FunFacts_Screen()),
                                                //);
                                              },
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.all(10),
                                                height: 100,
                                                width: 80,
                                                decoration: const BoxDecoration(
                                                  image: DecorationImage(
                                                    image: AssetImage(
                                                        "assets/games/Fun Facts.png"),
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),

                                          ShakeAnimatedWidget(
                                            enabled: true,
                                            duration:
                                                Duration(milliseconds: 450),
                                            shakeAngle: Rotation.deg(z: 4),
                                            curve: Curves.linear,
                                            child: InkWell(
                                              onTap: () {
                                                HapticFeedback.vibrate();
                                                _otpSent
                                                    ? showSnackBar("Please Click on Continue !")
                                                    : showSnackBar(
                                                    "Please Click on the Enter The Zone !");
                                                //showSnackBar("Please Enter The Details to Play ! ");
                                                // Navigator.push(
                                                //   context,
                                                //   MaterialPageRoute(
                                                //       // builder: (context) => ChessGame()),
                                                //       builder: (context) =>
                                                //           const Quiz_Screen()),
                                                // );
                                              },
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.all(10),
                                                height: 100,
                                                width: 80,
                                                decoration: const BoxDecoration(
                                                  image: DecorationImage(
                                                    image: AssetImage(
                                                        "assets/games/Quiz Time.png"),
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),

                                          const SizedBox(
                                            width: 40,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 40,
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Column(
                                    children: [
                                      !_otpSent
                                          ? Padding(
                                              padding: const EdgeInsets.fromLTRB(
                                                  80, 0, 80, 40),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    width: 400,
                                                    // width: MediaQuery.of(context)
                                                    //         .size
                                                    //         .width -
                                                    //     1200,
                                                    // height: MediaQuery.of(context)
                                                    //         .size
                                                    //         .height -
                                                    //     500,

                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(
                                                          color: Colors
                                                              .white, // Set border color
                                                          width: 0.2),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                    margin: const EdgeInsets.fromLTRB(
                                                        00, 10, 00, 10),
                                                    child: Column(
                                                      children: [
                                                        // const SizedBox(
                                                        //   height: 40,
                                                        // ),
                                                        FadeAnimation(
                                                            1.1,
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .fromLTRB(
                                                                          0,
                                                                          40,
                                                                          0,
                                                                          0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    "Please Enter Your Details To Proceed",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: TextStyle(
                                                                        //fontFamily: defaultFontFamily,
                                                                        color: Colors.redAccent,
                                                                        //Color.fromRGBO(113, 56, 208, 1.0),
                                                                        fontWeight: FontWeight.normal,
                                                                        fontSize: 16),
                                                                  ),
                                                                ],
                                                              ),
                                                            )),
                                                        // const SizedBox(
                                                        //   height: 40,
                                                        // ),
                                                        FadeAnimation(
                                                            1.1,
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .fromLTRB(
                                                                          40,
                                                                          40,
                                                                          0,
                                                                          0),
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                    "Enter Your Details",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left,
                                                                    style: TextStyle(
                                                                        fontFamily: defaultFontFamily,
                                                                        color: LightColor.appBlue,
                                                                        //Color.fromRGBO(113, 56, 208, 1.0),
                                                                        fontWeight: FontWeight.normal,
                                                                        fontSize: 22),
                                                                  ),
                                                                ],
                                                              ),
                                                            )),
                                                        // const SizedBox(
                                                        //   height: 40,
                                                        // ),
                                                        FadeAnimation(
                                                            1.1,
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .fromLTRB(
                                                                          40,
                                                                          40,
                                                                          0,
                                                                          0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    "Name",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left,
                                                                    style: TextStyle(
                                                                        fontFamily: defaultFontFamily,
                                                                        color: LightColor.appBlue,
                                                                        //Color.fromRGBO(113, 56, 208, 1.0),
                                                                        fontWeight: FontWeight.normal,
                                                                        fontSize: 15),
                                                                  ),
                                                                ],
                                                              ),
                                                            )),

                                                        const SizedBox(
                                                          height: 10,
                                                        ),

                                                        FadeAnimation(
                                                          0.5,
                                                          Container(
                                                            height: 53,
                                                            // width: MediaQuery.of(context)
                                                            //     .size
                                                            //     .width -
                                                            //     180,
                                                            margin: const EdgeInsets
                                                                .fromLTRB(40, 0,
                                                                    40, 0),
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              border:
                                                                  Border.all(
                                                                      color: (Colors
                                                                              .grey[
                                                                          800])!, // Set border color
                                                                      width:
                                                                          0.2),
                                                              // gradient: const LinearGradient(
                                                              //   // begin: Alignment.centerLeft,
                                                              //   // end: Alignment.centerRight,
                                                              //   colors: <Color>[
                                                              //     Color.fromRGBO(
                                                              //         255, 241, 255, 1.0),
                                                              //     Color.fromRGBO(
                                                              //         243, 231, 255, 1.0),
                                                              //   ],
                                                              // ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors
                                                                      .grey
                                                                      .withOpacity(
                                                                          0.3),
                                                                  spreadRadius:
                                                                      1,
                                                                  blurRadius:
                                                                      19,
                                                                  offset: const Offset(
                                                                      0,
                                                                      3), // changes position of shadow
                                                                ),
                                                              ],
                                                            ),
                                                            child: TextField(

                                                              minLines: 1,
                                                              maxLength: 30,
                                                              controller:
                                                                  _nameController,
                                                              inputFormatters: <
                                                                  TextInputFormatter>[
                                                                FilteringTextInputFormatter
                                                                    .allow(RegExp(
                                                                        "[a-z A-Z]")),
                                                              ],
                                                              textAlignVertical:
                                                                  TextAlignVertical
                                                                      .center,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black87,
                                                                fontFamily:
                                                                    defaultFontFamily,
                                                              ),
                                                              decoration: const InputDecoration(
                                                                  counter: SizedBox.shrink(),
                                                                  border: InputBorder.none,
                                                                  // prefixIcon: Container(
                                                                  //   padding:
                                                                  //   EdgeInsets.all(11),
                                                                  //   height: 15,
                                                                  //   width: 15,
                                                                  //   child: Image.asset(
                                                                  //     'assets/icons/icons/email.png',
                                                                  //   ),
                                                                  // ),
                                                                  hintText: "  Enter Your Full Name",
                                                                  //filled: false,
                                                                  // fillColor: LightColor.yboxbackpurple,
                                                                  hintStyle: TextStyle(
                                                                      fontSize: 14,
                                                                      // fontFamily:
                                                                      // defaultFontFamily,
                                                                      color: Colors.grey)),
                                                            ),
                                                          ),
                                                        ),
                                                        // const SizedBox(
                                                        //   height: 30,
                                                        // ),
                                                        FadeAnimation(
                                                            1.1,
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .fromLTRB(
                                                                          40,
                                                                          30,
                                                                          0,
                                                                          0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    "Mobile Number",
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            defaultFontFamily,
                                                                        color: LightColor
                                                                            .appBlue,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .normal,
                                                                        fontSize:
                                                                            15),
                                                                  ),
                                                                ],
                                                              ),
                                                            )),
                                                        // const SizedBox(
                                                        //   height: 10,
                                                        // ),
                                                        FadeAnimation(
                                                          0.5,
                                                          Padding(
                                                            padding: const EdgeInsets
                                                                .fromLTRB(0, 10,
                                                                    0, 0),
                                                            child: Container(
                                                              height: 53,
                                                              // width: MediaQuery.of(context)
                                                              //     .size
                                                              //     .width -
                                                              //     180,
                                                              margin: EdgeInsets
                                                                  .fromLTRB(40,
                                                                      0, 40, 0),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                border:
                                                                    Border.all(
                                                                        color: (Colors.grey[
                                                                            800])!, // Set border color
                                                                        width:
                                                                            0.2),
                                                                // gradient: const LinearGradient(
                                                                //   // begin: Alignment.centerLeft,
                                                                //   // end: Alignment.centerRight,
                                                                //   colors: <Color>[
                                                                //     Color.fromRGBO(
                                                                //         255, 241, 255, 1.0),
                                                                //     Color.fromRGBO(
                                                                //         243, 231, 255, 1.0),
                                                                //   ],
                                                                // ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.3),
                                                                    spreadRadius:
                                                                        1,
                                                                    blurRadius:
                                                                        19,
                                                                    offset: const Offset(
                                                                        0,
                                                                        3), // changes position of shadow
                                                                  ),
                                                                ],
                                                              ),
                                                              child: TextField(
                                                                keyboardType:
                                                                    TextInputType
                                                                        .number,
                                                                inputFormatters: <
                                                                    TextInputFormatter>[
                                                                  FilteringTextInputFormatter
                                                                      .digitsOnly
                                                                ],
                                                                minLines: 1,
                                                                maxLength: 10,
                                                                controller:
                                                                    _phoneController,
                                                                textAlignVertical:
                                                                    TextAlignVertical
                                                                        .center,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black87,
                                                                  fontFamily:
                                                                      defaultFontFamily,
                                                                ),
                                                                decoration: const InputDecoration(
                                                                    counter: SizedBox.shrink(),
                                                                    border: InputBorder.none,
                                                                    // prefixIcon: Container(
                                                                    //   padding:
                                                                    //   EdgeInsets.all(11),
                                                                    //   height: 15,
                                                                    //   width: 15,
                                                                    //   child: Image.asset(
                                                                    //     'assets/icons/icons/email.png',
                                                                    //   ),
                                                                    // ),
                                                                    hintText: "  Enter 10 Digit Mobile Number",
                                                                    filled: false,
                                                                    // fillColor: LightColor.yboxbackpurple,
                                                                    hintStyle: TextStyle(
                                                                        fontSize: 14,
                                                                        // fontFamily:
                                                                        // defaultFontFamily,
                                                                        color: Colors.grey)),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  0, 20, 0, 10),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .fromLTRB(
                                                                            30,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                child: Theme(
                                                                  data: Theme.of(
                                                                          context)
                                                                      .copyWith(
                                                                    unselectedWidgetColor:
                                                                        Colors
                                                                            .grey,
                                                                  ),
                                                                  child:
                                                                      Checkbox(
                                                                    checkColor:
                                                                        Colors
                                                                            .blueAccent,
                                                                    activeColor:
                                                                        Colors
                                                                            .white,
                                                                    value:
                                                                        _policyChecked,
                                                                    onChanged:
                                                                        (value) {
                                                                      setState(() =>
                                                                          _policyChecked =
                                                                              value!);
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child:
                                                                    FadeAnimation(
                                                                        1.1,
                                                                        Padding(
                                                                          padding: const EdgeInsets.fromLTRB(
                                                                              10,
                                                                              0,
                                                                              40,
                                                                              0),
                                                                          child:
                                                                              Text(
                                                                            "I hereby consent to receive policy related  communication from SUD Life Insurance  Ltd or its authorized representatives via Call, SMS, Email & Voice over Internet Protocol (VoIP) including WhatsApp and agree to waive my registration on NCPR (National Customer Preference Registry) in this regard.",
                                                                            textAlign:
                                                                                TextAlign.left,
                                                                            maxLines:
                                                                                8,
                                                                            style: TextStyle(
                                                                                fontFamily: defaultFontFamily,
                                                                                color: LightColor.appBlue,
                                                                                fontWeight: FontWeight.normal,
                                                                                fontSize: 10),
                                                                          ),
                                                                        )),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            // if (_nameController
                                                            //     .text ==
                                                            //     "") {
                                                            //   showSnackBar(
                                                            //       "Enter Name");
                                                            // } else if (_phoneController
                                                            //     .text ==
                                                            //     "") {
                                                            //   showSnackBar(
                                                            //       "Enter Phone Number");
                                                            // }

                                                            if (_nameController
                                                                    .text ==
                                                                "") {
                                                              showSnackBar(
                                                                  "Please Enter Name");
                                                            } else if (_phoneController
                                                                    .text ==
                                                                "") {
                                                              showSnackBar(
                                                                  "Please Enter Phone Number");
                                                            } else if (!_policyChecked) {
                                                              showSnackBar(
                                                                  "Please Accept the policy ");
                                                            } else if (int.tryParse(
                                                                    _phoneController
                                                                        .text) ==
                                                                null) {
                                                              showSnackBar(
                                                                  "Only Numbers are allowed");
                                                            } else {
                                                              _submitPhoneNumber();
                                                            }
                                                          },
                                                          child: Padding(
                                                            padding: const EdgeInsets
                                                                .fromLTRB(0, 0,
                                                                    0, 10),
                                                            child: Container(
                                                              margin: const EdgeInsets
                                                                      .fromLTRB(
                                                                  40,
                                                                  10,
                                                                  40,
                                                                  20),

                                                              // height: height_size - 360,
                                                              // width: width_size - 470,
                                                              height: 50,
                                                              //width: 260,
                                                              decoration:
                                                                  const BoxDecoration(
                                                                color: LightColor
                                                                    .appBlue,
                                                                borderRadius: BorderRadius.only(
                                                                    topRight:
                                                                        Radius.circular(
                                                                            20.0),
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            20.0),
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            20.0),
                                                                    bottomLeft:
                                                                        Radius.circular(
                                                                            20.0)),
                                                                // boxShadow: [
                                                                //   BoxShadow(
                                                                //     color:
                                                                //     Colors.black.withOpacity(0.4),
                                                                //     spreadRadius: 10,
                                                                //     blurRadius: 9,
                                                                //     offset: const Offset(0,
                                                                //         3), // changes position of shadow
                                                                //   ),
                                                                // ],
                                                              ),
                                                              child: Center(
                                                                child: Text(
                                                                  'Enter the zone',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      fontFamily:
                                                                          defaultFontFamily,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                  // FadeAnimation(
                                                  //     1.1,
                                                  //     Row(
                                                  //       mainAxisAlignment:
                                                  //       MainAxisAlignment
                                                  //           .center,
                                                  //       children: [
                                                  //         Text(
                                                  //           "Protecting Families, Enriching Lives",
                                                  //           textAlign:
                                                  //           TextAlign
                                                  //               .center,
                                                  //           style: TextStyle(
                                                  //             //fontFamily: defaultFontFamily,
                                                  //               color: Colors
                                                  //                   .white,
                                                  //               //Color.fromRGBO(113, 56, 208, 1.0),
                                                  //               fontWeight:
                                                  //               FontWeight
                                                  //                   .bold,
                                                  //               fontSize: 22),
                                                  //         ),
                                                  //       ],
                                                  //     )),
                                                ],
                                              ),
                                            )
                                          : Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: Colors
                                                        .white, // Set border color
                                                    width: 0.2),
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              margin: const EdgeInsets.fromLTRB(
                                                  40, 10, 40, 10),
                                              child: Column(
                                                children: [
                                                  // const SizedBox(
                                                  //   height: 20,
                                                  // ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Row(
                                                      children: [
                                                        IconButton(
                                                          icon: const Icon(
                                                              Icons
                                                                  .arrow_back_ios,
                                                              color:
                                                                  Colors.grey),
                                                          onPressed: () {
                                                            HapticFeedback
                                                                .vibrate();

                                                            setState(() {
                                                              _otpSent = false;
                                                              _timer.cancel();
                                                              _show = false;
                                                              _firstDigitOtp
                                                                  .clear();
                                                              _secondDigitOtp
                                                                  .clear();
                                                              _thirdDigitOtp
                                                                  .clear();
                                                              _fourthDigitOtp
                                                                  .clear();
                                                              _fifthDigitOtp
                                                                  .clear();
                                                              _sixthDigitOtp
                                                                  .clear();
                                                            });
                                                          },
                                                        ),
                                                        // Text(
                                                        //   "Back",
                                                        //   textAlign:
                                                        //   TextAlign.left,
                                                        //   style: TextStyle(
                                                        //       fontFamily:
                                                        //       defaultFontFamily,
                                                        //       color: Colors
                                                        //           .blueAccent,
                                                        //       fontWeight:
                                                        //       FontWeight
                                                        //           .normal,
                                                        //       fontSize: 18),
                                                        // ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  FadeAnimation(
                                                      1.1,
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                40, 0, 0, 0),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              "Mobile Verification",
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      defaultFontFamily,
                                                                  color: Colors
                                                                      .blueAccent,
                                                                  //Color.fromRGBO(113, 56, 208, 1.0),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  fontSize: 18),
                                                            ),
                                                          ],
                                                        ),
                                                      )),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  FadeAnimation(
                                                      1.1,
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                40, 0, 0, 0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              "Enter 06 Digit OTP",
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      defaultFontFamily,
                                                                  color: Colors
                                                                      .blueAccent,
                                                                  //Color.fromRGBO(113, 56, 208, 1.0),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  fontSize: 12),
                                                            ),
                                                            Spacer(),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .fromLTRB(
                                                                          0,
                                                                          0,
                                                                          40,
                                                                          0),
                                                              child: Text(
                                                                '$_start',
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style: TextStyle(
                                                                    fontFamily: defaultFontFamily,
                                                                    color: Colors.blueAccent,
                                                                    //Color.fromRGBO(113, 56, 208, 1.0),
                                                                    fontWeight: FontWeight.normal,
                                                                    fontSize: 12),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  FadeAnimation(
                                                    0.5,
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 35,
                                                        ),
                                                        OtpInput(_firstDigitOtp,
                                                            true),
                                                        OtpInput(
                                                            _secondDigitOtp,
                                                            false),
                                                        OtpInput(_thirdDigitOtp,
                                                            false),
                                                        OtpInput(
                                                            _fourthDigitOtp,
                                                            false),
                                                        OtpInput(_fifthDigitOtp,
                                                            false),
                                                        OtpInput(_sixthDigitOtp,
                                                            false),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  FadeAnimation(
                                                      1.1,
                                                      InkWell(
                                                        onTap: () {
                                                          if (_show) {
                                                            setState(() {
                                                              _show = false;
                                                              _timer.cancel();
                                                            });
                                                            HapticFeedback
                                                                .vibrate();
                                                            startTimer();
                                                            _resubmitPhoneNumber();
                                                          }
                                                        },
                                                        child: Padding(
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                                  0, 0, 0, 0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                _show
                                                                    ? "Resend Otp"
                                                                    : '',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        defaultFontFamily,
                                                                    color: Colors
                                                                        .blueAccent,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    fontSize:
                                                                        10),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )),
                                                  const SizedBox(
                                                    height: 40,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      _submitOTP(
                                                          verification_id);

                                                      // Navigator.of(context).push(
                                                      //     PageRouteBuilder(
                                                      //         pageBuilder: (context,
                                                      //             animation,
                                                      //             secondaryAnimation) {
                                                      //           return ZoneHomeScreen();
                                                      //         },
                                                      //         transitionDuration:
                                                      //             const Duration(
                                                      //                 milliseconds:
                                                      //                     500),
                                                      //         transitionsBuilder:
                                                      //             (context,
                                                      //                 animation,
                                                      //                 secondaryAnimation,
                                                      //                 child) {
                                                      //           return FadeTransition(
                                                      //             opacity:
                                                      //                 animation,
                                                      //             child: child,
                                                      //           );
                                                      //         }));
                                                    },
                                                    child: Container(
                                                      margin: const EdgeInsets
                                                              .fromLTRB(
                                                          50, 10, 50, 20),

                                                      // height: height_size - 360,
                                                      // width: width_size - 470,
                                                      height: 50,
                                                      //width: 260,
                                                      decoration:
                                                          const BoxDecoration(
                                                        color:
                                                            Colors.blueAccent,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topRight: Radius
                                                                    .circular(
                                                                        20.0),
                                                                bottomRight:
                                                                    Radius.circular(
                                                                        20.0),
                                                                topLeft: Radius
                                                                    .circular(
                                                                        20.0),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        20.0)),
                                                        // boxShadow: [
                                                        //   BoxShadow(
                                                        //     color:
                                                        //     Colors.black.withOpacity(0.4),
                                                        //     spreadRadius: 10,
                                                        //     blurRadius: 9,
                                                        //     offset: const Offset(0,
                                                        //         3), // changes position of shadow
                                                        //   ),
                                                        // ],
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          'Continue',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontFamily:
                                                                  defaultFontFamily,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   // SystemChrome.setPreferredOrientations([
  //   //   DeviceOrientation.landscapeLeft,
  //   //   DeviceOrientation.landscapeRight,
  //   // ]);
  //
  //   final double heightSize = MediaQuery.of(context).size.height;
  //   final double widthSize = MediaQuery.of(context).size.width;
  //   print(heightSize.toString() + " * " + widthSize.toString());
  //   String dropdownValue = 'One';
  //
  //   // final Animation<double> offsetAnimation =
  //   // Tween(begin: 0.0, end: 24.0).chain(CurveTween(curve: Curves.elasticIn)).animate(controller)
  //   //   ..addStatusListener((status) {
  //   //     if (status == AnimationStatus.completed) {
  //   //       controller.reverse();
  //   //     }
  //   //   });
  //   //
  //   // controller.forward(from: 0.0);
  //
  //   return Scaffold(
  //     backgroundColor: Colors.white,
  //     body: GestureDetector(
  //       onTap: () {
  //         this.controller.isCompleted
  //             ? this.controller.reverse()
  //             : this.controller.forward();
  //       },
  //       child: Stack(
  //         children: <Widget>[
  //           widthSize < 900
  //               ? SingleChildScrollView(
  //                   child: Container(
  //                     width: MediaQuery.of(context).size.width,
  //                     height: MediaQuery.of(context).size.height,
  //                     decoration: BoxDecoration(
  //                       image: widthSize < 500
  //                           ? const DecorationImage(
  //                               image:
  //                                   //AssetImage("assets/images/mobile_new.png"),
  //                                   AssetImage("assets/images/EX Mob Bag.png"),
  //                               fit: BoxFit.fill,
  //                             )
  //                           : const DecorationImage(
  //                               image:
  //                                   AssetImage("assets/images/Exz Tab Bag.png"),
  //                               fit: BoxFit.fill,
  //                             ),
  //                     ),
  //                     child: widthSize < 500
  //                         ? Column(
  //                             children: [
  //                               Padding(
  //                                 padding: EdgeInsets.fromLTRB(30, 50, 30, 0),
  //                                 child: Row(
  //                                   mainAxisAlignment: MainAxisAlignment.center,
  //                                   children: [
  //                                     Container(
  //                                       // height: 70,
  //                                       // width: 160,
  //                                       padding: const EdgeInsets.all(14),
  //                                       decoration: const BoxDecoration(
  //                                         color: Colors.white,
  //                                         borderRadius: BorderRadius.only(
  //                                             topRight: Radius.circular(15.0),
  //                                             bottomRight: Radius.circular(15.0),
  //                                             topLeft: Radius.circular(15.0),
  //                                             bottomLeft: Radius.circular(15.0)),
  //                                       ),
  //                                       child: Container(
  //                                         // height: 50,
  //                                         // width: 100,
  //                                         padding: const EdgeInsets.fromLTRB(60,15,60,15),
  //                                         decoration: const BoxDecoration(
  //                                           color: Colors.white,
  //                                           image: DecorationImage(
  //                                             image:
  //                                             AssetImage("assets/images/site-logo.png"),
  //                                             fit: BoxFit.contain,
  //                                           ),
  //                                         ),
  //                                         child: null,
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                               // Column(
  //                               //   crossAxisAlignment: CrossAxisAlignment.center,
  //                               //   mainAxisSize: MainAxisSize.max,
  //                               //   mainAxisAlignment: MainAxisAlignment.start,
  //                               //   children: [
  //                               //     const SizedBox(
  //                               //       height: 30,
  //                               //     ),
  //                               //     Container(
  //                               //       // height: 70,
  //                               //       // width: 160,
  //                               //       padding: const EdgeInsets.all(14),
  //                               //       decoration: const BoxDecoration(
  //                               //         color: Colors.white,
  //                               //         borderRadius: BorderRadius.only(
  //                               //             topRight: Radius.circular(15.0),
  //                               //             bottomRight: Radius.circular(15.0),
  //                               //             topLeft: Radius.circular(15.0),
  //                               //             bottomLeft: Radius.circular(15.0)),
  //                               //       ),
  //                               //       child: Container(
  //                               //         // height: 50,
  //                               //         // width: 100,
  //                               //         padding: const EdgeInsets.fromLTRB(50, 10,50,10),
  //                               //         decoration: const BoxDecoration(
  //                               //           color: Colors.white,
  //                               //           image: DecorationImage(
  //                               //             image:
  //                               //             AssetImage("assets/images/site-logo.png"),
  //                               //             fit: BoxFit.contain,
  //                               //           ),
  //                               //         ),
  //                               //         child: null,
  //                               //       ),
  //                               //     ),
  //                               //     // Container(
  //                               //     //   height: 70,
  //                               //     //   width: 160,
  //                               //     //   decoration: const BoxDecoration(
  //                               //     //     color: Colors.white,
  //                               //     //     borderRadius: BorderRadius.only(
  //                               //     //         topRight: Radius.circular(15.0),
  //                               //     //         bottomRight: Radius.circular(15.0),
  //                               //     //         topLeft: Radius.circular(15.0),
  //                               //     //         bottomLeft: Radius.circular(15.0)),
  //                               //     //   ),
  //                               //     //   child: Container(
  //                               //     //     height: 50,
  //                               //     //     width: 100,
  //                               //     //     margin: const EdgeInsets.all(12),
  //                               //     //     decoration: const BoxDecoration(
  //                               //     //       color: Colors.white,
  //                               //     //       image: DecorationImage(
  //                               //     //         image:
  //                               //     //         AssetImage("assets/images/site-logo.png"),
  //                               //     //         fit: BoxFit.contain,
  //                               //     //       ),
  //                               //     //     ),
  //                               //     //     child: null,
  //                               //     //   ),
  //                               //     // ),
  //                               //     const SizedBox(
  //                               //       height: 10,
  //                               //     ),
  //                               //
  //                               //   ],
  //                               // ),
  //                               Spacer(),
  //
  //                               Column(
  //                                 crossAxisAlignment: CrossAxisAlignment.center,
  //                                 mainAxisSize: MainAxisSize.max,
  //                                 mainAxisAlignment: MainAxisAlignment.end,
  //                                 children: [
  //                                   InkWell(
  //                                     onTap: () {
  //
  //                                       Navigator.of(context).push(
  //                                           PageRouteBuilder(
  //                                               pageBuilder: (context,
  //                                                   animation,
  //                                                   secondaryAnimation) {
  //                                                 return ZoneHomeScreen();
  //                                               },
  //                                               transitionDuration:
  //                                                   const Duration(
  //                                                       milliseconds: 500),
  //                                               transitionsBuilder: (context,
  //                                                   animation,
  //                                                   secondaryAnimation,
  //                                                   child) {
  //                                                 return FadeTransition(
  //                                                   opacity: animation,
  //                                                   child: child,
  //                                                 );
  //                                               }));
  //
  //                                       //   Navigator.of(context).push(CustomPageRoute(ZoneScreen()));
  //
  //                                       //   Navigator.of(context).push(_createRoute());
  //
  //                                       // Navigator.push(
  //                                       //   context,
  //                                       //   MaterialPageRoute(
  //                                       //       builder: (context) => ZoneScreen()),
  //                                       // );
  //                                     },
  //                                     child: Container(
  //                                       margin: const EdgeInsets.all(10),
  //                                       // height: height_size - 360,
  //                                       // width: width_size - 470,
  //                                       height: 60,
  //                                       width: 160,
  //                                       decoration: BoxDecoration(
  //                                         color: Colors.white,
  //                                         borderRadius: const BorderRadius.only(
  //                                             topRight: Radius.circular(20.0),
  //                                             bottomRight:
  //                                                 Radius.circular(20.0),
  //                                             topLeft: Radius.circular(20.0),
  //                                             bottomLeft:
  //                                                 Radius.circular(20.0)),
  //                                         boxShadow: [
  //                                           BoxShadow(
  //                                             color:
  //                                                 Colors.black.withOpacity(0.4),
  //                                             spreadRadius: 10,
  //                                             blurRadius: 9,
  //                                             offset: const Offset(0,
  //                                                 3), // changes position of shadow
  //                                           ),
  //                                         ],
  //                                       ),
  //                                       child: Center(
  //                                         child: Text(
  //                                           'Enter the zone',
  //                                           style: TextStyle(
  //                                               fontSize: 16,
  //                                               fontFamily: defaultFontFamily,
  //                                               fontWeight: FontWeight.bold,
  //                                               color:
  //                                                   Colors.blueAccent.shade400),
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                   const SizedBox(
  //                                     height: 120,
  //                                   ),
  //                                   Row(
  //                                     mainAxisAlignment:
  //                                         MainAxisAlignment.spaceBetween,
  //                                     children: [
  //                                       const SizedBox(
  //                                         width: 40,
  //                                       ),
  //
  //                                       // ShakeAnimatedWidget(
  //                                       //   enabled: true,
  //                                       //   duration: const Duration(milliseconds: 450),
  //                                       //   shakeAngle: Rotation.deg(z: 4),
  //                                       //   curve: Curves.linear,
  //                                       //   child: InkWell(
  //                                       //     onTap: () {
  //                                       //       Navigator.push(
  //                                       //         context,
  //                                       //         MaterialPageRoute(
  //                                       //             builder: (context) => const ChessGame()),
  //                                       //       );
  //                                       //     },
  //                                       //     child: Container(
  //                                       //       margin: const EdgeInsets.all(10),
  //                                       //       // height: height_size - 320,
  //                                       //       // width: width_size - 665,
  //                                       //
  //                                       //       height: 120,
  //                                       //       width: 100,
  //                                       //       decoration: const BoxDecoration(
  //                                       //         image: DecorationImage(
  //                                       //           image: AssetImage("assets/games/Chesss.png"),
  //                                       //           fit: BoxFit.fill,
  //                                       //         ),
  //                                       //       ),
  //                                       //     ),
  //                                       //   ),
  //                                       // ),
  //
  //                                       // ShakeAnimatedWidget(
  //                                       //   enabled: true,
  //                                       //   duration: Duration(milliseconds: 450),
  //                                       //   shakeAngle: Rotation.deg(z: 4),
  //                                       //   curve: Curves.linear,
  //                                       //   child: InkWell(
  //                                       //     onTap: () {
  //                                       //       Navigator.push(
  //                                       //         context,
  //                                       //         MaterialPageRoute(
  //                                       //             // builder: (context) => ChessGame()),
  //                                       //             builder: (context) => SplashScrenn()),
  //                                       //       );
  //                                       //     },
  //                                       //     child: Container(
  //                                       //       margin: const EdgeInsets.all(10),
  //                                       //       height: 80,
  //                                       //       width: 65,
  //                                       //       decoration: const BoxDecoration(
  //                                       //         image: DecorationImage(
  //                                       //           image: AssetImage(
  //                                       //               "assets/games/Covi KIll.png"),
  //                                       //           fit: BoxFit.fill,
  //                                       //         ),
  //                                       //       ),
  //                                       //     ),
  //                                       //   ),
  //                                       // ),
  //
  //                                       ShakeAnimatedWidget(
  //                                         enabled: true,
  //                                         duration: Duration(milliseconds: 450),
  //                                         shakeAngle: Rotation.deg(z: 4),
  //                                         curve: Curves.linear,
  //                                         child: InkWell(
  //                                           onTap: () {
  //                                             Navigator.push(
  //                                               context,
  //                                               MaterialPageRoute(
  //                                                   // builder: (context) => ChessGame()),
  //                                                   builder: (context) =>
  //                                                       const FunFacts_Screen()),
  //                                             );
  //                                           },
  //                                           child: Container(
  //                                             margin: const EdgeInsets.all(10),
  //                                             height: 80,
  //                                             width: 65,
  //                                             decoration: const BoxDecoration(
  //                                               image: DecorationImage(
  //                                                 image: AssetImage(
  //                                                     "assets/games/Fun Facts.png"),
  //                                                 fit: BoxFit.fill,
  //                                               ),
  //                                             ),
  //                                           ),
  //                                         ),
  //                                       ),
  //
  //                                       ShakeAnimatedWidget(
  //                                         enabled: true,
  //                                         duration: Duration(milliseconds: 450),
  //                                         shakeAngle: Rotation.deg(z: 4),
  //                                         curve: Curves.linear,
  //                                         child: InkWell(
  //                                           onTap: () {
  //                                             Navigator.push(
  //                                               context,
  //                                               MaterialPageRoute(
  //                                                   // builder: (context) => ChessGame()),
  //                                                   builder: (context) =>
  //                                                       const Quiz_Screen()),
  //                                             );
  //                                           },
  //                                           child: Container(
  //                                             margin: const EdgeInsets.all(10),
  //                                             height: 80,
  //                                             width: 65,
  //                                             decoration: const BoxDecoration(
  //                                               image: DecorationImage(
  //                                                 image: AssetImage(
  //                                                     "assets/games/Quiz Time Old.png"),
  //                                                 fit: BoxFit.fill,
  //                                               ),
  //                                             ),
  //                                           ),
  //                                         ),
  //                                       ),
  //
  //                                       const SizedBox(
  //                                         width: 40,
  //                                       ),
  //                                     ],
  //                                   ),
  //                                   const SizedBox(
  //                                     height: 100,
  //                                   ),
  //                                 ],
  //                               )
  //                             ],
  //                           )
  //                         : Column(
  //                       children: [
  //
  //                         Padding(
  //                           padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
  //                           child: Row(
  //                             mainAxisAlignment: MainAxisAlignment.start,
  //                             children: [
  //                               Container(
  //                                 // height: 70,
  //                                 // width: 160,
  //                                 padding: const EdgeInsets.all(14),
  //                                 decoration: const BoxDecoration(
  //                                   color: Colors.white,
  //                                   borderRadius: BorderRadius.only(
  //                                       topRight: Radius.circular(15.0),
  //                                       bottomRight: Radius.circular(15.0),
  //                                       topLeft: Radius.circular(15.0),
  //                                       bottomLeft: Radius.circular(15.0)),
  //                                 ),
  //                                 child: Container(
  //                                   // height: 50,
  //                                   // width: 100,
  //                                   padding: const EdgeInsets.fromLTRB(60,20,60,20),
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
  //                             ],
  //                           ),
  //                         ),
  //
  //                         Spacer(),
  //
  //                         Column(
  //                           crossAxisAlignment: CrossAxisAlignment.center,
  //                           mainAxisSize: MainAxisSize.max,
  //                           mainAxisAlignment: MainAxisAlignment.end,
  //                           children: [
  //                             InkWell(
  //                               onTap: () {
  //
  //                                 Navigator.of(context).push(
  //                                     PageRouteBuilder(
  //                                         pageBuilder: (context,
  //                                             animation,
  //                                             secondaryAnimation) {
  //                                           return ZoneHomeScreen();
  //                                         },
  //                                         transitionDuration:
  //                                         const Duration(
  //                                             milliseconds: 500),
  //                                         transitionsBuilder: (context,
  //                                             animation,
  //                                             secondaryAnimation,
  //                                             child) {
  //                                           return FadeTransition(
  //                                             opacity: animation,
  //                                             child: child,
  //                                           );
  //                                         }));
  //
  //                                 //   Navigator.of(context).push(CustomPageRoute(ZoneScreen()));
  //
  //                                 //   Navigator.of(context).push(_createRoute());
  //
  //                                 // Navigator.push(
  //                                 //   context,
  //                                 //   MaterialPageRoute(
  //                                 //       builder: (context) => ZoneScreen()),
  //                                 // );
  //                               },
  //                               child: Container(
  //                                 margin: const EdgeInsets.all(10),
  //                                 // height: height_size - 360,
  //                                 // width: width_size - 470,
  //                                 height: 60,
  //                                 width: 160,
  //                                 decoration: BoxDecoration(
  //                                   color: Colors.white,
  //                                   borderRadius: const BorderRadius.only(
  //                                       topRight: Radius.circular(20.0),
  //                                       bottomRight:
  //                                       Radius.circular(20.0),
  //                                       topLeft: Radius.circular(20.0),
  //                                       bottomLeft:
  //                                       Radius.circular(20.0)),
  //                                   boxShadow: [
  //                                     BoxShadow(
  //                                       color:
  //                                       Colors.black.withOpacity(0.4),
  //                                       spreadRadius: 10,
  //                                       blurRadius: 9,
  //                                       offset: const Offset(0,
  //                                           3), // changes position of shadow
  //                                     ),
  //                                   ],
  //                                 ),
  //                                 child: Center(
  //                                   child: Text(
  //                                     'Enter the zone',
  //                                     style: TextStyle(
  //                                         fontSize: 16,
  //                                         fontFamily: defaultFontFamily,
  //                                         fontWeight: FontWeight.bold,
  //                                         color:
  //                                         Colors.blueAccent.shade400),
  //                                   ),
  //                                 ),
  //                               ),
  //                             ),
  //                             const SizedBox(
  //                               height: 20,
  //                             ),
  //                             Row(
  //                               mainAxisAlignment:
  //                               MainAxisAlignment.spaceBetween,
  //                               children: [
  //                                 const SizedBox(
  //                                   width: 40,
  //                                 ),
  //
  //                                 // ShakeAnimatedWidget(
  //                                 //   enabled: true,
  //                                 //   duration: const Duration(milliseconds: 450),
  //                                 //   shakeAngle: Rotation.deg(z: 4),
  //                                 //   curve: Curves.linear,
  //                                 //   child: InkWell(
  //                                 //     onTap: () {
  //                                 //       Navigator.push(
  //                                 //         context,
  //                                 //         MaterialPageRoute(
  //                                 //             builder: (context) => const ChessGame()),
  //                                 //       );
  //                                 //     },
  //                                 //     child: Container(
  //                                 //       margin: const EdgeInsets.all(10),
  //                                 //       // height: height_size - 320,
  //                                 //       // width: width_size - 665,
  //                                 //
  //                                 //       height: 120,
  //                                 //       width: 100,
  //                                 //       decoration: const BoxDecoration(
  //                                 //         image: DecorationImage(
  //                                 //           image: AssetImage("assets/games/Chesss.png"),
  //                                 //           fit: BoxFit.fill,
  //                                 //         ),
  //                                 //       ),
  //                                 //     ),
  //                                 //   ),
  //                                 // ),
  //
  //                                 // ShakeAnimatedWidget(
  //                                 //   enabled: true,
  //                                 //   duration: Duration(milliseconds: 450),
  //                                 //   shakeAngle: Rotation.deg(z: 4),
  //                                 //   curve: Curves.linear,
  //                                 //   child: InkWell(
  //                                 //     onTap: () {
  //                                 //       Navigator.push(
  //                                 //         context,
  //                                 //         MaterialPageRoute(
  //                                 //             // builder: (context) => ChessGame()),
  //                                 //             builder: (context) => SplashScrenn()),
  //                                 //       );
  //                                 //     },
  //                                 //     child: Container(
  //                                 //       margin: const EdgeInsets.all(10),
  //                                 //       height: 80,
  //                                 //       width: 65,
  //                                 //       decoration: const BoxDecoration(
  //                                 //         image: DecorationImage(
  //                                 //           image: AssetImage(
  //                                 //               "assets/games/Covi KIll.png"),
  //                                 //           fit: BoxFit.fill,
  //                                 //         ),
  //                                 //       ),
  //                                 //     ),
  //                                 //   ),
  //                                 // ),
  //
  //                                 ShakeAnimatedWidget(
  //                                   enabled: true,
  //                                   duration: Duration(milliseconds: 450),
  //                                   shakeAngle: Rotation.deg(z: 4),
  //                                   curve: Curves.linear,
  //                                   child: InkWell(
  //                                     onTap: () {
  //                                       Navigator.push(
  //                                         context,
  //                                         MaterialPageRoute(
  //                                           // builder: (context) => ChessGame()),
  //                                             builder: (context) =>
  //                                             const FunFacts_Screen()),
  //                                       );
  //                                     },
  //                                     child: Container(
  //                                       margin: const EdgeInsets.all(10),
  //                                       height: 80,
  //                                       width: 65,
  //                                       decoration: const BoxDecoration(
  //                                         image: DecorationImage(
  //                                           image: AssetImage(
  //                                               "assets/games/Fun Facts.png"),
  //                                           fit: BoxFit.fill,
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ),
  //
  //                                 ShakeAnimatedWidget(
  //                                   enabled: true,
  //                                   duration: Duration(milliseconds: 450),
  //                                   shakeAngle: Rotation.deg(z: 4),
  //                                   curve: Curves.linear,
  //                                   child: InkWell(
  //                                     onTap: () {
  //                                       Navigator.push(
  //                                         context,
  //                                         MaterialPageRoute(
  //                                           // builder: (context) => ChessGame()),
  //                                             builder: (context) =>
  //                                             const Quiz_Screen()),
  //                                       );
  //                                     },
  //                                     child: Container(
  //                                       margin: const EdgeInsets.all(10),
  //                                       height: 80,
  //                                       width: 65,
  //                                       decoration: const BoxDecoration(
  //                                         image: DecorationImage(
  //                                           image: AssetImage(
  //                                               "assets/games/Quiz Time Old.png"),
  //                                           fit: BoxFit.fill,
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ),
  //
  //                                 const SizedBox(
  //                                   width: 40,
  //                                 ),
  //                               ],
  //                             ),
  //                             const SizedBox(
  //                               height: 10,
  //                             ),
  //                           ],
  //                         )
  //                       ],
  //                     ),
  //                   ),
  //                 )
  //               : SingleChildScrollView(
  //                   child: Container(
  //                     width: MediaQuery.of(context).size.width,
  //                     height: MediaQuery.of(context).size.height,
  //                     decoration: const BoxDecoration(
  //                       image: DecorationImage(
  //                         //image: AssetImage("assets/images/new.png"),
  //                         image: AssetImage("assets/images/Exz Tab Bag.png"),
  //                         fit: BoxFit.fill,
  //                       ),
  //                     ),
  //                     child: Column(
  //                       children: [
  //                         Padding(
  //                           padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
  //                           child: Row(
  //                             mainAxisAlignment: MainAxisAlignment.start,
  //                             children: [
  //                               Container(
  //                                 // height: 70,
  //                                 // width: 160,
  //                                 padding: const EdgeInsets.all(14),
  //                                 decoration: const BoxDecoration(
  //                                   color: Colors.white,
  //                                   borderRadius: BorderRadius.only(
  //                                       topRight: Radius.circular(15.0),
  //                                       bottomRight: Radius.circular(15.0),
  //                                       topLeft: Radius.circular(15.0),
  //                                       bottomLeft: Radius.circular(15.0)),
  //                                 ),
  //                                 child: Container(
  //                                   // height: 50,
  //                                   // width: 100,
  //                                   padding: const EdgeInsets.fromLTRB(60,15,60,15),
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
  //                             ],
  //                           ),
  //                         ),
  //                         Spacer(),
  //                         Column(
  //                           crossAxisAlignment: CrossAxisAlignment.center,
  //                           mainAxisSize: MainAxisSize.max,
  //                           mainAxisAlignment: MainAxisAlignment.end,
  //                           children: [
  //                             InkWell(
  //                               onTap: () {
  //                                 // SlideTransition(
  //                                 //   position: _offsetAnimation,
  //                                 //   child: const Padding(
  //                                 //     padding: EdgeInsets.all(8.0),
  //                                 //     child: FlutterLogo(size: 150.0),
  //                                 //   ),
  //                                 // );
  //
  //                                 Navigator.of(context).push(PageRouteBuilder(
  //                                     pageBuilder:
  //                                         (context, animation, secondaryAnimation) {
  //                                       return ZoneHomeScreen();
  //                                     },
  //                                     transitionDuration:
  //                                     const Duration(milliseconds: 500),
  //                                     transitionsBuilder: (context, animation,
  //                                         secondaryAnimation, child) {
  //                                       return FadeTransition(
  //                                         opacity: animation,
  //                                         child: child,
  //                                       );
  //                                     }));
  //
  //                                 //   Navigator.of(context).push(CustomPageRoute(ZoneScreen()));
  //
  //                                 //   Navigator.of(context).push(_createRoute());
  //
  //                                 // Navigator.push(
  //                                 //   context,
  //                                 //   MaterialPageRoute(
  //                                 //       builder: (context) => ZoneScreen()),
  //                                 // );
  //                               },
  //                               child: Container(
  //                                 margin: const EdgeInsets.all(10),
  //                                 // height: height_size - 360,
  //                                 // width: width_size - 470,
  //                                 height: 70,
  //                                 width: 240,
  //                                 decoration: BoxDecoration(
  //                                   color: Colors.white,
  //                                   borderRadius: const BorderRadius.only(
  //                                       topRight: Radius.circular(20.0),
  //                                       bottomRight: Radius.circular(20.0),
  //                                       topLeft: Radius.circular(20.0),
  //                                       bottomLeft: Radius.circular(20.0)),
  //                                   boxShadow: [
  //                                     BoxShadow(
  //                                       color: Colors.black.withOpacity(0.4),
  //                                       spreadRadius: 10,
  //                                       blurRadius: 9,
  //                                       offset: const Offset(
  //                                           0, 3), // changes position of shadow
  //                                     ),
  //                                   ],
  //                                 ),
  //                                 child: Center(
  //                                   child: Text(
  //                                     'Enter the zone',
  //                                     style: TextStyle(
  //                                         fontSize: 20,
  //                                         fontFamily: defaultFontFamily,
  //                                         fontWeight: FontWeight.bold,
  //                                         color: Colors.blueAccent.shade400),
  //                                   ),
  //                                 ),
  //                               ),
  //                             ),
  //                             const SizedBox(
  //                               height: 40,
  //                             ),
  //                             Row(
  //                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                               children: [
  //                                 const SizedBox(
  //                                   width: 40,
  //                                 ),
  //
  //                                 // ShakeAnimatedWidget(
  //                                 //   enabled: true,
  //                                 //   duration: const Duration(milliseconds: 450),
  //                                 //   shakeAngle: Rotation.deg(z: 4),
  //                                 //   curve: Curves.linear,
  //                                 //   child: InkWell(
  //                                 //     onTap: () {
  //                                 //       Navigator.push(
  //                                 //         context,
  //                                 //         MaterialPageRoute(
  //                                 //             builder: (context) => const ChessGame()),
  //                                 //       );
  //                                 //     },
  //                                 //     child: Container(
  //                                 //       margin: const EdgeInsets.all(10),
  //                                 //       // height: height_size - 320,
  //                                 //       // width: width_size - 665,
  //                                 //
  //                                 //       height: 120,
  //                                 //       width: 100,
  //                                 //       decoration: const BoxDecoration(
  //                                 //         image: DecorationImage(
  //                                 //           image: AssetImage("assets/games/Chesss.png"),
  //                                 //           fit: BoxFit.fill,
  //                                 //         ),
  //                                 //       ),
  //                                 //     ),
  //                                 //   ),
  //                                 // ),
  //
  //                                 // ShakeAnimatedWidget(
  //                                 //   enabled: true,
  //                                 //   duration: Duration(milliseconds: 450),
  //                                 //   shakeAngle: Rotation.deg(z: 4),
  //                                 //   curve: Curves.linear,
  //                                 //   child: InkWell(
  //                                 //     onTap: () {
  //                                 //       Navigator.push(
  //                                 //         context,
  //                                 //         MaterialPageRoute(
  //                                 //             // builder: (context) => ChessGame()),
  //                                 //             builder: (context) => SplashScrenn()),
  //                                 //       );
  //                                 //     },
  //                                 //     child: Container(
  //                                 //       margin: const EdgeInsets.all(10),
  //                                 //       height: 100,
  //                                 //       width: 80,
  //                                 //       decoration: const BoxDecoration(
  //                                 //         image: DecorationImage(
  //                                 //           image: AssetImage(
  //                                 //               "assets/games/Covi KIll.png"),
  //                                 //           fit: BoxFit.fill,
  //                                 //         ),
  //                                 //       ),
  //                                 //     ),
  //                                 //   ),
  //                                 // ),
  //
  //                                 ShakeAnimatedWidget(
  //                                   enabled: true,
  //                                   duration: Duration(milliseconds: 450),
  //                                   shakeAngle: Rotation.deg(z: 4),
  //                                   curve: Curves.linear,
  //                                   child: InkWell(
  //                                     onTap: () {
  //                                       Navigator.push(
  //                                         context,
  //                                         MaterialPageRoute(
  //                                           // builder: (context) => ChessGame()),
  //                                             builder: (context) =>
  //                                             const FunFacts_Screen()),
  //                                       );
  //                                     },
  //                                     child: Container(
  //                                       margin: const EdgeInsets.all(10),
  //                                       height: 100,
  //                                       width: 80,
  //                                       decoration: const BoxDecoration(
  //                                         image: DecorationImage(
  //                                           image: AssetImage(
  //                                               "assets/games/Fun Facts.png"),
  //                                           fit: BoxFit.fill,
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ),
  //
  //                                 ShakeAnimatedWidget(
  //                                   enabled: true,
  //                                   duration: Duration(milliseconds: 450),
  //                                   shakeAngle: Rotation.deg(z: 4),
  //                                   curve: Curves.linear,
  //                                   child: InkWell(
  //                                     onTap: () {
  //                                       Navigator.push(
  //                                         context,
  //                                         MaterialPageRoute(
  //                                           // builder: (context) => ChessGame()),
  //                                             builder: (context) =>
  //                                             const Quiz_Screen()),
  //                                       );
  //                                     },
  //                                     child: Container(
  //                                       margin: const EdgeInsets.all(10),
  //                                       height: 100,
  //                                       width: 80,
  //                                       decoration: const BoxDecoration(
  //                                         image: DecorationImage(
  //                                           image: AssetImage(
  //                                               "assets/games/Quiz Time Old.png"),
  //                                           fit: BoxFit.fill,
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ),
  //
  //                                 const SizedBox(
  //                                   width: 40,
  //                                 ),
  //                               ],
  //                             ),
  //                             const SizedBox(
  //                               height: 20,
  //                             ),
  //                           ],
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Future<void> clear() async {
    var prefs = await SharedPreferences.getInstance();

    prefs.remove('0answerA');
    prefs.remove('0answerB');
    prefs.remove('0answerC');
    prefs.remove('0answerD');

    prefs.remove('1answerA');
    prefs.remove('1answerB');
    prefs.remove('1answerC');
    prefs.remove('1answerD');

    prefs.remove('2answerA');
    prefs.remove('2answerB');
    prefs.remove('2answerC');
    prefs.remove('2answerD');

    prefs.remove('3answerA');
    prefs.remove('3answerB');
    prefs.remove('3answerC');
    prefs.remove('3answerD');

    prefs.remove('4answerA');
    prefs.remove('4answerB');
    prefs.remove('4answerC');
    prefs.remove('4answerD');

    prefs.remove('5answerA');
    prefs.remove('5answerB');
    prefs.remove('5answerC');
    prefs.remove('5answerD');

    prefs.remove('6answerA');
    prefs.remove('6answerB');
    prefs.remove('6answerC');
    prefs.remove('6answerD');

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

    prefs.remove('10answerA');
    prefs.remove('10answerB');
    prefs.remove('10answerC');
    prefs.remove('10answerD');

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

  Future<void> _submitPhoneNumber() async {
    String phoneNumber;

    if (_phoneController.text.length < 10 ||
        _phoneController.text.length > 10 ||
        _phoneController.text.isEmpty ||
        _phoneController.text == "") {
      showSnackBar("Enter Correct Phone Number");
    } else {

      phoneNumber = "+91 " + _phoneController.text.toString().trim();
      print(defaultTargetPlatform);
      if (TargetPlatform.android == defaultTargetPlatform ||
          TargetPlatform.iOS == defaultTargetPlatform) {
        try {
          final result = await InternetAddress.lookup('example.com');
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            await FirebaseAuth.instance.verifyPhoneNumber(
              phoneNumber: phoneNumber,
              timeout: const Duration(seconds: 120),
              verificationFailed: (Exception error) {
                print(error);

                showSnackBar("Something went wrong, please try again.");
              },
              codeSent: (String verificationId, int? resendToken) async {
                showSnackBar("OTP sent!");
                startTimer();

                setState(() {
                  _otpSent = true;
                  verification_id = verificationId;
                });
              },
              verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {
                showSnackBar("Verified.");
              },
              codeAutoRetrievalTimeout: (String verificationId) {
                showSnackBar("Timeout!");
              },
            );
            print('connected');
          }
        } on SocketException catch (_) {
          showSnackBar("Your internet connection is not working.");
        }
      } else {
        try {
          // final result = await InternetAddress.lookup('example.com');
          // if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          FirebaseAuth auth = FirebaseAuth.instance;
          ConfirmationResult confirmationResult =
              await auth.signInWithPhoneNumber(
            phoneNumber,
                RecaptchaVerifier(
                  onSuccess: () => {
                    print('reCAPTCHA Completed!'),
                    showSnackBar("OTP sent!"),
                    setState(() {
                      _otpSent = true;
                    }),
                  },
                  onError: (FirebaseAuthException error) => print(error),
                  onExpired: () => print('reCAPTCHA Expired!'),
                ),
            // RecaptchaVerifier(
            //   onSuccess: () => print('reCAPTCHA Completed!'),
            //   onError: (FirebaseAuthException error) => print(error),
            //   onExpired: () => print('reCAPTCHA Expired!'),
            // ),
          );

          setState(() {
            NewConfirmationResult = confirmationResult;
            verification_id = confirmationResult.verificationId.toString();
          });

          startTimer();
          print('connected');

        } on SocketException catch (_) {
          showSnackBar("Your internet connection is not working.");
        }
      }

    }
  }

  Future<void> _resubmitPhoneNumber() async {
    String phoneNumber;

    if (_phoneController.text.length < 10 ||
        _phoneController.text.length > 10 ||
        _phoneController.text.isEmpty ||
        _phoneController.text == "") {
      showSnackBar("Enter Correct Phone Number");
    } else {
      phoneNumber = "+91 " + _phoneController.text.toString().trim();

      print(defaultTargetPlatform);
      if (TargetPlatform.android == defaultTargetPlatform ||
          TargetPlatform.iOS == defaultTargetPlatform) {
        try {
          final result = await InternetAddress.lookup('example.com');
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            await FirebaseAuth.instance.verifyPhoneNumber(
              phoneNumber: phoneNumber,
              timeout: const Duration(seconds: 120),
              verificationFailed: (Exception error) {
                print(error);

                showSnackBar("Something went wrong, please try again.");
              },
              codeSent: (String verificationId, int? resendToken) async {
                showSnackBar("OTP sent!");

                setState(() {
                  _otpSent = true;
                  verification_id = verificationId;
                });

                // // Update the UI - wait for the user to enter the SMS code
                //
                // if (_firstDigitOtp.text.trim() == '') {
                //   showSnackBar("Enter First Digit Of OTP");
                // } else if (_secondDigitOtp.text.trim() == "") {
                //   showSnackBar("Enter Second Digit Of OTP");
                // } else if (_thirdDigitOtp.text.trim() == "") {
                //   showSnackBar("Enter Third Digit Of OTP");
                // } else if (_fourthDigitOtp.text.trim() == "") {
                //   showSnackBar("Enter Fourth Digit Of OTP");
                // } else if (_fifthDigitOtp.text.trim() == "") {
                //   showSnackBar("Enter Fifth Digit Of OTP");
                // } else if (_sixthDigitOtp.text.trim() == "") {
                //   showSnackBar("Enter Sixth Digit Of OTP");
                // } else {
                //   smsCode = _firstDigitOtp.text +
                //       _secondDigitOtp.text +
                //       _thirdDigitOtp.text +
                //       _fourthDigitOtp.text +
                //       _fifthDigitOtp.text +
                //       _sixthDigitOtp.text;
                //
                //   // Create a PhoneAuthCredential with the code
                //   PhoneAuthCredential credential = PhoneAuthProvider.credential(
                //       verificationId: verificationId, smsCode: smsCode);
                //
                //   // Sign the user in (or link) with the credential
                //   await FirebaseAuth.instance
                //       .signInWithCredential(credential)
                //       .then((UserCredential authRes) {
                //     if (authRes.credential != null) {
                //       print("Verified");
                //       print(authRes.user);
                //     }
                //   }).catchError((e) => {
                //             print(e),
                //           });
                // }
              },
              verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {
                showSnackBar("Verified.");
              },
              codeAutoRetrievalTimeout: (String verificationId) {
                showSnackBar("Timeout!");
              },
            );
            print('connected');
          }
        } on SocketException catch (_) {
          showSnackBar("Your internet connection is not working.");
        }
      } else {
        FirebaseAuth auth = FirebaseAuth.instance;

        ConfirmationResult confirmationResult =
            await auth.signInWithPhoneNumber(
          phoneNumber,
          RecaptchaVerifier(
            onSuccess: () => {
              print('reCAPTCHA Completed!'),
              showSnackBar("OTP sent!"),
            setState(() {
            _otpSent = true;
            }),
            },
            onError: (FirebaseAuthException error) => print(error),
            onExpired: () => print('reCAPTCHA Expired!'),
          ),
        );

        setState(() {
          NewConfirmationResult = confirmationResult;
        });

        startTimer();

        // if (_firstDigitOtp.text.trim() == '') {
        //   showSnackBar("Enter First Digit Of OTP");
        // } else if (_secondDigitOtp.text.trim() == "") {
        //   showSnackBar("Enter Second Digit Of OTP");
        // } else if (_thirdDigitOtp.text.trim() == "") {
        //   showSnackBar("Enter Third Digit Of OTP");
        // } else if (_fourthDigitOtp.text.trim() == "") {
        //   showSnackBar("Enter Fourth Digit Of OTP");
        // } else if (_fifthDigitOtp.text.trim() == "") {
        //   showSnackBar("Enter Fifth Digit Of OTP");
        // } else if (_sixthDigitOtp.text.trim() == "") {
        //   showSnackBar("Enter Sixth Digit Of OTP");
        // } else {
        //   smsCode = _firstDigitOtp.text +
        //       _secondDigitOtp.text +
        //       _thirdDigitOtp.text +
        //       _fourthDigitOtp.text +
        //       _fifthDigitOtp.text +
        //       _sixthDigitOtp.text;
        //
        //   UserCredential userCredential =
        //       await confirmationResult.confirm(smsCode);
        //   if (userCredential.credential != null) {
        //     print("Verified");
        //   }
        // }

      }
    }
  }

  Future<void> _submitOTP(verificationId) async {
    String smsCode;
    print(defaultTargetPlatform);

    if (TargetPlatform.android == defaultTargetPlatform ||
        TargetPlatform.iOS == defaultTargetPlatform) {
      if (_firstDigitOtp.text.trim() == '') {
        showSnackBar("Enter First Digit Of OTP");
      } else if (_secondDigitOtp.text.trim() == "") {
        showSnackBar("Enter Second Digit Of OTP");
      } else if (_thirdDigitOtp.text.trim() == "") {
        showSnackBar("Enter Third Digit Of OTP");
      } else if (_fourthDigitOtp.text.trim() == "") {
        showSnackBar("Enter Fourth Digit Of OTP");
      } else if (_fifthDigitOtp.text.trim() == "") {
        showSnackBar("Enter Fifth Digit Of OTP");
      } else if (_sixthDigitOtp.text.trim() == "") {
        showSnackBar("Enter Sixth Digit Of OTP");
      } else {
        showProgressSnackBar("Logging you in");
        smsCode = _firstDigitOtp.text +
            _secondDigitOtp.text +
            _thirdDigitOtp.text +
            _fourthDigitOtp.text +
            _fifthDigitOtp.text +
            _sixthDigitOtp.text;

        PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: verification_id, smsCode: smsCode);
        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((UserCredential authRes) {
          if (authRes.user != null) {
            String? id = authRes.user?.uid;
            String? name = _nameController.text.toString();
            Map<String, String> _userMap = {
              'Name': _nameController.text.toString(),
              'Number': _phoneController.text.toString(),
            };

            FirebaseDatabase.instance
                .reference()
                .child('SUDCustomer/Customers/' +
                    name +
                    "-" +
                    id.toString() +
                    "/" +
                    DateTime.now().millisecondsSinceEpoch.toString())
                .set(_userMap)
                .then(
                  (value) => setState(() {}),
                );

            print("Verified");
            print(authRes.user);
            Navigator.of(context).pop();
            Navigator.of(context).push(PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) {
                  return ZoneHomeScreen();
                },
                transitionDuration: const Duration(milliseconds: 500),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                }));
          } else {
            showSnackBar("Enter Correct OTP");
          }
        }).catchError((e) => {
                  showSnackBar("Enter Correct OTP"),
                  print(e),
                });
      }
    } else {
      if (_firstDigitOtp.text.trim() == '') {
        showSnackBar("Enter First Digit Of OTP");
      }
      else if (_secondDigitOtp.text.trim() == "") {
        showSnackBar("Enter Second Digit Of OTP");
      }
      else if (_thirdDigitOtp.text.trim() == "") {
        showSnackBar("Enter Third Digit Of OTP");
      }
      else if (_fourthDigitOtp.text.trim() == "") {
        showSnackBar("Enter Fourth Digit Of OTP");
      }
      else if (_fifthDigitOtp.text.trim() == "") {
        showSnackBar("Enter Fifth Digit Of OTP");
      }
      else if (_sixthDigitOtp.text.trim() == "") {
        showSnackBar("Enter Sixth Digit Of OTP");
      }
      else {
        smsCode = _firstDigitOtp.text +
            _secondDigitOtp.text +
            _thirdDigitOtp.text +
            _fourthDigitOtp.text +
            _fifthDigitOtp.text +
            _sixthDigitOtp.text;

        UserCredential userCredential =
            await NewConfirmationResult.confirm(smsCode);

        if (userCredential.user != null) {
          String? id = userCredential.user?.uid;
          String? name = _nameController.text.toString();
          Map<String, String> _userMap = {
            'Name': _nameController.text.toString(),
            'Number': _phoneController.text.toString(),
          };

          FirebaseDatabase.instance
              .reference()
              .child('SUDCustomer/Customers/' +
                  name +
                  "-" +
                  id.toString() +
                  "/" +
                  DateTime.now().millisecondsSinceEpoch.toString())
              .set(_userMap)
              .then(
                (value) => setState(() {}),
              );

          print("Verified");
          Navigator.of(context).pop();

          Navigator.of(context).push(PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
                return ZoneHomeScreen();
              },
              transitionDuration: const Duration(milliseconds: 500),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              }));
        } else {
          showSnackBar("Please Enter Correct OTP");
        }
      }
    }
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => ZoneHomeScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        // var tween = Tween<Offset>(
        // begin: Offset.zero,
        // end: const Offset(1.5, 0.0),
        // ).animate(CurvedAnimation(
        // parent: _controller,
        // curve: Curves.elasticIn,
        // ));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );

        // return ScaleTransition(
        //     scale: _animation,
        //   child: child
        // );

        // return SlideTransition(
        //
        //   position:  tween,
        //   child: child
        // );
      },
    );
  }

  @override
  void dispose() {
    if (_timer.isActive) {
      _timer.cancel();
      print("Banner Timer Canceled in Dispose() ");
    } else {
      print("Banner Timer Not Canceled in Dispose() ");
    }
    _controller.dispose();
    controller.dispose();
    super.dispose();
  }

  Future showProgressSnackBar(String error) async {
    HapticFeedback.vibrate();
    final snackBar = SnackBar(
      duration: const Duration(seconds: 2),
      backgroundColor: LightColor.appBlue,
      content: Container(
        height: 30,
        child: Row(
          children: [
            Text(
              "Logging you in",
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            Spacer(),
            Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.transparent,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: 60,
            ),
          ],
        ),
      ),
      // action: SnackBarAction(
      //   textColor: Colors.white,
      //   label: 'Okay',
      //   onPressed: () {
      //     // Some code to undo the change.
      //   },
      // ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar).closed.then((value)
    {
      ScaffoldMessenger.of(context).clearSnackBars();
    });
  }

  Future showSnackBar(String error) async {
    HapticFeedback.vibrate();
    final snackBar = SnackBar(
      duration: const Duration(seconds: 2),
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
    ScaffoldMessenger.of(context).showSnackBar(snackBar).closed.then((value)
    {
      ScaffoldMessenger.of(context).clearSnackBars();
    });

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

  void _handleLoad(String value) {
    setState(() {
      _stackToView = 0;
    });
  }

  Future<bool> hasNetwork() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }
}

class OtpInput extends StatelessWidget {
  final TextEditingController controller;
  final bool autoFocus;
  const OtpInput(this.controller, this.autoFocus, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 53,
      width: 40,
      margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
            color: (Colors.grey[800])!, // Set border color
            width: 0.2),
        // gradient: const LinearGradient(
        //   // begin: Alignment.centerLeft,
        //   // end: Alignment.centerRight,
        //   colors: <Color>[
        //     Color.fromRGBO(
        //         255, 241, 255, 1.0),
        //     Color.fromRGBO(
        //         243, 231, 255, 1.0),
        //   ],
        // ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 19,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: TextField(
        autofocus: autoFocus,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        controller: controller,
        minLines: 1,
        maxLength: 1,
        cursorColor: Theme.of(context).primaryColor,
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(
          color: Colors.black87,
        ),
        decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: " ",
            filled: false,
            hintStyle: TextStyle(fontSize: 14, color: Colors.grey)),
        onChanged: (value) {
          print(value);
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          } else {
            FocusScope.of(context).previousFocus();
          }
        },
      ),
    );
    return SizedBox(
      height: 60,
      width: 50,
      child: TextField(
        autofocus: autoFocus,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        controller: controller,
        maxLength: 1,
        cursorColor: Theme.of(context).primaryColor,
        decoration: const InputDecoration(
            border: OutlineInputBorder(),
            counterText: '',
            hintStyle: TextStyle(color: Colors.black, fontSize: 20.0)),
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }
}
