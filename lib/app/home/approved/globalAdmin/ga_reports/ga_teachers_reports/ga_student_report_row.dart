import 'package:al_halaqat/app/models/student.dart';
import 'package:al_halaqat/app/models/study_center.dart';
import 'package:flutter/foundation.dart';

class GaStudentReportRow {
  GaStudentReportRow({
    @required this.student,
    @required this.center,
  });

  final Student student;
  final StudyCenter center;
}
