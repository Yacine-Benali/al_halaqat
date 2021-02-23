import 'package:alhalaqat/app/home/approved/admin/admin_teachers/teacher_profile/a_teacher_profile_provider.dart';
import 'package:alhalaqat/app/models/halaqa.dart';
import 'package:alhalaqat/app/models/study_center.dart';
import 'package:alhalaqat/app/models/teacher.dart';
import 'package:alhalaqat/app/models/teacher_center_attendance.dart';
import 'package:flutter/material.dart';

class ATeacherProfileBloc {
  ATeacherProfileBloc({
    @required this.provider,
    @required this.teacher,
    @required this.halaqatList,
    @required this.studyCenter,
  });

  final ATeacherProfileProvider provider;
  final Teacher teacher;
  final List<Halaqa> halaqatList;
  final StudyCenter studyCenter;

  List<String> getTabBarTitles() {
    List<String> titlesList = List();
    titlesList.add('ملف شخصي');
    titlesList.add('حضور في ${studyCenter.name}');

    return titlesList;
  }

  Stream<List<TeacherCenterAttendance>> fetchTCenterAttendance() =>
      provider.getTCenterAttendaceList(studyCenter.id, teacher.id);

  Future<void> saveTcenterAttendance(
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
