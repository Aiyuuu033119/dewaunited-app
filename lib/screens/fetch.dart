import 'dart:async';
import 'package:dewaunited/components/countAnimation.dart';
import 'package:dewaunited/components/dialog.dart';
import 'package:dewaunited/components/textfieldDialog.dart';
import 'package:dewaunited/formatting/event.dart';
import 'package:dewaunited/formatting/tickets.dart';
import 'package:dewaunited/models/databaseHelper.dart';
import 'package:dewaunited/models/fetch.dart';
import 'package:flutter/material.dart';
import 'package:dewaunited/compose/back.dart';
import 'package:flutter/services.dart';
import 'package:circle_progress_bar/circle_progress_bar.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

// import 'package:sqflite/sqflite.dart';
class FetchEvent extends StatefulWidget {
  final Map data;
  final String accessToken;
  final String tokenType;
  final bool darkMode;

  const FetchEvent({
    super.key,
    required this.data,
    required this.accessToken,
    required this.tokenType,
    required this.darkMode,
  });

  @override
  State<FetchEvent> createState() => _FetchEventState();
}

class _FetchEventState extends State<FetchEvent> {
  Back back = Back();
  int index = 0;

  List items = [];
  List tickets = [];

  final eventController = TextEditingController();
  bool errorEvent = false;
  String hintEvent = 'Select event';
  final model = TextEditingController();

  bool canTouch = true;
  Duration duration = Duration(seconds: 0);

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

    if (widget.accessToken != "" && widget.tokenType != "") {
      if (mounted) getEvent(widget.accessToken, widget.tokenType);
    }
  }

  void getEvent(accessToken, tokenType) async {
    FetchModel instance = FetchModel();
    await instance.getEvents(accessToken, tokenType, context);
    if (!mounted) {
      return;
    }
    setState(() {
      items = instance.items;
      print(items);
    });
  }

  void getTicket(accessToken, tokenType) async {
    setState(() {
      getDuration(0);
    });

    FetchModel instance = FetchModel();
    await instance.getTicket(accessToken, tokenType, model.text, context);
    if (!mounted) {
      return;
    }
    setState(() {
      tickets = instance.items;
    });

    saveOffline();
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

  void saveOffline() async {
    DatabaseHelper instance = DatabaseHelper();

    var db = await instance.getDB();
    var eventQuery = await db.query('event_tbl');

    if (eventQuery.length == 0) {
      saveFetchData(instance, '');
    } else {
      print(eventQuery[0]['ticketing_id']);
      reminderModal(context, () {
        Navigator.pop(context);
        saveFetchData(instance, eventQuery[0]['ticketing_id']);
      });
    }
  }

  void reminderModal(context, func) async {
    dialogModal(
        context,
        "Are you sure you want to fetch ticket on this event? Previous data will be deleted!",
        "Reminder", (ctx) async {
      func();
    }, widget.darkMode);
  }

  void saveFetchData(instance, id) async {
    if (id != '') {
      await instance.deleteEvent(id);
      await instance.deleteTicket(id);
    }

    List eventData = items
        .where((element) => element['ticketing_id'] == int.parse(model.text))
        .toList();

    setState(() {
      getDuration(tickets.length == 0 ? 5 : tickets.length);
      canTouch = false;
      backDrop();
      Timer(
        Duration(
            milliseconds: 1 * (tickets.length < 200 ? 700 : tickets.length)),
        () {
          setState(() {
            canTouch = true;
            Navigator.pop(context);
            getDuration(0);
          });
        },
      );
    });

    Event event = Event(
      ticketingID: eventData[0]['ticketing_id'],
      matchID: eventData[0]['match_id'],
      matchName: eventData[0]['match_name'],
      matchDate: eventData[0]['match_date'],
      banner: eventData[0]['banner'],
      bannerMobile: eventData[0]['banner_mobile'],
      sellingStartSate: eventData[0]['selling_start_date'],
      sellingEndDate: eventData[0]['selling_end_date'],
      homeTeam: eventData[0]['home_team'],
      homeLogo: eventData[0]['home_logo'],
      awayTeam: eventData[0]['away_team'],
      awayLogo: eventData[0]['away_logo'],
      locationName: eventData[0]['location_name'],
      leagueName: eventData[0]['league_name'],
      leagueLogo: eventData[0]['league_logo'],
    );

    await instance.addEvent(event);

    // print('tickets ${tickets.length}');

    var list = List.generate(
        tickets.length,
        (index) =>
            Ticket.toJson(tickets[index], int.parse(model.text)).toJson());

    // print('time ${DateFormat('kk:mm:ss').format(now)}');

    await instance.addBulkTicket(list);

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
                  children: [
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
                      'Successfully Fetch! ${tickets.length} Ticket(s)',
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
                  if (duration.toString() != '0:00:00.000000')
                    const SizedBox(
                      height: 60.0,
                    ),
                  if (duration.toString() != '0:00:00.000000')
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      width: width / 1.2,
                      child: CircleProgressBar(
                        foregroundColor: const Color(0xffE1B763),
                        backgroundColor: Colors.black12,
                        value:
                            duration.toString() == '0:00:00.000000' ? 0.0 : 1.0,
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
                                    count:
                                        duration.toString() == '0:00:00.000000'
                                            ? 0.00
                                            : 100.00,
                                    unit: '%',
                                    duration: duration,
                                    style: TextStyle(
                                      fontSize: 30.0,
                                      fontFamily: 'Spartan',
                                      fontWeight: FontWeight.w900,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                canTouch ? "Fetch" : "Fetching & Saving",
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontFamily: 'Spartan',
                                  color: Colors.black,
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
                    child: TextFieldInputDialog(
                      label: 'EVENT',
                      result: eventController,
                      error: errorEvent,
                      hint: hintEvent,
                      items: items,
                      itemLabel: 'match_name',
                      itemValue: 'ticketing_id',
                      darkmode: widget.darkMode,
                      model: model,
                      readOnly: canTouch,
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
                            eventController.text.isEmpty == true
                                ? setState(() {
                                    errorEvent = true;
                                    hintEvent = "Please select event";
                                  })
                                : setState(() {
                                    errorEvent = false;
                                    hintEvent = "";
                                  });
                            if (!errorEvent) {
                              getTicket(widget.accessToken, widget.tokenType);
                            }
                          }
                        },
                        child: Container(
                          width: width,
                          height: 60.0,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color:
                                    const Color(0xffE1B763).withOpacity(0.75),
                                spreadRadius: 1,
                                blurRadius: !widget.darkMode ? 12 : 0,
                                offset: const Offset(
                                    0, 4), // changes x,y position of shadow
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
                                "FETCH TICKETS",
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
