import 'package:al_halaqat/app/models/global_admin.dart';
import 'package:al_halaqat/services/api_path.dart';
import 'package:al_halaqat/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class GaGlobalAdminsProvider {
  GaGlobalAdminsProvider({@required this.database});

  final Database database;

  Stream<List<GlobalAdmin>> fetcheGaAdmins(
    int limitNumber,
  ) =>
      database.collectionStream(
        path: APIPath.usersCollection(),
        builder: (data, documentId) => GlobalAdmin.fromMap(data, documentId),
        queryBuilder: (query) =>
            query.where('isGlobalAdmin', isEqualTo: true).limit(limitNumber),
        sort: (rhs, lhs) => lhs.createdAt.compareTo(rhs.createdAt),
      );

  Future<void> createGlobalAdmin(
    GlobalAdmin admin,
  ) async {
    final DocumentReference postRef = FirebaseFirestore.instance
        .doc('/globalConfiguration/globalConfiguration');

    FirebaseFirestore.instance.runTransaction((Transaction tx) async {
      if (admin.readableId == null) {
        DocumentSnapshot postSnapshot = await tx.get(postRef);
        tx.update(postRef, <String, dynamic>{
          'nextUserReadableId': postSnapshot.data()['nextUserReadableId'] + 1,
        });
        admin.readableId = postSnapshot.data()['nextUserReadableId'].toString();
      }

      tx.set(
        FirebaseFirestore.instance.doc(APIPath.userDocument(admin.id)),
        admin.toMap(),
      );
    }, timeout: Duration(seconds: 10));
  }

  String getUniqueId() => database.getUniqueId();
}
