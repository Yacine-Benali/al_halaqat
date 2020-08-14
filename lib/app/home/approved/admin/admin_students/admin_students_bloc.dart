import 'package:al_halaqat/app/models/admin.dart';
import 'package:al_halaqat/app/models/student.dart';
import 'package:al_halaqat/app/models/study_center.dart';
import 'package:al_halaqat/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'admin_students_provider.dart';

class AdminStudentsBloc {
  AdminStudentsBloc({
    @required this.provider,
    @required this.admin,
    @required this.auth,
  });

  final AdminStudentsProvider provider;
  final Admin admin;
  final Auth auth;

  Stream<List<Student>> fetchStudents(
    List<StudyCenter> centersList,
  ) {
    List<String> centerIds = centersList.map((e) => e.id).toList();
    if (centerIds.length <= 10) {
      return provider.fetchStudents(centerIds);
    } else {
      print('huston we got a problem');
    }
  }

  Future<void> createStudent(
    Student student,
    StudyCenter chosenCenter,
  ) async {
    if (student.readableId == null) {
      List<String> testList =
          await auth.fetchSignInMethodsForEmail(email: student.username);
      if (testList.contains('password'))
        throw PlatformException(
          code: 'ERROR_USED_USERNAME',
        );
    }

    if (student.createdBy.isEmpty) {
      student.createdBy = {
        'name': admin.name,
        'id': admin.id,
      };
    }
    if (student.id == null) {
      student.id = provider.getUniqueId();
    }
    if (student.state == null) {
      student.state = 'approved';
    }
    if (student.center == null) {
      student.center = chosenCenter.id;
    }

    await provider.createStudent(student);
  }

  List<Student> getFilteredStudentsList(
    List<Student> data,
    StudyCenter chosenCenter,
    String chosenStudentState,
  ) {
    List<Student> filteredStudentsList = List();

    for (Student student in data) {
      if (student.center == chosenCenter.id &&
          student.state == chosenStudentState) {
        filteredStudentsList.add(student);
      }
    }
    return filteredStudentsList;
  }

  executeAction(Student student, String action) async {
    switch (action) {
      case 'reApprove':
        student.state = 'approved';
        break;
      case 'archive':
        student.state = 'archived';
        break;
      case 'delete':
        student.state = 'deleted';
        break;
    }
    await provider.createStudent(student);
  }

  Future<List<Student>> getStudentSearch(
    List<Student> studentsList,
    String search,
  ) async {
    print("Resident search = $search");
    if (search == "empty") return [];
    if (search == "error") throw Error();
    List<Student> filteredSearchList = [];

    for (Student s in studentsList) {
      if (s.name.toLowerCase().contains(search.toLowerCase()) ||
          s.readableId.toLowerCase().contains(search.toLowerCase())) {
        filteredSearchList.add(s);
      }
    }
    return filteredSearchList;
  }
}
