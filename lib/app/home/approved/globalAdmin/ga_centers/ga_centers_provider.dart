import 'package:al_halaqat/app/models/admin.dart';
import 'package:al_halaqat/app/models/study_center.dart';
import 'package:al_halaqat/services/api_path.dart';
import 'package:al_halaqat/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class GaCentersProvider {
  GaCentersProvider({@required this.database});

  final Database database;
  String getUniqueId() => database.getUniqueId();

  Stream<List<StudyCenter>> getCentersStream() {
    return database.collectionStream(
      path: APIPath.centersCollection(),
      builder: (data, documentId) => StudyCenter.fromMap(data, documentId),
    );
  }

  Future<Admin> getAdminById(String id) => database.fetchDocument(
        path: APIPath.userDocument(id),
        builder: (data, documentId) => Admin.fromMap(data, documentId),
      );

  Future<void> createCenter(
    StudyCenter center,
  ) async {
    final DocumentReference postRef =
        Firestore.instance.document('/globalConfiguration/globalConfiguration');

    await Firestore.instance.runTransaction((Transaction tx) async {
      if (center.readableId == null) {
        DocumentSnapshot postSnapshot = await tx.get(postRef);

        await tx.update(postRef, <String, dynamic>{
          'nextCenterReadableId': postSnapshot.data['nextCenterReadableId'] + 1,
        });
        center.readableId = postSnapshot['nextCenterReadableId'].toString();
      }

      await tx.set(
        Firestore.instance.document(APIPath.centerDocument(center.id)),
        center.toMap(),
      );
    }, timeout: Duration(seconds: 10));
  }
}
