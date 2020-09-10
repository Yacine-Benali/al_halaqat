import 'package:al_halaqat/app/models/conversation_user.dart';
import 'package:al_halaqat/app/models/log_object.dart';
import 'package:al_halaqat/app/models/mini_center.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AdminLog {
  AdminLog({
    @required this.createdAt,
    @required this.teacher,
    @required this.action,
    @required this.object,
    @required this.center,
  });
  Timestamp createdAt;
  ConversationUser teacher;
  String action;
  LogObject object;
  MiniCenter center;

  factory AdminLog.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    Timestamp createdAt = data['createdAt'];
    ConversationUser teacher = ConversationUser.fromMap(data['teacher']);
    String action = data['action'];
    LogObject object = LogObject.fromMap(data['object']);
    MiniCenter center = MiniCenter.fromMap(data['center']);

    return AdminLog(
      center: center,
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
      'center': center.toMap(),
    };
  }
}
