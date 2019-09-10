import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class GeneralUtils{
  static void showToast({
    String msg,
    Toast toastLength = Toast.LENGTH_SHORT,
    ToastGravity gravity = ToastGravity.BOTTOM,
    int timeInSecForIos = 2,
    Color backgroundColor = Colors.black,
    Color textColor = Colors.white,
    double fontSize = 15.0
  }){
    Fluttertoast.showToast(
      msg: msg,
      toastLength: toastLength,
      gravity: gravity,
      timeInSecForIos: timeInSecForIos,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: fontSize,
    );
  }
}