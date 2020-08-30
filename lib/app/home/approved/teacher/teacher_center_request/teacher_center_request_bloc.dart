import 'package:al_halaqat/app/home/approved/teacher/teacher_center_request/teacher_center_request_provider.dart';
import 'package:al_halaqat/app/models/center_request.dart';
import 'package:al_halaqat/app/models/study_center.dart';
import 'package:al_halaqat/app/models/teacher.dart';
import 'package:flutter/material.dart';

class TeacherCenterRequestBloc {
  TeacherCenterRequestBloc({
    @required this.provider,
    @required this.teacher,
  });

  final TeacherCenterRequestProvider provider;
  final Teacher teacher;

  Future<void> sendJoinRequest(String centerId) async {
    StudyCenter center = await provider.queryCenterbyRId(centerId);
    if (center == null) {
    } else {
      teacher.centerState[center.id] = 'pending';
      teacher.centers.add(center.id);
      CenterRequest joinRequest = CenterRequest(
        id: 'join-' + teacher.id,
        createdAt: null,
        userId: teacher.id,
        user: teacher,
        action: 'join-existing',
        state: 'pending',
        halaqa: null,
      );

      await provider.sendJoinRequest(teacher, joinRequest, center.id);
    }
  }
}
