import 'package:dewaunited/components/dialog.dart';
import 'package:dewaunited/components/sidebar.dart';
import 'package:dewaunited/compose/back.dart';
import 'package:dewaunited/compose/checkAuth.dart';
import 'package:dewaunited/models/auth.dart';
import 'package:dewaunited/screens/fetch.dart';
import 'package:dewaunited/screens/login.dart';
import 'package:dewaunited/screens/scan.dart';
import 'package:dewaunited/screens/sync.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class Home extends StatefulWidget {
  final int? isStillLogin;
  final int active;
  const Home({Key? key, this.isStillLogin, required this.active})
      : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Back back = Back();
  int index = 0;

  String accessToken = "";
  String tokenType = "";
  bool darkMode = false;

  Map data = {};

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
    initial();
    index = widget.active;
    darmmodeFunc();
  }

  Future<void> darmmodeFunc() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      darkMode = prefs.getBool("darkmode")!;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    List<Widget> pages = [
      Scan(
        data: data,
        accessToken: accessToken,
        tokenType: tokenType,
        darkMode: darkMode,
      ),
      FetchEvent(
        data: data,
        accessToken: accessToken,
        tokenType: tokenType,
        darkMode: darkMode,
      ),
      SyncTicket(
        data: data,
        accessToken: accessToken,
        tokenType: tokenType,
        darkMode: darkMode,
      ),
    ];

    return WillPopScope(
      onWillPop: () async => back.onWillPop(context),
      child: Scaffold(
        backgroundColor: Colors.white,
        drawer: Sidebar(
          darkmode: darkMode,
          active: index,
          onTap: (ctx, i) {
            if (i == 3) {
              logoutModel(context);
            } else {
              setState(() {
                index = i;
                Navigator.pushReplacement(
                  ctx,
                  MaterialPageRoute(builder: (context) => Home(active: index)),
                );
              });
            }
          },
        ),
        appBar: AppBar(
          toolbarHeight: 80.0,
          elevation: 0,
          leading: Builder(builder: (BuildContext context) {
            return IconButton(
              padding: const EdgeInsets.only(left: 10.0),
              iconSize: 30.0,
              icon: const SizedBox(
                child: Image(
                  image: AssetImage('assets/images/menu.png'),
                  fit: BoxFit.contain,
                ),
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          }),
          title: SizedBox(
            width: isPortrait ? width / 6 : width / 14,
            child: const Image(
              image: AssetImage('assets/images/logo.png'),
              fit: BoxFit.contain,
            ),
          ),
          centerTitle: true,
          backgroundColor: !darkMode ? Color(0xffF5C666) : Color(0xff343A40),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Builder(builder: (BuildContext context) {
                return IconButton(
                  padding: const EdgeInsets.only(right: 5.0),
                  iconSize: 30.0,
                  icon: SizedBox(
                    child: Image(
                      image: !darkMode
                          ? AssetImage('assets/images/moon.png')
                          : AssetImage('assets/images/sun.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                  onPressed: () {
                    setState(() async {
                      darkMode = !darkMode;
                      final prefs = await SharedPreferences.getInstance();
                      setState(() {
                        prefs.setBool("darkmode", darkMode);
                      });
                    });
                  },
                );
              }),
            ),
          ],
        ),
        body:
            accessToken != "" && accessToken != "" ? pages[index] : SizedBox(),
      ),
    );
  }

  void initial() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      accessToken = prefs.getString("access_token")!;
      tokenType = prefs.getString("token_type")!;
    });
    checkAuth(context, accessToken, tokenType);
    getData(accessToken, tokenType);
  }

  void getData(accessToken, tokenType) async {
    AuthModel instance = AuthModel();
    await instance.profile(accessToken, tokenType);

    if (instance.data.isNotEmpty) {
      if (instance.data['error'] == true) {
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
                          'Invalid Token!',
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

        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('access_token');
        await prefs.remove('token_type');
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Login(),
          ),
        );

        return;
      }
      setState(() {
        data = instance.data;
      });

      if (widget.isStillLogin == 0) {
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
                    Icons.check_circle,
                    color: Color(0xff49D679),
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
                          'Success',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontFamily: 'Spartan',
                            fontWeight: FontWeight.w900,
                            color: Color(0xff49D679),
                          ),
                        ),
                        SizedBox(
                          height: 2.0,
                        ),
                        Text(
                          'Welcome in DewaUnited!',
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
      }
    }
  }

  void logoutModel(context) async {
    dialogModal(context, "Are you sure you want to logout?", "Reminder",
        (ctx) async {
      AuthModel instance = AuthModel();
      await instance.logout(accessToken, tokenType);
      if (instance.data['message'] == "User successfully logged out.") {
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
                    Icons.check_circle,
                    color: Color(0xff49D679),
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
                          'Success',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontFamily: 'Spartan',
                            fontWeight: FontWeight.w900,
                            color: Color(0xff49D679),
                          ),
                        ),
                        SizedBox(
                          height: 2.0,
                        ),
                        Text(
                          'User successfully logged out!',
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

        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('access_token');
        await prefs.remove('token_type');
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Login(),
          ),
        );
      }
    }, darkMode);
  }
}
