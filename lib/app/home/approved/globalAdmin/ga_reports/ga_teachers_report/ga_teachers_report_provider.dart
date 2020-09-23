import 'package:alhalaqat/app/models/study_center.dart';
import 'package:alhalaqat/app/models/teacher.dart';
import 'package:alhalaqat/services/api_path.dart';
import 'package:alhalaqat/services/database.dart';
import 'package:flutter/foundation.dart';

class GaTeachersReportProvider {
  GaTeachersReportProvider({@required this.database});

  final Database database;

  Future<List<Teacher>> fetchTeachers() => database.fetchCollection(
        path: APIPath.usersCollection(),
        builder: (data, documentId) => Teacher.fromMap(data, documentId),
        queryBuilder: (query) => query.where('isTeacher', isEqualTo: true),
      );

  Future<StudyCenter> fetchTeacherCenter(String centerId) =>
      database.fetchDocument(
        path: APIPath.centerDocument(centerId),
        builder: (data, documentId) => StudyCenter.fromMap(data, documentId),
      );
}
