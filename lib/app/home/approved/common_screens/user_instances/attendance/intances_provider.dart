import 'package:al_halaqat/app/models/instance.dart';
import 'package:al_halaqat/app/models/student.dart';
import 'package:al_halaqat/services/api_path.dart';
import 'package:al_halaqat/services/database.dart';
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
        queryBuilder: (query) =>
            query.where('halaqatLearningIn', arrayContains: halaqaId),
      );

  Future<void> setInstance(Instance instance) async => await database.setData(
        path: APIPath.instanceDocument(instance.id),
        data: instance.toMap(),
        merge: true,
      );
}
