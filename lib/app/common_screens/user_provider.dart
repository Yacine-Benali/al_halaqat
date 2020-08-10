import 'package:al_halaqat/app/models/center_request.dart';
import 'package:al_halaqat/app/models/global_admin_request.dart';
import 'package:al_halaqat/app/models/study_center.dart';
import 'package:al_halaqat/app/models/user.dart';
import 'package:al_halaqat/services/api_path.dart';
import 'package:al_halaqat/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class UserProvider {
  UserProvider({@required this.database});
  final Database database;

  Future<void> createCenter(StudyCenter center, String uid) async {
    await database.setData(
      path: APIPath.centerDocument(uid),
      data: center.toMap(),
      merge: true,
    );
  }

  String getUniqueId() => database.getUniqueId();

  Future<StudyCenter> getCenter(String uid) async =>
      await database.fetchDocument(
        path: APIPath.centerDocument(uid),
        builder: (data, documentId) => StudyCenter.fromMap(data, documentId),
      );

  Future<StudyCenter> queryCenterbyRId(String readableId) async =>
      await database.fetchQueryDocument(
        path: APIPath.centersCollection(),
        builder: (data, documentId) => StudyCenter.fromMap(data, documentId),
        queryBuilder: (query) =>
            query.where('readableId', isEqualTo: readableId),
      );

  Future<void> createTeacherOrStudent(
    User user,
    String uid,
    CenterRequest centerRequest,
    String centerRequestCenterId,
  ) async {
    final DocumentReference postRef =
        Firestore.instance.document('/globalConfiguration/globalConfiguration');
    Firestore.instance.runTransaction((Transaction tx) async {
      if (user.readableId == null) {
        DocumentSnapshot postSnapshot = await tx.get(postRef);
        await tx.update(postRef, <String, dynamic>{
          'nextUserReadableId': postSnapshot.data['nextUserReadableId'] + 1
        });
        user.readableId = postSnapshot['nextUserReadableId'].toString();
      }

      await tx.set(
        Firestore.instance.document(APIPath.userDocument(uid)),
        user.toMap(),
      );
      if (centerRequest != null && centerRequestCenterId != null) {
        await tx.set(
          Firestore.instance.document(
            APIPath.centerRequestsDocument(
              centerRequestCenterId,
              centerRequest.id,
            ),
          ),
          centerRequest.toMap(),
        );
      }
    });
  }

  Future<void> createAdmin(
    User user,
    String uid,
    GlobalAdminRequest globalAdminRequest,
    StudyCenter center,
  ) async {
    final DocumentReference postRef =
        Firestore.instance.document('/globalConfiguration/globalConfiguration');

    Firestore.instance.runTransaction((Transaction tx) async {
      if (user.readableId == null && center?.readableId == null) {
        DocumentSnapshot postSnapshot = await tx.get(postRef);

        if (center == null) {
          await tx.update(postRef, <String, dynamic>{
            'nextUserReadableId': postSnapshot.data['nextUserReadableId'] + 1,
          });
          user.readableId = postSnapshot['nextUserReadableId'].toString();
        } else {
          await tx.update(postRef, <String, dynamic>{
            'nextUserReadableId': postSnapshot.data['nextUserReadableId'] + 1,
            'nextCenterReadableId':
                postSnapshot.data['nextCenterReadableId'] + 1
          });
          user.readableId = postSnapshot['nextUserReadableId'].toString();
          center.readableId = postSnapshot['nextCenterReadableId'].toString();
        }
      }

      await tx.set(
        Firestore.instance.document(APIPath.userDocument(uid)),
        user.toMap(),
      );

      if (globalAdminRequest != null) {
        await tx.set(
          Firestore.instance.document(
              APIPath.globalAdminRequestsDocument(globalAdminRequest.id)),
          globalAdminRequest.toMap(),
        );
      }
      if (center != null) {
        await tx.set(
          Firestore.instance.document(APIPath.centerDocument(center.id)),
          center.toMap(),
        );
      }
    }, timeout: Duration(seconds: 10));
  }
}
