import 'package:al_halaqat/app/models/conversation_user.dart';
import 'package:al_halaqat/app/models/log_object.dart';
import 'package:al_halaqat/app/models/mini_center.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AdminLog {
  AdminLog({
    @required this.id,
    @required this.createdAt,
    @required this.admin,
    @required this.action,
    @required this.object,
    @required this.center,
  });
  String id;
  Timestamp createdAt;
  ConversationUser admin;
  String action;
  LogObject object;
  MiniCenter center;

  factory AdminLog.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    String id = documentId;
    Timestamp createdAt = data['createdAt'];
    ConversationUser admin = ConversationUser.fromMap(data['admin']);
    String action = data['action'];
    LogObject object = LogObject.fromMap(data['object']);
    MiniCenter center = MiniCenter.fromMap(data['center']);

    return AdminLog(
      id: id,
      center: center,
      createdAt: createdAt,
      admin: admin,
      action: action,
      object: object,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'admin': admin.toMap(),
      'action': action,
      'object': object.toMap(),
      'center': center.toMap(),
    };
  }
}
