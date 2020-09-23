import 'package:alhalaqat/app/models/study_center.dart';
import 'package:alhalaqat/app/models/teacher.dart';
import 'package:flutter/foundation.dart';

class GaTeacherReportRow {
  GaTeacherReportRow({
    @required this.teacher,
    @required this.center,
    @required this.state,
  });

  final Teacher teacher;
  final StudyCenter center;
  final String state;
}
