import 'package:alhalaqat/app/models/evaluation.dart';
import 'package:alhalaqat/app/models/halaqa.dart';
import 'package:alhalaqat/app/models/instance.dart';
import 'package:alhalaqat/app/models/report_card.dart';
import 'package:alhalaqat/services/api_path.dart';
import 'package:alhalaqat/services/database.dart';
import 'package:flutter/foundation.dart';

class OrganizerHalaqatProvider {
  OrganizerHalaqatProvider({@required this.database});

  final Database database;

  Stream<List<Halaqa>> fetchHalaqat(
    List<String> halaqatId,
  ) =>
      database.collectionStream(
        path: APIPath.halaqatCollection(),
        builder: (data, documentId) => Halaqa.fromMap(data),
        queryBuilder: (query) => query.where('id', whereIn: halaqatId),
      );

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
}
