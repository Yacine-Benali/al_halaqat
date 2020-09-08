import 'package:al_halaqat/app/models/halaqa.dart';
import 'package:al_halaqat/app/models/student.dart';
import 'package:al_halaqat/app/models/teacher.dart';
import 'package:al_halaqat/services/api_path.dart';
import 'package:al_halaqat/services/database.dart';
import 'package:flutter/foundation.dart';

class CenterNumbersProvider {
  CenterNumbersProvider({@required this.database});

  final Database database;

  Future<List<Student>> fetchStudents(String centerId, String state) async =>
      await database.fetchCollection(
        path: APIPath.usersCollection(),
        builder: (data, documentId) => Student.fromMap(data, documentId),
        queryBuilder: (query) => query
            .where('isStudent', isEqualTo: true)
            .where('center', isEqualTo: centerId)
            .where('state', isEqualTo: state),
      );

  Future<List<Teacher>> fetchTeachers(String centerId, String state) async =>
      await database.fetchCollection(
        path: APIPath.usersCollection(),
        builder: (data, documentId) => Teacher.fromMap(data, documentId),
        queryBuilder: (query) => query
            .where('isTeacher', isEqualTo: true)
            .where('centerState.$centerId', isEqualTo: state),
      );

  Future<List<Halaqa>> fetchHalaqat(String centerId, String state) async =>
      await database.fetchCollection(
        path: APIPath.halaqatCollection(),
        builder: (data, documentId) => Halaqa.fromMap(data),
        queryBuilder: (query) => query
            .where('centerId', isEqualTo: centerId)
            .where('state', isEqualTo: state),
      );
}
