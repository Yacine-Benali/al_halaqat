import 'package:al_halaqat/app/models/halaqa.dart';
import 'package:al_halaqat/services/api_path.dart';
import 'package:al_halaqat/services/database.dart';
import 'package:flutter/foundation.dart';

class AdminReportsProvider {
  AdminReportsProvider({@required this.database});

  final Database database;

  Future<List<Halaqa>> fetchHalaqat(String centerId) =>
      database.fetchCollection(
        path: APIPath.halaqatCollection(),
        builder: (data, documentId) => Halaqa.fromMap(data),
        queryBuilder: (query) => query
            .where('centerId', isEqualTo: centerId)
            .where('state', isEqualTo: 'approved'),
      );
}
