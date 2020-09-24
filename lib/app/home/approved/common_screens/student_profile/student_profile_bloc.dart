import 'dart:math';

import 'package:alhalaqat/app/home/approved/common_screens/student_profile/student_profile_provider.dart';
import 'package:alhalaqat/app/models/evaluation.dart';
import 'package:alhalaqat/app/models/evaluation_helper.dart';
import 'package:alhalaqat/app/models/halaqa.dart';
import 'package:alhalaqat/app/models/instance.dart';
import 'package:alhalaqat/app/models/quran.dart';
import 'package:alhalaqat/app/models/report_card.dart';
import 'package:alhalaqat/app/models/report_card_summery.dart';
import 'package:alhalaqat/app/models/student.dart';
import 'package:alhalaqat/app/models/student_attendance.dart';
import 'package:alhalaqat/app/models/student_profile.dart';
import 'package:alhalaqat/constants/key_translate.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl2;

class StudentProfileBloc {
  StudentProfileBloc({
    @required this.halaqatList,
    @required this.student,
    @required this.provider,
    @required this.quran,
    @required this.studentRoaming,
  });

  final StudentProfileProvider provider;
  final List<Halaqa> halaqatList;
  final Student student;
  final Quran quran;
  final bool studentRoaming;

  List<String> getSouratList() {
    return quran.data.keys.toList();
  }

  List<String> getEvaluationsTableTitle() {
    return [
      'الحصة',
      'الحفظ',
      'التقييم',
      'المراجعة',
      'التقييم',
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
    return one + ' ' + two;
  }

  String format(DateTime dateTime) {
    return intl2.DateFormat("yyyy-MM-dd").format(dateTime);
  }

  List<String> getAttendaceTableTitle() {
    List<String> columnTitleList = List();
    columnTitleList.add('إسم');
    columnTitleList.addAll(KeyTranslate.attendanceState.values);
    columnTitleList.addAll([
      'ملاحظة',
    ]);
    return columnTitleList;
  }

  Future<List<StudentProfile>> getStudentProfile() async {
    List<StudentProfile> studentsProfileList = List();

    for (String halaqaLearingIn in student.halaqatLearningIn) {
      bool isFound = false;
      String profileHalaqaName = '';
      for (Halaqa halaqa in halaqatList) {
        if (halaqa.id == halaqaLearingIn) {
          isFound = true;
          profileHalaqaName = halaqa.name;
        }
      }
      if (!isFound && studentRoaming) {
        Halaqa halaqa = await provider.fetchHalaqa(halaqaLearingIn);
        profileHalaqaName = halaqa.name;
      }

      String reportCardId = student.id + '_' + halaqaLearingIn;

      Future<List<Instance>> instancesList =
          provider.fetchInstances(halaqaLearingIn);
      Future<List<Evaluation>> evaluationsList =
          provider.fetchEvaluations(reportCardId);
      Future<ReportCard> reportCard = provider.fetchReportCard(reportCardId);

      final snapshots =
          Future.wait([instancesList, evaluationsList, reportCard]);
      List<Object> snapshotsData = await snapshots;

      final temp = StudentProfile(
        halaqaId: halaqaLearingIn,
        halaqaName: profileHalaqaName,
        instancesList: snapshotsData[0],
        evaluationsList: snapshotsData[1],
        reportCard: snapshotsData[2],
      );
      studentsProfileList.add(temp);
    }

    return studentsProfileList;
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

  Future<ReportCard> mergeReportCard(List<ReportCard> reportCardsList) async {
    List<ReportCardSummery> summeryList = List();
    List<String> souratList = getSouratList();

    //! some fuckery is comming at you beware
    for (String soura in souratList) {
      int numberOfAyatMemorized = 0;

      for (ReportCard reportCard in reportCardsList) {
        if (reportCard != null) {
          int temp = reportCard.summery
              .firstWhere(
                  (reportCardSummery) => reportCardSummery.soura == soura)
              .numberOfAyatMemorized;

          if (numberOfAyatMemorized < temp) {
            numberOfAyatMemorized = temp;
          }
        }
      }
      double precentage = numberOfAyatMemorized / quran.data[soura] * 100;
      ReportCardSummery temp2 = ReportCardSummery(
        soura: soura,
        numbeOfAyatInSoura: quran.data[soura],
        numberOfAyatMemorized: numberOfAyatMemorized,
        percentage: roundDouble(precentage),
      );
      summeryList.add(temp2);
    }
    double summeryPercentage = 0;

    for (ReportCardSummery summery in summeryList) {
      summeryPercentage += summery.percentage;
    }
    summeryPercentage = summeryPercentage / summeryList.length;

    return ReportCard(
      id: 'fuck it',
      studentName: student.name,
      centerId: 'null',
      halaqaId: 'null',
      studentId: 'null',
      precentage: roundDouble(summeryPercentage),
      summery: summeryList,
    );
  }

  double roundDouble(double value) {
    double mod = pow(10.0, 2);
    double result = (value * mod).round().toDouble() / mod;

    return result;
  }
}
