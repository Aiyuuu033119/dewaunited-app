import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:dewaunited/components/textfield.dart';
import 'package:dewaunited/compose/back.dart';
import 'package:dewaunited/compose/checkAuth.dart';
import 'package:dewaunited/compose/textTransform.dart';
import 'package:dewaunited/models/ticket.dart';
import 'package:dewaunited/screens/ticket.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:permission_handler/permission_handler.dart';

class Scan extends StatefulWidget {
  final Map data;
  final String accessToken;
  final String tokenType;
  final bool darkMode;

  const Scan({
    Key? key,
    required this.data,
    required this.accessToken,
    required this.tokenType,
    required this.darkMode,
  }) : super(key: key);

  @override
  State<Scan> createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  Back back = Back();
  TextTransform text = TextTransform();

  String scanResult = '';

  final codeController = TextEditingController();
  bool errorCode = false;
  String hintCode = 'Please input the code';

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
    double width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async => back.onWillPop(context),
      child: Scaffold(
        backgroundColor: !widget.darkMode ? Colors.white : Color(0xFF212529),
        body: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              child: Column(
                children: [
                  const SizedBox(
                    height: 70.0,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    decoration: BoxDecoration(
                      color: !widget.darkMode ? Colors.white : Color(0xFF212529),
                      borderRadius: BorderRadius.all(
                        Radius.circular(15.0),
                      ),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 25.0),
                    width: width / 1.5,
                    child: Image(
                      image: !widget.darkMode ? AssetImage('assets/images/qr.png') : AssetImage('assets/images/qr-white.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  const SizedBox(
                    height: 35.0,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
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
                                color: const Color(0xffE1B763).withOpacity(0.75),
                                spreadRadius: 1,
                                blurRadius: !widget.darkMode ? 12 : 0,
                                offset: const Offset(0, 4), // changes x,y position of shadow
                              ),
                            ],
                            color: const Color(0xffE1B763),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(35.0),
                            ),
                          ),
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: width >= 375 ? 8.0 : 5.0),
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
                    height: 30.0,
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
                    height: 30.0,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: textFieldInput('CODE', codeController, errorCode, hintCode, width, false, () {}),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
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
                            color: !widget.darkMode ? const Color(0xffFFFFFF) : Colors.transparent,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(35.0),
                            ),
                            border: Border.all(
                              color: !widget.darkMode ? Color(0xffE1B763) : Color(0xffFFFFFF),
                              width: 2.0,
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: width >= 375 ? 8.0 : 5.0),
                              child: Text(
                                "CHECK",
                                style: TextStyle(
                                  fontSize: width >= 375 ? 15.0 : 13.0,
                                  fontFamily: 'Spartan',
                                  color: !widget.darkMode ? Color(0xffE1B763) : Color(0xffFFFFFF),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 100.0,
                  ),
                ],
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
      var codeSanner = await BarcodeScanner.scan(); //barcode scnner

      checkAuth(context, widget.accessToken, widget.tokenType);
      if (codeSanner.rawContent.isNotEmpty) {
        setState(() {
          scanResult = codeSanner.rawContent;
        });

        TicketModel instanceTicket = TicketModel();
        await instanceTicket.getSignature(widget.accessToken, widget.tokenType, scanResult);

        if (instanceTicket.data['error'] == true) {
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Ticket(
                  qrString: scanResult,
                  ticketData: instanceTicket.data,
                  accessToken: widget.accessToken,
                  tokenType: widget.tokenType,
                  darkMode: widget.darkMode),
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
    TicketModel instanceTicket = TicketModel();
    await instanceTicket.getSignature(widget.accessToken, widget.tokenType, codeController.text);

    if (instanceTicket.data['error'] == true) {
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

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Ticket(
              qrString: scanResult,
              ticketData: instanceTicket.data,
              accessToken: widget.accessToken,
              tokenType: widget.tokenType,
              darkMode: widget.darkMode),
        ),
      );
    }
  }
}
