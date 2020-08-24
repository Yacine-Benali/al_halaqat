import 'package:al_halaqat/app/home/approved/teacher/teacher_halaqat/teacher_halaqat_provider.dart';
import 'package:al_halaqat/app/models/center_request.dart';
import 'package:al_halaqat/app/models/halaqa.dart';
import 'package:al_halaqat/app/models/study_center.dart';
import 'package:al_halaqat/app/models/teacher.dart';
import 'package:al_halaqat/services/auth.dart';
import 'package:flutter/material.dart';

class TeacherHalaqaBloc {
  TeacherHalaqaBloc({
    @required this.provider,
    @required this.teacher,
    @required this.auth,
  });

  final TeacherHalaqatProvider provider;
  final Teacher teacher;
  final Auth auth;

  Stream<List<Halaqa>> fetchHalaqat(List<String> halaqatId) =>
      provider.fetchHalaqat(halaqatId);

  Future<void> editHalaqa(
    Halaqa halaqa,
    StudyCenter chosenCenter,
  ) async {
    await provider.editHalaqa(halaqa);
  }

  Future<void> creatHalaqa(
    Halaqa halaqa,
    StudyCenter chosenCenter,
  ) async {
    halaqa.id = provider.getUniqueId();
    halaqa.createdBy = {
      'name': teacher.name,
      'id': teacher.id,
    };
    halaqa.centerId = chosenCenter.id;
    if (teacher.halaqatTeachingIn == null) teacher.halaqatTeachingIn = List();

    teacher.halaqatTeachingIn.add(halaqa.id);
    if (chosenCenter.requestPermissionForHalaqaCreation == false) {
      halaqa.state = 'approved';

      await provider.createHalaqa(halaqa, teacher);
    } else {
      halaqa.state = 'pending';
      CenterRequest centerRequest = CenterRequest(
        id: provider.getUniqueId(),
        createdAt: null,
        userId: teacher.id,
        user: teacher,
        action: 'create-halaqa',
        state: 'pending',
        halaqa: halaqa,
      );

      await provider.createHalaqaRequest(
        halaqa,
        teacher,
        chosenCenter.id,
        centerRequest,
      );
    }
  }

  List<Halaqa> getFilteredHalaqatList(
      List<Halaqa> data, StudyCenter chosenCenter) {
    List<Halaqa> filteredHalaqat = List();

    for (Halaqa halaqa in data)
      if (halaqa?.centerId == chosenCenter.id) filteredHalaqat.add(halaqa);

    return filteredHalaqat;
  }
}
