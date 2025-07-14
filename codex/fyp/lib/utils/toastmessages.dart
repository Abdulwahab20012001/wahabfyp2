//import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'dart:ui';

import 'package:flutter/src/material/colors.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp/utils/app_colors.dart';

class Messages {
  static toastmessages(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Mycolors.Text_white,
      textColor: Mycolors.Text_black,
      fontSize: 16,
    );
  }

  static void showToast(
      {required String msg,
      required Toast toastLength,
      required ToastGravity gravity,
      required int timeInSecForIosWeb,
      required MaterialColor backgroundColor,
      required Color textColor,
      required double fontSize}) {}
}
