import 'package:al_halaqat/app/models/admin.dart';
import 'package:al_halaqat/app/models/center_request.dart';
import 'package:al_halaqat/app/models/global_admin_request.dart';
import 'package:al_halaqat/app/models/study_center.dart';
import 'package:al_halaqat/app/models/user.dart';
import 'package:al_halaqat/services/api_path.dart';
import 'package:al_halaqat/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class CenterRequestsProvider {
  CenterRequestsProvider({@required this.database});

  final Database database;

  Stream<List<CenterRequest>> fetchCenterRequests(
    String requestsState,
    String centerId,
    int limitNumber,
  ) {
    return database.collectionStream(
      path: APIPath.centerRequestsCollection(centerId),
      builder: (data, documentId) => CenterRequest.fromMap(
        data,
        documentId,
      ),
      queryBuilder: (query) => query
          .where('centerId', isEqualTo: centerId)
          .where('state', isEqualTo: requestsState)
          .limit(limitNumber),
      sort: (rhs, lhs) => lhs.createdAt.compareTo(rhs.createdAt),
    );
  }

  Future<void> updateJoinRequest(
    String centerId,
    CenterRequest centerRequest,
    User user,
  ) async {
    await Firestore.instance.runTransaction((Transaction tx) async {
      // update the request
      final requestDocRef = Firestore.instance
          .document(APIPath.centerRequestsDocument(centerId, centerRequest.id));

      tx.update(requestDocRef, centerRequest.toMap());

      // update the user if the action is join-new
      if (user != null) {
        final userDocRef =
            Firestore.instance.document(APIPath.userDocument(user.id));

        tx.update(userDocRef, user.toMap());
      }
    }, timeout: Duration(seconds: 10));
  }

  Future<void> updateNewHalaqaRequest(
    CenterRequest centerRequest,
    User user,
  ) async {
    await Firestore.instance.runTransaction((Transaction tx) async {
      //TODO implement this function
      // update the request
      final requestDocRef =
          Firestore.instance.document(APIPath.centerDocument(centerRequest.id));

      tx.update(requestDocRef, centerRequest.toMap());

      // update the user if the action is join-new
      if (user != null) {
        final centerDocRef =
            Firestore.instance.document(APIPath.userDocument(user.id));

        tx.update(centerDocRef, user.toMap());
      }
    }, timeout: Duration(seconds: 10));
  }
}
