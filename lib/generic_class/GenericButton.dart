import 'package:flutter/material.dart';
import 'package:my_lawyer/generic_class/GenericTextfield.dart';
import 'package:my_lawyer/utils/AppColors.dart';
import 'dart:core';

class GenericButton {

  Widget appThemeButton(String title, double fontSize, Color textColor,
      FontWeight fontWeight, Function function,
      {Color bgColor = AppColor.ColorRed, double borderRadius = 5}) {
    return Container(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius)
          )
        ),
        child: Text(
          title,
          style: appThemeTextStyle(fontSize,
              fontWeight: fontWeight, textColor: textColor),
        ),
        onPressed: function,
      ),
    );
  }
}
