import 'dart:io';

import 'package:alhalaqat/app/conversation_helper/conversation_helper_bloc.dart';
import 'package:alhalaqat/app/home/approved/admin/admin_teachers/admin_teacher_provider.dart';
import 'package:alhalaqat/app/logs_helper/logs_helper_bloc.dart';
import 'package:alhalaqat/app/models/halaqa.dart';
import 'package:alhalaqat/app/models/study_center.dart';
import 'package:alhalaqat/app/models/teacher.dart';
import 'package:alhalaqat/app/models/user.dart';
import 'package:alhalaqat/app/models/user_halaqa.dart';
import 'package:alhalaqat/common_widgets/format.dart';
import 'package:alhalaqat/constants/key_translate.dart';
import 'package:alhalaqat/services/auth.dart';
import 'package:alhalaqat/services/local_storage_service.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

class AdminTeacherBloc {
  AdminTeacherBloc({
    @required this.provider,
    @required this.admin,
    @required this.auth,
    @required this.conversationHelper,
    @required this.logsHelperBloc,
  });

  final AdminTeachersProvider provider;
  final ConversationHelpeBloc conversationHelper;
  final LogsHelperBloc logsHelperBloc;
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
      List<Halaqa> data, StudyCenter chosenCenter) {
    List<Halaqa> filteredStudentsList = List();

    for (Halaqa halaqa in data) {
      if (halaqa.centerId == chosenCenter.id) {
        filteredStudentsList.add(halaqa);
      }
    }
    return filteredStudentsList;
  }

  // ignore: missing_return
  Stream<UserHalaqa<Teacher>> fetchTeachers(List<StudyCenter> centersList) {
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

  Future<List<Teacher>> getTeacherSearch(
    List<Teacher> studentsList,
    String search,
  ) async {
    print("Resident search = $search");
    if (search == "empty") return [];
    if (search == "error") throw Error();
    List<Teacher> filteredSearchList = [];

    for (Teacher s in studentsList) {
      if (s.name.toLowerCase().contains(search.toLowerCase()) ||
          s.readableId.toLowerCase().contains(search.toLowerCase())) {
        filteredSearchList.add(s);
      }
    }
    return filteredSearchList;
  }

  Future<void> modifieTeacher(
    Teacher oldTeacher,
    Teacher newTeacher,
    StudyCenter chosenCenter,
  ) async {
    List<String> temp = List();
    if (oldTeacher.username != newTeacher.username) {
      List<String> testList =
          await auth.fetchSignInMethodsForEmail(email: newTeacher.username);
      if (testList.contains('password'))
        throw PlatformException(
          code: 'ERROR_USED_USERNAME',
        );
    }
    for (String a in newTeacher.halaqatTeachingIn) {
      if (a != null) temp.add(a);
    }
    newTeacher.halaqatTeachingIn = temp;
    await provider.createTeacher(newTeacher);
    await Future.wait([
      logsHelperBloc.adminTeacherLog(
          admin, newTeacher, ObjectAction.edit, chosenCenter),
      conversationHelper.onTeacherModification(oldTeacher, newTeacher),
    ]);
  }

  Future<void> createTeacher(Teacher teacher, StudyCenter chosenCenter) async {
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

      await provider.createTeacher(teacher);
      await Future.wait([
        logsHelperBloc.adminTeacherLog(
            admin, teacher, ObjectAction.add, chosenCenter),
        conversationHelper.onTeacherCreation(teacher)
      ]);
    }
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
        await provider.createTeacher(teacher);
        await logsHelperBloc.adminTeacherLog(
            admin, teacher, ObjectAction.edit, chosenCenter);

        break;
      case 'archive':
        teacher.centerState[chosenCenter.id] = 'archived';
        await provider.createTeacher(teacher);
        await logsHelperBloc.adminTeacherLog(
            admin, teacher, ObjectAction.edit, chosenCenter);

        break;
      case 'delete':
        teacher.centerState[chosenCenter.id] = 'deleted';
        await provider.createTeacher(teacher);
        await logsHelperBloc.adminTeacherLog(
            admin, teacher, ObjectAction.delete, chosenCenter);

        break;
    }
  }

  Future<String> getReportasCsv(
    UserHalaqa<Teacher> teacherHalaqaList,
    StudyCenter center,
    String chosenState,
  ) async {
    var excel = Excel.createExcel();
    Sheet teacherSheet = excel['المعلمين'];
    Sheet teacherHalaqaSheet = excel['الحلقة-المعلمين'];
    excel.delete('Sheet1');

    List<Teacher> teachersList = teacherHalaqaList.usersList;
    List<Halaqa> halaqatList = teacherHalaqaList.halaqatList;

    // add stamp
    List<String> stamp = [
      'المركز',
      center.name,
      '',
      'التاريخ',
      Format.date(DateTime.now())
    ];
    teacherSheet.insertRowIterables(stamp, 0);
    teacherHalaqaSheet.insertRowIterables(stamp, 0);

    teacherSheet.appendRow([
      "رقم المعلم",
      "الاسم",
      "سنة الميلاد",
      "الجنس",
      "الجنسية",
      "العنوان",
      "رقم الهاتف",
      "الالمستوى  التعليمي",
      "المدرسة/الجامعة",
      "ملاحظات",
      "تاريخ إنشاء الحساب",
      "بواسطة",
    ]);
    teacherHalaqaSheet.appendRow([
      "اسم الحلقة",
      "رقم الحلقة",
      "المعلم",
    ]);
    // add headers
    for (Teacher teacher in teachersList) {
      List<String> studentRow = List();
      studentRow.add(teacher.readableId);
      studentRow.add(teacher.name);
      studentRow.add(teacher.dateOfBirth.toString());
      studentRow.add(teacher.gender);
      studentRow.add(KeyTranslate.isoCountryToArabic[teacher.nationality]);
      studentRow.add(teacher.address);
      studentRow.add(teacher.phoneNumber);
      studentRow.add(teacher.educationalLevel);
      studentRow.add(teacher.etablissement);
      studentRow.add(teacher.note);
      studentRow.add(Format.date(teacher.createdAt.toDate()));
      studentRow.add(teacher.createdBy['name']);

      teacherSheet.appendRow(studentRow);

      List<Halaqa> halaqatEnrolledIn = halaqatList
          .where((element) => teacher.halaqatTeachingIn.contains(element.id))
          .toList();
      for (Halaqa item in halaqatEnrolledIn) {
        List<String> teacherHalaqaRow = List();

        teacherHalaqaRow.add(item.name);
        teacherHalaqaRow.add(item.readableId);
        teacherHalaqaRow.add(teacher.name);
        teacherHalaqaSheet.appendRow(teacherHalaqaRow);
      }
    }
    LocalStorageService storage = LocalStorageService();
    String name = 'teacher-reports-${center.name}-$chosenState.xlsx';
    File file = await storage.getLocalFile(name);
    await excel.encode().then((onValue) {
      file
        ..createSync(recursive: true)
        ..writeAsBytesSync(onValue);
    });
    return file.path;
  }
}
