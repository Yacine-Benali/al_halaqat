import 'package:alhalaqat/app/models/halaqa.dart';
import 'package:alhalaqat/app/models/supervisor.dart';
import 'package:alhalaqat/services/api_path.dart';
import 'package:alhalaqat/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AdminSupervisorsProvider {
  AdminSupervisorsProvider({@required this.database});

  final Database database;

  Stream<List<Supervisor>> fetchSupervisors(List<String> centerIds) {
    return database.collectionStream(
      path: APIPath.usersCollection(),
      builder: (data, documentId) => Supervisor.fromMap(data, documentId),
      queryBuilder: (query) => query
          .where('isSupervisor', isEqualTo: true)
          .where('centers', arrayContainsAny: centerIds),
      sort: (a, b) => a.createdAt.compareTo(b.createdAt),
    );
  }

  Future<void> createSupervisor(Supervisor supervisor) async {
    final DocumentReference postRef = FirebaseFirestore.instance
        .doc('/globalConfiguration/globalConfiguration');

    await FirebaseFirestore.instance.runTransaction((Transaction tx) async {
      if (supervisor.readableId == null) {
        DocumentSnapshot postSnapshot = await tx.get(postRef);
        tx.update(postRef, <String, dynamic>{
          'nextUserReadableId': postSnapshot.data()['nextUserReadableId'] + 1,
        });
        supervisor.readableId =
            postSnapshot.data()['nextUserReadableId'].toString();
      }

      tx.set(
        FirebaseFirestore.instance.doc(APIPath.userDocument(supervisor.id)),
        supervisor.toMap(),
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
