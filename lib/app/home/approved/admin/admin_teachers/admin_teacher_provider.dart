import 'package:al_halaqat/app/models/teacher.dart';
import 'package:al_halaqat/services/api_path.dart';
import 'package:al_halaqat/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AdminTeachersProvider {
  AdminTeachersProvider({@required this.database});

  final Database database;

  Stream<List<Teacher>> fetchTeachers(
    List<String> centerIds,
  ) {
    return database.collectionStream(
      path: APIPath.usersCollection(),
      builder: (data, documentId) => Teacher.fromMap(data, documentId),
      queryBuilder: (query) => query
          .where('isTeacher', isEqualTo: true)
          .where('centers', arrayContainsAny: centerIds),
    );
  }

  Future<void> createTeacher(
    Teacher teacher,
  ) async {
    final DocumentReference postRef =
        Firestore.instance.document('/globalConfiguration/globalConfiguration');

    Firestore.instance.runTransaction((Transaction tx) async {
      if (teacher.readableId == null) {
        DocumentSnapshot postSnapshot = await tx.get(postRef);
        await tx.update(postRef, <String, dynamic>{
          'nextUserReadableId': postSnapshot.data['nextUserReadableId'] + 1,
        });
        teacher.readableId = postSnapshot['nextUserReadableId'].toString();
      }

      await tx.set(
        Firestore.instance.document(APIPath.userDocument(teacher.id)),
        teacher.toMap(),
      );
    }, timeout: Duration(seconds: 10));
  }

  String getUniqueId() => database.getUniqueId();
}
