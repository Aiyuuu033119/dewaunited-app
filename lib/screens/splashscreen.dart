import 'dart:async';
import 'package:dewaunited/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dewaunited/screens/login.dart';
import 'package:page_transition/page_transition.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<SharedPreferences> loginData = SharedPreferences.getInstance();

  double progressValue = 0.0;

  String accessToken = "";
  String tokenType = "";

  int page = 1;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
    check();
  }

  @override
  Widget build(BuildContext context) {
    updateProgress();
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            // height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: height - (height * 0.10),
                  child: AnimatedSplashScreen(
                    duration: 3000,
                    splashIconSize: width / 4,
                    splash: 'assets/images/logo.png',
                    nextScreen: nextScreen(page),
                    pageTransitionType: PageTransitionType.leftToRight,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: height * 0.07),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: LinearProgressIndicator(
                      minHeight: 6.0,
                      backgroundColor: const Color(0xFF8A7346),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFFF5C666)),
                      value: progressValue,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void updateProgress() {
    const oneSec = Duration(seconds: 1);
    Timer.periodic(
      oneSec,
      (Timer timer) => {
        if (mounted)
          {
            setState(
              () {
                progressValue += 0.1;
                // we "finish" downloading here
                if (progressValue.toStringAsFixed(1) == '3.0') {
                  timer.cancel();
                  return;
                }
              },
            )
          }
      },
    );
  }

  void check() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      accessToken = prefs.getString("access_token")!;
      tokenType = prefs.getString("token_type")!;
    });

    if (accessToken.isNotEmpty && tokenType.isNotEmpty) {
      setState(() {
        page = 2;
      });
    }
  }

  Widget nextScreen(page) {
    if (page == 1) {
      return Login();
    } else {
      return Home(
        isStillLogin: 1,
        active: 0,
      );
    }
  }
}
