import 'package:dewaunited/screens/login.dart';
import 'package:dewaunited/screens/redeem.dart';
import 'package:dewaunited/screens/splashscreen.dart';
import 'package:dewaunited/screens/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/': (context) => const SplashScreen(),
      '/login': (context) => const Login(),
      '/home': (context) => const Home(isStillLogin: 0),
      '/redeem': (context) => const Redeem(),
    },
  ));
}
