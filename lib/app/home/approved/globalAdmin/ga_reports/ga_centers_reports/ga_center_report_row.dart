import 'package:al_halaqat/app/models/study_center.dart';
import 'package:flutter/foundation.dart';

class GaCenterReportRow {
  GaCenterReportRow({
    @required this.center,
    @required this.numberOfStudents,
    @required this.numberOfTeachers,
    @required this.numberOfHalaqat,
  });

  final StudyCenter center;
  final int numberOfStudents;
  final int numberOfTeachers;
  final int numberOfHalaqat;
}
