import 'dart:math';

import 'package:al_halaqat/app/home/approved/common_screens/user_instances/evaluation/evaluation_provider.dart';
import 'package:al_halaqat/app/models/evaluation.dart';
import 'package:al_halaqat/app/models/evaluation_helper.dart';
import 'package:al_halaqat/app/models/instance.dart';
import 'package:al_halaqat/app/models/quran.dart';
import 'package:al_halaqat/app/models/report_card.dart';
import 'package:al_halaqat/app/models/report_card_summery.dart';
import 'package:al_halaqat/app/models/user.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart' as intl2;

class EvaluationBloc {
  EvaluationBloc({
    @required this.provider,
    @required this.instance,
    @required this.user,
    @required this.studentId,
    @required this.studentName,
    @required this.quran,
  });
  final String studentId;
  final String studentName;
  final EvaluationProvider provider;
  final Instance instance;
  final User user;
  final Quran quran;

  String format(DateTime dateTime) {
    return intl2.DateFormat("yyyy-MM-dd").format(dateTime);
  }

  String format2(EvaluationHelper eval) {
    String one = eval.fromSoura + '(${eval.fromAya})';
    String two = eval.toSoura + '(${eval.toAya})';
    return one + ' ' + two;
  }

  List<String> getColumnTitle() {
    return [
      'الحصة',
      'الحفظ',
      'التقييم',
      'المراجعة',
      'التقييم',
    ];
  }

  List<String> getPossibleMarks() {
    return [
      '0',
      '1',
      '2',
      '3',
      '4',
      '5',
    ];
  }

  List<String> getSouratList() {
    return quran.data.keys.toList();
  }

  List<String> getAyatList(String soura) {
    int finalAyaNumber = quran.data[soura];
    List<String> ayatList = List();
    for (int i = 1; i <= finalAyaNumber; i++) ayatList.add('$i');

    return ayatList;
  }

  Stream<List<Evaluation>> fetchEvaluations() =>
      provider.fetchEvaluations(studentId, instance.halaqaId);

  Future<void> setEvaluation(
    Evaluation evaluation,
    List<Evaluation> evaluationsList,
  ) async {
    if (evaluation.id == null) {
      evaluation.id = provider.getUniqueId();
      evaluation.instanceId = instance.id;
      evaluation.studentName = studentName;

      evaluation.createdBy = {
        'name': user.name,
        'id': user.id,
      };
    }

    evaluationsList.add(evaluation);
    List<ReportCardSummery> summeryList = List();
    List<String> sourateList = getSouratList();

    for (String soura in sourateList) {
      int biggestAya = 0;
      for (Evaluation evaluation in evaluationsList) {
        if (soura == evaluation.memorized.toSoura) {
          biggestAya = evaluation.memorized.toAya;
        }
      }
      double precentage = biggestAya / quran.data[soura] * 100;
      ReportCardSummery temp = ReportCardSummery(
        soura: soura,
        numbeOfAyatInSoura: quran.data[soura],
        numberOfAyatMemorized: biggestAya,
        percentage: roundDouble(precentage),
      );
      summeryList.add(temp);
    }

    double summeryPercentage = 0;

    for (ReportCardSummery summery in summeryList) {
      summeryPercentage += summery.percentage;
    }
    summeryPercentage = summeryPercentage / summeryList.length;

    ReportCard reportCard = ReportCard(
      id: studentId + '_' + instance.halaqaId,
      studentName: studentName,
      centerId: instance.centerId,
      halaqaId: instance.halaqaId,
      studentId: studentId,
      summery: summeryList,
      precentage: roundDouble(summeryPercentage),
    );

    // for(Evaluation)
    await provider.setReportCard(reportCard);
    await provider.setEvaluation(reportCard.id, evaluation);
  }

  double roundDouble(double value) {
    double mod = pow(10.0, 2);
    double result = (value * mod).round().toDouble() / mod;

    return result;
  }
}
