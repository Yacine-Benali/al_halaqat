import 'package:alhalaqat/app/models/conversation.dart';
import 'package:alhalaqat/services/api_path.dart';
import 'package:alhalaqat/services/database.dart';
import 'package:flutter/foundation.dart';

class ConversationsProvider {
  ConversationsProvider({@required this.database});
  Database database;

  Stream<List<Conversation>> getTeacherConversationStream(
    String teacherId,
  ) {
    return database.collectionStream(
      path: APIPath.conversationsCollection(),
      builder: (data, documentId) => Conversation.fromMap(data, documentId),
      queryBuilder: (query) => query
          .where('isEnabled', isEqualTo: true)
          .where('teacher.id', isEqualTo: teacherId)
          .orderBy('latestMessage.seen', descending: false),
    );
  }

  Stream<List<Conversation>> getStudentConversationStream(
    String studentId,
  ) {
    return database.collectionStream(
      path: APIPath.conversationsCollection(),
      builder: (data, documentId) => Conversation.fromMap(data, documentId),
      queryBuilder: (query) => query
          .where('isEnabled', isEqualTo: true)
          .where('student.id', isEqualTo: studentId),
    );
  }
}
