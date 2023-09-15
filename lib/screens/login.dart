import 'package:dewaunited/components/textfield.dart';
import 'package:dewaunited/compose/back.dart';
import 'package:dewaunited/models/auth.dart';
// import 'package:dewaunited/models/databaseHelper.dart';
import 'package:dewaunited/screens/scanOffline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:string_validator/string_validator.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Back back = Back();

  final email = TextEditingController();
  bool errorEmail = false;
  String hintEmail = 'Enter your email';

  final password = TextEditingController();
  bool errorPass = false;
  String hintPass = 'Enter your password';
  bool viewPassword = true;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
    createDBTbl();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async => back.onWillPop(context),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            TextEditingController().clear();
          },
          child: SafeArea(
            child: SingleChildScrollView(
              child: SizedBox(
                height: height,
                child: Stack(
                  children: [
                    Positioned(
                      width: width,
                      top: 0,
                      right: 0,
                      child: const Image(
                        image: AssetImage('assets/images/bg-top.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 60.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 10.0,
                          ),
                          SizedBox(
                            width: width / 2.7,
                            child: const Image(
                              image: AssetImage('assets/images/logo.png'),
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          SizedBox(
                            width: width,
                            child: const Text(
                              'Login',
                              style: TextStyle(fontSize: 30.0, fontFamily: 'Spartan', fontWeight: FontWeight.w900, color: Colors.black),
                            ),
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          SizedBox(
                            width: width,
                            child: const Text(
                              'Please sign in to continue',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontFamily: 'Spartan',
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFA2A4A3),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          textFieldInput('EMAIL', email, errorEmail, hintEmail, width, false, () {}),
                          const SizedBox(
                            height: 15.0,
                          ),
                          textFieldInput('PASSWORD', password, errorPass, hintPass, width, viewPassword, () {
                            setState(() {
                              viewPassword = !viewPassword;
                            });
                          }),
                          const SizedBox(
                            height: 20.0,
                          ),
                          SizedBox(
                            width: width,
                            // padding: const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: GestureDetector(
                                onTap: () {
                                  loginValidator(context);
                                },
                                child: Container(
                                  width: 130.0,
                                  height: 40.0,
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xffE1B763).withOpacity(0.75),
                                        spreadRadius: 1,
                                        blurRadius: 12,
                                        offset: const Offset(0, 4), // changes x,y position of shadow
                                      ),
                                    ],
                                    color: const Color(0xffE1B763),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(35.0),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    // ignore: prefer_const_literals_to_create_immutables
                                    children: [
                                      const Text(
                                        "LOGIN",
                                        style: TextStyle(
                                          fontSize: 13.0,
                                          fontFamily: 'Spartan',
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(width: 8.0),
                                      const Image(
                                        image: AssetImage('assets/images/arrow.png'),
                                        fit: BoxFit.contain,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          SizedBox(
                            width: width,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ScanOffline(),
                                  ),
                                );
                              },
                              child: const Text(
                                'No Internet? Use Offline Transaction',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontFamily: 'Spartan',
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFFA2A4A3),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      width: width,
                      bottom: 0,
                      right: 0,
                      child: const Image(
                        image: AssetImage('assets/images/bg-bottom.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> createDBTbl() async {
    final prefs = await SharedPreferences.getInstance();
    var db = await openDatabase(prefs.getString("dbPath").toString());

    var tableNames = (await db.query('sqlite_master', where: 'type = ?', whereArgs: ['table']))
        .map((row) => row['name'] as String)
        .toList(growable: false)
      ..sort();

    var event = tableNames.where(
      (element) => element == 'event_tbl',
    );

    var ticket = tableNames.where(
      (element) => element == 'ticket_tbl',
    );

    // ignore: unrelated_type_equality_checks
    if (!event.contains('event_tbl')) {
      await db.execute(
          "CREATE TABLE event_tbl( id INTEGER PRIMARY KEY AUTOINCREMENT, ticketing_id TEXT, match_id TEXT, match_name TEXT, match_date TEXT, banner TEXT, banner_mobile TEXT, selling_start_date TEXT, selling_end_date TEXT, home_team TEXT, home_logo TEXT, away_team TEXT, away_logo TEXT, location_name TEXT, league_name TEXT, league_logo TEXT)");
    }

    // ignore: unrelated_type_equality_checks
    if (!ticket.contains('ticket_tbl')) {
      await db.execute(
          "CREATE TABLE ticket_tbl( id INTEGER PRIMARY KEY AUTOINCREMENT, event_id TEXT, ticketing_id TEXT, code TEXT, name TEXT, phone TEXT, category TEXT, seat_type TEXT, claimed_at TEXT, sync TEXT, no TEXT)");
    }
  }

  void loginValidator(context) {
    email.text.isEmpty == true
        ? setState(() {
            errorEmail = true;
            hintEmail = "Please input your email";
          })
        : isEmail(email.text) == true
            ? setState(() {
                errorEmail = false;
                hintEmail = "";
              })
            : setState(() {
                email.text = "";
                errorEmail = true;
                hintEmail = "Incorrect input";
              });

    password.text.isEmpty == true
        ? setState(() {
            errorPass = true;
            hintPass = "Please input your password";
          })
        : setState(() {
            errorPass = false;
            hintPass = "";
          });

    if (!errorEmail && !errorPass) {
      loginModel(context);
    }
  }

  void loginModel(context) async {
    AuthModel instance = AuthModel();
    await instance.login(email.text, password.text);
    if (instance.data.isNotEmpty) {
      if (instance.data['error'] == 'Unauthorized' || instance.data['error'] == true) {
        setState(() {
          email.text = "";
          hintEmail = 'Invalid email';
          errorEmail = true;

          password.text = "";
          hintPass = 'Invalid Password';
          errorPass = true;
        });

        showToastWidget(
          Container(
            padding: const EdgeInsets.only(top: 12.0, bottom: 12.0, left: 10.0),
            margin: const EdgeInsets.symmetric(horizontal: 25.0),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  spreadRadius: 2,
                  blurRadius: 14,
                  offset: const Offset(3, 4),
                )
              ],
              borderRadius: const BorderRadius.all(
                Radius.circular(10.0),
              ),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                // ignore: prefer_const_constructors
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: const Icon(
                    Icons.error,
                    color: Color(0xffEF4646),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: SizedBox(
                    height: 40.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Error',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontFamily: 'Spartan',
                            fontWeight: FontWeight.w900,
                            color: Color(0xffEF4646),
                          ),
                        ),
                        SizedBox(
                          height: 2.0,
                        ),
                        Text(
                          'Invalid Credentials!',
                          style: TextStyle(
                            fontSize: 12.0,
                            fontFamily: 'Spartan',
                            fontWeight: FontWeight.w700,
                            color: Color(0xffA2A4A3),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          context: context,
          animation: StyledToastAnimation.fade,
          reverseAnimation: StyledToastAnimation.fade,
          position: StyledToastPosition.top,
          animDuration: const Duration(seconds: 1),
          duration: const Duration(seconds: 4),
          curve: Curves.elasticOut,
          reverseCurve: Curves.linear,
        );
        return;
      }
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', instance.data['access_token']);
      await prefs.setString('token_type', instance.data['token_type']);
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/home');
    }
  }
}
