import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:dewaunited/compose/back.dart';
import 'package:dewaunited/compose/checkAuth.dart';
import 'package:dewaunited/compose/textTransform.dart';
import 'package:dewaunited/models/auth.dart';
import 'package:dewaunited/models/ticket.dart';
import 'package:dewaunited/screens/ticket.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:permission_handler/permission_handler.dart';

class Scan extends StatefulWidget {
  final Map data;
  final String accessToken;
  final String tokenType;

  const Scan(
      {Key? key,
      required this.data,
      required this.accessToken,
      required this.tokenType})
      : super(key: key);

  @override
  State<Scan> createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  Back back = Back();
  TextTransform text = TextTransform();

  String scanResult = '';

  @override
  Widget build(BuildContext context) {
    // double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async => back.onWillPop(context),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xffF5C666),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(25.0),
                        bottomRight: Radius.circular(25.0),
                      ),
                    ),
                    width: width,
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        const SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          children: [
                            const CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 45.0,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                backgroundImage:
                                    AssetImage('assets/images/dp.png'),
                                radius: 43.0,
                              ),
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            SizedBox(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.data.isEmpty
                                        ? '-----'
                                        : text
                                            .capitalize(widget.data['name'])
                                            .toString(),
                                    style: const TextStyle(
                                      fontSize: 18.0,
                                      fontFamily: 'Spartan',
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFFFFFFFF),
                                    ),
                                  ),
                                  Text(
                                    widget.data.isEmpty
                                        ? '-----'
                                        : text
                                            .capitalize(
                                                widget.data['level_label'])
                                            .toString(),
                                    style: const TextStyle(
                                      fontSize: 11.0,
                                      fontFamily: 'Spartan',
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF634D23),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 55.0,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(15.0),
                      ),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 25.0),
                    width: width,
                    child: const Image(
                      image: AssetImage('assets/images/qr.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  const SizedBox(
                    height: 55.0,
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
                          height: 55.0,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xffE1B763).withOpacity(1.0),
                                spreadRadius: 1,
                                blurRadius: 12,
                                offset: const Offset(
                                    0, 4), // changes x,y position of shadow
                              ),
                            ],
                            color: const Color(0xffE1B763),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(35.0),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              "SCAN",
                              style: TextStyle(
                                fontSize: 13.0,
                                fontFamily: 'Spartan',
                                color: Colors.white,
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

      checkAuth(context, widget.accessToken, widget.tokenType);

      if (codeSanner.rawContent.isNotEmpty) {
        setState(() {
          scanResult = codeSanner.rawContent;
          print('This is the QR CODE $scanResult');
        });

        TicketModel instanceTicket = TicketModel();
        await instanceTicket.getSignature(
            widget.accessToken, widget.data['id'], scanResult);

        print(instanceTicket.data);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Ticket(
              qrString: scanResult,
              signature: instanceTicket.data['signature'],
              accessToken: widget.accessToken,
              tokenType: widget.tokenType,
              userId: widget.data['id'],
            ),
          ),
        );
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

      //   print(scanResult);
      // }
    } else if (permission == PermissionStatus.permanentlyDenied) {
      openAppSettings();
    }
  }
}
