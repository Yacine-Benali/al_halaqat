import 'package:alhalaqat/app/models/admin.dart';
import 'package:alhalaqat/app/models/center_request.dart';
import 'package:alhalaqat/app/models/halaqa.dart';
import 'package:alhalaqat/app/models/student.dart';
import 'package:alhalaqat/app/models/teacher.dart';
import 'package:alhalaqat/app/models/user.dart';
import 'package:alhalaqat/services/api_path.dart';
import 'package:alhalaqat/services/database.dart';
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
    await FirebaseFirestore.instance.runTransaction((Transaction tx) async {
      // update the request
      final requestDocRef = FirebaseFirestore.instance
          .doc(APIPath.centerRequestsDocument(centerId, centerRequest.id));

      tx.update(requestDocRef, centerRequest.toMap());

      // update the user if the action is join-new
      if (user != null) {
        final userDocRef =
            FirebaseFirestore.instance.doc(APIPath.userDocument(user.id));

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
    await FirebaseFirestore.instance.runTransaction((Transaction tx) async {
      // update the request
      final requestDocRef = FirebaseFirestore.instance
          .doc(APIPath.centerRequestsDocument(centerId, centerRequest.id));

      tx.update(requestDocRef, centerRequest.toMap());

      final userDocRef =
          FirebaseFirestore.instance.doc(APIPath.userDocument(user.id));

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
    await FirebaseFirestore.instance.runTransaction((Transaction tx) async {
      // update the request
      final requestDocRef = FirebaseFirestore.instance
          .doc(APIPath.centerRequestsDocument(centerId, centerRequest.id));

      tx.update(requestDocRef, centerRequest.toMap());

      final userDocRef =
          FirebaseFirestore.instance.doc(APIPath.userDocument(user.id));

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
    await FirebaseFirestore.instance.runTransaction((Transaction tx) async {
      // update the request
      final centerRequestDocRef = FirebaseFirestore.instance
          .doc(APIPath.centerRequestsDocument(centerId, centerRequest.id));

      tx.update(centerRequestDocRef, centerRequest.toMap());

      // update the user if the action is join-new
      final halaqaDocRef =
          FirebaseFirestore.instance.doc(APIPath.halaqaDocument(halaqa.id));

      tx.update(halaqaDocRef, halaqa.toMap());
    }, timeout: Duration(seconds: 10));
  }

  String getUniqueId() => database.getUniqueId();
}
