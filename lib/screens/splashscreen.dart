import 'dart:async';
import 'package:dewaunited/components/dialog.dart';
import 'package:dewaunited/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<SharedPreferences> loginData = SharedPreferences.getInstance();

  double progressValue = 0.0;

  String accessToken = "";
  String tokenType = "";

  int page = 1;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
    check();
    saveDatabase();
  }

  Future<bool> createFile() async {
    Directory? directory;
    try {
      final prefs = await SharedPreferences.getInstance();

      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.storage)) {
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
          newPath = newPath + "/media/com.example.dewaunited/Database";
          directory = Directory(newPath);
        } else {
          dialogModal(
              context,
              "App will not work unless you accept the permission",
              "Reminder", (ctx) async {
            saveDatabase();
            Navigator.pop(context);
            return false;
          }, false);
          return false;
        }
      }

      if (directory != null) {
        File saveFile = File(directory.path + "/dewaunited.db");
        setState(() {
          prefs.setString("dbPath", directory!.path + "/dewaunited.db");
        });
        if (!await directory.exists()) {
          await directory.create(recursive: true);
          saveFile.writeAsString("");
          updateProgress();
          return true;
        }
        if (await directory.exists()) {
          updateProgress();
        }
      }

      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  saveDatabase() async {
    await createFile();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            // height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: width / 4,
                  height: height - (height * 0.10),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: height * 0.07),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: LinearProgressIndicator(
                      minHeight: 6.0,
                      backgroundColor: const Color(0xFF8A7346),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFFF5C666)),
                      value: progressValue,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void updateProgress() {
    const oneSec = Duration(seconds: 1);
    Timer.periodic(
      oneSec,
      (Timer timer) => {
        if (mounted)
          {
            setState(
              () {
                progressValue += 0.1;
                // we "finish" downloading here
                if (progressValue.toStringAsFixed(1) == '1.0') {
                  timer.cancel();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Login(),
                    ),
                  );
                  return;
                }
              },
            )
          }
      },
    );
  }

  void check() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      accessToken = prefs.getString("access_token")!;
      tokenType = prefs.getString("token_type")!;
    });

    if (accessToken.isNotEmpty && tokenType.isNotEmpty) {
      setState(() {
        page = 2;
      });
    }
  }

  // Widget nextScreen(page) {
  //   if (page == 1) {
  //     return Login();
  //   } else {
  //     return Home(
  //       isStillLogin: 1,
  //       active: 0,
  //     );
  //   }
  // }
}
