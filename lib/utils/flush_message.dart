import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:knot_iq/utils/colors.dart';

class FlushMessages {
  static Future<void> commonToast(String msg, {Color? backGroundColor}) {
    return Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: backGroundColor ?? Appcolors.primaryColor,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
