import 'package:alhalaqat/app/models/teacher_log.dart';
import 'package:alhalaqat/services/api_path.dart';
import 'package:alhalaqat/services/database.dart';
import 'package:flutter/foundation.dart';

class CenterLogsProvider {
  CenterLogsProvider({@required this.database});
  final Database database;

  Future<List<TeacherLog>> fetchIlatestInstances(
    String centerId,
  ) =>
      database.fetchCollection(
        path: APIPath.centerLogsCollection(centerId),
        builder: (data, documentId) => TeacherLog.fromMap(data, documentId),
        queryBuilder: (query) =>
            query.orderBy('createdAt', descending: true).limit(20),
      );

  Future<List<TeacherLog>> fetchMoreInstances(
    String centerId,
    TeacherLog teacherLog,
  ) =>
      database.fetchCollection(
        path: APIPath.centerLogsCollection(centerId),
        builder: (data, documentId) => TeacherLog.fromMap(data, documentId),
        queryBuilder: (query) => query
            .orderBy('createdAt', descending: true)
            .startAfter([teacherLog.createdAt]).limit(10),
      );
}
