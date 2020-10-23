import 'dart:io';

import 'package:alhalaqat/app/home/approved/globalAdmin/ga_reports/ga_students_reports/ga_student_report_row.dart';
import 'package:alhalaqat/app/home/approved/globalAdmin/ga_reports/ga_students_reports/ga_students_report_provider.dart';
import 'package:alhalaqat/app/models/student.dart';
import 'package:alhalaqat/app/models/study_center.dart';
import 'package:alhalaqat/common_widgets/format.dart';
import 'package:alhalaqat/constants/key_translate.dart';
import 'package:alhalaqat/services/local_storage_service.dart';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';

class GaStudentsReportBloc {
  GaStudentsReportBloc({
    @required this.provider,
  });

  final GaStudentsReportProvider provider;

  Future<List<GaStudentReportRow>> getStudentReport() async {
    List<Student> studentsList = await provider.fetchStudents();
    List<StudyCenter> centersList = List();
    List<GaStudentReportRow> adminRows = List();

    for (Student student in studentsList) {
      StudyCenter center;
      for (StudyCenter existingCenter in centersList) {
        if (existingCenter?.id == student.center) center = existingCenter;
      }
      if (center == null) {
        StudyCenter newCenter =
            await provider.fetchStudentCenter(student.center);
        center = newCenter;
        centersList.add(newCenter);
      }
      GaStudentReportRow temp = GaStudentReportRow(
        student: student,
        center: center,
      );
      adminRows.add(temp);
    }

    return adminRows;
  }

  List<String> getColumnTitle() {
    List<String> columnTitleList = List();
    columnTitleList.addAll([
      'المركز',
      'الحالة',
      'رقم المستخدم',
      'الاسم',
      'سنة الميلاد',
      'الجنس',
      'الجنسية',
      'العنوان',
      'رقم الهاتف',
      'رقم ثاني',
      'الالمستوى  التعليمي',
      'المدرسة/الجامعة',
      'ملاحظات',
      'تاريخ إنشاء الحساب',
      'بواسطة'
    ]);

    return columnTitleList;
  }

  Future<String> getReportasCsv(List<GaStudentReportRow> rowList) async {
    var excel = Excel.createExcel();
    Sheet centesSheet = excel['الطلاب'];
    excel.delete('Sheet1');

    // add stamp
    List<String> stamp = ['التاريخ', Format.date(DateTime.now())];
    centesSheet.insertRowIterables(stamp, 0);

    centesSheet.appendRow(getColumnTitle());
    for (GaStudentReportRow row in rowList) {
      List<String> fuckingRow = List();
      fuckingRow.add(row.center?.name ?? '');
      fuckingRow.add(KeyTranslate.reportsState[row.student.state]);

      fuckingRow.add(row.student.readableId);
      fuckingRow.add(row.student.name);
      fuckingRow.add(row.student.dateOfBirth.toString());
      fuckingRow.add(row.student.gender);
      fuckingRow.add(KeyTranslate.isoCountryToArabic[row.student.nationality]);
      fuckingRow.add(row.student.address);
      fuckingRow.add(row.student.phoneNumber);
      fuckingRow.add(row.student.parentPhoneNumber);
      fuckingRow.add(row.student.educationalLevel);
      fuckingRow.add(row.student.etablissement);
      fuckingRow.add(row.student.note);
      fuckingRow.add(Format.date(row.student.createdAt.toDate()));
      fuckingRow.add(row.student.createdBy['name']);

      centesSheet.appendRow(fuckingRow);
    }
    LocalStorageService storage = LocalStorageService();
    String name = 'students_report.xlsx';
    File file = await storage.getLocalFile(name);
    await excel.encode().then((onValue) {
      file
        ..createSync(recursive: true)
        ..writeAsBytesSync(onValue);
    });

    return file.path;
  }
}
