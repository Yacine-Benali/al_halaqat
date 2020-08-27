// import 'package:flutter/foundation.dart';
// import 'package:b1_parent/app/conversation/conversation_model.dart';
// import 'package:b1_parent/app/conversation/teacher_model.dart';
// import 'package:b1_parent/services/api_path.dart';
// import 'package:b1_parent/services/database.dart';

// class ConversationsProvider {
//   ConversationsProvider({@required this.database});
//   Database database;

//   Future<void> creatConversation(
//     String schoolName,
//     ConversationModel conversation,
//     String conversationId,
//   ) =>
//       database.setData(
//         path: APIPath.conversationDocument(schoolName, conversationId),
//         data: conversation.toMap(),
//         merge: true,
//       );

//   Stream<List<ConversationModel>> conversationStream(
//     String schoolName,
//     String uid,
//   ) {
//     return database.collectionStream(
//       path: APIPath.conversationsCollection(schoolName),
//       builder: (data, documentId) =>
//           ConversationModel.fromMap(data, documentId),
//       queryBuilder: (query) => query.where('student.uid', isEqualTo: uid),
//       sort: (conversation1, conversation2) {
//         return conversation1.latestMessage.timestamp
//                 .compareTo(conversation2.latestMessage.timestamp) *
//             -1;
//       },
//     );
//   }

//   Stream<List<TeacherModel>> teachersStream(
//       String schoolName, String classroom) {
//     return database.collectionStream(
//       path: APIPath.teachersCollection(schoolName),
//       builder: (data, documentId) => TeacherModel.fromMap(data, documentId),
//       queryBuilder: (query) =>
//           query.where('classrooms', arrayContains: classroom),
//     );
//   }
// }
