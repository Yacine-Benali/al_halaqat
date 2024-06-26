import 'package:alhalaqat/app/models/study_center.dart';
import 'package:flutter/foundation.dart';

class AdminCenterReportRow {
  AdminCenterReportRow({
    @required this.center,
    @required this.numberOfApprovedStudents,
    @required this.numberOfApprovedTeachers,
    @required this.numberOfApprovedHalaqat,
    @required this.numberOfArchivedStudents,
    @required this.numberOfArchivedTeachers,
    @required this.numberOfArchivedHalaqat,
  });

  final StudyCenter center;
  final int numberOfApprovedStudents;
  final int numberOfApprovedTeachers;
  final int numberOfApprovedHalaqat;
  final int numberOfArchivedStudents;
  final int numberOfArchivedTeachers;
  final int numberOfArchivedHalaqat;
}
