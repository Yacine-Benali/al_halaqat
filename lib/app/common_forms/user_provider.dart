import 'package:alhalaqat/app/models/center_request.dart';
import 'package:alhalaqat/app/models/global_admin_request.dart';
import 'package:alhalaqat/app/models/study_center.dart';
import 'package:alhalaqat/app/models/user.dart';
import 'package:alhalaqat/services/api_path.dart';
import 'package:alhalaqat/services/database.dart';
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
  Future<List<StudyCenter>> getCenterByname(String centerName) {
    return database.fetchCollection(
      path: APIPath.centersCollection(),
      builder: (data, documentId) => StudyCenter.fromMap(data, documentId),
      queryBuilder: (query) => query.where('name', isEqualTo: centerName),
    );
  }

  Future<void> createTeacherOrStudent(
    User user,
    String uid,
    CenterRequest centerRequest,
    String centerRequestCenterId,
  ) async {
    final DocumentReference postRef = FirebaseFirestore.instance
        .doc('/globalConfiguration/globalConfiguration');
    FirebaseFirestore.instance.runTransaction((Transaction tx) async {
      if (user.readableId == null) {
        DocumentSnapshot postSnapshot = await tx.get(postRef);
        tx.update(postRef, <String, dynamic>{
          'nextUserReadableId': postSnapshot.data()['nextUserReadableId'] + 1
        });
        user.readableId = postSnapshot.data()['nextUserReadableId'].toString();
      }

      tx.set(
        FirebaseFirestore.instance.doc(APIPath.userDocument(uid)),
        user.toMap(),
      );
      if (centerRequest != null && centerRequestCenterId != null) {
        tx.set(
          FirebaseFirestore.instance.doc(
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
    final DocumentReference postRef = FirebaseFirestore.instance
        .doc('/globalConfiguration/globalConfiguration');

    FirebaseFirestore.instance.runTransaction((Transaction tx) async {
      if (user.readableId == null && center?.readableId == null) {
        DocumentSnapshot postSnapshot = await tx.get(postRef);

        if (center == null) {
          tx.update(postRef, <String, dynamic>{
            'nextUserReadableId': postSnapshot.data()['nextUserReadableId'] + 1,
          });
          user.readableId =
              postSnapshot.data()['nextUserReadableId'].toString();
        } else {
          tx.update(postRef, <String, dynamic>{
            'nextUserReadableId': postSnapshot.data()['nextUserReadableId'] + 1,
            'nextCenterReadableId':
                postSnapshot.data()['nextCenterReadableId'] + 1
          });
          user.readableId =
              postSnapshot.data()['nextUserReadableId'].toString();
          center.readableId =
              postSnapshot.data()['nextCenterReadableId'].toString();
        }
      }
      tx.set(
        FirebaseFirestore.instance.doc(APIPath.userDocument(uid)),
        user.toMap(),
      );

      if (globalAdminRequest != null) {
        tx.set(
          FirebaseFirestore.instance
              .doc(APIPath.globalAdminRequestsDocument(globalAdminRequest.id)),
          globalAdminRequest.toMap(),
        );
      }
      if (center != null) {
        tx.set(
          FirebaseFirestore.instance.doc(APIPath.centerDocument(center.id)),
          center.toMap(),
        );
      }
    }, timeout: Duration(seconds: 10));
  }
}
