import 'package:flutter/material.dart';

Widget textFieldInput(String label, TextEditingController result, bool error, String hint, width, bool obsecure, Function view) {
  return Container(
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.12),
          spreadRadius: 2,
          blurRadius: 14,
          offset: const Offset(3, 4), // changes x,y position of shadow
        ),
      ],
    ),
    child: Column(
      // ignore: prefer_const_literals_to_create_immutables
      children: [
        Container(
          width: width,
          height: 14.0,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(10.0),
            ),
          ),
          child: const Text(''),
        ),
        SizedBox(
          height: 45.0,
          child: TextField(
            // cursorHeight: 16.0,
            controller: result,
            obscureText: obsecure ? true : false,
            autofocus: true,
            style: const TextStyle(
              fontFamily: 'Spartan',
              fontSize: 13.0,
              fontWeight: FontWeight.w600,
              color: Color(0xFFA2A4A3),
            ),
            decoration: InputDecoration(
              labelText: label,
              labelStyle: const TextStyle(
                fontFamily: 'Spartan',
                fontSize: 12.0,
                fontWeight: FontWeight.w800,
                color: Color(0xFFA2A4A3),
              ),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintText: hint,
              hintStyle: const TextStyle(
                fontFamily: 'Spartan',
                fontSize: 13.0,
                fontWeight: FontWeight.w500,
                color: Color(0xFFD6D6D6),
              ),
              fillColor: Colors.white,
              filled: true,
              prefixIcon: label == 'EMAIL'
                  ? const Padding(
                      padding: EdgeInsets.only(bottom: 13.0, top: 2.0),
                      child: Image(
                        image: AssetImage('assets/images/email.png'),
                        fit: BoxFit.contain,
                      ),
                    )
                  : label == 'CODE'
                      ? const Padding(
                          padding: EdgeInsets.only(bottom: 16.0, top: 2.0),
                          child: Image(
                            image: AssetImage('assets/images/qr-icon.png'),
                            fit: BoxFit.contain,
                          ),
                        )
                      : const Padding(
                          padding: EdgeInsets.only(bottom: 16.0, top: 2.0),
                          child: Image(
                            image: AssetImage('assets/images/lock.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
              suffixIcon: label == 'EMAIL' || label == 'CODE'
                  ? null
                  : GestureDetector(
                      onTap: () {
                        view();
                      },
                      child: obsecure
                          ? const Padding(
                              padding: EdgeInsets.only(bottom: 18.0, top: 2.0, left: 5.0, right: 5.0),
                              child: Image(
                                image: AssetImage('assets/images/eye.png'),
                                fit: BoxFit.contain,
                              ),
                            )
                          : const Padding(
                              padding: EdgeInsets.only(bottom: 13.0, top: 4.0, left: 5.0, right: 5.0),
                              child: Image(
                                image: AssetImage('assets/images/eye-close.png'),
                                fit: BoxFit.contain,
                              ),
                            ),
                    ),
              contentPadding: const EdgeInsets.only(bottom: 0.0),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(10.0),
                ),
                borderSide: BorderSide(
                  color: Colors.transparent,
                  width: 1.0,
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(10.0),
                ),
                borderSide: BorderSide(
                  color: Colors.transparent,
                  width: 1.0,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
