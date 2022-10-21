import 'package:flutter/animation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class Back {
  DateTime currentBackPressTime = DateTime.now();

  Future<bool> onWillPop(context) async {
    DateTime now = DateTime.now();
    if (now.difference(currentBackPressTime) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      showToast(
        "Exit Warning",
        context: context,
        animation: StyledToastAnimation.fade,
        reverseAnimation: StyledToastAnimation.fade,
        position: StyledToastPosition.bottom,
        animDuration: const Duration(seconds: 1),
        duration: const Duration(seconds: 4),
        curve: Curves.elasticOut,
        reverseCurve: Curves.linear,
      );
      return Future.value(false);
    } else {
      SystemNavigator.pop();
      return Future.value(true);
    }
  }
}
