import 'package:al_halaqat/app/home/approved/teacher/teacher_halaqat/teacher_halaqat_provider.dart';
import 'package:al_halaqat/app/logs_helper/logs_helper_bloc.dart';
import 'package:al_halaqat/app/models/center_request.dart';
import 'package:al_halaqat/app/models/halaqa.dart';
import 'package:al_halaqat/app/models/study_center.dart';
import 'package:al_halaqat/app/models/teacher.dart';
import 'package:al_halaqat/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class TeacherHalaqaBloc {
  TeacherHalaqaBloc({
    @required this.provider,
    @required this.teacher,
    @required this.auth,
    @required this.logsHelperBloc,
  });

  final TeacherHalaqatProvider provider;
  final LogsHelperBloc logsHelperBloc;
  final Teacher teacher;
  final Auth auth;

  Stream<List<Halaqa>> fetchHalaqat(List<String> halaqatId) {
    List<List<String>> partitionedList = List();

    for (var i = 0; i < halaqatId.length; i += 10) {
      partitionedList.add(halaqatId.sublist(
          i, i + 10 > halaqatId.length ? halaqatId.length : i + 10));
    }
    List<Stream<List<Halaqa>>> halaqatStreamList = partitionedList
        .map((sublist) => provider.fetchHalaqat(sublist))
        .toList();

    return Rx.combineLatest(halaqatStreamList,
        (List<List<Halaqa>> values) => values.expand((x) => x).toList());
  }

  Future<void> editHalaqa(Halaqa halaqa, StudyCenter chosenCenter) async =>
      await Future.wait([
        logsHelperBloc.teacherHalaqaLog(teacher, halaqa, ObjectAction.edit),
        provider.editHalaqa(halaqa)
      ]);

  Future<void> creatHalaqa(Halaqa halaqa, StudyCenter chosenCenter) async {
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

      return await Future.wait([
        logsHelperBloc.teacherHalaqaLog(teacher, halaqa, ObjectAction.add),
        provider.createHalaqa(halaqa, teacher)
      ]);
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

      return await provider.createHalaqaRequest(
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
