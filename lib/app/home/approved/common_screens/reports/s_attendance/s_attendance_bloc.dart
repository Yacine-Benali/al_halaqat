import 'dart:io';

import 'package:al_halaqat/app/home/approved/common_screens/reports/s_attendance/s_attendance_provider.dart';
import 'package:al_halaqat/app/models/halaqa.dart';
import 'package:al_halaqat/app/models/instance.dart';
import 'package:al_halaqat/app/models/student_attendance.dart';
import 'package:al_halaqat/app/models/user_attendance_summery.dart';
import 'package:al_halaqat/common_widgets/format.dart';
import 'package:al_halaqat/constants/key_translate.dart';
import 'package:al_halaqat/services/storage.dart';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';

class SAttendanceBloc {
  SAttendanceBloc({
    @required this.provider,
    @required this.halaqatList,
  });

  final SAttendanceProvider provider;
  final List<Halaqa> halaqatList;

  Future<List<UsersAttendanceSummery>> fetchInstances(
    Halaqa halaqa,
    DateTime firstDate,
    DateTime lastDate,
    bool showPercentages,
  ) async {
    List<UsersAttendanceSummery> userAttendaceList = List();
    List<Instance> instances = await provider.fetchInstances(
      halaqa.id,
      firstDate,
      lastDate,
    );

    for (Instance instance in instances) {
      for (StudentAttendance instanceSa in instance.studentAttendanceList) {
        bool isFound = false;
        if (userAttendaceList.isNotEmpty) {
          for (UsersAttendanceSummery userAttendance in userAttendaceList) {
            if (userAttendance.id == instanceSa.id) {
              isFound = true;
              switch (instanceSa.state) {
                case 'present':
                  userAttendance.present = userAttendance.present + 1;
                  break;
                case 'latee':
                  userAttendance.latee = userAttendance.latee + 1;
                  break;
                case 'absentWithExecuse':
                  userAttendance.absentWithExecuse =
                      userAttendance.absentWithExecuse + 1;
                  break;
                case 'absent':
                  userAttendance.absent = userAttendance.absent + 1;
                  break;
              }
            }
          }
        }
        if (!isFound) {
          UsersAttendanceSummery userAttendance;
          switch (instanceSa.state) {
            case 'present':
              userAttendance = UsersAttendanceSummery(
                id: instanceSa.id,
                name: instanceSa.name,
                present: 1,
                latee: 0,
                absent: 0,
                absentWithExecuse: 0,
              );
              userAttendaceList.add(userAttendance);
              break;
            case 'latee':
              userAttendance = UsersAttendanceSummery(
                id: instanceSa.id,
                name: instanceSa.name,
                present: 0,
                latee: 1,
                absent: 0,
                absentWithExecuse: 0,
              );
              userAttendaceList.add(userAttendance);
              break;
            case 'absentWithExecuse':
              userAttendance = UsersAttendanceSummery(
                id: instanceSa.id,
                name: instanceSa.name,
                present: 0,
                latee: 0,
                absent: 0,
                absentWithExecuse: 1,
              );
              userAttendaceList.add(userAttendance);
              break;
            case 'absent':
              userAttendance = UsersAttendanceSummery(
                id: instanceSa.id,
                name: instanceSa.name,
                present: 0,
                latee: 0,
                absent: 0,
                absentWithExecuse: 1,
              );
              userAttendaceList.add(userAttendance);
              break;
          }
        }
      }
    }
    UsersAttendanceSummery halaqaAttendanceSummery = UsersAttendanceSummery(
      id: halaqa.id,
      name: halaqa.name,
      present: 0,
      latee: 0,
      absent: 0,
      absentWithExecuse: 0,
    );
    for (UsersAttendanceSummery usersAttendance in userAttendaceList) {
      halaqaAttendanceSummery.present += usersAttendance.present;
      halaqaAttendanceSummery.latee += usersAttendance.latee;
      halaqaAttendanceSummery.absentWithExecuse +=
          usersAttendance.absentWithExecuse;
      halaqaAttendanceSummery.absent += usersAttendance.absent;
    }
    userAttendaceList.insert(0, halaqaAttendanceSummery);
    if (showPercentages) {
      userAttendaceList.forEach((element) {
        double all = element.present +
            element.latee +
            element.absent +
            element.absentWithExecuse;
        element.present = Format.roundDouble(element.present / all * 100);

        element.latee = Format.roundDouble(element.latee / all * 100);
        element.absent = Format.roundDouble(element.absent / all * 100);
        element.absentWithExecuse =
            Format.roundDouble(element.absentWithExecuse / all * 100);
      });
    }

    return userAttendaceList;
  }

  List<String> getColumnTitle() {
    List<String> columnTitleList = List();
    columnTitleList.add('إسم');
    columnTitleList.addAll(KeyTranslate.attendanceState.values);

    return columnTitleList;
  }

  Future<String> getReportasCsv(
    List<UsersAttendanceSummery> list,
    DateTime first,
    DateTime last,
  ) async {
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Sheet1'];

    List<List<String>> rows = List<List<String>>();
    List<String> row = List();
    row.addAll(getColumnTitle());
    sheetObject.insertRowIterables(row, 0);

    for (int i = 0; i < list.length; i++) {
      List<String> row = List();
      row.add(list[i].name);
      row.add(list[i].present.toString());
      row.add(list[i].latee.toString());
      row.add(list[i].absent.toString());
      row.add(list[i].absentWithExecuse.toString());
      sheetObject.appendRow(row);
    }
    Storage storage = Storage();
    String name = getFileName(first, last);
    File file = await storage.getLocalFile(name);
    await excel.encode().then((onValue) {
      file
        ..createSync(recursive: true)
        ..writeAsBytesSync(onValue);
    });
    return file.path;
  }

  String getFileName(DateTime first, DateTime last) {
    String a = Format.date(first);
    String b = Format.date(last);
    return 'attendance-' + a + '-' + b + '.xlsx';
  }
}
