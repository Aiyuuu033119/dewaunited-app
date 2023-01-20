import 'package:flutter/material.dart';
import 'package:dewaunited/compose/back.dart';
import 'package:flutter/services.dart';

class ImportEvent extends StatefulWidget {
  final Map data;
  final String accessToken;
  final String tokenType;
  final bool darkMode;

  const ImportEvent(
      {super.key,
      required this.data,
      required this.accessToken,
      required this.tokenType,
      required this.darkMode});

  @override
  State<ImportEvent> createState() => _ImportEventState();
}

class _ImportEventState extends State<ImportEvent> {
  Back back = Back();
  int index = 0;

  String accessToken = "";
  String tokenType = "";
  bool darkMode = false;

  Map data = {};

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
    // double width = MediaQuery.of(context).size.width;
    // bool isPortrait =
    //     MediaQuery.of(context).orientation == Orientation.portrait;

    return WillPopScope(
      onWillPop: () async => back.onWillPop(context),
      child: Scaffold(
        backgroundColor: !widget.darkMode ? Colors.white : Color(0xFF212529),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Text("Import"),
          ),
        ),
      ),
    );
  }
}
