import 'package:al_halaqat/app/models/admin.dart';
import 'package:al_halaqat/app/models/global_admin_request.dart';
import 'package:al_halaqat/app/models/study_center.dart';
import 'package:al_halaqat/services/api_path.dart';
import 'package:al_halaqat/services/database.dart';
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
    Firestore.instance.runTransaction((Transaction tx) async {
      await tx.set(
        Firestore.instance.document(APIPath.userDocument(admin.id)),
        admin.toMap(),
      );
      await tx.set(
        Firestore.instance.document(
            APIPath.globalAdminRequestsDocument(globalAdminRequest.id)),
        globalAdminRequest.toMap(),
      );
    }, timeout: Duration(seconds: 10));
  }
}
