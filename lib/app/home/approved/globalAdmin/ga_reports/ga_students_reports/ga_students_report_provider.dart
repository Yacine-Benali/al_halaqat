import 'package:alhalaqat/app/models/student.dart';
import 'package:alhalaqat/app/models/study_center.dart';
import 'package:alhalaqat/services/api_path.dart';
import 'package:alhalaqat/services/database.dart';
import 'package:flutter/foundation.dart';

class GaStudentsReportProvider {
  GaStudentsReportProvider({@required this.database});

  final Database database;

  Future<List<Student>> fetchStudents() => database.fetchCollection(
        path: APIPath.usersCollection(),
        builder: (data, documentId) => Student.fromMap(data, documentId),
        queryBuilder: (query) => query.where('isStudent', isEqualTo: true),
      );

  Future<StudyCenter> fetchStudentCenter(String centerId) =>
      database.fetchDocument(
        path: APIPath.centerDocument(centerId),
        builder: (data, documentId) => StudyCenter.fromMap(data, documentId),
      );
}
