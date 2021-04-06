import 'package:flutter/foundation.dart';

class LocalTCAReport {
  int hoursStayed;
  String teacherName;

  LocalTCAReport({
    this.hoursStayed = 0,
    @required this.teacherName,
  });
}
