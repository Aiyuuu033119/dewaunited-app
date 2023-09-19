import 'dart:async';
import 'package:dewaunited/components/countAnimation.dart';
import 'package:dewaunited/components/dialog.dart';
import 'package:dewaunited/formatting/tickets.dart';
import 'package:dewaunited/models/databaseHelper.dart';
import 'package:dewaunited/models/fetch.dart';
import 'package:flutter/material.dart';
import 'package:dewaunited/compose/back.dart';
import 'package:flutter/services.dart';
import 'package:circle_progress_bar/circle_progress_bar.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
// import 'package:sqflite/sqflite.dart';

class SyncTicket extends StatefulWidget {
  final Map data;
  final String accessToken;
  final String tokenType;
  final bool darkMode;

  const SyncTicket({
    super.key,
    required this.data,
    required this.accessToken,
    required this.tokenType,
    required this.darkMode,
  });

  @override
  State<SyncTicket> createState() => _SyncTicketState();
}

class _SyncTicketState extends State<SyncTicket> {
  Back back = Back();

  bool canTouch = true;
  Duration duration = Duration(seconds: 0);

  DateTime now = DateTime.now();

  var totalTicket = [];
  List countClaimedTicket = [];

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
    setState(() {
      getDuration(0);
    });
  }

  void setTicket(accessToken, tokenType) async {
    setState(() {
      getDuration(0);
    });

    getOffline();
  }

  void getDuration(int secs) async {
    duration = await setDuration(secs);
  }

  Future<Duration> setDuration(int secs) async {
    return Duration(
        milliseconds: 1 *
            (secs == 0
                ? 0
                : secs > 0 && secs < 200
                    ? 700
                    : secs));
  }

  void backDrop() {
    showDialog(
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
        );
      },
    );
  }

  void getOffline() async {
    DatabaseHelper instance = DatabaseHelper();

    var db = await instance.getDB();
    var eventQuery = await db.query('event_tbl');

    if (eventQuery.length == 0) {
      warningToast();
    } else {
      reminderModal(context, () {
        Navigator.pop(context);
        saveFetchData(db, eventQuery[0]['ticketing_id']);
        getCountClaimedTicket();
      });
    }
  }

  void reminderModal(context, func) async {
    dialogModal(context, "Are you sure you want to sync all the tickets?", "Reminder", (ctx) async {
      func();
    }, widget.darkMode);
  }

  void getCountClaimedTicket() async {
    DatabaseHelper instance = DatabaseHelper();
    var db = await instance.getDB();

    totalTicket = await db.rawQuery("SELECT count(*) as total_ticket FROM ticket_tbl");
    countClaimedTicket = await db.rawQuery("SELECT seat_type, COUNT(*) AS count_claimed FROM ticket_tbl WHERE sync=1 GROUP BY seat_type");
  }

  void saveFetchData(db, id) async {
    // var ticketQuery = await db.query('ticket_tbl');

    var ticketQuery = await db.query('ticket_tbl', where: 'event_id = ? AND sync = ?', whereArgs: [id, 1]);

    if (ticketQuery.length == 0) {
      warningToast();
    } else {
      var list = List.generate(ticketQuery.length, (index) => Ticket.toSync(ticketQuery[index], int.parse(id)).toSync());

      setState(() {
        getDuration(list.length == 0 ? 5 : list.length);
        canTouch = false;
        backDrop();
        Timer(
          Duration(milliseconds: 1 * (list.length < 200 ? 700 : list.length)),
          () {
            setState(() {
              canTouch = true;
              Navigator.pop(context);
              getDuration(0);
            });
          },
        );
      });

      FetchModel instance = FetchModel();
      await instance.syncTicket(widget.accessToken, widget.tokenType, context, list);

      if (instance.data['status'] == true) {
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
                          'Successfully Fetch!',
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

  void warningToast() {
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
                Icons.warning_rounded,
                color: Color.fromARGB(255, 239, 129, 70),
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
                      'Warning',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontFamily: 'Spartan',
                        fontWeight: FontWeight.w900,
                        color: Color.fromARGB(255, 239, 129, 70),
                      ),
                    ),
                    SizedBox(
                      height: 2.0,
                    ),
                    Text(
                      'No Ticket to be Sync!',
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
              width: width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // if (duration.toString() != '0:00:00.000000')
                  const SizedBox(
                    height: 60.0,
                  ),
                  // if (duration.toString() != '0:00:00.000000')
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    width: width / 1.2,
                    child: CircleProgressBar(
                      foregroundColor: const Color(0xffE1B763),
                      backgroundColor: widget.darkMode == true ? Colors.white : Colors.black12,
                      value: duration.toString() == '0:00:00.000000' ? 0.0 : 1.0,
                      animationDuration: duration,
                      strokeWidth: 15.0,
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CountAnimation(
                                  count: duration.toString() == '0:00:00.000000' ? 0.00 : 100.00,
                                  unit: '%',
                                  duration: duration,
                                  style: TextStyle(
                                    fontSize: 30.0,
                                    fontFamily: 'Spartan',
                                    fontWeight: FontWeight.w900,
                                    color: widget.darkMode == true ? Colors.white : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              canTouch ? "Sync" : "Syncing",
                              style: TextStyle(
                                fontSize: 15.0,
                                fontFamily: 'Spartan',
                                color: widget.darkMode == true ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
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
                          if (canTouch) {
                            setTicket(widget.accessToken, widget.tokenType);
                          }
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
                                "Sync Tickets",
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
                  Visibility(
                    visible: totalTicket.isNotEmpty == true,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: Text(
                        totalTicket.isNotEmpty ? "Total Ticket: ${totalTicket[0]['total_ticket']}" : "",
                        style: TextStyle(
                          fontSize: width >= 375 ? 15.0 : 13.0,
                          fontFamily: 'Spartan',
                          color: widget.darkMode == true ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Visibility(
                    visible: countClaimedTicket.isNotEmpty == true,
                    child: Text(
                      countClaimedTicket.isNotEmpty ? "${countClaimedTicket[0]['seat_type']}: ${countClaimedTicket[0]['count_claimed']} claimed" : "",
                      style: TextStyle(
                        fontSize: width >= 375 ? 15.0 : 13.0,
                        fontFamily: 'Spartan',
                        color: widget.darkMode == true ? Colors.white : Colors.black,
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
}
