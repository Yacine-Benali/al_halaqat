import 'package:alhalaqat/app/models/instance.dart';
import 'package:alhalaqat/services/api_path.dart';
import 'package:alhalaqat/services/database.dart';
import 'package:flutter/foundation.dart';

class SAttendanceProvider {
  SAttendanceProvider({@required this.database});

  final Database database;

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
