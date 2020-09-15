import 'dart:io';

import 'package:al_halaqat/app/home/approved/globalAdmin/ga_reports/ga_teachers_report/ga_teacher_report_row.dart';
import 'package:al_halaqat/app/home/approved/globalAdmin/ga_reports/ga_teachers_report/ga_teachers_report_provider.dart';
import 'package:al_halaqat/app/models/study_center.dart';
import 'package:al_halaqat/app/models/teacher.dart';
import 'package:al_halaqat/common_widgets/format.dart';
import 'package:al_halaqat/constants/key_translate.dart';
import 'package:al_halaqat/services/storage.dart';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';

class GaTeachersReportBloc {
  GaTeachersReportBloc({
    @required this.provider,
  });

  final GaTeachersReportProvider provider;

  Future<List<GaTeacherReportRow>> getTeachersReport() async {
    List<Teacher> teachersList = await provider.fetchTeachers();
    List<StudyCenter> centersList = List();
    List<GaTeacherReportRow> adminRows = List();

    for (Teacher teacher in teachersList) {
      Map<String, String> centerState = teacher.centerState;
      for (MapEntry entry in centerState.entries.toList()) {
        StudyCenter center;
        for (StudyCenter existingCenter in centersList) {
          if (existingCenter?.id == entry.key) center = existingCenter;
        }
        if (center == null) {
          StudyCenter newCenter = await provider.fetchTeacherCenter(entry.key);
          center = newCenter;
          centersList.add(newCenter);
        }
        GaTeacherReportRow temp = GaTeacherReportRow(
          teacher: teacher,
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
      'المركز',
      'رقم المستخدم',
      'الاسم',
      'سنة الميلاد',
      'الجنس',
      'الجنسية',
      'العنوان',
      'رقم الهاتف',
      'المستوى التعليمي',
      'المدرسة/الجامعة',
      'ملاحظات',
      'تاريخ إنشاء الحساب',
      'بواسطة'
    ]);

    return columnTitleList;
  }

  Future<String> getReportasCsv(List<GaTeacherReportRow> rowList) async {
    var excel = Excel.createExcel();
    Sheet centesSheet = excel['المعلمين'];
    excel.delete('Sheet1');

    // add stamp
    List<String> stamp = ['التاريخ', Format.date(DateTime.now())];
    centesSheet.insertRowIterables(stamp, 0);

    centesSheet.appendRow(getColumnTitle());
    for (GaTeacherReportRow row in rowList) {
      List<String> fuckingRow = List();
      fuckingRow.add(row.center?.name ?? '');
      fuckingRow.add(row.teacher.readableId);
      fuckingRow.add(row.teacher.name);
      fuckingRow.add(row.teacher.dateOfBirth.toString());
      fuckingRow.add(row.teacher.gender);
      fuckingRow.add(KeyTranslate.isoCountryToArabic[row.teacher.nationality]);
      fuckingRow.add(row.teacher.address);
      fuckingRow.add(row.teacher.phoneNumber);
      fuckingRow.add(row.teacher.educationalLevel);
      fuckingRow.add(row.teacher.etablissement);
      fuckingRow.add(row.teacher.note);
      fuckingRow.add(Format.date(row.teacher.createdAt.toDate()));
      fuckingRow.add(row.teacher.createdBy['name']);

      centesSheet.appendRow(fuckingRow);
    }
    Storage storage = Storage();
    String name = 'teachers_report.xlsx';
    File file = await storage.getLocalFile(name);
    await excel.encode().then((onValue) {
      file
        ..createSync(recursive: true)
        ..writeAsBytesSync(onValue);
    });

    return file.path;
  }
}
