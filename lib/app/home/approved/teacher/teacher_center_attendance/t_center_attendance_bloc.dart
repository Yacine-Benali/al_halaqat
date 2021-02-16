import 'package:alhalaqat/app/home/approved/teacher/teacher_center_attendance/t_center_attendance_provider.dart';
import 'package:alhalaqat/app/models/study_center.dart';
import 'package:alhalaqat/app/models/teacher.dart';
import 'package:alhalaqat/app/models/teacher_center_attendance.dart';
import 'package:flutter/material.dart';

class TCenterAttendanceBloc {
  TCenterAttendanceBloc({
    @required this.provider,
    @required this.teacher,
  });

  final TCenterAttendanceProvider provider;
  final Teacher teacher;

  Stream<List<TeacherCenterAttendance>> fetchTCenterAttendance(
    StudyCenter studyCenter,
  ) =>
      provider.getTCenterAttendaceList(studyCenter.id, teacher.id);

  Future<void> saveTcenterAttendance(
    StudyCenter studyCenter,
    TeacherCenterAttendance teacherCenterAttendance,
  ) {
    if (teacherCenterAttendance.id == null) {
      teacherCenterAttendance.id = provider.getUniqueId();
    }
    return provider.saveTcenterAttendance(
      studyCenter.id,
      teacher.id,
      teacherCenterAttendance,
    );
  }
}
