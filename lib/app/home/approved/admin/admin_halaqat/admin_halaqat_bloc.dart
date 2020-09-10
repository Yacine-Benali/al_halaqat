import 'package:al_halaqat/app/home/approved/admin/admin_halaqat/admin_halaqat_provider.dart';
import 'package:al_halaqat/app/logs_helper/logs_helper_bloc.dart';
import 'package:al_halaqat/app/models/halaqa.dart';
import 'package:al_halaqat/app/models/study_center.dart';
import 'package:al_halaqat/app/models/teacher.dart';
import 'package:al_halaqat/app/models/user.dart';
import 'package:al_halaqat/app/models/user_halaqa.dart';
import 'package:al_halaqat/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class AdminHalaqaBloc {
  AdminHalaqaBloc({
    @required this.provider,
    @required this.admin,
    @required this.auth,
    @required this.logsHelperBloc,
  });

  final AdminHalaqatProvider provider;
  final User admin;
  final Auth auth;
  final LogsHelperBloc logsHelperBloc;

  // ignore: missing_return
  Stream<UserHalaqa<Teacher>> fetchTeachers(
    List<StudyCenter> centersList,
  ) {
    List<String> centerIds = centersList.map((e) => e.id).toList();
    if (centerIds.length <= 10) {
      Stream<List<Teacher>> teachersStream = provider.fetchTeachers(centerIds);
      Stream<List<Halaqa>> halaqatStream = provider.fetchHalaqat(centerIds);
      Stream<UserHalaqa<Teacher>> teachersHalaqatStream = Rx.combineLatest2(
          teachersStream,
          halaqatStream,
          (a, b) => UserHalaqa<Teacher>(usersList: a, halaqatList: b));
      return teachersHalaqatStream;
    } else {
      print('huston we got a problem');
    }
  }

  Future<void> createHalaqa(
    Halaqa halaqa,
    StudyCenter chosenCenter,
  ) async {
    if (halaqa.id == null) {
      halaqa.id = provider.getUniqueId();
      halaqa.createdBy = {
        'name': admin.name,
        'id': admin.id,
      };
      halaqa.centerId = chosenCenter.id;
      halaqa.state = 'approved';
      return await Future.wait([
        logsHelperBloc.adminHalaqaLog(
            admin, halaqa, ObjectAction.add, chosenCenter),
        provider.createHalaqa(halaqa)
      ]);
    } else {
      return await Future.wait([
        logsHelperBloc.adminHalaqaLog(
            admin, halaqa, ObjectAction.edit, chosenCenter),
        provider.createHalaqa(halaqa)
      ]);
    }
  }

  List<Halaqa> getFilteredHalaqatList(
    List<Halaqa> data,
    String chosenHalaqaState,
    StudyCenter center,
  ) {
    List<Halaqa> filteredHalaqatList = List();

    for (Halaqa halaqa in data) {
      if (halaqa.state == chosenHalaqaState && halaqa.centerId == center.id) {
        filteredHalaqatList.add(halaqa);
      }
    }
    return filteredHalaqatList;
  }

  Future<void> executeAction(
    Halaqa halaqa,
    String action,
    StudyCenter chosenCenter,
  ) async {
    switch (action) {
      case 'reApprove':
        halaqa.state = 'approved';
        await Future.wait([
          logsHelperBloc.adminHalaqaLog(
              admin, halaqa, ObjectAction.edit, chosenCenter),
          provider.createHalaqa(halaqa)
        ]);
        break;
      case 'archive':
        halaqa.state = 'archived';
        await Future.wait([
          logsHelperBloc.adminHalaqaLog(
              admin, halaqa, ObjectAction.edit, chosenCenter),
          provider.createHalaqa(halaqa)
        ]);
        break;
      case 'delete':
        halaqa.state = 'deleted';
        await Future.wait([
          logsHelperBloc.adminHalaqaLog(
              admin, halaqa, ObjectAction.delete, chosenCenter),
          provider.createHalaqa(halaqa)
        ]);
        break;
    }
  }

  Teacher getTeacherOfHalaqa(Halaqa halaqa, List<Teacher> teachersList) {
    for (Teacher teacher in teachersList)
      if (teacher.halaqatTeachingIn.contains(halaqa.id)) return teacher;
    return null;
  }
}
