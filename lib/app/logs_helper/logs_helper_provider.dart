import 'package:alhalaqat/app/models/admin_log.dart';
import 'package:alhalaqat/app/models/teacher_log.dart';
import 'package:alhalaqat/services/api_path.dart';
import 'package:alhalaqat/services/database.dart';
import 'package:flutter/foundation.dart';

class LogsHelperProvider {
  LogsHelperProvider({@required this.database});

  final Database database;

  Future<void> createCenterLog(TeacherLog teacherLog, String centerId) =>
      database.addDocument(
        path: APIPath.centerLogsCollection(centerId),
        data: teacherLog.toMap(),
      );

  Future<void> createAdminLog(AdminLog adminLog) => database.addDocument(
        path: APIPath.adminLogsCollection(),
        data: adminLog.toMap(),
      );
}
