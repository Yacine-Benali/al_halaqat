import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

extension TimeOfDay2 on TimeOfDay {
  /// on equal will return false
  bool isLaterThen(TimeOfDay other) {
    if (this.hour > other.hour)
      return true;
    else if (this.hour == other.hour && this.minute >= other.minute)
      return true;
    else
      return false;
  }
}

TimeOfDay timeOfDayFromString(String hourMinute) {
  int hour = int.parse((hourMinute.substring(0, 2)));
  int minute = int.parse((hourMinute.substring(2, 4)));
  return TimeOfDay(hour: hour, minute: minute);
}

String timeOfDayToString(TimeOfDay timeOfDay) {
  var hour = timeOfDay.hour.toString();
  var minutes = timeOfDay.minute.toString();
  if (hour.length == 1) hour = '0' + hour;
  if (minutes.length == 1) minutes = '0' + minutes;

  String time = hour + minutes;
  return time;
}

class TeacherCenterAttendance {
  TeacherCenterAttendance({
    @required this.id,
    @required this.date,
    @required this.timeIn,
    @required this.timeOut,
    @required this.note,
  });
  String id;
  final Timestamp date;
  final TimeOfDay timeIn;
  final TimeOfDay timeOut;
  final String note;

  factory TeacherCenterAttendance.fromMap(
      Map<String, dynamic> data, String id) {
    if (data == null) {
      return null;
    }
    final Timestamp date = data['date'];
    final String tempIn = data['timeIn'];
    final TimeOfDay timeIn = timeOfDayFromString(tempIn);
    final String tempOut = data['timeOut'];
    final TimeOfDay timeOut = timeOfDayFromString(tempOut);

    ;
    final String note = data['note'];
    return TeacherCenterAttendance(
      id: id,
      date: date,
      timeIn: timeIn,
      timeOut: timeOut,
      note: note,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'timeIn': timeOfDayToString(timeIn),
      'timeOut': timeOfDayToString(timeOut),
      'note': note,
    };
  }

  @override
  String toString() {
    print("""
      date: $date,\n
      timeIn: ${timeOfDayToString(timeIn)},\n
      timeOut: ${timeOfDayToString(timeOut)},\n
      note: $note,\n
      """);
    return super.toString();
  }
}
