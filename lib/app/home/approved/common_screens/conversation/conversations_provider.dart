import 'package:al_halaqat/app/models/conversation.dart';
import 'package:al_halaqat/services/api_path.dart';
import 'package:al_halaqat/services/database.dart';
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
          .where('teacher.id', isEqualTo: teacherId),
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
