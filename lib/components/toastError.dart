import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

void errorToast(context, errorDesc) {
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
                children: [
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
                    errorDesc,
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
