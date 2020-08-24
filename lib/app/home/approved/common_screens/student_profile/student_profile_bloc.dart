import 'package:al_halaqat/app/home/approved/common_screens/student_profile/student_profile_provider.dart';
import 'package:al_halaqat/app/models/evaluation.dart';
import 'package:al_halaqat/app/models/evaluation_helper.dart';
import 'package:al_halaqat/app/models/halaqa.dart';
import 'package:al_halaqat/app/models/instance.dart';
import 'package:al_halaqat/app/models/report_card.dart';
import 'package:al_halaqat/app/models/student.dart';
import 'package:al_halaqat/app/models/student_attendance.dart';
import 'package:al_halaqat/app/models/student_profile.dart';
import 'package:al_halaqat/constants/key_translate.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl2;

class StudentProfileBloc {
  StudentProfileBloc({
    @required this.halaqatList,
    @required this.student,
    @required this.provider,
  });

  final StudentProfileProvider provider;
  final List<Halaqa> halaqatList;
  final Student student;

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
      'النسبة المؤية',
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

  List<String> getTitles() {
    List<String> titles = List();

    titles.add('ملف شخصي');

    for (String halaqaLearingIn in student.halaqatLearningIn) {
      for (Halaqa halaqa in halaqatList) {
        if (halaqa.id == halaqaLearingIn) {
          titles.add(halaqa.name);
        }
      }
    }
    return titles;
  }

  Future<List<StudentProfile>> getStudentProfile() async {
    List<StudentProfile> studentsProfileList = List();

    for (String halaqaLearingIn in student.halaqatLearningIn) {
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
}
