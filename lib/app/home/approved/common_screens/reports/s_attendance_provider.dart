import 'package:al_halaqat/app/models/halaqa.dart';
import 'package:al_halaqat/app/models/instance.dart';
import 'package:al_halaqat/services/api_path.dart';
import 'package:al_halaqat/services/database.dart';
import 'package:flutter/foundation.dart';

class SAttendanceProvider {
  SAttendanceProvider({@required this.database});

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

  Future<List<Instance>> fetchInstances(
    String halaqaId,
    DateTime firstDate,
    DateTime lastDate,
  ) =>
      database.fetchCollection(
        path: APIPath.instancesCollection(),
        builder: (data, documentId) => Instance.fromMap(data, documentId),
        queryBuilder: (query) => query
            .where('halaqaId', isEqualTo: halaqaId)
            .where('createdAt', isGreaterThanOrEqualTo: firstDate)
            .where('createdAt', isLessThanOrEqualTo: lastDate),
      );
}
