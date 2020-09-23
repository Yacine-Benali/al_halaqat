import 'package:alhalaqat/app/models/evaluation.dart';
import 'package:alhalaqat/app/models/report_card.dart';
import 'package:alhalaqat/services/api_path.dart';
import 'package:alhalaqat/services/database.dart';
import 'package:flutter/foundation.dart';

class EvaluationProvider {
  EvaluationProvider({@required this.database});
  final Database database;

  Stream<List<Evaluation>> fetchEvaluations(
    String studentId,
    String halaqaId,
  ) =>
      database.collectionStream(
        path: APIPath.evaluationsCollection(studentId + '_' + halaqaId),
        builder: (data, documentId) => Evaluation.fromMap(data, documentId),
        queryBuilder: (query) => query.orderBy('createdAt', descending: true),
      );

  Future<void> setReportCard(ReportCard reportCard) async => await database
      .setData(
        path: APIPath.reportCardDocument(reportCard.id),
        data: reportCard.toMap(),
        merge: true,
      )
      .timeout(Duration(seconds: 5));
  Future<void> setEvaluation(
    String reportCardId,
    Evaluation evaluation,
  ) async =>
      await database
          .setData(
            path: APIPath.evaluationDocument(reportCardId, evaluation.id),
            data: evaluation.toMap(),
            merge: true,
          )
          .timeout(Duration(seconds: 5));

  String getUniqueId() => database.getUniqueId();
}
