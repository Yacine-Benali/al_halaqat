import 'package:al_halaqat/app/models/halaqa.dart';
import 'package:al_halaqat/app/models/teacher.dart';
import 'package:al_halaqat/services/api_path.dart';
import 'package:al_halaqat/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AdminHalaqatProvider {
  AdminHalaqatProvider({@required this.database});

  final Database database;

  Stream<List<Halaqa>> fetchHalaqat(
    String centerId,
  ) =>
      database.collectionStream(
        path: APIPath.halaqatCollection(),
        builder: (data, documentId) => Halaqa.fromMap(data, documentId),
        sort: (a, b) => a.createdAt.compareTo(b.createdAt),
      );

  Future<void> createHalaqa(
    Halaqa halaqa,
  ) async {
    final DocumentReference postRef =
        Firestore.instance.document(APIPath.centerDocument(halaqa.centerId));

    Firestore.instance.runTransaction((Transaction tx) async {
      if (halaqa.readableId == null) {
        DocumentSnapshot postSnapshot = await tx.get(postRef);
        await tx.update(postRef, <String, dynamic>{
          'nextHalaqaReadableId': postSnapshot.data['nextHalaqaReadableId'] + 1,
        });
        halaqa.readableId = postSnapshot['readableId'].toString() +
            postSnapshot['nextHalaqaReadableId'].toString();
      }

      await tx.set(
        Firestore.instance.document(APIPath.halaqaDocument(halaqa.id)),
        halaqa.toMap(),
      );
    }, timeout: Duration(seconds: 10));
  }

  String getUniqueId() => database.getUniqueId();
}