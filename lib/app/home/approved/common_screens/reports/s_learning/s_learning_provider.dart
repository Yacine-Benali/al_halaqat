import 'package:alhalaqat/app/models/report_card.dart';
import 'package:alhalaqat/services/api_path.dart';
import 'package:alhalaqat/services/database.dart';
import 'package:flutter/foundation.dart';

class SLearningProvider {
  SLearningProvider({@required this.database});

  final Database database;

  Future<List<ReportCard>> fetchReportCards(
    String halaqatId,
  ) =>
      database.fetchCollection(
        path: APIPath.reportCardsCollection(),
        builder: (data, documentId) => ReportCard.fromMap(data, documentId),
        queryBuilder: (query) => query.where('halaqaId', isEqualTo: halaqatId),
      );
}
