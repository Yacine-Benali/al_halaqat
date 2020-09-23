import 'package:alhalaqat/app/models/instance.dart';
import 'package:alhalaqat/app/models/quran.dart';
import 'package:alhalaqat/app/models/student.dart';
import 'package:alhalaqat/app/models/teacher.dart';
import 'package:alhalaqat/services/api_path.dart';
import 'package:alhalaqat/services/database.dart';
import 'package:flutter/foundation.dart';

class AttendanceProvider {
  AttendanceProvider({@required this.database});
  final Database database;

  Future<List<Student>> fetchHalaqaStudents(
    String halaqaId,
  ) =>
      database.fetchCollection(
        path: APIPath.usersCollection(),
        builder: (data, documentId) => Student.fromMap(data, documentId),
        queryBuilder: (query) => query
            .where('halaqatLearningIn', arrayContains: halaqaId)
            .where('state', isEqualTo: 'approved'),
      );

  Future<Teacher> fetchHalaqaTeacher(
    String halaqaId,
  ) =>
      database.fetchQueryDocument(
        path: APIPath.usersCollection(),
        builder: (data, documentId) => Teacher.fromMap(data, documentId),
        queryBuilder: (query) =>
            query.where('halaqatTeachingIn', arrayContains: halaqaId),
      );

  Future<void> setInstance(Instance instance) async => await database.setData(
        path: APIPath.instanceDocument(instance.id),
        data: instance.toMap(),
        merge: true,
      );

  Future<Quran> fetchQuran() => database.fetchDocument(
        path: APIPath.globalConfigurationDoc(),
        builder: (data, documentId) => Quran.fromMap(data, documentId),
      );
}
