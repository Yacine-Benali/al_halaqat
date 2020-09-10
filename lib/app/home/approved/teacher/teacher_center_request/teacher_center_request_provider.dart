import 'package:al_halaqat/app/models/center_request.dart';
import 'package:al_halaqat/app/models/study_center.dart';
import 'package:al_halaqat/app/models/teacher.dart';
import 'package:al_halaqat/services/api_path.dart';
import 'package:al_halaqat/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class TeacherCenterRequestProvider {
  TeacherCenterRequestProvider({@required this.database});

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
    Teacher teacher,
    CenterRequest centerRequest,
    String centerId,
  ) async {
    FirebaseFirestore.instance.runTransaction((Transaction tx) async {
      await tx.set(
        FirebaseFirestore.instance.document(APIPath.userDocument(teacher.id)),
        teacher.toMap(),
      );
      await tx.set(
        FirebaseFirestore.instance.document(
            APIPath.centerRequestsDocument(centerId, centerRequest.id)),
        centerRequest.toMap(),
      );
    }, timeout: Duration(seconds: 10));
  }
}
