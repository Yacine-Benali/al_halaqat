import 'dart:io';

import 'package:al_halaqat/app/conversation_helper/conversation_helper_bloc.dart';
import 'package:al_halaqat/app/logs_helper/logs_helper_bloc.dart';
import 'package:al_halaqat/app/models/halaqa.dart';
import 'package:al_halaqat/app/models/quran.dart';
import 'package:al_halaqat/app/models/student.dart';
import 'package:al_halaqat/app/models/study_center.dart';
import 'package:al_halaqat/app/models/user.dart';
import 'package:al_halaqat/app/models/user_halaqa.dart';
import 'package:al_halaqat/common_widgets/format.dart';
import 'package:al_halaqat/constants/key_translate.dart';
import 'package:al_halaqat/services/auth.dart';
import 'package:al_halaqat/services/storage.dart';
import 'package:excel/excel.dart';
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
    @required this.logsHelperBloc,
  });

  final AdminStudentsProvider provider;
  final User admin;
  final Auth auth;
  final ConversationHelpeBloc conversationHelper;
  final LogsHelperBloc logsHelperBloc;
  List<Halaqa> halaqat;
  Future<Quran> fetchQuran() => provider.fetchQuran();

  // ignore: missing_return
  Stream<UserHalaqa<Student>> fetchStudents(List<StudyCenter> centersList) {
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
      List<Halaqa> data, StudyCenter chosenCenter) {
    List<Halaqa> filteredStudentsList = List();

    for (Halaqa halaqa in data) {
      if (halaqa.centerId == chosenCenter.id) {
        filteredStudentsList.add(halaqa);
      }
    }
    return filteredStudentsList;
  }

  Future<void> modifieStudent(
      Student oldStudent, Student newStudent, StudyCenter chosenCenter) async {
    List<String> temp = List();
    for (String a in newStudent.halaqatLearningIn) {
      if (a != null) temp.add(a);
    }
    newStudent.halaqatLearningIn = temp;
    await provider.createStudent(newStudent);
    await Future.wait([
      conversationHelper.onStudentModification(oldStudent, newStudent),
      logsHelperBloc.adminStudentLog(
          admin, newStudent, ObjectAction.edit, chosenCenter),
    ]);
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
      await provider.createStudent(student);
      await Future.wait([
        conversationHelper.onStudentCreation(student),
        logsHelperBloc.adminStudentLog(
            admin, student, ObjectAction.add, chosenCenter),
      ]);
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

  Future<void> executeAction(
      Student student, String action, StudyCenter chosenCenter) async {
    switch (action) {
      case 'reApprove':
        student.state = 'approved';
        await provider.createStudent(student);
        await logsHelperBloc.adminStudentLog(
            admin, student, ObjectAction.edit, chosenCenter);

        break;
      case 'archive':
        student.state = 'archived';
        await provider.createStudent(student);
        await logsHelperBloc.adminStudentLog(
            admin, student, ObjectAction.edit, chosenCenter);
        break;
      case 'delete':
        student.state = 'deleted';
        await provider.createStudent(student);
        await logsHelperBloc.adminStudentLog(
            admin, student, ObjectAction.delete, chosenCenter);
        break;
    }
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

  Future<String> getReportasCsv(
    UserHalaqa<Student> studentHalaqaList,
    StudyCenter center,
    String chosenState,
  ) async {
    var excel = Excel.createExcel();
    Sheet studentSheet = excel['الطلاب'];
    Sheet studentHalaqaSheet = excel['الحلقة-الطالب'];
    excel.delete('Sheet1');

    List<Student> studentsList = studentHalaqaList.usersList;
    List<Halaqa> halaqatList = studentHalaqaList.halaqatList;

    // add stamp
    List<String> stamp = [
      'المركز',
      center.name,
      '',
      'التاريخ',
      Format.date(DateTime.now())
    ];
    studentSheet.insertRowIterables(stamp, 0);
    studentHalaqaSheet.insertRowIterables(stamp, 0);

    studentSheet.appendRow([
      "رقم الطالب",
      "الاسم",
      "سنة الميلاد",
      "الجنس",
      "الجنسية",
      "العنوان",
      "رقم الهاتف",
      "رقم ثاني",
      "المستوى التعليمي",
      "المدرسة/الجامعة",
      "ملاحظات",
      "تاريخ إنشاء الحساب",
      "بواسطة",
    ]);
    studentHalaqaSheet.appendRow([
      "الطالب",
      "اسم الحلقة",
      "رقم الحلقة",
    ]);
    // add headers
    for (Student student in studentsList) {
      List<String> studentRow = List();
      studentRow.add(student.readableId);
      studentRow.add(student.name);
      studentRow.add(student.dateOfBirth.toString());
      studentRow.add(student.gender);
      studentRow.add(KeyTranslate.isoCountryToArabic[student.nationality]);
      studentRow.add(student.address);
      studentRow.add(student.phoneNumber);
      studentRow.add(student.parentPhoneNumber);
      studentRow.add(student.educationalLevel);
      studentRow.add(student.etablissement);
      studentRow.add(student.note);
      studentRow.add(Format.date(student.createdAt.toDate()));
      studentRow.add(student.createdBy['name']);

      studentSheet.appendRow(studentRow);

      List<Halaqa> halaqatEnrolledIn = halaqatList
          .where((element) => student.halaqatLearningIn.contains(element.id))
          .toList();
      for (Halaqa item in halaqatEnrolledIn) {
        List<String> studentHalaqaRow = List();

        studentHalaqaRow.add(student.name);
        studentHalaqaRow.add(item.name);
        studentHalaqaRow.add(item.readableId);
        studentHalaqaSheet.appendRow(studentHalaqaRow);
      }
    }
    Storage storage = Storage();
    String name = 'students-reports-${center.name}-$chosenState.xlsx';
    File file = await storage.getLocalFile(name);
    await excel.encode().then((onValue) {
      file
        ..createSync(recursive: true)
        ..writeAsBytesSync(onValue);
    });
    return file.path;
  }
}
