import 'package:al_halaqat/app/models/evaluation.dart';
import 'package:al_halaqat/app/models/instance.dart';
import 'package:al_halaqat/app/models/report_card.dart';
import 'package:al_halaqat/services/api_path.dart';
import 'package:al_halaqat/services/database.dart';
import 'package:flutter/foundation.dart';

class StudentProfileProvider {
  StudentProfileProvider({@required this.database});
  final Database database;

  Future<List<Instance>> fetchInstances(
    String halaqaId,
  ) async =>
      await database.fetchCollection(
        path: APIPath.instancesCollection(),
        builder: (data, documentId) => Instance.fromMap(data, documentId),
        queryBuilder: (query) => query
            .where('halaqaId', isEqualTo: halaqaId)
            .orderBy('createdAt', descending: true),
      );

  Future<List<Evaluation>> fetchEvaluations(String reportCardId) async =>
      await database.fetchCollection(
        path: APIPath.evaluationsCollection(reportCardId),
        builder: (data, documentId) => Evaluation.fromMap(data, documentId),
        //sort: (a, b) => a.createdAt.compareTo(b.createdAt),
        queryBuilder: (query) => query.orderBy('createdAt', descending: true),
      );

  Future<ReportCard> fetchReportCard(String reportCardId) async =>
      await database.fetchDocument(
        path: APIPath.reportCardDocument(reportCardId),
        builder: (data, documentId) => ReportCard.fromMap(data, documentId),
      );

  String getUniqueId() => database.getUniqueId();
}
