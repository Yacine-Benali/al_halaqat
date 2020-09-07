import 'package:al_halaqat/app/models/instance.dart';
import 'package:al_halaqat/services/api_path.dart';
import 'package:al_halaqat/services/database.dart';
import 'package:flutter/foundation.dart';

class TAttendanceProvider {
  TAttendanceProvider({@required this.database});

  final Database database;

  Future<List<Instance>> fetchInstances(
    String centerId,
    DateTime firstDate,
    DateTime lastDate,
  ) =>
      database.fetchCollection(
        path: APIPath.instancesCollection(),
        builder: (data, documentId) => Instance.fromMap(data, documentId),
        queryBuilder: (query) => query
            .where('centerId', isEqualTo: centerId)
            .where('createdAt', isGreaterThanOrEqualTo: firstDate)
            .where('createdAt', isLessThanOrEqualTo: lastDate),
      );
}
