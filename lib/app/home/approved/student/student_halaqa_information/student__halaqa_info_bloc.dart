import 'dart:math';

import 'package:alhalaqat/app/models/evaluation_helper.dart';
import 'package:alhalaqat/app/models/instance.dart';
import 'package:alhalaqat/app/models/student.dart';
import 'package:alhalaqat/app/models/student_attendance.dart';
import 'package:alhalaqat/constants/key_translate.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart' as intl2;

class StudentHalaqaInfoBloc {
  StudentHalaqaInfoBloc({
    @required this.student,
  });

  final Student student;

  List<String> getEvaluationsTableTitle() {
    return [
      'الحصة',
      'الحفظ',
      'التقييم',
      'المراجعة',
      'التقييم',
      'الملاحظة',
    ];
  }

  List<String> getReportCardTitles() {
    return [
      'السورة',
      'النسبة المئوية',
    ];
  }

  String format2(EvaluationHelper eval) {
    String one = eval.fromSoura + '(${eval.fromAya})';
    String two = eval.toSoura + '(${eval.toAya})';
    return one + '\n' + two;
  }

  String format(DateTime dateTime) {
    return intl2.DateFormat("yyyy-MM-dd").format(dateTime);
  }

  List<String> getAttendaceTableTitle() {
    List<String> columnTitleList = List();
    columnTitleList.add('إسم');
    columnTitleList.addAll(KeyTranslate.attendanceState.values);

    return columnTitleList;
  }

  List<String> getTitles() {
    List<String> titles = List();

    titles.add('الحضور');
    titles.add('التقييمات');

    return titles;
  }

  List<StudentAttendance> getStudentAttendance(List<Instance> instancesLis) {
    List<StudentAttendance> list = List();

    for (Instance instance in instancesLis) {
      for (StudentAttendance studentAttendance
          in instance.studentAttendanceList) {
        if (studentAttendance.id == student.id) {
          list.add(studentAttendance);
        }
      }
    }
    return list;
  }

  double roundDouble(double value) {
    double mod = pow(10.0, 2);
    double result = (value * mod).round().toDouble() / mod;

    return result;
  }
}
