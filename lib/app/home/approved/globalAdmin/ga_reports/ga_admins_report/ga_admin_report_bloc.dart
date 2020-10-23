import 'dart:io';

import 'package:alhalaqat/app/home/approved/globalAdmin/ga_reports/ga_admins_report/ga_admin_report_provider.dart';
import 'package:alhalaqat/app/home/approved/globalAdmin/ga_reports/ga_admins_report/ga_admin_report_row.dart';
import 'package:alhalaqat/app/models/admin.dart';
import 'package:alhalaqat/app/models/study_center.dart';
import 'package:alhalaqat/common_widgets/format.dart';
import 'package:alhalaqat/constants/key_translate.dart';
import 'package:alhalaqat/services/local_storage_service.dart';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';

class GaAdminReportBloc {
  GaAdminReportBloc({
    @required this.provider,
  });

  final GaAdminReportProvider provider;

  Future<List<GaAdminReportRow>> getAdminReport() async {
    List<Admin> adminsList = await provider.fetchAdmins();
    List<StudyCenter> centersList = List();
    List<GaAdminReportRow> adminRows = List();

    for (Admin admin in adminsList) {
      Map<String, String> centerState = admin.centerState;
      for (MapEntry entry in centerState.entries.toList()) {
        StudyCenter center;
        for (StudyCenter existingCenter in centersList) {
          if (existingCenter?.id == entry.key) center = existingCenter;
        }
        if (center == null) {
          StudyCenter newCenter = await provider.fetchAdminCenter(entry.key);
          center = newCenter;
          centersList.add(newCenter);
        }
        GaAdminReportRow temp = GaAdminReportRow(
          admin: admin,
          center: center,
          state: entry.value,
        );
        adminRows.add(temp);
      }
    }

    return adminRows;
  }

  List<String> getColumnTitle() {
    List<String> columnTitleList = List();
    columnTitleList.addAll([
      'رقم المشرف',
      'الاسم',
      'المركز',
      'الحالة',
      'سنة الميلاد',
      'الجنس',
      'الجنسية',
      'العنوان',
      'رقم الهاتف',
      'الالمستوى  التعليمي',
      'المدرسة/الجامعة',
      'ملاحظات',
      'تاريخ إنشاء الحساب',
      'بواسطة',
    ]);

    return columnTitleList;
  }

  Future<String> getReportasCsv(List<GaAdminReportRow> rowList) async {
    var excel = Excel.createExcel();
    Sheet centesSheet = excel['المشرفين'];
    excel.delete('Sheet1');

    // add stamp
    List<String> stamp = ['التاريخ', Format.date(DateTime.now())];
    centesSheet.insertRowIterables(stamp, 0);

    centesSheet.appendRow(getColumnTitle());
    for (GaAdminReportRow row in rowList) {
      List<String> fuckingRow = List();
      fuckingRow.add(row.admin.readableId);
      fuckingRow.add(row.admin.name);
      fuckingRow.add(row.center?.name ?? '');
      fuckingRow.add(KeyTranslate.reportsState[row.state] ?? '');
      fuckingRow.add(row.admin.dateOfBirth.toString());
      fuckingRow.add(row.admin.gender);
      fuckingRow.add(KeyTranslate.isoCountryToArabic[row.admin.nationality]);
      fuckingRow.add(row.admin.address);
      fuckingRow.add(row.admin.phoneNumber);
      fuckingRow.add(row.admin.educationalLevel);
      fuckingRow.add(row.admin.etablissement);
      fuckingRow.add(row.admin.note);
      fuckingRow.add(Format.date(row.admin.createdAt.toDate()));
      fuckingRow.add(row.admin.createdBy['name']);

      centesSheet.appendRow(fuckingRow);
    }
    LocalStorageService storage = LocalStorageService();
    String name = 'admins_report.xlsx';
    File file = await storage.getLocalFile(name);
    await excel.encode().then((onValue) {
      file
        ..createSync(recursive: true)
        ..writeAsBytesSync(onValue);
    });

    return file.path;
  }
}
