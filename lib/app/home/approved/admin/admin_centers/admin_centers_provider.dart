import 'package:al_halaqat/app/models/study_center.dart';
import 'package:al_halaqat/services/api_path.dart';
import 'package:al_halaqat/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AdminCentersProvider {
  AdminCentersProvider({@required this.database});

  final Database database;
  String getUniqueId() => database.getUniqueId();

  Stream<List<StudyCenter>> getCentersStream(List<String> centersId) {
    return database.collectionStream(
      path: APIPath.centersCollection(),
      builder: (data, documentId) => StudyCenter.fromMap(data, documentId),
      queryBuilder: (query) =>
          query.where(FieldPath.documentId, whereIn: centersId),
    );
  }

  Future<List<StudyCenter>> getCenter(String centerName) {
    return database.fetchCollection(
      path: APIPath.centersCollection(),
      builder: (data, documentId) => StudyCenter.fromMap(data, documentId),
      queryBuilder: (query) => query.where('name', isEqualTo: centerName),
    );
  }

  Future<void> setCenter(
    StudyCenter center,
  ) async =>
      database.setData(
        path: APIPath.centerDocument(center.id),
        data: center.toMap(),
        merge: true,
      );

  Future<void> createCenter(
    StudyCenter center,
  ) async {
    final DocumentReference postRef = FirebaseFirestore.instance
        .doc('/globalConfiguration/globalConfiguration');

    await FirebaseFirestore.instance.runTransaction((Transaction tx) async {
      if (center.readableId == null) {
        DocumentSnapshot postSnapshot = await tx.get(postRef);

        tx.update(postRef, <String, dynamic>{
          'nextCenterReadableId':
              postSnapshot.data()['nextCenterReadableId'] + 1,
        });
        center.readableId =
            postSnapshot.data()['nextCenterReadableId'].toString();
      }

      tx.set(
        FirebaseFirestore.instance.doc(APIPath.centerDocument(center.id)),
        center.toMap(),
      );
    });
  }
}
