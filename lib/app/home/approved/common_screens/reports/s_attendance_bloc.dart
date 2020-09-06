import 'dart:io';

import 'package:al_halaqat/app/home/approved/common_screens/reports/s_attendance_provider.dart';
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
    @required this.halaqatId,
  });

  final SAttendanceProvider provider;
  final List<String> halaqatId;

  Future<List<List<Halaqa>>> fetchHalaqat() {
    List<List<String>> partitionedList = List();

    for (var i = 0; i < halaqatId.length; i += 10) {
      partitionedList.add(halaqatId.sublist(
          i, i + 10 > halaqatId.length ? halaqatId.length : i + 10));
    }
    List<Future<List<Halaqa>>> halaqatFuturesList = partitionedList
        .map((sublist) => provider.fetchHalaqat(sublist))
        .toList();

    return Future.wait(halaqatFuturesList);
  }

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
              break;
          }

          userAttendaceList.add(userAttendance);
        }
      }
    }
    if (showPercentages) {
      userAttendaceList.forEach((element) {
        double all = element.present +
            element.latee +
            element.absent +
            element.absentWithExecuse;

        element.present = element.present / all * 100;
        element.latee = element.latee / all * 100;
        element.absent = element.absent / all * 100;
        element.absentWithExecuse = element.absentWithExecuse / all * 100;
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

  Future<void> getReportasCsv(
    List<UsersAttendanceSummery> list,
    DateTime first,
    DateTime last,
  ) async {
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Sheet1'];
    // List<List<String>> rows = List<List<String>>();
    // List<String> row = List();
    // row.addAll(getColumnTitle());
    // rows.add(row);
    // //
    // for (UsersAttendanceSummery data in list) {
    //   //row refer to each column of a row in csv file and rows refer to each row in a file
    //   List<String> row = List();
    //   row.add(data.name);
    //   row.add(data.present.toString());
    //   row.add(data.latee.toString());
    //   row.add(data.absent.toString());
    //   row.add(data.absentWithExecuse.toString());
    //   rows.add(row);
    // }
    // String csv = ListToCsvConverter().convert(rows);
    // return csv;

    List<List<String>> rows = List<List<String>>();
    List<String> row = List();
    row.addAll(getColumnTitle());
    sheetObject.insertRowIterables(row, 0);

    //
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
  }

  String getFileName(DateTime first, DateTime last) {
    String a = Format.date(first);
    String b = Format.date(last);
    return 'attendance-' + a + '-' + b + '.xls';
  }
}
