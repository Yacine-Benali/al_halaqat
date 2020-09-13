import 'package:al_halaqat/app/models/halaqa.dart';
import 'package:al_halaqat/app/models/student.dart';
import 'package:al_halaqat/app/models/study_center.dart';
import 'package:al_halaqat/app/models/teacher.dart';
import 'package:al_halaqat/services/api_path.dart';
import 'package:al_halaqat/services/database.dart';
import 'package:flutter/foundation.dart';

class GaHalaqatReportProvider {
  GaHalaqatReportProvider({@required this.database});

  final Database database;

  Future<List<Halaqa>> fetchHalaqat() => database.fetchCollection(
        path: APIPath.halaqatCollection(),
        builder: (data, documentId) => Halaqa.fromMap(data),
      );

  Future<Teacher> fetchHalaqaTeacher(String halaqaId) =>
      database.fetchQueryDocument(
        path: APIPath.usersCollection(),
        builder: (data, documentId) => Teacher.fromMap(data, documentId),
        queryBuilder: (query) =>
            query.where('halaqatTeachingIn', arrayContains: halaqaId),
      );

  Future<List<Student>> fetchHalaqaStudents(String halaqaId) =>
      database.fetchCollection(
        path: APIPath.usersCollection(),
        builder: (data, documentId) => Student.fromMap(data, documentId),
        queryBuilder: (query) =>
            query.where('halaqatLearningIn', arrayContains: halaqaId),
      );

  Future<StudyCenter> fetchHalaqaCenter(String centerId) =>
      database.fetchDocument(
        path: APIPath.centerDocument(centerId),
        builder: (data, documentId) => StudyCenter.fromMap(data, documentId),
      );
}
