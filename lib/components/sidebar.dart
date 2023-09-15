import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Sidebar extends StatelessWidget {
  final Function onTap;
  final int active;
  final bool darkmode;

  // ignore: prefer_const_constructors_in_immutables
  Sidebar({Key? key, required this.darkmode, required this.active, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Drawer(
      child: Container(
        color: !darkmode ? Colors.white : Color(0xFF212529),
        child: Column(
          children: <Widget>[
            DrawerHeader(
              padding: EdgeInsets.zero,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage('assets/images/bg-sidebar.png'),
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
                color: !darkmode ? Colors.white : Color(0xFF212529),
                border: Border.all(
                  width: 0.0,
                  color: !darkmode ? Colors.white : Color(0xFF212529),
                  style: BorderStyle.solid,
                ),
              ),
              child: Container(
                padding: EdgeInsets.all(width / 10.0),
                width: width,
                child: const Image(
                  image: AssetImage('assets/images/logo.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(
              height: 40.0,
            ),
            // Container(
            //   color: active == 0 ? (!darkmode ? Color(0xffF5C666) : Color(0xFF343A40)) : Colors.transparent,
            //   child: ListTile(
            //     contentPadding: const EdgeInsets.symmetric(
            //       horizontal: 20.0,
            //     ),
            //     title: Text(
            //       'Scan QR Code',
            //       style: TextStyle(
            //         color: active == 0
            //             ? Colors.white
            //             : !darkmode
            //                 ? Colors.black
            //                 : Colors.white,
            //         fontSize: 15.0,
            //         fontWeight: active == 0 ? FontWeight.w600 : FontWeight.w100,
            //         fontFamily: 'Spartan',
            //       ),
            //     ),
            //     onTap: () => onTap(
            //       context,
            //       0,
            //     ),
            //   ),
            // ),
            Container(
              color: active == 1 ? (!darkmode ? Color(0xffF5C666) : Color(0xFF343A40)) : Colors.transparent,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                ),
                title: Text(
                  'Fetch Event',
                  style: TextStyle(
                    color: active == 1
                        ? Colors.white
                        : !darkmode
                            ? Colors.black
                            : Colors.white,
                    fontSize: 15.0,
                    fontWeight: active == 1 ? FontWeight.w600 : FontWeight.w100,
                    fontFamily: 'Spartan',
                  ),
                ),
                onTap: () => onTap(
                  context,
                  1,
                ),
              ),
            ),
            Container(
              color: active == 2 ? (!darkmode ? Color(0xffF5C666) : Color(0xFF343A40)) : Colors.transparent,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                ),
                title: Text(
                  'Sync Ticket',
                  style: TextStyle(
                    color: active == 2
                        ? Colors.white
                        : !darkmode
                            ? Colors.black
                            : Colors.white,
                    fontSize: 15.0,
                    fontWeight: active == 2 ? FontWeight.w600 : FontWeight.w100,
                    fontFamily: 'Spartan',
                  ),
                ),
                onTap: () => onTap(
                  context,
                  2,
                ),
              ),
            ),
            // Container(
            //   color: active == 3
            //       ? (!darkmode ? Color(0xffF5C666) : Color(0xFF343A40))
            //       : Colors.transparent,
            //   child: ListTile(
            //     contentPadding: const EdgeInsets.symmetric(
            //       horizontal: 20.0,
            //     ),
            //     title: Text(
            //       'Import',
            //       style: TextStyle(
            //         color: active == 3
            //             ? Colors.white
            //             : !darkmode
            //                 ? Colors.black
            //                 : Colors.white,
            //         fontSize: 15.0,
            //         fontWeight: active == 3 ? FontWeight.w600 : FontWeight.w100,
            //         fontFamily: 'Spartan',
            //       ),
            //     ),
            //     onTap: () => onTap(
            //       context,
            //       3,
            //     ),
            //   ),
            // ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              title: Text(
                'Logout',
                style: TextStyle(
                  color: !darkmode ? Colors.black : Colors.white,
                  fontSize: 15.0,
                  fontFamily: 'Spartan',
                ),
              ),
              onTap: () => onTap(
                context,
                3,
              ),
              // onTap: () => {Navigator.of(context).pop()},
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 20),
                    color: Colors.transparent,
                    child: RichText(
                      text: TextSpan(
                        children: [
                          WidgetSpan(
                            child: Icon(
                              Icons.copyright,
                              color: darkmode ? Colors.white : Colors.black,
                              size: 15.0,
                            ),
                          ),
                          TextSpan(
                            text: ' ${DateFormat('yyyy').format(DateTime.now())} ',
                            style: TextStyle(
                              height: 1.4,
                              letterSpacing: 1.0,
                              fontSize: 10.0,
                              fontFamily: 'Spartan',
                              color: darkmode ? Colors.white : Colors.black,
                            ),
                          ),
                          WidgetSpan(
                            child: SizedBox(
                              height: 5.0,
                              width: width,
                            ),
                          ),
                          TextSpan(
                            text: 'DEWAUNITED',
                            style: TextStyle(
                              height: 1.4,
                              letterSpacing: 1.0,
                              fontSize: 10.0,
                              fontFamily: 'Spartan',
                              color: darkmode ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
