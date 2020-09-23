import 'package:alhalaqat/app/models/admin.dart';
import 'package:alhalaqat/app/models/global_admin_request.dart';
import 'package:alhalaqat/app/models/study_center.dart';
import 'package:alhalaqat/services/api_path.dart';
import 'package:alhalaqat/services/database.dart';
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
      queryBuilder: (query) => query
          .where('state', isEqualTo: requestsState)
          .orderBy('createdAt', descending: true)
          .limit(limitNumber),
    );
  }

  Future<void> updateJoinNewRequest(
    GlobalAdminRequest gaRequest,
    StudyCenter center,
    Admin admin,
  ) async {
    await FirebaseFirestore.instance.runTransaction((Transaction tx) async {
      // update the request
      final requestDocRef = FirebaseFirestore.instance
          .doc(APIPath.globalAdminRequestsDocument(gaRequest.id));
      tx.update(requestDocRef, gaRequest.toMap());

      // update the center if the action is join-new
      final centerDocRef =
          FirebaseFirestore.instance.doc(APIPath.centerDocument(center.id));
      tx.update(centerDocRef, center.toMap());

      // update the admin
      final adminDocRef =
          FirebaseFirestore.instance.doc(APIPath.userDocument(admin.id));
      tx.update(
        adminDocRef,
        {'centerState.${gaRequest.center.id}': gaRequest.state},
      );
      //
    });
  }

  Future<void> updateJoinExistingRequestAccepted(
    GlobalAdminRequest gaRequest,
    Admin admin,
  ) async {
    await FirebaseFirestore.instance.runTransaction((Transaction tx) async {
      // update the request
      final requestDocRef = FirebaseFirestore.instance
          .doc(APIPath.globalAdminRequestsDocument(gaRequest.id));

      tx.update(requestDocRef, gaRequest.toMap());

      // update the admin
      final adminDocRef =
          FirebaseFirestore.instance.doc(APIPath.userDocument(admin.id));

      tx.update(adminDocRef, {
        'centerState.${gaRequest.center.id}': gaRequest.state,
        'centers': FieldValue.arrayUnion([gaRequest.centerId])
      });
    });
  }

  Future<void> updateJoinExistingRequestRefused(
    GlobalAdminRequest gaRequest,
    Admin admin,
  ) async {
    await FirebaseFirestore.instance.runTransaction((Transaction tx) async {
      // update the request
      final requestDocRef = FirebaseFirestore.instance
          .doc(APIPath.globalAdminRequestsDocument(gaRequest.id));

      tx.update(requestDocRef, gaRequest.toMap());

      // update the admin
      final adminDocRef =
          FirebaseFirestore.instance.doc(APIPath.userDocument(admin.id));

      tx.update(adminDocRef, {
        'centerState.${gaRequest.center.id}': FieldValue.delete(),
      });
    });
  }
}
