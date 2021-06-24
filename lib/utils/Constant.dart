import 'package:flutter/material.dart';

double screenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double screenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double getAspectHeight(BuildContext context, double height) {
  return (screenHeight(context) * height) / 812;
}

double getAspectWidth(BuildContext context, double width) {
  return (screenWidth(context) * width) / 375;
}

class UserType {
  static const User = 0;
  static const Lawyer = 1;
}

class SignInType {
  static const Normal = 0;
  static const Google = 1;
  static const Apple = 2;
}
