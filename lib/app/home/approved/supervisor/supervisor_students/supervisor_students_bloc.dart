import 'package:alhalaqat/app/models/halaqa.dart';
import 'package:alhalaqat/app/models/quran.dart';
import 'package:alhalaqat/app/models/student.dart';
import 'package:alhalaqat/app/models/study_center.dart';
import 'package:alhalaqat/app/models/supervisor.dart';
import 'package:alhalaqat/app/models/user_halaqa.dart';
import 'package:alhalaqat/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

import 'supervisor_students_provider.dart';

class SupervisorStudentsBloc {
  SupervisorStudentsBloc({
    @required this.provider,
    @required this.supervisor,
    @required this.auth,
    // @required this.logsHelperBloc,
  });

  final SupervisorStudentsProvider provider;
  final Supervisor supervisor;
  final Auth auth;
  //final LogsHelperBloc logsHelperBloc;

  List<Halaqa> halaqat;
  Future<Quran> fetchQuran() => provider.fetchQuran();

  Stream<UserHalaqa<Student>> fetchStudents() {
    List<String> halaqatId = supervisor.halaqatSupervisingIn;
    List<List<String>> partitionedList = List();

    for (var i = 0; i < halaqatId.length; i += 10) {
      partitionedList.add(halaqatId.sublist(
          i, i + 10 > halaqatId.length ? halaqatId.length : i + 10));
    }
    if (halaqatId.isEmpty) {
      partitionedList.add(['emptyId']);
    }
    /*
    warning
    calling students of each sublist
     may result in duplicate data as one student can be in the first sublist
     and in the second sublist 
     */
    List<Stream<List<Student>>> studentStreamList = partitionedList
        .map((sublist) => provider.fetchStudents(sublist))
        .toList();

    List<Stream<List<Halaqa>>> halaqatStreamList = partitionedList
        .map((sublist) => provider.fetchHalaqat(sublist))
        .toList();

    Stream<List<Student>> studentsStream =
        Rx.combineLatest(studentStreamList, (List<List<Student>> values) {
      //! fix for above warning
      List<Student> notUniqueStudentsList = values.expand((x) => x).toList();
      List<Student> uniqueStudentsList = notUniqueStudentsList.toSet().toList();

      return uniqueStudentsList;
    });

    Stream<List<Halaqa>> halaqatStream = Rx.combineLatest(halaqatStreamList,
        (List<List<Halaqa>> values) => values.expand((x) => x).toList());

    Stream<UserHalaqa<Student>> studentsHalaqatStream = Rx.combineLatest2(
        studentsStream, halaqatStream, (List<Student> a, List<Halaqa> b) {
      return UserHalaqa<Student>(usersList: a, halaqatList: b);
    });

    return studentsHalaqatStream;
  }

  Future<void> modifieStudent(Student oldStudent, Student newStudent) async {
    List<String> temp = List();
    if (oldStudent.username != newStudent.username) {
      List<String> testList =
          await auth.fetchSignInMethodsForEmail(email: newStudent.username);
      if (testList.contains('password'))
        throw PlatformException(
          code: 'ERROR_USED_USERNAME',
        );
    }
    for (String a in newStudent.halaqatLearningIn) {
      if (a != null) temp.add(a);
    }
    newStudent.halaqatLearningIn = temp;

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
      student.id = provider.getUniqueId();
      student.state = 'approved';
      student.center = chosenCenter.id;

      student.createdBy = {
        'name': supervisor.name,
        'id': supervisor.id,
      };
      await provider.createStudent(student);
    }
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

  List<Halaqa> getFilteredHalaqaList(
      List<Halaqa> data, StudyCenter chosenCenter) {
    List<Halaqa> filteredStudentsList = List();

    for (Halaqa halaqa in data) {
      if (halaqa.centerId == chosenCenter.id) {
        filteredStudentsList.add(halaqa);
      }
    }
    return filteredStudentsList;
  }

  Future<void> executeAction(Student student, String action) async {
    switch (action) {
      case 'reApprove':
        student.state = 'approved';
        await provider.createStudent(student);
        // await logsHelperBloc.supervisorStudentLog(
        //     supervisor, student, ObjectAction.edit);

        break;
      case 'archive':
        student.state = 'archived';
        // await logsHelperBloc.supervisorStudentLog(
        //     supervisor, student, ObjectAction.edit);
        await provider.createStudent(student);

        break;
      case 'delete':
        student.state = 'deleted';
        // await logsHelperBloc.supervisorStudentLog(
        //     supervisor, student, ObjectAction.delete);
        await provider.createStudent(student);

        break;
    }
  }

  Future<List<Student>> getStudentSearch(
      List<Student> studentsList, String search) async {
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

  Future<List<Student>> fetchStudent(
      String nameOrId, StudyCenter center) async {
    List<Student> student;
    try {
      int.parse(nameOrId);

      student = await provider.fetchStudentById(nameOrId, center.id);
    } catch (_) {
      student = await provider.fetchStudentByName(nameOrId, center.id);
    }
    return student;
  }
}
