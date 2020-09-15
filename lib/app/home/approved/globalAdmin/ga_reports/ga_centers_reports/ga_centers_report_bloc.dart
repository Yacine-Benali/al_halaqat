import 'dart:io';

import 'package:al_halaqat/app/home/approved/globalAdmin/ga_reports/ga_centers_reports/ga_center_report_row.dart';
import 'package:al_halaqat/app/home/approved/globalAdmin/ga_reports/ga_centers_reports/ga_centers_report_provider.dart';
import 'package:al_halaqat/app/models/halaqa.dart';
import 'package:al_halaqat/app/models/student.dart';
import 'package:al_halaqat/app/models/study_center.dart';
import 'package:al_halaqat/app/models/teacher.dart';
import 'package:al_halaqat/common_widgets/format.dart';
import 'package:al_halaqat/constants/key_translate.dart';
import 'package:al_halaqat/services/storage.dart';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';

class GaCentersReportBloc {
  GaCentersReportBloc({
    @required this.provider,
  });

  final GaCentersReportProvider provider;

  Future<List<GaCenterReportRow>> getCenterReports() async {
    List<GaCenterReportRow> list = List();

    List<StudyCenter> centersList = await provider.fetchCenters();
    for (StudyCenter center in centersList) {
      List<Student> approvedStudentsList =
          await provider.fetchCenterStudents(center.id, 'approved');
      List<Student> archivedStudentsList =
          await provider.fetchCenterStudents(center.id, 'archived');
      List<Halaqa> approvedHalaqatList =
          await provider.fetchCenterHalaqat(center.id, 'approved');
      List<Halaqa> archivedHalaqatList =
          await provider.fetchCenterHalaqat(center.id, 'archived');

      List<Teacher> approvedTeachersList =
          await provider.fetchCenterTeachers(center.id, 'approved');

      List<Teacher> archivedTeachersList =
          await provider.fetchCenterTeachers(center.id, 'archived');

      GaCenterReportRow row = GaCenterReportRow(
        center: center,
        numberOfApprovedStudents: approvedStudentsList.length ?? 0,
        numberOfArchivedStudents: archivedStudentsList.length ?? 0,
        numberOfApprovedTeachers: approvedTeachersList.length ?? 0,
        numberOfArchivedTeachers: archivedTeachersList.length ?? 0,
        numberOfApprovedHalaqat: approvedHalaqatList.length ?? 0,
        numberOfArchivedHalaqat: archivedHalaqatList.length ?? 0,
      );
      list.add(row);
    }
    return list;
  }

  List<String> getColumnTitle() {
    List<String> columnTitleList = List();
    columnTitleList.addAll([
      'رقم المركز',
      'اسم المركز',
      'العنوان',
      'رقم الهاتف',
      'تاريخ الإنشاء',
      'بواسطة',
      'عدد الطلاب النشطاء',
      'عدد الطلاب المؤرشفين',
      'عدد المعلمين النشطاء',
      'عدد المعلمين المؤرشفين',
      'عدد الحلقات النشطة',
      'عدد الحلقات المؤرشفة',
      'الحالة'
    ]);

    return columnTitleList;
  }

  String getAddress(StudyCenter center) {
    return KeyTranslate.isoCountryToArabic[center.country] +
        ' ' +
        center.city +
        ' ' +
        center.street;
  }

  Future<String> getReportasCsv(List<GaCenterReportRow> rowList) async {
    var excel = Excel.createExcel();
    Sheet centesSheet = excel['المراكز'];
    excel.delete('Sheet1');

    // add stamp
    List<String> stamp = ['التاريخ', Format.date(DateTime.now())];
    centesSheet.insertRowIterables(stamp, 0);

    centesSheet.appendRow(getColumnTitle());
    for (GaCenterReportRow row in rowList) {
      List<String> fuckingRow = List();
      fuckingRow.add(row.center.readableId);
      fuckingRow.add(row.center.name);
      fuckingRow.add(getAddress(row.center));
      fuckingRow.add(row.center.phoneNumber);
      fuckingRow
          .add(Format.date(row.center.createdAt.toDate() ?? DateTime.now()));
      fuckingRow.add(row.center.createdBy['name']);
      fuckingRow.add(row.numberOfApprovedStudents.toString());
      fuckingRow.add(row.numberOfArchivedStudents.toString());
      fuckingRow.add(row.numberOfApprovedTeachers.toString());
      fuckingRow.add(row.numberOfArchivedTeachers.toString());
      fuckingRow.add(row.numberOfApprovedHalaqat.toString());
      fuckingRow.add(row.numberOfArchivedHalaqat.toString());

      fuckingRow.add(KeyTranslate.userStateList[row.center.state]);
      centesSheet.appendRow(fuckingRow);
    }
    Storage storage = Storage();
    String name = 'centers_report.xlsx';
    File file = await storage.getLocalFile(name);
    await excel.encode().then((onValue) {
      file
        ..createSync(recursive: true)
        ..writeAsBytesSync(onValue);
    });

    return file.path;
  }
}
