import 'package:flutter/foundation.dart';

class LocalTCAReport {
  int hoursThought;
  int noSessions;
  int hoursStayed;
  String teacherName;

  LocalTCAReport({
    this.hoursThought = 0,
    this.noSessions = 0,
    this.hoursStayed = 0,
    @required this.teacherName,
  });
}
