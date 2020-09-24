import 'dart:io';

import 'package:alhalaqat/app/home/approved/common_screens/reports/s_learning/s_learning_provider.dart';
import 'package:alhalaqat/app/models/halaqa.dart';
import 'package:alhalaqat/app/models/report_card.dart';
import 'package:alhalaqat/services/storage.dart';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';

class SLearningBloc {
  SLearningBloc({
    @required this.provider,
    @required this.halaqatList,
  });

  final SLearningProvider provider;
  final List<Halaqa> halaqatList;

  Future<List<ReportCard>> fetchReportCards(
    Halaqa halaqa,
  ) =>
      provider.fetchReportCards(halaqa.id);

  List<String> getColumnTitle() {
    List<String> columnTitleList = List();
    columnTitleList.add('الاسم');
    columnTitleList.add('النسبة المئوية');

    return columnTitleList;
  }

  Future<String> saveReport(List<ReportCard> list, Halaqa halaqa) async {
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Sheet1'];

    List<List<String>> rows = List<List<String>>();
    List<String> row = List();
    row.addAll(getColumnTitle());
    sheetObject.insertRowIterables(row, 0);

    for (int i = 0; i < list.length; i++) {
      List<String> row = List();
      row.add(list[i].studentName);
      row.add(list[i].precentage.toString());

      sheetObject.appendRow(row);
    }
    Storage storage = Storage();
    String name = halaqa.name + '.xlsx';
    File file = await storage.getLocalFile(name);
    await excel.encode().then((onValue) {
      file
        ..createSync(recursive: true)
        ..writeAsBytesSync(onValue);
    });
    return file.path;
  }
}
