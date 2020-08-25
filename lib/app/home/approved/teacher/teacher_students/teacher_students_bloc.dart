import 'package:al_halaqat/app/models/halaqa.dart';
import 'package:al_halaqat/app/models/quran.dart';
import 'package:al_halaqat/app/models/student.dart';
import 'package:al_halaqat/app/models/study_center.dart';
import 'package:al_halaqat/app/models/teacher.dart';
import 'package:al_halaqat/app/models/user_halaqa.dart';
import 'package:al_halaqat/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

import 'teacher_students_provider.dart';

class TeacherStudentsBloc {
  TeacherStudentsBloc({
    @required this.provider,
    @required this.teacher,
    @required this.auth,
  });

  final TeacherStudentsProvider provider;
  final Teacher teacher;
  final Auth auth;
  List<Halaqa> halaqat;
  Future<Quran> fetchQuran() => provider.fetchQuran();

  Stream<UserHalaqa<Student>> fetchStudents() {
    List<String> halaqatId = teacher.halaqatTeachingIn;
    List<List<String>> partitionedList = List();

    for (var i = 0; i < halaqatId.length; i += 10) {
      partitionedList.add(halaqatId.sublist(
          i, i + 10 > halaqatId.length ? halaqatId.length : i + 10));
    }

    List<List<String>> partitionedList2 = List();

    for (var i = 0; i < halaqatId.length; i += 10) {
      partitionedList2.add(halaqatId.sublist(
          i, i + 10 > halaqatId.length ? halaqatId.length : i + 10));
    }

    List<Stream<List<Student>>> studentStreamList = partitionedList
        .map((sublist) => provider.fetchStudents(sublist))
        .toList();

    List<Stream<List<Halaqa>>> halaqatStreamList = partitionedList2
        .map((sublist) => provider.fetchHalaqat(sublist))
        .toList();

    Stream<List<Student>> studentsStream = Rx.combineLatest(studentStreamList,
        (List<List<Student>> values) => values.expand((x) => x).toList());

    Stream<List<Halaqa>> halaqatStream = Rx.combineLatest(halaqatStreamList,
        (List<List<Halaqa>> values) => values.expand((x) => x).toList());

    Stream<UserHalaqa<Student>> studentsHalaqatStream = Rx.combineLatest2(
        studentsStream,
        halaqatStream,
        (a, b) => UserHalaqa<Student>(usersList: a, halaqatList: b));

    return studentsHalaqatStream;
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
        'name': teacher.name,
        'id': teacher.id,
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

  Future<void> executeAction(Student student, String action) async {
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
