import 'dart:math';

import 'package:alhalaqat/app/home/approved/common_screens/user_instances/evaluation/evaluation_provider.dart';
import 'package:alhalaqat/app/models/evaluation.dart';
import 'package:alhalaqat/app/models/evaluation_helper.dart';
import 'package:alhalaqat/app/models/instance.dart';
import 'package:alhalaqat/app/models/quran.dart';
import 'package:alhalaqat/app/models/report_card.dart';
import 'package:alhalaqat/app/models/report_card_summery.dart';
import 'package:alhalaqat/app/models/user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
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
    return one + '--' + two;
  }

  List<String> getColumnTitle() {
    return [
      'التاريخ',
      'الحفظ',
      'التقييم',
      'المراجعة',
      'التقييم',
    ];
  }

  List<String> getPossibleMarks() {
    return [
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

  void validateEvaluation(Evaluation evaluation) {
    bool shouldThrow = false;
    List<String> sourateList = getSouratList();
    int memorizedFromSoura =
        sourateList.indexOf(evaluation.memorized.fromSoura);
    int memorizedFromAya = evaluation.memorized.fromAya;
    int memorizedToSoura = sourateList.indexOf(evaluation.memorized.toSoura);
    int memorizedToAya = evaluation.memorized.toAya;
    //
    if (memorizedFromSoura > memorizedToSoura) {
      // throw
      shouldThrow = true;
    } else if (memorizedFromSoura == memorizedToSoura) {
      if (memorizedFromAya > memorizedToAya) {
        //throw
        shouldThrow = true;
      }
    }
    int rehearsedFromSoura =
        sourateList.indexOf(evaluation.rehearsed.fromSoura);
    int rehearsedFromAya = evaluation.rehearsed.fromAya;
    int rehearsedToSoura = sourateList.indexOf(evaluation.rehearsed.toSoura);
    int rehearsedToAya = evaluation.rehearsed.toAya;

    if (rehearsedFromSoura > rehearsedToSoura) {
      // throw
      shouldThrow = true;
    } else if (rehearsedFromSoura == rehearsedToSoura) {
      if (rehearsedFromAya > rehearsedToAya) {
        //throw
        shouldThrow = true;
      }
    }
    if (shouldThrow)
      throw PlatformException(
        code: 'INVALID_EVALUATION',
        message: 'the entered evaluation is invalid',
      );
  }

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

    //! let the magic begins
    for (String fromSoura in sourateList) {
      bool isFound = false;
      for (Evaluation evaluation in evaluationsList) {
        if (fromSoura == evaluation.memorized.fromSoura) {
          isFound = true;
          String toSoura = evaluation.memorized.toSoura;
          if (fromSoura == toSoura) {
            int biggestAya = evaluation.memorized.toAya;

            double precentage = biggestAya / quran.data[fromSoura] * 100;
            ReportCardSummery temp = ReportCardSummery(
              soura: fromSoura,
              numbeOfAyatInSoura: quran.data[fromSoura],
              numberOfAyatMemorized: biggestAya,
              percentage: roundDouble(precentage),
            );
            summeryList.add(temp);
          } else {
            int fromSouraIndex = sourateList.indexOf(fromSoura);
            int fromAya = evaluation.memorized.fromAya;
            int toSouraIndex = sourateList.indexOf(toSoura);
            int toAya = evaluation.memorized.toAya;

            if (fromSouraIndex < toSouraIndex) {
              int beginingSouraBiggestAya = quran.data[fromSoura] + 1 - fromAya;
              double precentage =
                  beginingSouraBiggestAya / quran.data[fromSoura] * 100;
              ReportCardSummery temp = ReportCardSummery(
                soura: fromSoura,
                numbeOfAyatInSoura: quran.data[fromSoura],
                numberOfAyatMemorized: beginingSouraBiggestAya,
                percentage: roundDouble(precentage),
              );
              summeryList.add(temp);
              for (int i = fromSouraIndex + 1; i < toSouraIndex; i++) {
                String finishedSoura = sourateList.elementAt(i);
                ReportCardSummery temp = ReportCardSummery(
                  soura: finishedSoura,
                  numbeOfAyatInSoura: quran.data[finishedSoura],
                  numberOfAyatMemorized: quran.data[finishedSoura],
                  percentage: 100,
                );
                summeryList.add(temp);
              }
              double lastPrecentage = toAya / quran.data[toSoura] * 100;

              ReportCardSummery lastTemp = ReportCardSummery(
                soura: toSoura,
                numbeOfAyatInSoura: quran.data[toSoura],
                numberOfAyatMemorized: toAya,
                percentage: roundDouble(lastPrecentage),
              );
              summeryList.add(lastTemp);
            } else {
              //TODO throw exception
            }
          }
        } else {
          int fromSouraIndex = sourateList.indexOf(fromSoura);
          int evaluationFromSouraIndex =
              sourateList.indexOf(evaluation.memorized.fromSoura);
          int evaluationToSouraIndex =
              sourateList.indexOf(evaluation.memorized.toSoura);
          if (fromSouraIndex < evaluationToSouraIndex &&
              fromSouraIndex > evaluationFromSouraIndex) isFound = true;
        }
      }
      if (!isFound) {
        ReportCardSummery temp = ReportCardSummery(
          soura: fromSoura,
          numbeOfAyatInSoura: quran.data[fromSoura],
          numberOfAyatMemorized: 0,
          percentage: 0,
        );
        summeryList.add(temp);
      }
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

    await Future.wait([
      provider.setReportCard(reportCard),
      provider.setEvaluation(reportCard.id, evaluation)
    ]);
  }

  double roundDouble(double value) {
    double mod = pow(10.0, 2);
    double result = (value * mod).round().toDouble() / mod;

    return result;
  }
}
