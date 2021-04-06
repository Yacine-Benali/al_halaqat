import 'dart:io';

import 'package:alhalaqat/app/models/local_t_c_a_report.dart';
import 'package:alhalaqat/app/models/study_center.dart';
import 'package:alhalaqat/app/models/teacher.dart';
import 'package:alhalaqat/app/models/teacher_center_attendance.dart';
import 'package:alhalaqat/common_widgets/format.dart';
import 'package:alhalaqat/services/local_storage_service.dart';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';

import 't_center_attendance_provider.dart';

class TCenterAttendanceBloc {
  TCenterAttendanceBloc({
    @required this.provider,
    @required this.center,
  });

  final TCenterAttendanceProvider provider;
  final StudyCenter center;

  Future<List<LocalTCAReport>> fetchTeachers(
    DateTime firstDate,
    DateTime lastDate,
  ) async {
    List<LocalTCAReport> list = List();
    List<Teacher> teachersList = await provider.fetchTeachers(center.id);

    for (Teacher teacher in teachersList) {
      LocalTCAReport teacherSummery = LocalTCAReport(teacherName: teacher.name);

      List<TeacherCenterAttendance> attendanceList = await provider
          .getTCenterAttendaceList(center.id, teacher.id, firstDate, lastDate);

      for (TeacherCenterAttendance attendance in attendanceList) {
        int hoursStayed = attendance.timeOut.hour - attendance.timeIn.hour;
        teacherSummery.hoursStayed += hoursStayed ?? 0;
      }
      list.add(teacherSummery);
    }
    return list;
  }

  List<String> getColumnTitle() {
    List<String> columnTitleList = List();
    columnTitleList.add('اسم');
    columnTitleList.add('ساعات الدوام');

    return columnTitleList;
  }

  Future<String> getReportasCsv(
    List<LocalTCAReport> list,
    DateTime first,
    DateTime last,
  ) async {
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Sheet1'];

    List<String> row = List();
    row.addAll(getColumnTitle());
    sheetObject.insertRowIterables(row, 0);

    for (int i = 0; i < list.length; i++) {
      List<String> row = List();
      row.add(list[i].teacherName);
      row.add(list[i].hoursStayed.toString());
      sheetObject.appendRow(row);
    }
    LocalStorageService storage = LocalStorageService();
    String name = getFileName(list, first, last);
    File file = await storage.getLocalFile(name);
    await excel.encode().then((onValue) {
      file
        ..createSync(recursive: true)
        ..writeAsBytesSync(onValue);
    });
    return file.path;
  }

  String getFileName(List<LocalTCAReport> l, DateTime first, DateTime last) {
    String a = Format.date(first);
    String b = Format.date(last);
    return 'teacherAttendance-' + a + '-' + b + '.xlsx';
  }
}
