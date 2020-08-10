import 'package:al_halaqat/app/models/admin.dart';
import 'package:al_halaqat/app/models/study_center.dart';
import 'package:al_halaqat/services/api_path.dart';
import 'package:al_halaqat/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class GaAdminsProvider {
  GaAdminsProvider({@required this.database});

  final Database database;

  Stream<List<Admin>> fetcheGaRequests(
    int limitNumber,
  ) {
    return database.collectionStream(
      path: APIPath.usersCollection(),
      builder: (data, documentId) => Admin.fromMap(
        data,
        documentId,
      ),
      queryBuilder: (query) =>
          query.where('isAdmin', isEqualTo: true).limit(limitNumber),
      sort: (rhs, lhs) => lhs.createdAt.compareTo(rhs.createdAt),
    );
  }
}
