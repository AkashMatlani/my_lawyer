
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePicker {

  Future<Map<String, dynamic>> selectDate(String format, DateTime initialDate, BuildContext context) async {
    var date = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2100));

    if (date != null) {
      String dateStr = DateFormat(format).format(date);
      return {'selectedDate': dateStr, 'date': date};
    }
  }

  Future<Map<String, dynamic>> selectTime(BuildContext context, TimeOfDay initialTime) async {

    var time = await showTimePicker(context: context, initialTime: initialTime);

    if (time != null) {
      var hours = time.hour.toString();
      var minute = time.minute.toString();
      return {'selectedTime': '$hours:$minute', 'time': time};
    }
  }
}

