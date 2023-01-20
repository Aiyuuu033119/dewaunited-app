import 'package:dewaunited/compose/back.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Redeem extends StatefulWidget {
  const Redeem({Key? key}) : super(key: key);

  @override
  State<Redeem> createState() => _RedeemState();
}

class _RedeemState extends State<Redeem> {
  Back back = Back();

  final email = TextEditingController();
  bool errorEmail = false;
  String hintEmail = "";

  final password = TextEditingController();
  bool errorPass = false;
  String hintPass = "";
  bool viewPassword = true;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async => back.onWillPop(context),
      child: Scaffold(
        backgroundColor: const Color(0xFFFAB835),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFFEC045), Color(0xFFFA8920)],
                ),
              ),
              height: height,
              child: Stack(
                children: [
                  const Positioned(
                    width: 25.0,
                    height: 25.0,
                    top: 15.0,
                    right: 15.0,
                    child: SizedBox(
                      child: Image(
                        image: AssetImage('assets/images/close.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: width,
                          child: const Image(
                            image: AssetImage('assets/images/coins.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(
                          height: 40.0,
                        ),
                        SizedBox(
                          width: width,
                          child: const Center(
                            child: Text(
                              'Redeem Now!',
                              style: TextStyle(
                                fontSize: 30.0,
                                fontFamily: 'Spartan',
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        SizedBox(
                          width: width,
                          child: const Center(
                            child: Text(
                              'Collect and invite more people to have chance of winning',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14.0,
                                fontFamily: 'Spartan',
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 45.0,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          width: width,
                          // padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/redeem');
                              },
                              child: Container(
                                width: width,
                                height: 55.0,
                                decoration: const BoxDecoration(
                                  color: Color(0xffFFFFFF),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(35.0),
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    "CLAIM",
                                    style: TextStyle(
                                      fontSize: 13.0,
                                      fontFamily: 'Spartan',
                                      color: Color(0xFFE1B763),
                                    ),
                                  ),
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
          ),
        ),
      ),
    );
  }
}
