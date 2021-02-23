import 'package:alhalaqat/app/home/approved/teacher/teacher_center_request/teacher_center_request_provider.dart';
import 'package:alhalaqat/app/models/center_request.dart';
import 'package:alhalaqat/app/models/study_center.dart';
import 'package:alhalaqat/app/models/teacher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TeacherCenterRequestBloc {
  TeacherCenterRequestBloc({
    @required this.provider,
    @required this.teacher,
  });

  final TeacherCenterRequestProvider provider;
  final Teacher teacher;

  Future<void> sendJoinRequest(String centerId) async {
    List<String> centersIdList = teacher.centerState.keys.toList();
    StudyCenter center = await provider.queryCenterbyRId(centerId);
    if (center == null) {
      throw PlatformException(
        code: 'CENTE_DOES_NOT_EXIST',
        message: 'لا يوجد مركز بذلك الرقم التعريفي',
      );
    } else if (centersIdList.contains(center.id)) {
      return;
    } else {
      teacher.centerState[center.id] = 'pending';
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
