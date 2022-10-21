import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Sidebar extends StatelessWidget {
  final Function onTap;
  final int active;
  final String darkmode;

  // ignore: prefer_const_constructors_in_immutables
  Sidebar(
      {Key? key,
      required this.darkmode,
      required this.active,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Drawer(
      child: Container(
        color: Colors.white,
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
                color: Colors.white,
                border: Border.all(
                  width: 0.0,
                  color: Colors.white,
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
            Container(
              color: active == 0 ? const Color(0xffF5C666) : Colors.transparent,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
                title: Text('Home',
                    style: TextStyle(
                        color: active == 0 ? Colors.white : Colors.black,
                        fontSize: 13.0,
                        fontFamily: 'Spartan')),
                onTap: () => onTap(context, 3),
                // onTap: () => {Navigator.of(context).pop()},
              ),
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
              title: Text('Logout',
                  style: TextStyle(
                      color: darkmode == "0" ? Colors.black : Colors.white,
                      fontSize: 13.0,
                      fontFamily: 'Spartan')),
              onTap: () => onTap(context, 1),
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
                              color:
                                  darkmode == "1" ? Colors.white : Colors.black,
                              size: 15.0,
                            ),
                          ),
                          TextSpan(
                            text:
                                ' ${DateFormat('yyyy').format(DateTime.now())} ',
                            style: TextStyle(
                              height: 1.4,
                              letterSpacing: 1.0,
                              fontSize: 10.0,
                              fontFamily: 'Spartan',
                              color:
                                  darkmode == "1" ? Colors.white : Colors.black,
                            ),
                          ),
                          WidgetSpan(
                            child: SizedBox(
                              height: 5.0,
                              width: width,
                            ),
                          ),
                          TextSpan(
                            text: 'DEWA UNITED',
                            style: TextStyle(
                              height: 1.4,
                              letterSpacing: 1.0,
                              fontSize: 10.0,
                              fontFamily: 'Spartan',
                              color:
                                  darkmode == "1" ? Colors.white : Colors.black,
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
