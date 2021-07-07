import 'package:flutter/material.dart';
import 'package:my_lawyer/generic_class/GenericTextfield.dart';
import 'package:my_lawyer/utils/AppColors.dart';

class AlertView {
  showAlertView(BuildContext context, String message, Function onPressed,
      {String title = "My Lawyer", String action = "Okay"}) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title,
          style: appThemeTextStyle(18,
              textColor: AppColor.ColorRed, fontWeight: FontWeight.w700)),
      content: Text(
        message,
        style: appThemeTextStyle(16, textColor: AppColor.ColorRed),
      ),
      actions: [
        TextButton(
            onPressed: onPressed,
            child: Text(action,
                style: appThemeTextStyle(16,
                    textColor: AppColor.ColorRed, fontWeight: FontWeight.w700)))
      ],
    );

    showDialog(context: context, builder: (_) => alertDialog);
  }

  showAlertViewWithTwoButton(
      BuildContext context,
      String message,
      String action1,
      String action2,
      Function onPressedAction1,
      Function onPressedAction2,
      {String title = "My Lawyer"}) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
            onPressed: onPressedAction1,
            child: Text(
              action1,
              style: appThemeTextStyle(16),
            )),
        TextButton(
            onPressed: onPressedAction2,
            child: Text(
              action2,
              style: appThemeTextStyle(16),
            ))
      ],
    );

    showDialog(context: context, builder: (_) => alertDialog);
  }

  showAlert(String message, BuildContext context) {
    AlertView()
        .showAlertView(context, message, () => {Navigator.of(context).pop()});
  }

  void showToast(BuildContext context, String message) {
    SnackBar snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
