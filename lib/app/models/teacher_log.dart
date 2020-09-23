import 'package:alhalaqat/app/models/conversation_user.dart';
import 'package:alhalaqat/app/models/log_object.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class TeacherLog {
  TeacherLog({
    @required this.id,
    @required this.createdAt,
    @required this.teacher,
    @required this.action,
    @required this.object,
  });
  String id;
  Timestamp createdAt;
  ConversationUser teacher;
  String action;
  LogObject object;

  factory TeacherLog.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    String id = documentId;
    Timestamp createdAt = data['createdAt'];
    ConversationUser teacher = ConversationUser.fromMap(data['teacher']);
    String action = data['action'];
    LogObject object = LogObject.fromMap(data['object']);

    return TeacherLog(
      id: id,
      createdAt: createdAt,
      teacher: teacher,
      action: action,
      object: object,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'teacher': teacher.toMap(),
      'action': action,
      'object': object.toMap(),
    };
  }
}
