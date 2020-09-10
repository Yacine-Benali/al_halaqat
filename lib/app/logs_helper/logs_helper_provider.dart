import 'package:al_halaqat/app/models/teacher_log.dart';
import 'package:al_halaqat/services/api_path.dart';
import 'package:al_halaqat/services/database.dart';
import 'package:flutter/foundation.dart';

class LogsHelperProvider {
  LogsHelperProvider({@required this.database});

  final Database database;

  Future<void> createCenterLog(TeacherLog teacherLog, String centerId) =>
      database.addDocument(
        path: APIPath.centerLogsCollection(centerId),
        data: teacherLog.toMap(),
      );
}
