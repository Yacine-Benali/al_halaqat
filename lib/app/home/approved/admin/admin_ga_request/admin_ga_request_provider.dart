import 'package:alhalaqat/app/models/admin.dart';
import 'package:alhalaqat/app/models/global_admin_request.dart';
import 'package:alhalaqat/app/models/study_center.dart';
import 'package:alhalaqat/services/api_path.dart';
import 'package:alhalaqat/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AdminGaRequestProvider {
  AdminGaRequestProvider({@required this.database});

  final Database database;

  String getUniqueId() => database.getUniqueId();

  Future<StudyCenter> queryCenterbyRId(String readableId) async =>
      await database.fetchQueryDocument(
        path: APIPath.centersCollection(),
        builder: (data, documentId) => StudyCenter.fromMap(data, documentId),
        queryBuilder: (query) =>
            query.where('readableId', isEqualTo: readableId),
      );

  Future<void> sendJoinRequest(
    Admin admin,
    GlobalAdminRequest globalAdminRequest,
  ) async {
    FirebaseFirestore.instance.runTransaction((Transaction tx) async {
      tx.set(
        FirebaseFirestore.instance.doc(APIPath.userDocument(admin.id)),
        admin.toMap(),
      );
      tx.set(
        FirebaseFirestore.instance
            .doc(APIPath.globalAdminRequestsDocument(globalAdminRequest.id)),
        globalAdminRequest.toMap(),
      );
    }, timeout: Duration(seconds: 10));
  }
}
