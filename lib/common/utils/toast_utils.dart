import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastUtils {
  showError(String mess) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
        msg: mess,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  showSuccess(String mess) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
        msg: mess,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  showWarning(String mess) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
        msg: mess,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.yellow,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
