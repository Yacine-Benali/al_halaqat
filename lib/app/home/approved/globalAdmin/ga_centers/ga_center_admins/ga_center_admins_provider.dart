import 'package:alhalaqat/app/models/admin.dart';
import 'package:alhalaqat/services/api_path.dart';
import 'package:alhalaqat/services/database.dart';
import 'package:flutter/foundation.dart';

class GaCenterAdminsProvider {
  GaCenterAdminsProvider({@required this.database});

  final Database database;

  Stream<List<Admin>> fetchCenterAdmins(String centerId) =>
      database.collectionStream(
        path: APIPath.usersCollection(),
        builder: (data, documentId) => Admin.fromMap(data, documentId),
        queryBuilder: (query) => query
            .where('isAdmin', isEqualTo: true)
            .where('centers', arrayContains: centerId),
      );
}
