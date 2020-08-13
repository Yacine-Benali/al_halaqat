import 'package:al_halaqat/app/models/admin.dart';
import 'package:al_halaqat/app/models/student.dart';
import 'package:al_halaqat/app/models/study_center.dart';
import 'package:al_halaqat/app/models/user.dart';
import 'package:al_halaqat/services/api_path.dart';
import 'package:al_halaqat/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AdminStudentsProvider {
  AdminStudentsProvider({@required this.database});

  final Database database;

  Stream<List<Student>> fetchStudents(
    List<String> centerIds,
  ) =>
      database.collectionStream(
        path: APIPath.usersCollection(),
        builder: (data, documentId) => Student.fromMap(data, documentId),
        queryBuilder: (query) => query
            .where('isStudent', isEqualTo: true)
            .where('center', whereIn: centerIds),
      );

  Future<void> createStudent(
    Student student,
  ) async {
    final DocumentReference postRef =
        Firestore.instance.document('/globalConfiguration/globalConfiguration');

    Firestore.instance.runTransaction((Transaction tx) async {
      if (student.readableId == null) {
        DocumentSnapshot postSnapshot = await tx.get(postRef);
        await tx.update(postRef, <String, dynamic>{
          'nextUserReadableId': postSnapshot.data['nextUserReadableId'] + 1,
        });
        student.readableId = postSnapshot['nextUserReadableId'].toString();
      }

      await tx.set(
        Firestore.instance.document(APIPath.userDocument(student.id)),
        student.toMap(),
      );
    }, timeout: Duration(seconds: 10));
  }

  String getUniqueId() => database.getUniqueId();
}