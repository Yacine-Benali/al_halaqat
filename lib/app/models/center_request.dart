import 'package:al_halaqat/app/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class CenterRequest {
  CenterRequest({
    @required this.id,
    @required this.createdAt,
    @required this.userId,
    @required this.user,
    @required this.action,
    @required this.state,
    @required this.halaqaName,
    @required this.halaqaId,
  });
  String id;
  Timestamp createdAt;
  String userId;
  User user;
  String action;
  String state;
  String halaqaName;
  String halaqaId;

  factory CenterRequest.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    String id = documentId;
    Timestamp createdAt = data['createdAt'];
    String userId = data['userId'];
    User user = User.fromMap(data['user'], userId);
    String action = data['action'];
    String state = data['state'];
    String halaqaName = data['halaqaName'];
    String halaqaId = data['halaqaId'];

    return CenterRequest(
      id: id,
      createdAt: createdAt,
      userId: userId,
      user: user,
      action: action,
      state: state,
      halaqaId: halaqaId,
      halaqaName: halaqaName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'userId': userId,
      'user': user.toMap(),
      'action': action,
      'state': state,
      'halaqaId': halaqaId,
      'halaqaName': halaqaName,
    };
  }
}