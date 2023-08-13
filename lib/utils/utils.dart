import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:bloc/bloc.dart';
import 'package:home_widget/home_widget.dart';

import 'package:scribble/bloc/register/register_bloc.dart';

class Utils {
  static const platformChannel = MethodChannel("widgets.emirs.scribble");

  static validatePhone(String value, Emitter emit) {
    String pattern = r"^\+((?:9[679]|8[035789]|6[789]|5[90]|42|3[578]|2[1-689])|9[0-58]|8[1246]|6[0-6]|5[1-8]|4[013-9]|3[0-469]|2[70]|7|1)(?:\W*\d){0,13}\d$";
    RegExp regExp = RegExp(pattern);

    if (value.isEmpty) {
      emit(RegisterPhoneEmpty());
    }
    else if (!regExp.hasMatch(value)) {
      emit(RegisterPhoneInvalid());
    } else {
      emit(RegisterPhoneValid());
    }
  }

  static alertPopup(BuildContext context, String message) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  static updateWidget(String? url, String? sentBy) {
    HomeWidget.saveWidgetData("scribb_url", url);
    HomeWidget.saveWidgetData("sent_by", sentBy);
    HomeWidget.updateWidget(
      iOSName: "Scribble",
      androidName: "HomeWidgetProvider"
    );
  }

  static Future<bool> getWidgetStatus() async {
    final bool result = await platformChannel.invokeMethod("getWidgetStatus");

    return result;
  }
}