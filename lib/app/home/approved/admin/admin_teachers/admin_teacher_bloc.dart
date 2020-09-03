import 'package:al_halaqat/app/conversation_helper/conversation_helper_bloc.dart';
import 'package:al_halaqat/app/home/approved/admin/admin_teachers/admin_teacher_provider.dart';
import 'package:al_halaqat/app/models/halaqa.dart';
import 'package:al_halaqat/app/models/study_center.dart';
import 'package:al_halaqat/app/models/teacher.dart';
import 'package:al_halaqat/app/models/user.dart';
import 'package:al_halaqat/app/models/user_halaqa.dart';
import 'package:al_halaqat/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

class AdminTeacherBloc {
  AdminTeacherBloc({
    @required this.provider,
    @required this.admin,
    @required this.auth,
    @required this.conversationHelper,
  });

  final AdminTeachersProvider provider;
  final ConversationHelpeBloc conversationHelper;

  final User admin;
  final Auth auth;

  List<Halaqa> getAvailableHalaqat(List<Halaqa> halaqatList,
      List<Teacher> teachersList, StudyCenter chosenCenter) {
    List<Halaqa> availableHalaqa = List();

    for (Halaqa halaqa in halaqatList) {
      bool isFound = false;
      if (halaqa.centerId == chosenCenter.id) {
        for (Teacher teacher in teachersList) {
          if (teacher.halaqatTeachingIn.contains(halaqa.id)) {
            isFound = true;
          }
        }
        if (!isFound) {
          availableHalaqa.add(halaqa);
        }
      }
    }

    return availableHalaqa;
  }

  List<Halaqa> getFilteredHalaqaList(
    List<Halaqa> data,
    StudyCenter chosenCenter,
  ) {
    List<Halaqa> filteredStudentsList = List();

    for (Halaqa halaqa in data) {
      if (halaqa.centerId == chosenCenter.id) {
        filteredStudentsList.add(halaqa);
      }
    }
    return filteredStudentsList;
  }

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

  Future<void> modifieTeacher(Teacher oldTeacher, Teacher newTeacher) async {
    List<String> temp = List();
    for (String a in newTeacher.halaqatTeachingIn) {
      if (a != null) temp.add(a);
    }
    newTeacher.halaqatTeachingIn = temp;
    await conversationHelper.onTeacherModification(oldTeacher, newTeacher);
    await provider.createTeacher(newTeacher);
  }

  Future<void> createTeacher(
    Teacher teacher,
    StudyCenter chosenCenter,
  ) async {
    List<String> temp = List();

    for (String a in teacher.halaqatTeachingIn) {
      if (a != null) temp.add(a);
    }
    teacher.halaqatTeachingIn = temp;
    if (teacher.readableId == null) {
      List<String> testList =
          await auth.fetchSignInMethodsForEmail(email: teacher.username);
      if (testList.contains('password'))
        throw PlatformException(
          code: 'ERROR_USED_USERNAME',
        );

      teacher.createdBy = {
        'name': admin.name,
        'id': admin.id,
      };
      teacher.id = provider.getUniqueId();
      if (!teacher.centers.contains(chosenCenter.id)) {
        teacher.centers[0] = chosenCenter.id;
      }
      teacher.centerState = {
        chosenCenter.id: 'approved',
      };
      await conversationHelper.onTeacherCreation(teacher);
    }
    await provider.createTeacher(teacher);
  }

  List<Teacher> getFilteredTeachersList(
    List<Teacher> data,
    StudyCenter chosenCenter,
    String chosenTeacherState,
  ) {
    List<Teacher> filteredTeacherList = List();

    for (Teacher teacher in data) {
      if (teacher.centers.contains(chosenCenter.id) &&
          teacher.centerState[chosenCenter.id] == chosenTeacherState) {
        filteredTeacherList.add(teacher);
      }
    }
    return filteredTeacherList;
  }

  Future<void> executeAction(
      Teacher teacher, String action, StudyCenter chosenCenter) async {
    switch (action) {
      case 'reApprove':
        teacher.centerState[chosenCenter.id] = 'approved';
        break;
      case 'archive':
        teacher.centerState[chosenCenter.id] = 'archived';
        break;
      case 'delete':
        teacher.centerState[chosenCenter.id] = 'deleted';
        break;
    }
    await provider.createTeacher(teacher);
  }
}
