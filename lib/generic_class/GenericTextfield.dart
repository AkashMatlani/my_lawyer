import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_lawyer/utils/AppColors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

TextField appThemeTextField(
  String hintText,
  TextInputType textInputType,
  TextEditingController controller, {
  String prefixIcon = '',
  String suffixIcon = '',
  bool obscureText = false,
  int maxLines = 1,
  double bottomPaddingPrefixImg = 10,
  bool hasPrefixIcon = false,
  bool hasSuffixIcon = false,
      bool readOnly = false,
}) {
  return TextField(
      textAlignVertical: TextAlignVertical.center,
      maxLines: maxLines,
      controller: controller,
      keyboardType: textInputType,
      cursorColor: AppColor.ColorGrayTextFieldHint,
      obscureText: obscureText,
      autocorrect: false,
      // enabled: enabled,
      readOnly: readOnly,
      decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.only(left: 10, right: 0, bottom: 0, top: 0),
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
          prefixIcon: (hasPrefixIcon == true)
              ? Container(
                  padding:
                      EdgeInsets.fromLTRB(5, 10, 5, bottomPaddingPrefixImg),
                  child: SvgPicture.asset(prefixIcon),
                )
              : null,
          suffixIcon: (hasSuffixIcon == true)
              ? Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: SvgPicture.asset(suffixIcon),
                )
              : null));
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
