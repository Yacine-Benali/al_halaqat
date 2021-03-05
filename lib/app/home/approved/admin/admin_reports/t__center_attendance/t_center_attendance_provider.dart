import 'package:alhalaqat/app/models/teacher.dart';
import 'package:alhalaqat/app/models/teacher_center_attendance.dart';
import 'package:alhalaqat/services/api_path.dart';
import 'package:alhalaqat/services/database.dart';
import 'package:flutter/foundation.dart';

class TCenterAttendanceProvider {
  TCenterAttendanceProvider({@required this.database});

  final Database database;

  Future<List<Teacher>> fetchTeachers(
    String centerId,
  ) =>
      database.fetchCollection(
        path: APIPath.usersCollection(),
        builder: (data, documentId) => Teacher.fromMap(data, documentId),
        queryBuilder: (query) => query
            .where('isTeacher', isEqualTo: true)
            .where('centers', arrayContains: centerId),
      );

  Future<List<TeacherCenterAttendance>> getTCenterAttendaceList(
    String centerId,
    String teacherId,
    DateTime firstDate,
    DateTime lastDate,
  ) =>
      database.fetchCollection(
        path: APIPath.teacherCenterAttendanceCollection(centerId, teacherId),
        builder: (data, id) => TeacherCenterAttendance.fromMap(data, id),
        queryBuilder: (query) => query
            .where('date', isGreaterThanOrEqualTo: firstDate)
            .where('date', isLessThanOrEqualTo: lastDate),
      );
}
