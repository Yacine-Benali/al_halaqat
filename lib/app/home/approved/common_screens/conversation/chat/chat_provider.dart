// import 'dart:io';

// import 'package:flutter/foundation.dart';
// import 'package:b1_parent/app/conversation/message_model.dart';
// import 'package:b1_parent/services/api_path.dart';
// import 'package:b1_parent/services/database.dart';

// class ChatProvider {
//   Database database;

//   ChatProvider({@required this.database});

//   Stream<List<MessageModel>> latestMessagesStream(
//       String schoolName, String conversationsId) {
//     return database.collectionStream(
//       path: APIPath.messagesCollection(schoolName, conversationsId),
//       builder: (data, documentId) => MessageModel.fromMap(data, documentId),
//       queryBuilder: (query) =>
//           query.orderBy('timestamp', descending: true).limit(20),
//     );
//   }

//   Future<List<MessageModel>> fetchMessages(String schoolName,
//       String conversationsId, MessageModel message, int numberOfMessages) {
//     return database.fetchCollection(
//       path: APIPath.messagesCollection(schoolName, conversationsId),
//       builder: (data, documentId) => MessageModel.fromMap(data, documentId),
//       queryBuilder: (query) => query
//           .orderBy('timestamp', descending: true)
//           .startAfter([message.timestamp]).limit(numberOfMessages),
//     );
//   }

//    void updateLatestMessage(
//       String schoolName, String conversationId, MessageModel message) {
//     database.setData(
//       path: APIPath.conversationDocument(schoolName, conversationId),
//       data: {
//         'latestMessage': message.toMap(),
//       },
//       merge: true,
//     );
//   }
//   void addMessageToCollection(
//       String schoolName, String conversationId, MessageModel message) async {
//     // add message to collection
//     return database.addDocument(
//       path: APIPath.messagesCollection(schoolName, conversationId),
//       data: message.toMap(),
//     );
//   }

//   Future<dynamic> uploadImage(
//       String schoolName, String conversationId, File file, String imageId) {
//     return database.uploadFile(
//       path: APIPath.uploadImageDocument(schoolName, conversationId, imageId),
//       file: file,
//     );
//   }

// }
