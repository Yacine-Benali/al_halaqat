import 'dart:io';

import 'package:alhalaqat/app/home/approved/globalAdmin/ga_reports/ga_halaqat_reports/ga_halaqa_report_row.dart';
import 'package:alhalaqat/app/home/approved/globalAdmin/ga_reports/ga_halaqat_reports/ga_halaqat_report_provider.dart';
import 'package:alhalaqat/app/models/halaqa.dart';
import 'package:alhalaqat/app/models/student.dart';
import 'package:alhalaqat/app/models/study_center.dart';
import 'package:alhalaqat/app/models/teacher.dart';
import 'package:alhalaqat/common_widgets/format.dart';
import 'package:alhalaqat/constants/key_translate.dart';
import 'package:alhalaqat/services/storage.dart';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';

class GaCHalaqatReportBloc {
  GaCHalaqatReportBloc({
    @required this.provider,
  });

  final GaHalaqatReportProvider provider;

  Future<List<GaHalaqaReportRow>> getHalaqatReport() async {
    List<GaHalaqaReportRow> list = List();
    List<StudyCenter> centersList = List();

    List<Halaqa> halaqatList = await provider.fetchHalaqat();

    for (Halaqa halaqa in halaqatList) {
      StudyCenter center;
      for (StudyCenter existingCenter in centersList) {
        if (existingCenter.id == halaqa.centerId) center = existingCenter;
      }
      if (center == null) {
        StudyCenter newCenter =
            await provider.fetchHalaqaCenter(halaqa.centerId);
        center = newCenter;
        centersList.add(newCenter);
      }
      List<Student> studentsList =
          await provider.fetchHalaqaStudents(halaqa.id);
      Teacher teacher = await provider.fetchHalaqaTeacher(halaqa.id);

      GaHalaqaReportRow row = GaHalaqaReportRow(
        center: center,
        halaqa: halaqa,
        numberOfStudents: studentsList.length ?? 0,
        teacher: teacher,
      );
      list.add(row);
    }
    return list;
  }

  List<String> getColumnTitle() {
    List<String> columnTitleList = List();
    columnTitleList.addAll([
      'اسم الحلقة',
      'رقم الحلقة',
      'المعلم',
      'عدد الطلاب',
      'المركز',
      'الحالة',
      'بواسطة'
    ]);

    return columnTitleList;
  }

  Future<String> getReportasCsv(List<GaHalaqaReportRow> rowList) async {
    var excel = Excel.createExcel();
    Sheet centesSheet = excel['الحلقات'];
    excel.delete('Sheet1');

    // add stamp
    List<String> stamp = ['التاريخ', Format.date(DateTime.now())];
    centesSheet.insertRowIterables(stamp, 0);

    centesSheet.appendRow(getColumnTitle());
    for (GaHalaqaReportRow row in rowList) {
      List<String> fuckingRow = List();
      fuckingRow.add(row.halaqa.name);
      fuckingRow.add(row.halaqa.readableId);
      fuckingRow.add(row.teacher?.name ?? '');
      fuckingRow.add(row.numberOfStudents.toString());
      fuckingRow.add(row.center.name);
      fuckingRow.add(KeyTranslate.centersStateList[row.halaqa.state]);
      fuckingRow.add(row.halaqa.createdBy['name'] ?? '');
      centesSheet.appendRow(fuckingRow);
    }
    Storage storage = Storage();
    String name = 'halaqat_report.xlsx';
    File file = await storage.getLocalFile(name);
    await excel.encode().then((onValue) {
      file
        ..createSync(recursive: true)
        ..writeAsBytesSync(onValue);
    });

    return file.path;
  }
}
