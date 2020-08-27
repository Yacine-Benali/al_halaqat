import 'dart:math';

import 'package:al_halaqat/app/home/approved/student/student_summery/student_summery_provider.dart';
import 'package:al_halaqat/app/models/evaluation.dart';
import 'package:al_halaqat/app/models/instance.dart';
import 'package:al_halaqat/app/models/quran.dart';
import 'package:al_halaqat/app/models/report_card.dart';
import 'package:al_halaqat/app/models/report_card_summery.dart';
import 'package:al_halaqat/app/models/student.dart';
import 'package:al_halaqat/app/models/student_profile.dart';
import 'package:flutter/material.dart';

class StudentSummeryBloc {
  StudentSummeryBloc({
    @required this.provider,
    @required this.student,
  });

  final Student student;
  final StudentSummeryProvider provider;

  Future<Quran> _fetchQuran() => provider.fetchQuran();

  Future<List<StudentProfile>> _getStudentProfile() async {
    List<StudentProfile> studentsProfileList = List();
    // print(student.halaqatLearningIn);
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

  Future<ReportCard> getReportCard() async {
    List<StudentProfile> studentProfileList = await _getStudentProfile();
    Quran quran = await _fetchQuran();
    List<ReportCard> reportCardsList =
        studentProfileList.map((e) => e.reportCard).toList();

    List<ReportCardSummery> summeryList = List();
    List<String> souratList = quran.data.keys.toList();
    // print(reportCardsList);
    //! some fuckery is comming at you beware
    for (String soura in souratList) {
      int numberOfAyatMemorized = 0;

      for (ReportCard reportCard in reportCardsList) {
        int temp = reportCard.summery
            .firstWhere((reportCardSummery) => reportCardSummery.soura == soura)
            .numberOfAyatMemorized;

        if (numberOfAyatMemorized < temp) {
          numberOfAyatMemorized = temp;
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
