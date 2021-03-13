import 'package:alhalaqat/app/conversation_helper/conversation_helper_bloc.dart';
import 'package:alhalaqat/app/home/approved/admin/admin_supervisors/admin_supervisors_provider.dart';
import 'package:alhalaqat/app/logs_helper/logs_helper_bloc.dart';
import 'package:alhalaqat/app/models/halaqa.dart';
import 'package:alhalaqat/app/models/study_center.dart';
import 'package:alhalaqat/app/models/supervisor.dart';
import 'package:alhalaqat/app/models/user.dart';
import 'package:alhalaqat/app/models/user_halaqa.dart';
import 'package:alhalaqat/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

class AdminSupervisorsBloc {
  AdminSupervisorsBloc({
    @required this.provider,
    @required this.admin,
    @required this.auth,
    @required this.conversationHelper,
    @required this.logsHelperBloc,
  });

  final AdminSupervisorsProvider provider;
  final ConversationHelpeBloc conversationHelper;
  final LogsHelperBloc logsHelperBloc;
  final User admin;
  final Auth auth;

  List<Halaqa> getAvailableHalaqat(List<Halaqa> halaqatList,
      List<Supervisor> supervisorsList, StudyCenter chosenCenter) {
    List<Halaqa> availableHalaqa = List();

    for (Halaqa halaqa in halaqatList) {
      bool isFound = false;
      if (halaqa.centerId == chosenCenter.id) {
        for (Supervisor supervisor in supervisorsList) {
          if (supervisor.halaqatSupervisingIn.contains(halaqa.id)) {
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
  Stream<UserHalaqa<Supervisor>> fetchSupervisors(
      List<StudyCenter> centersList) {
    List<String> centerIds = centersList.map((e) => e.id).toList();
    if (centerIds.length <= 10) {
      Stream<List<Supervisor>> supervisorsStream =
          provider.fetchSupervisors(centerIds);
      Stream<List<Halaqa>> halaqatStream = provider.fetchHalaqat(centerIds);
      Stream<UserHalaqa<Supervisor>> supervisorsHalaqatStream =
          Rx.combineLatest2(supervisorsStream, halaqatStream,
              (a, b) => UserHalaqa<Supervisor>(usersList: a, halaqatList: b));
      return supervisorsHalaqatStream;
    } else {
      print('huston we got a problem');
    }
  }

  Future<List<Supervisor>> getSupervisorSearch(
    List<Supervisor> supervisorsList,
    String search,
  ) async {
    print("Resident search = $search");
    if (search == "empty") return [];
    if (search == "error") throw Error();
    List<Supervisor> filteredSearchList = [];

    for (Supervisor s in supervisorsList) {
      if (s.name.toLowerCase().contains(search.toLowerCase()) ||
          s.readableId.toLowerCase().contains(search.toLowerCase())) {
        filteredSearchList.add(s);
      }
    }
    return filteredSearchList;
  }

  Future<void> modifieSupervisor(
    Supervisor oldSupervisor,
    Supervisor newSupervisor,
    StudyCenter chosenCenter,
  ) async {
    List<String> temp = List();
    if (oldSupervisor.username != newSupervisor.username) {
      List<String> testList =
          await auth.fetchSignInMethodsForEmail(email: newSupervisor.username);
      if (testList.contains('password'))
        throw PlatformException(
          code: 'ERROR_USED_USERNAME',
        );
    }
    for (String a in newSupervisor.halaqatSupervisingIn) {
      if (a != null) temp.add(a);
    }
    newSupervisor.halaqatSupervisingIn = temp;
    await provider.createSupervisor(newSupervisor);
    // TODO logs specefic to supervisor are not being record
    //  creating editing deleting supervisor

    // await Future.wait([

    //   logsHelperBloc.adminTeacherLog(
    //       admin, newSupervisor, ObjectAction.edit, chosenCenter),
    //   conversationHelper.onTeacherModification(oldSupervisor, newSupervisor),
    // ]);
  }

  Future<void> createSupervisor(
      Supervisor supervisor, StudyCenter chosenCenter) async {
    List<String> temp = List();

    for (String a in supervisor.halaqatSupervisingIn) {
      if (a != null) temp.add(a);
    }
    supervisor.halaqatSupervisingIn = temp;
    if (supervisor.readableId == null) {
      List<String> testList =
          await auth.fetchSignInMethodsForEmail(email: supervisor.username);
      if (testList.contains('password'))
        throw PlatformException(
          code: 'ERROR_USED_USERNAME',
        );

      supervisor.createdBy = {
        'name': admin.name,
        'id': admin.id,
      };
      supervisor.id = provider.getUniqueId();
      if (!supervisor.centers.contains(chosenCenter.id)) {
        supervisor.centers[0] = chosenCenter.id;
      }
      supervisor.centerState = {
        chosenCenter.id: 'approved',
      };

      await provider.createSupervisor(supervisor);

      // TODO logs specefic to supervisor are not being record
      //  creating editing deleting supervisor

      // await Future.wait([
      //   logsHelperBloc.adminTeacherLog(
      //       admin, teacher, ObjectAction.add, chosenCenter),
      //   conversationHelper.onTeacherCreation(teacher)
      // ]);
    }
  }

  List<Supervisor> getFilteredSupervisorsList(
    List<Supervisor> data,
    StudyCenter chosenCenter,
    String chosenSupervisorState,
  ) {
    List<Supervisor> filteredSupervisorsList = List();
    for (Supervisor supervisor in data) {
      if (supervisor.centers.contains(chosenCenter.id) &&
          supervisor.centerState[chosenCenter.id] == chosenSupervisorState) {
        filteredSupervisorsList.add(supervisor);
      }
    }
    return filteredSupervisorsList;
  }

  Future<void> executeAction(
      Supervisor supervisor, String action, StudyCenter chosenCenter) async {
    switch (action) {
      case 'reApprove':
        supervisor.centerState[chosenCenter.id] = 'approved';
        await provider.createSupervisor(supervisor);
        // await logsHelperBloc.adminTeacherLog(
        //     admin, teacher, ObjectAction.edit, chosenCenter);
        break;
      case 'archive':
        supervisor.centerState[chosenCenter.id] = 'archived';
        await provider.createSupervisor(supervisor);
        // await logsHelperBloc.adminTeacherLog(
        //     admin, teacher, ObjectAction.edit, chosenCenter);

        break;
      case 'delete':
        supervisor.centerState[chosenCenter.id] = 'deleted';
        await provider.createSupervisor(supervisor);
        // await logsHelperBloc.adminTeacherLog(
        //     admin, teacher, ObjectAction.delete, chosenCenter);
        break;
    }
  }
  // no supervisor reports for now
  // Future<String> getReportasCsv(
  //   UserHalaqa<Supervisor> teacherHalaqaList,
  //   StudyCenter center,
  //   String chosenState,
  // ) async {
  //   var excel = Excel.createExcel();
  //   Sheet teacherSheet = excel['المعلمين'];
  //   Sheet teacherHalaqaSheet = excel['الحلقة-المعلمين'];
  //   excel.delete('Sheet1');

  //   List<Supervisor> teachersList = teacherHalaqaList.usersList;
  //   List<Halaqa> halaqatList = teacherHalaqaList.halaqatList;

  //   // add stamp
  //   List<String> stamp = [
  //     'المركز',
  //     center.name,
  //     '',
  //     'التاريخ',
  //     Format.date(DateTime.now())
  //   ];
  //   teacherSheet.insertRowIterables(stamp, 0);
  //   teacherHalaqaSheet.insertRowIterables(stamp, 0);

  //   teacherSheet.appendRow([
  //     "رقم المعلم",
  //     "الاسم",
  //     "سنة الميلاد",
  //     "الجنس",
  //     "الجنسية",
  //     "العنوان",
  //     "رقم الهاتف",
  //     "الالمستوى  التعليمي",
  //     "المدرسة/الجامعة",
  //     "ملاحظات",
  //     "تاريخ إنشاء الحساب",
  //     "بواسطة",
  //   ]);
  //   teacherHalaqaSheet.appendRow([
  //     "اسم الحلقة",
  //     "رقم الحلقة",
  //     "المعلم",
  //   ]);
  //   // add headers
  //   for (Supervisor teacher in teachersList) {
  //     List<String> studentRow = List();
  //     studentRow.add(teacher.readableId);
  //     studentRow.add(teacher.name);
  //     studentRow.add(teacher.dateOfBirth.toString());
  //     studentRow.add(teacher.gender);
  //     studentRow.add(KeyTranslate.isoCountryToArabic[teacher.nationality]);
  //     studentRow.add(teacher.address);
  //     studentRow.add(teacher.phoneNumber);
  //     studentRow.add(teacher.educationalLevel);
  //     studentRow.add(teacher.etablissement);
  //     studentRow.add(teacher.note);
  //     studentRow.add(Format.date(teacher.createdAt.toDate()));
  //     studentRow.add(teacher.createdBy['name']);

  //     teacherSheet.appendRow(studentRow);

  //     List<Halaqa> halaqatEnrolledIn = halaqatList
  //         .where((element) => teacher.halaqatTeachingIn.contains(element.id))
  //         .toList();
  //     for (Halaqa item in halaqatEnrolledIn) {
  //       List<String> teacherHalaqaRow = List();

  //       teacherHalaqaRow.add(item.name);
  //       teacherHalaqaRow.add(item.readableId);
  //       teacherHalaqaRow.add(teacher.name);
  //       teacherHalaqaSheet.appendRow(teacherHalaqaRow);
  //     }
  //   }
  //   LocalStorageService storage = LocalStorageService();
  //   String name = 'teacher-reports-${center.name}-$chosenState.xlsx';
  //   File file = await storage.getLocalFile(name);
  //   await excel.encode().then((onValue) {
  //     file
  //       ..createSync(recursive: true)
  //       ..writeAsBytesSync(onValue);
  //   });
  //   return file.path;
  // }
}
