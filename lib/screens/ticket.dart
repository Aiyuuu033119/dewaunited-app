import 'package:dewaunited/components/dialog.dart';
import 'package:dewaunited/compose/back.dart';
import 'package:dewaunited/compose/checkAuth.dart';
import 'package:dewaunited/compose/textTransform.dart';
import 'package:dewaunited/models/ticket.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';

class Ticket extends StatefulWidget {
  final String qrString;
  final Map ticketData;
  final String accessToken;
  final String tokenType;
  final bool darkMode;

  const Ticket({
    Key? key,
    required this.qrString,
    required this.ticketData,
    required this.accessToken,
    required this.tokenType,
    required this.darkMode,
  }) : super(key: key);

  @override
  State<Ticket> createState() => _TicketState();
}

class _TicketState extends State<Ticket> {
  Back back = Back();
  TextTransform text = TextTransform();

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
    bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return WillPopScope(
      onWillPop: () async => back.onWillPop(context),
      child: Scaffold(
        backgroundColor: !widget.darkMode ? Colors.white : Color(0xFF212529),
        body: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              height: isPortrait ? height + (width >= 375 ? height / 15 : height / 3) : width + (height >= 375 ? width / 4 : width / 2),
              child: Stack(
                children: [
                  SizedBox(
                    height: 80.0,
                    child: AppBar(
                      toolbarHeight: 80.0,
                      leadingWidth: 80.0,
                      elevation: 0,
                      leading: Builder(builder: (BuildContext context) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
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
                        );
                      }),
                      title: Padding(
                        padding: const EdgeInsets.only(top: 3.0),
                        child: Text(
                          'Redeem',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontFamily: 'Spartan',
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      centerTitle: true,
                      backgroundColor: !widget.darkMode ? Color(0xffF5C666) : Color(0xff343A40),
                    ),
                  ),
                  Positioned(
                    width: width,
                    top: 80.0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: !widget.darkMode ? Color(0xffF5C666) : Color(0xff343A40),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(25.0),
                          bottomRight: Radius.circular(25.0),
                        ),
                      ),
                      width: width,
                      height: height / 4.8,
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    ),
                  ),
                  Positioned(
                    width: width,
                    top: 70.0,
                    right: 0,
                    child: Padding(
                      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 10.0),
                      child: Container(
                        width: width,
                        height: isPortrait ? height / 3.15 : width / 3.15,
                        decoration: BoxDecoration(
                          color: !widget.darkMode ? Colors.white : Color(0xffE1B763),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.12),
                              spreadRadius: 2,
                              blurRadius: 14,
                              offset: const Offset(
                                3,
                                4,
                              ), // changes x,y position of shadow
                            ),
                          ],
                          borderRadius: const BorderRadius.all(
                            Radius.circular(25.0),
                          ),
                          border: Border.all(
                            width: !widget.darkMode ? 3.0 : 1.0,
                            color: !widget.darkMode ? Color.fromARGB(255, 255, 255, 255) : Color(0xffE1B763),
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (widget.ticketData['matches']['banner_mobile'] != null)
                              Container(
                                width: width,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      widget.ticketData['matches']['banner_mobile'],
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(25.0),
                                  ),
                                ),
                                height: isPortrait ? height / 5.5 : width / 5.5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Container(
                                      width: isPortrait ? height / 10.5 : width / 10.5,
                                      child: widget.ticketData['matches']['banner_mobile'] != null
                                          ? Image(
                                              image: NetworkImage(widget.ticketData['matches']['league']['logo']),
                                              fit: BoxFit.contain,
                                            )
                                          : SizedBox(),
                                    )
                                  ],
                                ),
                              )
                            else
                              Container(
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  image: DecorationImage(
                                    image: AssetImage('assets/images/match.png'),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(25.0)),
                                ),
                                height: height / 5.5,
                              ),
                            SizedBox(
                              height: isPortrait ? (width >= 375 ? 15.0 : 10.0) : (height >= 375 ? 15.0 : 10.0),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(
                                widget.ticketData.isNotEmpty
                                    ? '${widget.ticketData['seat_type']} (${widget.ticketData['seat_category'][0].toUpperCase()}${widget.ticketData['seat_category'].substring(1).toLowerCase()})'
                                    : '---- ---',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontFamily: 'Spartan',
                                  fontWeight: FontWeight.w600,
                                  color: !widget.darkMode ? Colors.black : Colors.white,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 2.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(
                                widget.ticketData.isNotEmpty ? '${widget.ticketData['matches']['league']['name']}' : '---- ---',
                                style: TextStyle(
                                  fontSize: 11.0,
                                  fontFamily: 'Spartan',
                                  fontWeight: FontWeight.w600,
                                  color: !widget.darkMode ? Color(0xFF634D23) : Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(
                                widget.ticketData.isNotEmpty ? 'Spectator: ${widget.ticketData['name']}' : '---- ---',
                                style: TextStyle(
                                    fontSize: 11.0,
                                    fontFamily: 'Spartan',
                                    fontWeight: FontWeight.w600,
                                    color: !widget.darkMode ? Colors.black : Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    width: width,
                    top: isPortrait ? height / 2.1 : width / 2.1,
                    right: 0,
                    child: Padding(
                      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 10),
                      child: Container(
                        width: width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Match',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontFamily: 'Spartan',
                                fontWeight: FontWeight.w600,
                                color: !widget.darkMode ? Colors.black : Colors.white,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            SizedBox(
                              width: width,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: width / 4,
                                    child: Column(
                                      children: [
                                        if (widget.ticketData.isNotEmpty)
                                          if (widget.ticketData['matches']['team_a']['logo'] != null)
                                            SizedBox(
                                              child: Image(
                                                image: NetworkImage(widget.ticketData['matches']['team_a']['logo']),
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                        Text(
                                          widget.ticketData.isNotEmpty ? '${widget.ticketData['matches']['team_a']['name']}' : '---- ---',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 11.0,
                                            fontFamily: 'Spartan',
                                            fontWeight: FontWeight.w600,
                                            color: !widget.darkMode ? Color(0xFF634D23) : Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    'VS',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontFamily: 'Spartan',
                                      fontWeight: FontWeight.w600,
                                      color: !widget.darkMode ? Color(0xFF4E4E4E) : Colors.white,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(
                                    width: width / 4.5,
                                    child: Column(
                                      children: [
                                        if (widget.ticketData.isNotEmpty)
                                          if (widget.ticketData['matches']['team_b']['logo'] != null)
                                            SizedBox(
                                              child: Image(
                                                image: NetworkImage(widget.ticketData['matches']['team_b']['logo']),
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                        Text(
                                          widget.ticketData.isNotEmpty ? '${widget.ticketData['matches']['team_b']['name']}' : '---- ---',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 11.0,
                                            fontFamily: 'Spartan',
                                            fontWeight: FontWeight.w600,
                                            color: !widget.darkMode ? Color(0xFF634D23) : Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5.0),
                              child: Divider(
                                thickness: 1,
                                color: !widget.darkMode ? Color(0xFFE7E7E7) : Color(0xffF5C666),
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              'Location',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontFamily: 'Spartan',
                                fontWeight: FontWeight.w600,
                                color: !widget.darkMode ? Colors.black : Colors.white,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              widget.ticketData.isNotEmpty ? '${widget.ticketData['matches']['location']['name']}' : '---- ---',
                              style: TextStyle(
                                fontSize: 11.0,
                                fontFamily: 'Spartan',
                                color: !widget.darkMode ? Color(0xFF787878) : Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5.0),
                              child: Divider(
                                thickness: 1,
                                color: !widget.darkMode ? Color(0xFFE7E7E7) : Color(0xffF5C666),
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              'Time',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontFamily: 'Spartan',
                                fontWeight: FontWeight.w600,
                                color: !widget.darkMode ? Colors.black : Colors.white,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              widget.ticketData.isNotEmpty ? '${widget.ticketData['matches']['match_date']}' : '---- ---',
                              style: TextStyle(
                                fontSize: 11.0,
                                fontFamily: 'Spartan',
                                color: !widget.darkMode ? Color(0xFF787878) : Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5.0),
                              child: Divider(
                                thickness: 1,
                                color: !widget.darkMode ? Color(0xFFE7E7E7) : Color(0xffF5C666),
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              'Status',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontFamily: 'Spartan',
                                fontWeight: FontWeight.w600,
                                color: !widget.darkMode ? Colors.black : Colors.white,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              widget.ticketData.isNotEmpty ? '${widget.ticketData['matches']['league']['name']}' : '---- ---',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 11.0,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Spartan',
                                color: !widget.darkMode ? Color(0xFF8A7346) : Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: 7.0,
                            ),
                            Text(
                              widget.ticketData.isNotEmpty ? '(TICKET NO: ${widget.ticketData['ticket']})' : '---- ---',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 11.0,
                                fontFamily: 'Spartan',
                                color: !widget.darkMode ? Color(0xFF787878) : Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: 7.0,
                            ),
                            Container(
                              color: widget.ticketData.isNotEmpty
                                  ? (widget.ticketData['claimed_at'] == null ? Colors.red : Color(0xFF8A7346))
                                  : Color(0xFF8A7346),
                              padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 5.0),
                              child: Text(
                                widget.ticketData.isNotEmpty ? (widget.ticketData['claimed_at'] == null ? 'Not Claim' : 'Claim') : '-----',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 8.0,
                                  fontFamily: 'Spartan',
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            if (widget.ticketData.isNotEmpty)
                              SizedBox(
                                height: 40.0,
                              ),
                            if (widget.ticketData.isNotEmpty)
                              if (widget.ticketData['claimed_at'] == null)
                                GestureDetector(
                                  onTap: () async {
                                    claim(widget.darkMode);
                                  },
                                  child: Container(
                                    width: width,
                                    height: 55.0,
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xffE1B763).withOpacity(1.0),
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
                                    child: const Center(
                                      child: Text(
                                        "CLAIM",
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          fontFamily: 'Spartan',
                                          color: Colors.white,
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void claim(darkMode) async {
    checkAuth(context, widget.accessToken, widget.tokenType);
    dialogModal(context, "Are you sure you want to redeem the ticket?", "Reminder", (ctx) async {
      TicketModel instanceTicket = TicketModel();
      await instanceTicket.ticketUpdate(widget.accessToken, widget.tokenType, widget.qrString);
      Navigator.pop(ctx);

      // Sound-Effect
      final player = AudioPlayer();
      player.play(AssetSource("audio/success.mp3"));

      dialogModal(context, "Successfully Claimed!", "Success", (ctx) async {
        Navigator.pop(ctx);
        Navigator.pop(ctx);
      }, darkMode);
    }, darkMode);
  }
}
