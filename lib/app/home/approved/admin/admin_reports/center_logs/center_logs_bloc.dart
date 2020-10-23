import 'dart:io';

import 'package:alhalaqat/app/home/approved/admin/admin_reports/center_logs/center_logs_provider.dart';
import 'package:alhalaqat/app/models/study_center.dart';
import 'package:alhalaqat/app/models/teacher_log.dart';
import 'package:alhalaqat/app/models/user.dart';
import 'package:alhalaqat/common_widgets/format.dart';
import 'package:alhalaqat/constants/key_translate.dart';
import 'package:alhalaqat/services/local_storage_service.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class CenterLogsBloc {
  CenterLogsBloc({
    @required this.provider,
    @required this.user,
    @required this.chosenCenter,
  });

  final CenterLogsProvider provider;
  final User user;
  final StudyCenter chosenCenter;

  List<TeacherLog> teacherLogsList = [];
  List<TeacherLog> emptyList = [];
  BehaviorSubject<List<TeacherLog>> teachersLogsListController =
      BehaviorSubject<List<TeacherLog>>();

  Stream<List<TeacherLog>> get teacherLogsStream =>
      teachersLogsListController.stream;

  void fetchFirstInstances() {
    Future<List<TeacherLog>> latestTeachersLogs =
        provider.fetchIlatestInstances(chosenCenter.id);

    latestTeachersLogs.then((latestInstanceList) async {
      if (latestInstanceList.isNotEmpty) {
        if (teacherLogsList.isNotEmpty) {
        } else {
          teacherLogsList.insertAll(0, latestInstanceList);
        }
        if (!teachersLogsListController.isClosed) {
          teachersLogsListController.sink.add(teacherLogsList);
        }
      } else {
        teacherLogsList.clear();
        teachersLogsListController.sink.add(teacherLogsList);
      }
    });
  }

  Future<bool> fetchNextMessages(TeacherLog lastIntance) async {
    List<TeacherLog> moreIntances = await provider.fetchMoreInstances(
      chosenCenter.id,
      lastIntance,
    );
    await Future.delayed(Duration(milliseconds: 500));
    teacherLogsList.addAll(moreIntances);
    if (!teachersLogsListController.isClosed) {
      teachersLogsListController.sink.add(teacherLogsList);
    }
    return true;
  }

  void dispose() {
    teachersLogsListController.close();
  }

  Future<String> getReportasCsv(List<TeacherLog> teacherLogsList) async {
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['السجلات'];
    excel.delete('Sheet1');

    List<String> row = List();
    row.addAll([
      'الوقت',
      'اسم المعلم',
      'الفعل',
      'اسم المفعول به',
    ]);
    sheetObject.insertRowIterables(row, 0);

    for (TeacherLog teacherLog in teacherLogsList) {
      List<String> row = List();
      row.add(
          Format.dateWithTime(teacherLog.createdAt.toDate() ?? DateTime.now()));
      row.add(teacherLog.teacher.name);
      row.add(KeyTranslate.logActions[teacherLog.action] +
          ' ' +
          KeyTranslate.logObjectNature[teacherLog.object.nature]);
      row.add(teacherLog.object.name);
      sheetObject.appendRow(row);
    }

    LocalStorageService storage = LocalStorageService();
    String name = getFileName();
    File file = await storage.getLocalFile(name);
    await excel.encode().then((onValue) {
      file
        ..createSync(recursive: true)
        ..writeAsBytesSync(onValue);
    });
    return file.path;
  }

  String getFileName() {
    return chosenCenter.name + '.xlsx';
  }
}
