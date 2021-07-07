import 'package:flutter/material.dart';
import 'package:my_lawyer/generic_class/GenericTextfield.dart';
import 'package:my_lawyer/utils/LoadingView.dart';

Widget widgetNotAvailableData(String message) {
  return Center(
    child: Text(
      message,
      style: appThemeTextStyle(16, fontWeight: FontWeight.w600),
    ),
  );
}

Widget showLoaderInList() {
  return Align(
    alignment: Alignment.center,
    child: LoadingView().loader(),
  );
}
