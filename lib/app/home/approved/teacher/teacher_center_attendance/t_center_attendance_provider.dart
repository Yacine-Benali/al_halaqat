import 'package:alhalaqat/app/models/teacher_center_attendance.dart';
import 'package:alhalaqat/services/api_path.dart';
import 'package:alhalaqat/services/database.dart';
import 'package:flutter/foundation.dart';

class TCenterAttendanceProvider {
  TCenterAttendanceProvider({@required this.database});

  final Database database;
  String getUniqueId() => database.getUniqueId();

  Stream<List<TeacherCenterAttendance>> getTCenterAttendaceList(
    String centerId,
    String teacherId,
  ) =>
      database.collectionStream(
        path: APIPath.teacherCenterAttendanceCollection(centerId, teacherId),
        builder: (data, id) => TeacherCenterAttendance.fromMap(data, id),
      );

  Future<void> saveTcenterAttendance(
    String centerId,
    String teacherId,
    TeacherCenterAttendance teacherCenterAttendance,
  ) =>
      database.setData(
        path: APIPath.teacherCenterAttendanceDocument(
            centerId, teacherId, teacherCenterAttendance.id),
        data: teacherCenterAttendance.toMap(),
        merge: true,
      );
}
