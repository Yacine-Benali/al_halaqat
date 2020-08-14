import 'package:al_halaqat/app/home/approved/admin/admin_teachers/admin_teacher_provider.dart';
import 'package:al_halaqat/app/models/admin.dart';
import 'package:al_halaqat/app/models/student.dart';
import 'package:al_halaqat/app/models/study_center.dart';
import 'package:al_halaqat/app/models/teacher.dart';
import 'package:al_halaqat/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdminTeacherBloc {
  AdminTeacherBloc({
    @required this.provider,
    @required this.admin,
    @required this.auth,
  });

  final AdminTeachersProvider provider;
  final Admin admin;
  final Auth auth;

  Stream<List<Teacher>> fetchTeachers(
    List<StudyCenter> centersList,
  ) {
    List<String> centerIds = centersList.map((e) => e.id).toList();
    if (centerIds.length <= 10) {
      return provider.fetchTeachers(centerIds);
    } else {
      print('huston we got a problem');
    }
  }

  Future<void> createTeacher(
    Teacher teacher,
    StudyCenter chosenCenter,
  ) async {
    if (teacher.readableId == null) {
      List<String> testList =
          await auth.fetchSignInMethodsForEmail(email: teacher.username);
      if (testList.contains('password'))
        throw PlatformException(
          code: 'ERROR_USED_USERNAME',
        );
    }

    if (teacher.createdBy.isEmpty) {
      teacher.createdBy = {
        'name': admin.name,
        'id': admin.id,
      };
    }

    if (teacher.id == null) {
      teacher.id = provider.getUniqueId();
    }

    if (!teacher.centers.contains(chosenCenter.id)) {
      teacher.centers[0] = chosenCenter.id;
    }
    if (teacher.centerState.isEmpty) {
      teacher.centerState = {
        chosenCenter.id: 'approved',
      };
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

  // Future<List<Student>> getStudentSearch(
  //   List<Student> studentsList,
  //   String search,
  // ) async {
  //   print("Resident search = $search");
  //   if (search == "empty") return [];
  //   if (search == "error") throw Error();
  //   List<Student> filteredSearchList = [];

  //   for (Student s in studentsList) {
  //     if (s.name.toLowerCase().contains(search.toLowerCase()) ||
  //         s.readableId.toLowerCase().contains(search.toLowerCase())) {
  //       filteredSearchList.add(s);
  //     }
  //   }
  //   return filteredSearchList;
  // }
}
