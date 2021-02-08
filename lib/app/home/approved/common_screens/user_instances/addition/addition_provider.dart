import 'package:alhalaqat/app/models/student.dart';
import 'package:alhalaqat/services/api_path.dart';
import 'package:alhalaqat/services/database.dart';
import 'package:flutter/foundation.dart';

class AdditionProvider {
  AdditionProvider({@required this.database});

  final Database database;

  Stream<List<Student>> fetchStudents(String centerId) =>
      database.collectionStream(
        path: APIPath.usersCollection(),
        builder: (data, documentId) => Student.fromMap(data, documentId),
        queryBuilder: (query) => query
            .where('center', isEqualTo: centerId)
            .where('state', isEqualTo: 'approved'),
      );

  Future<void> saveStudent(Student student) async => database.setData(
        path: APIPath.userDocument(student.id),
        data: student.toMap(),
        merge: true,
      );
}
