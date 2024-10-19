import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:instax/core/resources/color_manager.dart';

class ToastMessage {
  static toast(String toast) {
    return Fluttertoast.showToast(
      msg: toast,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: ColorManager.black,
      textColor: ColorManager.white,
    );
  }

  static toastStateError(dynamic state) {
    String error;
    try {
      error = state.error.spilt(RegExp(r']'))[1];
    } catch (e) {
      error = state.error;
    }

    if (kDebugMode) print("===> $error !!! the error in toast show");

    toast(error);
  }
}
