import 'package:al_halaqat/app/home/approved/teacher/teacher_halaqat/teacher_halaqat_provider.dart';
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

  Stream<List<Halaqa>> fetchHalaqat() =>
      provider.fetchHalaqat(teacher.halaqatTeachingIn);

  Future<void> createHalaqa(
    Halaqa halaqa,
    StudyCenter chosenCenter,
  ) async {
    //TODO create or creat request
    // if (halaqa.id == null) {
    //   halaqa.id = provider.getUniqueId();
    //   halaqa.createdBy = {
    //     'name': admin.name,
    //     'id': admin.id,
    //   };
    //   halaqa.centerId = chosenCenter.id;
    //   halaqa.state = 'approved';
    // }

    // await provider.createHalaqa(halaqa);
  }

  List<Halaqa> getFilteredHalaqatList(
      List<Halaqa> data, StudyCenter chosenCenter) {
    List<Halaqa> filteredHalaqat = List();

    for (Halaqa halaqa in data)
      if (halaqa.centerId == chosenCenter.id) filteredHalaqat.add(halaqa);

    return filteredHalaqat;
  }
}
