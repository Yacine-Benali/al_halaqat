import 'package:al_halaqat/app/models/halaqa.dart';
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
      sort: (a, b) => a.createdAt.compareTo(b.createdAt),
    );
  }

  Future<void> createTeacher(
    Teacher teacher,
  ) async {
    final DocumentReference postRef = FirebaseFirestore.instance
        .doc('/globalConfiguration/globalConfiguration');

    await FirebaseFirestore.instance.runTransaction((Transaction tx) async {
      if (teacher.readableId == null) {
        DocumentSnapshot postSnapshot = await tx.get(postRef);
        tx.update(postRef, <String, dynamic>{
          'nextUserReadableId': postSnapshot.data()['nextUserReadableId'] + 1,
        });
        teacher.readableId =
            postSnapshot.data()['nextUserReadableId'].toString();
      }

      tx.set(
        FirebaseFirestore.instance.doc(APIPath.userDocument(teacher.id)),
        teacher.toMap(),
      );
    }, timeout: Duration(seconds: 10));
  }

  Stream<List<Halaqa>> fetchHalaqat(List<String> centerIds) =>
      database.collectionStream(
        path: APIPath.halaqatCollection(),
        builder: (data, documentId) => Halaqa.fromMap(data),
        queryBuilder: (query) => query
            .where('state', isEqualTo: 'approved')
            .where('centerId', whereIn: centerIds),
        sort: (a, b) => a.createdAt.compareTo(b.createdAt),
      );

  String getUniqueId() => database.getUniqueId();
}
