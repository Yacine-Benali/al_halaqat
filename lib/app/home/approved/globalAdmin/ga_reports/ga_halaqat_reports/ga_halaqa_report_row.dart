import 'package:al_halaqat/app/models/halaqa.dart';
import 'package:al_halaqat/app/models/study_center.dart';
import 'package:al_halaqat/app/models/teacher.dart';
import 'package:flutter/foundation.dart';

class GaHalaqaReportRow {
  GaHalaqaReportRow({
    @required this.halaqa,
    @required this.numberOfStudents,
    @required this.teacher,
    @required this.center,
  });

  final Halaqa halaqa;
  final int numberOfStudents;
  final Teacher teacher;
  final StudyCenter center;
}
