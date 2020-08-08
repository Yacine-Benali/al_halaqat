// import 'package:al_halaqat/app/models/global_admin_request.dart';
// import 'package:al_halaqat/services/api_path.dart';
// import 'package:al_halaqat/services/database.dart';
// import 'package:flutter/foundation.dart';

// class GaRequestsProvider {
//   GaRequestsProvider({@required this.database});

//   final Database database;

//   Future<List<GlobalAdminRequest>> fetchGaRequests(
//       MessageModel message, int numberOfMessages) {
//     return database.fetchCollection(
//         path: APIPath.adminRequestsCollection(),
//         builder: (data, documentId) =>
//             GlobalAdminRequest.fromMap(data, documentId),
//         queryBuilder: (query) =>
//             query.orderBy('createdAt', descending: true).startAfter(values));
//   }
// }
