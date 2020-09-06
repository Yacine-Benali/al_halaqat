import 'package:al_halaqat/app/models/halaqa.dart';
import 'package:al_halaqat/app/models/report_card.dart';
import 'package:al_halaqat/services/api_path.dart';
import 'package:al_halaqat/services/database.dart';
import 'package:flutter/foundation.dart';

class SLearningProvider {
  SLearningProvider({@required this.database});

  final Database database;

  Future<List<Halaqa>> fetchHalaqat(
    List<String> halaqatId,
  ) =>
      database.fetchCollection(
        path: APIPath.halaqatCollection(),
        builder: (data, documentId) => Halaqa.fromMap(data),
        queryBuilder: (query) => query
            .where('id', whereIn: halaqatId)
            .where('state', isEqualTo: 'approved'),
      );

  Future<List<ReportCard>> fetchReportCards(
    String halaqatId,
  ) =>
      database.fetchCollection(
        path: APIPath.reportCardsCollection(),
        builder: (data, documentId) => ReportCard.fromMap(data, documentId),
        queryBuilder: (query) => query.where('halaqaId', isEqualTo: halaqatId),
      );
}
