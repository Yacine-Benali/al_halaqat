import 'package:alhalaqat/app/models/halaqa.dart';
import 'package:alhalaqat/app/models/teacher.dart';
import 'package:alhalaqat/services/api_path.dart';
import 'package:alhalaqat/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AdminHalaqatProvider {
  AdminHalaqatProvider({@required this.database});

  final Database database;

  Stream<List<Halaqa>> fetchHalaqat(List<String> centerIds) =>
      database.collectionStream(
        path: APIPath.halaqatCollection(),
        builder: (data, documentId) => Halaqa.fromMap(data),
        queryBuilder: (query) => query.where('centerId', whereIn: centerIds),
      );

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

  Future<void> createHalaqa(
    Halaqa halaqa,
  ) async {
    await FirebaseFirestore.instance.runTransaction((Transaction tx) async {
      if (halaqa.readableId == null) {
        final DocumentReference postRef = FirebaseFirestore.instance
            .doc(APIPath.centerDocument(halaqa.centerId));
        DocumentSnapshot postSnapshot = await tx.get(postRef);
        tx.update(postRef, <String, dynamic>{
          'nextHalaqaReadableId':
              postSnapshot.data()['nextHalaqaReadableId'] + 1,
        });
        halaqa.readableId = postSnapshot.data()['readableId'].toString() +
            postSnapshot.data()['nextHalaqaReadableId'].toString();
      }

      tx.set(
        FirebaseFirestore.instance.doc(APIPath.halaqaDocument(halaqa.id)),
        halaqa.toMap(),
      );
    });
  }

  String getUniqueId() => database.getUniqueId();
}
