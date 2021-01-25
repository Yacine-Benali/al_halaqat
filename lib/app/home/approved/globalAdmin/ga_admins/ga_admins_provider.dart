import 'package:alhalaqat/app/models/admin.dart';
import 'package:alhalaqat/app/models/study_center.dart';
import 'package:alhalaqat/app/models/user.dart';
import 'package:alhalaqat/services/api_path.dart';
import 'package:alhalaqat/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class GaAdminsProvider {
  GaAdminsProvider({@required this.database});

  final Database database;

  Stream<List<Admin>> fetcheGaAdmins() => database.collectionStream(
        path: APIPath.usersCollection(),
        builder: (data, documentId) => Admin.fromMap(data, documentId),
        queryBuilder: (query) => query.where('isAdmin', isEqualTo: true),
        sort: (rhs, lhs) => lhs.createdAt.compareTo(rhs.createdAt),
      );

  Future<List<StudyCenter>> fetchCenters() => database.fetchCollection(
        path: APIPath.centersCollection(),
        builder: (data, documentId) => StudyCenter.fromMap(data, documentId),
        queryBuilder: (query) => query.where('state', isEqualTo: 'approved'),
      );

  Future<void> createAdmin(
    User user,
  ) async {
    final DocumentReference postRef = FirebaseFirestore.instance
        .doc('/globalConfiguration/globalConfiguration');

    await FirebaseFirestore.instance.runTransaction((Transaction tx) async {
      if (user.readableId == null) {
        DocumentSnapshot postSnapshot = await tx.get(postRef);
        tx.update(postRef, <String, dynamic>{
          'nextUserReadableId': postSnapshot.data()['nextUserReadableId'] + 1,
        });
        user.readableId = postSnapshot.data()['nextUserReadableId'].toString();
      }
      tx.set(
        FirebaseFirestore.instance.doc(APIPath.userDocument(user.id)),
        user.toMap(),
      );
    }, timeout: Duration(seconds: 10));
  }

  String getUniqueId() => database.getUniqueId();
}
