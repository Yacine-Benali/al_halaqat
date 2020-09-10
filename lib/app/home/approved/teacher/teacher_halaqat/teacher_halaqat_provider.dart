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
        FirebaseFirestore.instance.doc(APIPath.centerDocument(halaqa.centerId));

    try {
      await FirebaseFirestore.instance.runTransaction((Transaction tx) async {
        if (halaqa.readableId == null) {
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
        tx.set(
          FirebaseFirestore.instance.doc(APIPath.userDocument(teacher.id)),
          teacher.toMap(),
        );
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createHalaqaRequest(
    Halaqa halaqa,
    Teacher teacher,
    String centerId,
    CenterRequest centerRequest,
  ) async {
    final DocumentReference postRef =
        FirebaseFirestore.instance.doc(APIPath.centerDocument(halaqa.centerId));

    FirebaseFirestore.instance.runTransaction((Transaction tx) async {
      if (halaqa.readableId == null) {
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
      tx.set(
        FirebaseFirestore.instance.doc(APIPath.userDocument(teacher.id)),
        teacher.toMap(),
      );
      tx.set(
        FirebaseFirestore.instance.doc(APIPath.centerRequestsDocument(
          centerId,
          centerRequest.id,
        )),
        centerRequest.toMap(),
      );
    });
  }

  String getUniqueId() => database.getUniqueId();
}
