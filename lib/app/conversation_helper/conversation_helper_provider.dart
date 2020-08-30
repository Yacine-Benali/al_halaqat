import 'package:al_halaqat/app/models/admin.dart';
import 'package:al_halaqat/app/models/conversation.dart';
import 'package:al_halaqat/app/models/student.dart';
import 'package:al_halaqat/app/models/teacher.dart';
import 'package:al_halaqat/services/api_path.dart';
import 'package:al_halaqat/services/database.dart';
import 'package:flutter/foundation.dart';

class ConversationHelperProvide {
  ConversationHelperProvide({@required this.database});

  final Database database;

  Future<List<Admin>> fetchCenterAdmins(String centerId) =>
      database.fetchCollection(
        path: APIPath.usersCollection(),
        builder: (data, documentId) => Admin.fromMap(data, documentId),
        queryBuilder: (query) => query
            .where('isAdmin', isEqualTo: true)
            .where('centers', arrayContains: centerId),
      );

  Future<List<Teacher>> fetchHalaqaTeacher(List<String> halaqatIds) =>
      database.fetchCollection(
        path: APIPath.usersCollection(),
        builder: (data, documentId) => Teacher.fromMap(data, documentId),
        queryBuilder: (query) => query
            .where('isTeacher', isEqualTo: true)
            .where('halaqatTeachingIn', arrayContainsAny: halaqatIds),
      );
  Future<List<Student>> fetchHalaqatStudent(List<String> halaqatIds) =>
      database.fetchCollection(
        path: APIPath.usersCollection(),
        builder: (data, documentId) => Student.fromMap(data, documentId),
        queryBuilder: (query) => query
            .where('isStudent', isEqualTo: true)
            .where('halaqatLearningIn', arrayContainsAny: halaqatIds),
      );

  Future<List<Student>> fetchCenterStudents(String centerId) =>
      database.fetchCollection(
        path: APIPath.usersCollection(),
        builder: (data, documentId) => Student.fromMap(data, documentId),
        queryBuilder: (query) => query
            .where('isStudent', isEqualTo: true)
            .where('center', isEqualTo: centerId),
      );

  Future<void> createConversation(Conversation conversation) async =>
      await database.setData(
        path: APIPath.conversationDocument(conversation.groupChatId),
        data: conversation.toMapMerge(),
        merge: true,
      );

  Future<void> disableConversation(String groupChatId) async =>
      await database.setData(
        path: APIPath.conversationDocument(groupChatId),
        data: {'isEnabled': false},
        merge: true,
      );
}
