import 'dart:io';

import 'package:alhalaqat/app/home/approved/globalAdmin/ga_reports/admin_logs/admin_logs_provider.dart';
import 'package:alhalaqat/app/models/admin_log.dart';
import 'package:alhalaqat/app/models/user.dart';
import 'package:alhalaqat/common_widgets/format.dart';
import 'package:alhalaqat/constants/key_translate.dart';
import 'package:alhalaqat/services/local_storage_service.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class AdminLogsBloc {
  AdminLogsBloc({
    @required this.provider,
    @required this.user,
  });

  final AdminLogsProvider provider;
  final User user;

  List<AdminLog> adminLogsList = [];
  List<AdminLog> emptyList = [];
  BehaviorSubject<List<AdminLog>> adminsLogsListController =
      BehaviorSubject<List<AdminLog>>();

  Stream<List<AdminLog>> get adminLogsStream => adminsLogsListController.stream;

  void fetchFirstInstances() {
    Future<List<AdminLog>> latestadminsLogs = provider.fetchIlatestInstances();

    latestadminsLogs.then((latestInstanceList) async {
      if (latestInstanceList.isNotEmpty) {
        if (adminLogsList.isNotEmpty) {
        } else {
          adminLogsList.insertAll(0, latestInstanceList);
        }
        if (!adminsLogsListController.isClosed) {
          adminsLogsListController.sink.add(adminLogsList);
        }
      } else {
        adminLogsList.clear();
        adminsLogsListController.sink.add(adminLogsList);
      }
    });
  }

  Future<bool> fetchNextMessages(AdminLog adminLog) async {
    List<AdminLog> moreIntances = await provider.fetchMoreInstances(
      adminLog,
    );
    await Future.delayed(Duration(milliseconds: 500));
    adminLogsList.addAll(moreIntances);
    if (!adminsLogsListController.isClosed) {
      adminsLogsListController.sink.add(adminLogsList);
    }
    return true;
  }

  void dispose() {
    adminsLogsListController.close();
  }

  Future<String> getReportasCsv(List<AdminLog> adminLogsList) async {
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['السجلات'];
    excel.delete('Sheet1');

    List<String> row = List();
    row.addAll([
      'الوقت',
      'المركز',
      'اسم المعلم',
      'الفعل',
      'اسم المفعول به',
    ]);
    sheetObject.insertRowIterables(row, 0);

    for (AdminLog adminLog in adminLogsList) {
      List<String> row = List();
      row.add(
          Format.dateWithTime(adminLog.createdAt.toDate() ?? DateTime.now()));
      row.add(adminLog.center.name);
      row.add(adminLog.admin.name);
      row.add(KeyTranslate.logActions[adminLog.action] +
          ' ' +
          KeyTranslate.logObjectNature[adminLog.object.nature]);
      row.add(adminLog.object.name);
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
    return 'attendance' + '.xlsx';
  }
}
