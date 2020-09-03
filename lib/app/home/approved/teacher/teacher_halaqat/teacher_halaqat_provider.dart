import 'package:al_halaqat/app/models/center_request.dart';
import 'package:al_halaqat/app/models/halaqa.dart';
import 'package:al_halaqat/app/models/teacher.dart';
import 'package:al_halaqat/services/api_path.dart';
import 'package:al_halaqat/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class TeacherHalaqatProvider {
  TeacherHalaqatProvider({@required this.database});

  final Database database;

  Stream<List<Halaqa>> fetchHalaqat(
    List<String> halaqatId,
  ) =>
      database.collectionStream(
        path: APIPath.halaqatCollection(),
        builder: (data, documentId) => Halaqa.fromMap(data),
        queryBuilder: (query) => query
            .where('id', whereIn: halaqatId)
            .where('state', isEqualTo: 'approved'),
      );

  Future<void> editHalaqa(
    Halaqa halaqa,
  ) async =>
      await database.setData(
        path: APIPath.halaqaDocument(halaqa.id),
        data: halaqa.toMap(),
        merge: true,
      );
  Future<void> createHalaqa(
    Halaqa halaqa,
    Teacher teacher,
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
      await tx.set(
        Firestore.instance.document(APIPath.userDocument(teacher.id)),
        teacher.toMap(),
      );
    }, timeout: Duration(seconds: 10));
  }

  Future<void> createHalaqaRequest(
    Halaqa halaqa,
    Teacher teacher,
    String centerId,
    CenterRequest centerRequest,
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
      await tx.set(
        Firestore.instance.document(APIPath.userDocument(teacher.id)),
        teacher.toMap(),
      );
      await tx.set(
        Firestore.instance.document(APIPath.centerRequestsDocument(
          centerId,
          centerRequest.id,
        )),
        centerRequest.toMap(),
      );
    }, timeout: Duration(seconds: 10));
  }

  String getUniqueId() => database.getUniqueId();
}
