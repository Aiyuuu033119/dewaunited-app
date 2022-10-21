import 'package:dewaunited/components/dialog.dart';
import 'package:dewaunited/compose/back.dart';
import 'package:dewaunited/compose/checkAuth.dart';
import 'package:dewaunited/compose/textTransform.dart';
import 'package:dewaunited/models/ticket.dart';
import 'package:flutter/material.dart';

class Ticket extends StatefulWidget {
  final String qrString;
  final String signature;
  final String accessToken;
  final String tokenType;
  final int userId;

  const Ticket(
      {Key? key,
      required this.qrString,
      required this.signature,
      required this.accessToken,
      required this.tokenType,
      required this.userId})
      : super(key: key);

  @override
  State<Ticket> createState() => _TicketState();
}

class _TicketState extends State<Ticket> {
  Back back = Back();
  TextTransform text = TextTransform();

  Map result = {};

  @override
  void initState() {
    super.initState();
    initial();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async => back.onWillPop(context),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              height: height - 40.0,
              child: Stack(
                children: [
                  SizedBox(
                    height: 55.0,
                    child: AppBar(
                      elevation: 0,
                      leading: Builder(builder: (BuildContext context) {
                        return IconButton(
                          padding: const EdgeInsets.only(left: 10.0),
                          iconSize: 30.0,
                          icon: const SizedBox(
                            child: Image(
                              image: AssetImage('assets/images/back.png'),
                              fit: BoxFit.contain,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
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
                      backgroundColor: const Color(0xffF5C666),
                    ),
                  ),
                  Positioned(
                    width: width,
                    top: 55.0,
                    right: 0,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xffF5C666),
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
                    top: 55.0,
                    right: 0,
                    child: Padding(
                      padding:
                          EdgeInsets.only(left: 25.0, right: 25.0, top: 10.0),
                      child: Container(
                        width: width,
                        height: height / 3.65,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.12),
                              spreadRadius: 2,
                              blurRadius: 14,
                              offset: const Offset(
                                  3, 4), // changes x,y position of shadow
                            ),
                          ],
                          borderRadius: const BorderRadius.all(
                            Radius.circular(25.0),
                          ),
                          border: Border.all(
                            width: 3.0,
                            color: Colors.white,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                image: const DecorationImage(
                                  image: AssetImage('assets/images/match.png'),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(25.0)),
                              ),
                              height: height / 5.5,
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(
                                result.isNotEmpty
                                    ? '${result['tableticket']['tableticketpurchaselocationtypename']} (${result['tableticket']['tableticketpurchaselocationtypedescription']})'
                                    : '---- ---',
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  fontFamily: 'Spartan',
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 2.0,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(
                                result.isNotEmpty
                                    ? '${result['tableticket']['tableticketpurchaselocationtypename']} (${result['tableticket']['tableticketpurchaselocationtypedescription']})'
                                    : '---- ---',
                                style: const TextStyle(
                                  fontSize: 11.0,
                                  fontFamily: 'Spartan',
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF634D23),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    width: width,
                    top: height / 2.5,
                    right: 0,
                    child: Padding(
                      padding:
                          EdgeInsets.only(left: 25.0, right: 25.0, top: 10),
                      child: Container(
                        width: width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Match',
                              style: const TextStyle(
                                fontSize: 14.0,
                                fontFamily: 'Spartan',
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            SizedBox(
                              width: width,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: width / 4,
                                    child: Column(
                                      children: [
                                        if (result.isNotEmpty)
                                          if (result['tableticket'][
                                                  'tableticketpurchaseeventhomeclublogo'] !=
                                              null)
                                            SizedBox(
                                              child: const Image(
                                                image: AssetImage(
                                                    'assets/images/logo.png'),
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                        Text(
                                          result.isNotEmpty
                                              ? '${result['tableticket']['tableticketpurchaseeventhomeclubname']}'
                                              : '---- ---',
                                          textAlign: TextAlign.center,
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
                                  Text(
                                    'VS',
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                      fontFamily: 'Spartan',
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF4E4E4E),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(
                                    width: width / 4,
                                    child: Column(
                                      children: [
                                        if (result.isNotEmpty)
                                          if (result['tableticket'][
                                                  'tableticketpurchaseeventhomeclublogo'] !=
                                              null)
                                            SizedBox(
                                              child: const Image(
                                                image: AssetImage(
                                                    'assets/images/enemy.png'),
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                        Text(
                                          result.isNotEmpty
                                              ? '${result['tableticket']['tableticketpurchaseeventawayclubname']}'
                                              : '---- ---',
                                          textAlign: TextAlign.center,
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
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
                              child: const Divider(
                                thickness: 1,
                                color: Color(0xFFE7E7E7),
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              'Time',
                              style: const TextStyle(
                                fontSize: 14.0,
                                fontFamily: 'Spartan',
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              result.isNotEmpty
                                  ? '${result['tableticket']['tableticketpurchaseeventstartdate']}'
                                  : '---- ---',
                              style: const TextStyle(
                                fontSize: 11.0,
                                fontFamily: 'Spartan',
                                color: Color(0xFF787878),
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
                              child: const Divider(
                                thickness: 1,
                                color: Color(0xFFE7E7E7),
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              'Status',
                              style: const TextStyle(
                                fontSize: 14.0,
                                fontFamily: 'Spartan',
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              result.isNotEmpty
                                  ? '${result['tableticket']['tableticketpurchaseeventname']}'
                                  : '---- ---',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 11.0,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Spartan',
                                color: const Color(0xFF8A7346),
                              ),
                            ),
                            SizedBox(
                              height: 7.0,
                            ),
                            Text(
                              result.isNotEmpty
                                  ? '(${result['tableticket']['tableticketindex']})'
                                  : '---- ---',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 11.0,
                                fontFamily: 'Spartan',
                                color: Color(0xFF787878),
                              ),
                            ),
                            SizedBox(
                              height: 7.0,
                            ),
                            Container(
                              color: result.isNotEmpty
                                  ? (result['tableticket']
                                              ['tableticketisused'] ==
                                          0
                                      ? Colors.red
                                      : Color(0xFF8A7346))
                                  : Color(0xFF8A7346),
                              padding: EdgeInsets.symmetric(
                                  vertical: 3.0, horizontal: 5.0),
                              child: Text(
                                result.isNotEmpty
                                    ? (result['tableticket']
                                                ['tableticketisused'] ==
                                            0
                                        ? 'Not Claim'
                                        : 'Claim')
                                    : '-----',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 8.0,
                                  fontFamily: 'Spartan',
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 40.0,
                            ),
                            if (result.isNotEmpty)
                              if (result['tableticket']['tableticketisused'] ==
                                  0)
                                GestureDetector(
                                  onTap: () async {
                                    claim();
                                  },
                                  child: Container(
                                    width: width,
                                    height: 55.0,
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xffE1B763)
                                              .withOpacity(1.0),
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
                                    child: const Center(
                                      child: Text(
                                        "CLAIM",
                                        style: TextStyle(
                                          fontSize: 13.0,
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

  void initial() async {
    checkAuth(context, widget.accessToken, widget.tokenType);

    TicketModel instanceTicket = TicketModel();
    await instanceTicket.ticketDetail(
        widget.accessToken, widget.userId, widget.qrString, widget.signature);
    print(instanceTicket.data);
    setState(() {
      if (instanceTicket.data.isNotEmpty) {
        result = instanceTicket.data['result'];
        print(result);
      }
    });
  }

  void claim() async {
    checkAuth(context, widget.accessToken, widget.tokenType);
    dialogModal(
        context, "Are you sure you want to redeem the tikcet?", "Reminder",
        (ctx) async {
      TicketModel instanceTicket = TicketModel();
      await instanceTicket.ticketUpdate(
          widget.accessToken, widget.userId, widget.qrString, widget.signature);
      Navigator.pop(ctx);
      dialogModal(context, "Successfully Claimed!", "Success", (ctx) async {
        Navigator.pop(ctx);
        Navigator.pop(ctx);
      }, "0");
    }, "0");
  }
}
