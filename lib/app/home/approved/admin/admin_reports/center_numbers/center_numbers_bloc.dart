import 'dart:io';

import 'package:al_halaqat/app/home/approved/admin/admin_reports/center_numbers/center_numbers_provider.dart';
import 'package:al_halaqat/app/models/center_numbers.dart';
import 'package:al_halaqat/app/models/halaqa.dart';
import 'package:al_halaqat/app/models/student.dart';
import 'package:al_halaqat/app/models/study_center.dart';
import 'package:al_halaqat/app/models/teacher.dart';
import 'package:al_halaqat/services/storage.dart';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';

class CenterNumbersBloc {
  CenterNumbersBloc({
    @required this.provider,
    @required this.center,
  });

  final CenterNumbersProvider provider;
  final StudyCenter center;

  Future<CenterNumbers> fetchCenterNumbers() async {
    Future<List<Student>> activeStudentsList =
        provider.fetchStudents(center.id, 'approved');
    Future<List<Student>> archivedStudentsList =
        provider.fetchStudents(center.id, 'archived');

    Future<List<Teacher>> activeTeachersListF =
        provider.fetchTeachers(center.id, 'approved');
    Future<List<Teacher>> archivedTeachersListF =
        provider.fetchTeachers(center.id, 'archived');
    Future<List<Halaqa>> activeHalaqatListF =
        provider.fetchHalaqat(center.id, 'approved');

    Future<List<Halaqa>> archivedHalaqatListF =
        provider.fetchHalaqat(center.id, 'archived');

    List<List<Object>> snapshotsData = await Future.wait([
      activeStudentsList,
      archivedStudentsList,
      activeTeachersListF,
      archivedTeachersListF,
      activeHalaqatListF,
      archivedHalaqatListF,
    ]);

    return CenterNumbers(
      centerName: center.name,
      activeStudents: snapshotsData[0].length ?? 0,
      archivedStudents: snapshotsData[1].length ?? 0,
      activeTeachers: snapshotsData[2].length ?? 0,
      archivedTeachers: snapshotsData[3].length ?? 0,
      activeHalaqat: snapshotsData[4].length ?? 0,
      archivedHalaqat: snapshotsData[5].length ?? 0,
    );
  }

  List<String> getColumnTitle() {
    List<String> columnTitleList = List();

    return columnTitleList;
  }

  Future<String> getReportasCsv(
      bool showArchived, CenterNumbers centerNumbers) async {
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Sheet1'];

    List<String> row = List();
    row.addAll(getColumnTitle());
    sheetObject.insertRowIterables(row, 0);
    row.clear();
    row.add(centerNumbers.centerName);
    row.add(
      showArchived
          ? centerNumbers.activeTeachers.toString()
          : centerNumbers.archivedTeachers.toString(),
    );
    row.add(
      showArchived
          ? centerNumbers.activeStudents.toString()
          : centerNumbers.archivedStudents.toString(),
    );
    row.add(
      showArchived
          ? centerNumbers.activeHalaqat.toString()
          : centerNumbers.archivedStudents.toString(),
    );
    sheetObject.appendRow(row);

    Storage storage = Storage();
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
    return center.name + '.xlsx';
  }
}