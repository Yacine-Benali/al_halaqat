import 'package:alhalaqat/app/models/admin_log.dart';
import 'package:alhalaqat/services/api_path.dart';
import 'package:alhalaqat/services/database.dart';
import 'package:flutter/foundation.dart';

class AdminLogsProvider {
  AdminLogsProvider({@required this.database});
  final Database database;

  Future<List<AdminLog>> fetchIlatestInstances() => database.fetchCollection(
        path: APIPath.adminLogsCollection(),
        builder: (data, documentId) => AdminLog.fromMap(data, documentId),
        queryBuilder: (query) =>
            query.orderBy('createdAt', descending: true).limit(20),
      );

  Future<List<AdminLog>> fetchMoreInstances(
    AdminLog adminLog,
  ) =>
      database.fetchCollection(
        path: APIPath.adminLogsCollection(),
        builder: (data, documentId) => AdminLog.fromMap(data, documentId),
        queryBuilder: (query) => query
            .orderBy('createdAt', descending: true)
            .startAfter([adminLog.createdAt]).limit(10),
      );
}
