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
  static const Normal = 2;
  static const Google = 3;
  static const Apple = 4;
}

class UserPrefernces {
  static const UserToken = 'UserToken';
  static const UserInfo = 'UserInfo';
  static const DoneSetup = 'DoneSetup';
}

class LawyerListType {
  static const Hire = 0;
  static const Save = 1;
}

class CaseType {
  static const Criminal = 1;
  static const Civil = 2;
  static const Custom = 3;
}

class SideMenuOption {
  static const HireLawyer = 'Hire Lawyer';
  static const SavedCases = 'Saved Cases';
  static const ViewBids = 'View Bids';
  static const CreateNewCase = 'Create New Case';
  static const SearchCases = 'Search Cases';
  static const EditProfile = 'Edit Profile';
  static const ChangePassword = 'Change Password';
}

class AppImage {

  static const CProfileImg = 'images/Client/ic_profile.jpeg';
}