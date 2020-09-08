import 'package:flutter/foundation.dart';

class CenterNumbers {
  final String centerName;
  final int activeStudents;
  final int activeTeachers;
  final int activeHalaqat;

  final int archivedStudents;
  final int archivedTeachers;
  final int archivedHalaqat;

  CenterNumbers({
    @required this.centerName,
    @required this.activeStudents,
    @required this.activeTeachers,
    @required this.activeHalaqat,
    @required this.archivedStudents,
    @required this.archivedTeachers,
    @required this.archivedHalaqat,
  });
}
