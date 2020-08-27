import 'package:al_halaqat/app/models/admin.dart';
import 'package:al_halaqat/app/models/global_admin_request.dart';
import 'package:al_halaqat/app/models/study_center.dart';
import 'package:al_halaqat/services/api_path.dart';
import 'package:al_halaqat/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class GaRequestsProvider {
  GaRequestsProvider({@required this.database});

  final Database database;

  Stream<List<GlobalAdminRequest>> fetcheGaRequests(
    String requestsState,
    int limitNumber,
  ) {
    return database.collectionStream(
      path: APIPath.globalAdminRequestsCollection(),
      builder: (data, documentId) => GlobalAdminRequest.fromMap(
        data,
        documentId,
      ),
      queryBuilder: (query) =>
          query.where('state', isEqualTo: requestsState).limit(limitNumber),
      sort: (rhs, lhs) => lhs.createdAt.compareTo(rhs.createdAt),
    );
  }

  Future<void> updateRequest(
    GlobalAdminRequest gaRequest,
    StudyCenter center,
    Admin admin,
  ) async {
    await Firestore.instance.runTransaction((Transaction tx) async {
      // update the request
      final requestDocRef = Firestore.instance
          .document(APIPath.globalAdminRequestsDocument(gaRequest.id));

      tx.update(requestDocRef, gaRequest.toMap());

      // update the center if the action is join-new
      if (center != null) {
        final centerDocRef =
            Firestore.instance.document(APIPath.centerDocument(center.id));

        tx.update(centerDocRef, center.toMap());
      }
      // update the admin
      final adminDocRef =
          Firestore.instance.document(APIPath.userDocument(admin.id));

      tx.update(
          adminDocRef, {'centerState.${gaRequest.center.id}': gaRequest.state});
    }, timeout: Duration(seconds: 10));
  }
}
