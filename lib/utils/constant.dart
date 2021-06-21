import 'package:flutter/material.dart';

double screenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double screenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double getAspectHeight(BuildContext context, double height) {
  return (screenHeight(context) * height)/812;
}

double getAspectWidth(BuildContext context, double width) {
  return (screenWidth(context) * width)/375;
}
