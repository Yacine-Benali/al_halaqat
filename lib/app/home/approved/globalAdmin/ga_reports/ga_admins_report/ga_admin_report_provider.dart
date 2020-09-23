import 'package:alhalaqat/app/models/admin.dart';
import 'package:alhalaqat/app/models/study_center.dart';
import 'package:alhalaqat/services/api_path.dart';
import 'package:alhalaqat/services/database.dart';
import 'package:flutter/foundation.dart';

class GaAdminReportProvider {
  GaAdminReportProvider({@required this.database});

  final Database database;

  Future<List<Admin>> fetchAdmins() => database.fetchCollection(
        path: APIPath.usersCollection(),
        builder: (data, documentId) => Admin.fromMap(data, documentId),
        queryBuilder: (query) => query.where('isAdmin', isEqualTo: true),
      );

  Future<StudyCenter> fetchAdminCenter(String centerId) =>
      database.fetchDocument(
        path: APIPath.centerDocument(centerId),
        builder: (data, documentId) => StudyCenter.fromMap(data, documentId),
      );
}
