import 'package:alhalaqat/app/models/admin.dart';
import 'package:alhalaqat/app/models/study_center.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class GlobalAdminRequest {
  GlobalAdminRequest({
    @required this.id,
    @required this.createdAt,
    @required this.adminId,
    @required this.admin,
    @required this.action,
    @required this.centerId,
    @required this.center,
    @required this.state,
  });
  String id;
  Timestamp createdAt;
  String adminId;
  Admin admin;
  String action;
  String centerId;
  StudyCenter center;
  String state;

  factory GlobalAdminRequest.fromMap(
      Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    String id = documentId;
    Timestamp createdAt = data['createdAt'];
    String adminId = data['adminId'];
    Admin admin = Admin.fromMap(data['admin'], adminId);
    String action = data['action'];
    String centerId = data['centerId'];
    StudyCenter center = StudyCenter.fromMap(data['center'], centerId);
    String state = data['state'];

    return GlobalAdminRequest(
      id: id,
      createdAt: createdAt,
      adminId: adminId,
      admin: admin,
      action: action,
      centerId: centerId,
      center: center,
      state: state,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'adminId': adminId,
      'admin': admin.toMap(),
      'action': action,
      'centerId': centerId,
      'center': center.toMap(),
      'state': state,
    };
  }
}
