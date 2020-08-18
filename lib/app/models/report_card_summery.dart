import 'package:al_halaqat/app/models/evaluation_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class ReportCardSummery {
  ReportCardSummery({
    @required this.soura,
    @required this.numbeOfAyatInSoura,
    @required this.numberOfAyatMemorized,
    @required this.percentage,
  });

  String soura;
  int numberOfAyatMemorized;
  int numbeOfAyatInSoura;
  double percentage;

  factory ReportCardSummery.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    String soura = data['soura'];
    int numberOfAyatMemorized = data['numberOfAyatMemorized'];
    int numbeOfAyatInSoura = data['numbeOfAyatInSoura'];
    double percentage = data['percentage'];

    return ReportCardSummery(
      soura: soura,
      numberOfAyatMemorized: numberOfAyatMemorized,
      numbeOfAyatInSoura: numbeOfAyatInSoura,
      percentage: percentage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'soura': soura,
      'numberOfAyatMemorized': numberOfAyatMemorized,
      'numbeOfAyatInSoura': numbeOfAyatInSoura,
      'percentage': percentage,
    };
  }
}
