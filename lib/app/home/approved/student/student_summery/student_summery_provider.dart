import 'package:al_halaqat/app/models/evaluation.dart';
import 'package:al_halaqat/app/models/halaqa.dart';
import 'package:al_halaqat/app/models/instance.dart';
import 'package:al_halaqat/app/models/quran.dart';
import 'package:al_halaqat/app/models/report_card.dart';
import 'package:al_halaqat/services/api_path.dart';
import 'package:al_halaqat/services/database.dart';
import 'package:flutter/foundation.dart';

class StudentSummeryProvider {
  StudentSummeryProvider({@required this.database});

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
        queryBuilder: (query) => query.orderBy('createdAt', descending: true),
      );

  Future<ReportCard> fetchReportCard(String reportCardId) async =>
      await database.fetchDocument(
        path: APIPath.reportCardDocument(reportCardId),
        builder: (data, documentId) => ReportCard.fromMap(data, documentId),
      );

  Future<Quran> fetchQuran() => database.fetchDocument(
        path: APIPath.globalConfigurationDoc(),
        builder: (data, documentId) => Quran.fromMap(data, documentId),
      );
}
