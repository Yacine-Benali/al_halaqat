import 'package:al_halaqat/app/conversation_helper/conversation_helper_bloc.dart';
import 'package:al_halaqat/app/models/halaqa.dart';
import 'package:al_halaqat/app/models/quran.dart';
import 'package:al_halaqat/app/models/student.dart';
import 'package:al_halaqat/app/models/study_center.dart';
import 'package:al_halaqat/app/models/user.dart';
import 'package:al_halaqat/app/models/user_halaqa.dart';
import 'package:al_halaqat/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

import 'admin_students_provider.dart';

class AdminStudentsBloc {
  AdminStudentsBloc({
    @required this.provider,
    @required this.admin,
    @required this.auth,
    @required this.conversationHelper,
  });

  final AdminStudentsProvider provider;
  final User admin;
  final Auth auth;
  final ConversationHelpeBloc conversationHelper;
  List<Halaqa> halaqat;
  Future<Quran> fetchQuran() => provider.fetchQuran();

  // ignore: missing_return
  Stream<UserHalaqa<Student>> fetchStudents(
    List<StudyCenter> centersList,
  ) {
    List<String> centerIds = centersList.map((e) => e.id).toList();

    if (centerIds.length <= 10) {
      Stream<List<Student>> studentsStream = provider.fetchStudents(centerIds);
      Stream<List<Halaqa>> halaqatStream = provider.fetchHalaqat(centerIds);
      Stream<UserHalaqa<Student>> studentsHalaqatStream = Rx.combineLatest2(
          studentsStream,
          halaqatStream,
          (a, b) => UserHalaqa<Student>(usersList: a, halaqatList: b));
      return studentsHalaqatStream;
    } else {
      print('huston we got a problem');
    }
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

  Future<void> modifieStudent(Student oldStudent, Student newStudent) async {
    List<String> temp = List();
    for (String a in newStudent.halaqatLearningIn) {
      if (a != null) temp.add(a);
    }
    newStudent.halaqatLearningIn = temp;
    await conversationHelper.onStudentModification(oldStudent, newStudent);
    await provider.createStudent(newStudent);
  }

  Future<void> createStudent(
    Student student,
    StudyCenter chosenCenter,
  ) async {
    List<String> temp = List();

    for (String a in student.halaqatLearningIn) {
      if (a != null) temp.add(a);
    }
    student.halaqatLearningIn = temp;
    if (student.readableId == null) {
      List<String> testList =
          await auth.fetchSignInMethodsForEmail(email: student.username);
      if (testList.contains('password'))
        throw PlatformException(
          code: 'ERROR_USED_USERNAME',
        );

      student.createdBy = {
        'name': admin.name,
        'id': admin.id,
      };
      student.id = provider.getUniqueId();
      student.state = 'approved';
      student.center = chosenCenter.id;
      await conversationHelper.onStudentCreation(student);
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
