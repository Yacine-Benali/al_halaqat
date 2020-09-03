import 'package:al_halaqat/app/models/admin.dart';
import 'package:al_halaqat/app/models/center_request.dart';
import 'package:al_halaqat/app/models/halaqa.dart';
import 'package:al_halaqat/app/models/student.dart';
import 'package:al_halaqat/app/models/teacher.dart';
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
      queryBuilder: (query) =>
          query.where('state', isEqualTo: requestsState).limit(limitNumber),
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

        if (user is Teacher || user is Admin)
          tx.update(userDocRef, {'centerState.$centerId': centerRequest.state});
        else if (user is Student)
          tx.update(userDocRef, {'state': centerRequest.state});
      }
    }, timeout: Duration(seconds: 10));
  }

  Future<void> updateJoinExistingRequestAccepted(
    String centerId,
    CenterRequest centerRequest,
    User user,
  ) async {
    await Firestore.instance.runTransaction((Transaction tx) async {
      // update the request
      final requestDocRef = Firestore.instance
          .document(APIPath.centerRequestsDocument(centerId, centerRequest.id));

      tx.update(requestDocRef, centerRequest.toMap());

      final userDocRef =
          Firestore.instance.document(APIPath.userDocument(user.id));

      tx.update(userDocRef, {
        'centerState.$centerId': centerRequest.state,
        'centers': FieldValue.arrayUnion([centerId])
      });
    }, timeout: Duration(seconds: 10));
  }

  Future<void> updateJoinExistingRequestRefused(
    String centerId,
    CenterRequest centerRequest,
    User user,
  ) async {
    await Firestore.instance.runTransaction((Transaction tx) async {
      // update the request
      final requestDocRef = Firestore.instance
          .document(APIPath.centerRequestsDocument(centerId, centerRequest.id));

      tx.update(requestDocRef, centerRequest.toMap());

      final userDocRef =
          Firestore.instance.document(APIPath.userDocument(user.id));

      tx.update(userDocRef, {
        'centerState.$centerId': FieldValue.delete(),
      });
    }, timeout: Duration(seconds: 10));
  }

  Future<void> updateNewHalaqaRequest(
    CenterRequest centerRequest,
    Halaqa halaqa,
    String centerId,
  ) async {
    await Firestore.instance.runTransaction((Transaction tx) async {
      // update the request
      final centerRequestDocRef = Firestore.instance
          .document(APIPath.centerRequestsDocument(centerId, centerRequest.id));

      tx.update(centerRequestDocRef, centerRequest.toMap());

      // update the user if the action is join-new
      final halaqaDocRef =
          Firestore.instance.document(APIPath.halaqaDocument(halaqa.id));

      tx.update(halaqaDocRef, halaqa.toMap());
    }, timeout: Duration(seconds: 10));
  }

  String getUniqueId() => database.getUniqueId();
}
