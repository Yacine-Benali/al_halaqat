import 'package:al_halaqat/app/models/evaluation.dart';
import 'package:al_halaqat/app/models/instance.dart';
import 'package:al_halaqat/app/models/report_card.dart';
import 'package:flutter/foundation.dart';

class StudentProfile {
  StudentProfile({
    @required this.halaqaId,
    @required this.halaqaName,
    @required this.instancesList,
    @required this.evaluationsList,
    @required this.reportCard,
  });

  final String halaqaId;
  final String halaqaName;
  final List<Instance> instancesList;
  final List<Evaluation> evaluationsList;
  final ReportCard reportCard;
}
