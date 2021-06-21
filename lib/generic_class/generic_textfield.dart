import 'package:flutter/material.dart';
import 'package:my_lawyer/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

TextField appThemeTextField(
  String hintText,
  TextInputType textInputType,
  TextEditingController controller, {
  String prefixIcon = '',
  String suffixIcon = '',
}) {
  return TextField(
      controller: controller,
      keyboardType: textInputType,
      cursorColor: AppColor.ColorGrayTextFieldHint,
      decoration: InputDecoration(
          hintText: hintText,
          hintStyle: appThemeTextStyle(16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColor.ColorGrayBoarder, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColor.ColorGrayBoarder, width: 1),
          ),

          // border: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(8),
          //   borderSide: BorderSide(color: AppColor.ColorGrayBoarder)
          // ),
          prefixIcon: Icon(Icons.email) //ImageIcon(AssetImage(prefixIcon)),
          // suffixIcon: ImageIcon(AssetImage(suffixIcon)),
          ));
}

TextStyle appThemeTextStyle(double fontSize,
    {Color textColor = AppColor.ColorGrayTextFieldHint,
    FontWeight fontWeight = FontWeight.w400,
    double letterSpacing = 0.0,
    double height = 1,
    bool isShowUnderline = false}) {
  return TextStyle(
      fontFamily: 'Overpass',
      fontWeight: fontWeight,
      fontSize: ScreenUtil().setSp(fontSize),
      color: textColor,
      letterSpacing: letterSpacing,
      height: height,
      decoration:
          (isShowUnderline) ? TextDecoration.underline : TextDecoration.none);
}
