import 'package:al_halaqat/app/models/halaqa.dart';
import 'package:al_halaqat/app/models/student.dart';
import 'package:al_halaqat/app/models/study_center.dart';
import 'package:al_halaqat/app/models/teacher.dart';
import 'package:al_halaqat/services/api_path.dart';
import 'package:al_halaqat/services/database.dart';
import 'package:flutter/foundation.dart';

class GaCentersReportProvider {
  GaCentersReportProvider({@required this.database});

  final Database database;

  Future<List<StudyCenter>> fetchCenters() => database.fetchCollection(
        path: APIPath.centersCollection(),
        builder: (data, documentId) => StudyCenter.fromMap(data, documentId),
      );

  Future<List<Student>> fetchCenterStudents(String centerId, String state) =>
      database.fetchCollection(
        path: APIPath.usersCollection(),
        builder: (data, documentId) => Student.fromMap(data, documentId),
        queryBuilder: (query) => query
            .where('center', isEqualTo: centerId)
            .where('state', isEqualTo: state),
      );

  Future<List<Teacher>> fetchCenterTeachers(String centerId, String state) =>
      database.fetchCollection(
        path: APIPath.usersCollection(),
        builder: (data, documentId) => Teacher.fromMap(data, documentId),
        queryBuilder: (query) =>
            query.where('centerState.$centerId', isEqualTo: centerId),
      );

  Future<List<Halaqa>> fetchCenterHalaqat(String centerId, String state) =>
      database.fetchCollection(
        path: APIPath.halaqatCollection(),
        builder: (data, documentId) => Halaqa.fromMap(data),
        queryBuilder: (query) => query
            .where('centerId', isEqualTo: centerId)
            .where('state', isEqualTo: state),
      );
}
