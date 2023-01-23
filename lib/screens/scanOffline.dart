import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:dewaunited/components/textfield.dart';
import 'package:dewaunited/compose/back.dart';
import 'package:dewaunited/models/databaseHelper.dart';
import 'package:dewaunited/screens/ticketOffline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:permission_handler/permission_handler.dart';

class ScanOffline extends StatefulWidget {
  const ScanOffline({Key? key}) : super(key: key);

  @override
  State<ScanOffline> createState() => _ScanOfflineState();
}

class _ScanOfflineState extends State<ScanOffline> {
  Back back = Back();

  String scanResult = '';

  final codeController = TextEditingController();
  bool errorCode = false;
  String hintCode = 'Enter your code';

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
                    Positioned(
                      width: width,
                      top: 20.0,
                      left: 20.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              width: 40.0,
                              height: 40.0,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(35.0),
                                ),
                                color: Color(0xffE1B763),
                              ),
                              child: const Image(
                                image: AssetImage(
                                  'assets/images/arrow-left.png',
                                ),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 30.0, right: 30.0, bottom: 60.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 40.0,
                          ),
                          SizedBox(
                            width: width,
                            child: const Text(
                              'Scan Offline',
                              style: TextStyle(
                                  fontSize: 30.0,
                                  fontFamily: 'Spartan',
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black),
                            ),
                          ),
                          const SizedBox(
                            height: 50.0,
                          ),
                          Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(15.0),
                              ),
                            ),
                            margin:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            width: width,
                            child: Image(
                              image: AssetImage('assets/images/qr.png'),
                              fit: BoxFit.fill,
                            ),
                          ),
                          const SizedBox(
                            height: 35.0,
                          ),
                          Container(
                            width: width,
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: GestureDetector(
                                onTap: () async {
                                  scan();
                                },
                                child: Container(
                                  width: width,
                                  height: 60.0,
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xffE1B763)
                                            .withOpacity(0.75),
                                        spreadRadius: 1,
                                        blurRadius: 12,
                                        offset: const Offset(0,
                                            4), // changes x,y position of shadow
                                      ),
                                    ],
                                    color: const Color(0xffE1B763),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(35.0),
                                    ),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          top: width >= 375 ? 8.0 : 5.0),
                                      child: Text(
                                        "SCAN",
                                        style: TextStyle(
                                          fontSize: width >= 375 ? 15.0 : 13.0,
                                          fontFamily: 'Spartan',
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
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
                            child: const Text(
                              'OR',
                              textAlign: TextAlign.center,
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
                          textFieldInput('CODE', codeController, errorCode,
                              hintCode, width, false, () {}),
                          const SizedBox(
                            height: 30.0,
                          ),
                          Container(
                            width: width,
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: GestureDetector(
                                onTap: () async {
                                  codeController.text.isEmpty == true
                                      ? setState(() {
                                          errorCode = true;
                                          hintCode = "Please input the code";
                                        })
                                      : setState(() {
                                          errorCode = false;
                                          hintCode = "";
                                        });

                                  if (!errorCode) {
                                    check();
                                  }
                                },
                                child: Container(
                                  width: width,
                                  height: 60.0,
                                  decoration: BoxDecoration(
                                    color: const Color(0xffFFFFFF),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(35.0),
                                    ),
                                    border: Border.all(
                                      color: Color(0xffE1B763),
                                      width: 2.0,
                                      style: BorderStyle.solid,
                                    ),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          top: width >= 375 ? 8.0 : 5.0),
                                      child: Text(
                                        "CHECK",
                                        style: TextStyle(
                                          fontSize: width >= 375 ? 15.0 : 13.0,
                                          fontFamily: 'Spartan',
                                          color: Color(0xffE1B763),
                                        ),
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

  Future requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
    ].request();
    return statuses[Permission.camera];
  }

  Future<void> scan() async {
    final permission = await requestPermission();

    if (permission == PermissionStatus.granted) {
      print('granted');
      var codeSanner = await BarcodeScanner.scan(); //barcode scnner

      if (codeSanner.rawContent.isNotEmpty) {
        setState(() {
          scanResult = codeSanner.rawContent;
          print('This is the QR CODE $scanResult');
        });

        DatabaseHelper instance = DatabaseHelper();

        var db = await instance.getDB();
        var ticketQuery = await db
            .query('ticket_tbl', where: 'code = ?', whereArgs: [scanResult]);

        if (ticketQuery.length == 0) {
          showToastWidget(
            Container(
              padding:
                  const EdgeInsets.only(top: 12.0, bottom: 12.0, left: 10.0),
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
                            'QR code is not registered!',
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
        } else {
          var eventQuery = await db.query('event_tbl',
              where: 'ticketing_id = ?',
              whereArgs: [ticketQuery[0]['event_id']]);

          // print(ticketQuery);
          // print(eventQuery);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TicketOffline(
                qrString: scanResult,
                eventData: eventQuery,
                ticketData: ticketQuery,
              ),
            ),
          );
        }
      } else {
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
                          'Cannot Read QR Code!',
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
    } else if (permission == PermissionStatus.permanentlyDenied) {
      openAppSettings();
    }
  }

  Future<void> check() async {
    DatabaseHelper instance = DatabaseHelper();

    var db = await instance.getDB();
    var ticketQuery = await db.query('ticket_tbl',
        where: 'code = ?', whereArgs: [codeController.text]);

    if (ticketQuery.length == 0) {
      setState(() {
        codeController.text = '';
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
                        'Code Ticket is not registered!',
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
    } else {
      setState(() {
        codeController.text = '';
      });

      var eventQuery = await db.query('event_tbl',
          where: 'ticketing_id = ?', whereArgs: [ticketQuery[0]['event_id']]);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TicketOffline(
            qrString: scanResult,
            eventData: eventQuery,
            ticketData: ticketQuery,
          ),
        ),
      );
    }
  }
}
