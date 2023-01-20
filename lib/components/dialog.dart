import 'package:flutter/material.dart';

void dialogModal(BuildContext context, String contentMsg, String title,
    Function open, bool darkmode) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: !darkmode ? Colors.white : Color(0xFF212529),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          contentPadding: EdgeInsets.all(20.0),
          insetPadding: EdgeInsets.symmetric(horizontal: 30.0),
          content: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Theme(
                data: ThemeData(
                    unselectedWidgetColor:
                        !darkmode ? Colors.black26 : Colors.white),
                child: Column(
                  children: [
                    if (title == "Success")
                      Icon(
                        Icons.check_circle_outline,
                        size: 50.0,
                        color: !darkmode ? Color(0xFF8A7346) : Colors.white,
                      ),
                    if (title == "Reminder")
                      Icon(
                        Icons.error_outline,
                        size: 50.0,
                        color: !darkmode ? Color(0xFF8A7346) : Colors.white,
                      ),
                    if (title == "Error")
                      Icon(
                        Icons.cancel_outlined,
                        size: 50.0,
                        color: !darkmode ? Color(0xFF8A7346) : Colors.white,
                      ),
                    if (title == "Delete")
                      Icon(
                        Icons.cancel_outlined,
                        size: 50.0,
                        color: Color(0xfff85149),
                      ),
                    SizedBox(
                      height: 25.0,
                    ),
                    Text(
                      contentMsg,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13.0,
                        fontFamily: 'Spartan',
                        color: !darkmode ? Colors.black : Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    if (title == "Success")
                      GestureDetector(
                        onTap: () async {
                          open(context);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 55.0,
                          decoration: BoxDecoration(
                            // boxShadow: [
                            //   BoxShadow(
                            //     color:
                            //         const Color(0xffE1B763).withOpacity(1.0),
                            //     spreadRadius: 1,
                            //     blurRadius: 12,
                            //     offset: const Offset(
                            //         0, 4), // changes x,y position of shadow
                            //   ),
                            // ],
                            color: const Color(0xffE1B763),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(35.0),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              "OKAY",
                              style: TextStyle(
                                fontSize: 13.0,
                                fontFamily: 'Spartan',
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (title == "Reminder")
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              open(context);
                            },
                            child: Container(
                              width:
                                  ((MediaQuery.of(context).size.width - 100) /
                                          2) -
                                      5,
                              height: 55.0,
                              decoration: BoxDecoration(
                                // boxShadow: [
                                //   BoxShadow(
                                //     color:
                                //         const Color(0xffE1B763).withOpacity(1.0),
                                //     spreadRadius: 1,
                                //     blurRadius: 12,
                                //     offset: const Offset(
                                //         0, 4), // changes x,y position of shadow
                                //   ),
                                // ],
                                color: const Color(0xffE1B763),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(35.0),
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  "YES",
                                  style: TextStyle(
                                    fontSize: 13.0,
                                    fontFamily: 'Spartan',
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          GestureDetector(
                            onTap: () async {
                              Navigator.pop(context);
                            },
                            child: Container(
                              width:
                                  ((MediaQuery.of(context).size.width - 100) /
                                          2) -
                                      5,
                              height: 55.0,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color(0xffE1B763),
                                    width: 2.0,
                                    style: BorderStyle.solid),
                                color: Colors.transparent,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(35.0),
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  "CANCEL",
                                  style: TextStyle(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Spartan',
                                    color: Color(0xFF8A7346),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      });
}
