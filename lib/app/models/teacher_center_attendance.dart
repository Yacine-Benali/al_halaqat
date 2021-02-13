import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

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
  final String id;
  final Timestamp date;
  final Timestamp timeIn;
  final Timestamp timeOut;
  final int noSessions;
  final int noHours;
  final String note;

  factory TeacherCenterAttendance.fromMap(
      Map<String, dynamic> data, String id) {
    if (data == null) {
      return null;
    }
    final Timestamp date = data['date'];
    final Timestamp timeIn = data['timeIn'];
    final Timestamp timeOut = data['timeOut'];
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
      'timeIn': timeIn,
      'timeOut': timeOut,
      'noSessions': noSessions,
      'noHours': noHours,
      'note': note,
    };
  }
}
