import 'package:al_halaqat/app/models/student.dart';
import 'package:al_halaqat/app/models/study_center.dart';
import 'package:al_halaqat/services/api_path.dart';
import 'package:al_halaqat/services/database.dart';
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
