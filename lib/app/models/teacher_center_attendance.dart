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

TimeOfDay timeOfDayFromInt(int hourMinute) {
  int hour = int.parse((hourMinute.toString().substring(0, 2)));
  int minute = int.parse((hourMinute.toString().substring(2, 4)));
  return TimeOfDay(hour: hour, minute: minute);
}

int timeOfDayToInt(TimeOfDay timeOfDay) {
  return timeOfDay.hour * 100 + timeOfDay.minute;
  print(timeOfDay.hour.toString() + '***' + timeOfDay.minute.toString());
  return int.parse(timeOfDay.hour.toString() + timeOfDay.minute.toString());
}

class TeacherCenterAttendance {
  TeacherCenterAttendance({
    @required this.id,
    @required this.date,
    @required this.timeIn,
    @required this.timeOut,
    @required this.noSessions,
    @required this.noHours,
    @required this.note,
  });
  String id;
  final Timestamp date;
  final TimeOfDay timeIn;
  final TimeOfDay timeOut;
  final int noSessions;
  final int noHours;
  final String note;

  factory TeacherCenterAttendance.fromMap(
      Map<String, dynamic> data, String id) {
    if (data == null) {
      return null;
    }
    final Timestamp date = data['date'];
    final int tempIn = data['timeIn'];
    final TimeOfDay timeIn = timeOfDayFromInt(tempIn);
    final int tempOut = data['timeOut'];
    final TimeOfDay timeOut = timeOfDayFromInt(tempOut);

    final int noSessions = data['noSessions'];
    final int noHours = data['noHours'];
    final String note = data['note'];
    return TeacherCenterAttendance(
      id: id,
      date: date,
      timeIn: timeIn,
      timeOut: timeOut,
      noSessions: noSessions,
      noHours: noHours,
      note: note,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'timeIn': timeOfDayToInt(timeIn),
      'timeOut': timeOfDayToInt(timeOut),
      'noSessions': noSessions,
      'noHours': noHours,
      'note': note,
    };
  }

  @override
  String toString() {
    print("""
      date: $date,\n
      timeIn: ${timeOfDayToInt(timeIn)},\n
      timeOut: ${timeOfDayToInt(timeOut)},\n
      noSessions: $noSessions,\n
      noHours: $noHours,\n
      note: $note,\n
      """);
    return super.toString();
  }
}
