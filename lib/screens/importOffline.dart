import 'dart:io';

import 'package:dewaunited/compose/back.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImportOffline extends StatefulWidget {
  const ImportOffline({Key? key}) : super(key: key);

  @override
  State<ImportOffline> createState() => _ImportOfflineState();
}

class _ImportOfflineState extends State<ImportOffline> {
  Back back = Back();

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

    return WillPopScope(
      onWillPop: () async => back.onWillPop(context),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            TextEditingController().clear();
          },
          child: SafeArea(
            child: SingleChildScrollView(
              child: SizedBox(
                height: height,
                child: Stack(
                  children: [
                    Positioned(
                      width: width,
                      top: 0,
                      right: 0,
                      child: const Image(
                        image: AssetImage('assets/images/bg-top.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                    Positioned(
                      width: width,
                      top: 20.0,
                      left: 20.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                      ),
                    ),
                    Positioned(
                      width: width,
                      bottom: 0,
                      right: 0,
                      child: const Image(
                        image: AssetImage('assets/images/bg-bottom.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 30.0, right: 30.0, bottom: 60.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 40.0,
                          ),
                          SizedBox(
                            width: width,
                            child: const Text(
                              'Import Database',
                              style: TextStyle(
                                  fontSize: 30.0,
                                  fontFamily: 'Spartan',
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black),
                            ),
                          ),
                          const SizedBox(
                            height: 50.0,
                          ),
                          Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(15.0),
                              ),
                            ),
                            margin:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            width: width / 1.5,
                            child: Image(
                              image: AssetImage('assets/images/db.png'),
                              fit: BoxFit.fill,
                            ),
                          ),
                          const SizedBox(
                            height: 35.0,
                          ),
                          Container(
                            width: width,
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: GestureDetector(
                                onTap: () async {
                                  openFile();
                                },
                                child: Container(
                                  width: width,
                                  height: 60.0,
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xffE1B763)
                                            .withOpacity(0.75),
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
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          top: width >= 375 ? 8.0 : 5.0),
                                      child: Text(
                                        "IMPORT",
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
                          const SizedBox(
                            height: 30.0,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void openFile() async {
    final prefs = await SharedPreferences.getInstance();
    var result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
    );

    if (result == null) return;

    if (result.files[0].name.split(".").last == "db") {
      getFile(result.files[0].path, result.files[0].name);
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
                        'File Invalid!',
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

  Future getFile(url, filename) async {
    final file = await downloadFile(url, filename);
    if (file == null) return;
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
                      'Successfully Import!',
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

  Future<File?> downloadFile(url, filename) async {
    try {
      Directory? directory;

      directory = await getExternalStorageDirectory();
      String newPath = "";
      List paths = directory!.path.split("/");
      for (int x = 1; x < paths.length; x++) {
        String folder = paths[x];
        if (folder != "data") {
          newPath += "/" + folder;
        } else {
          break;
        }
      }

      directory = Directory(newPath + "/media/com.example.dewaunited/Backup");

      File oldFile = File(
          newPath + "/media/com.example.dewaunited/Database/dewaunited.db");
      File saveFile = File(url);

      // ignore: unrelated_type_equality_checks
      if (oldFile.exists() == true) {
        await oldFile.delete();
      }

      await saveFile.copy(
          newPath + "/media/com.example.dewaunited/Database/dewaunited.db");

      return saveFile;
    } catch (e) {
      return null;
    }
  }
}
