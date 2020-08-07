import 'package:flutter/foundation.dart';

class GlobalAdminRequest {
  GlobalAdminRequest({
    @required this.id,
    @required this.createdAt,
    @required this.adminId,
    @required this.adminName,
    @required this.adminNationality,
    @required this.action,
    @required this.centerId,
    @required this.centerName,
    @required this.state,
  });
  String id;
  int createdAt;
  String adminId;
  String adminName;
  String adminNationality;
  String action;
  String centerId;
  String centerName;
  String state;

  factory GlobalAdminRequest.fromMap(
      Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    String id = documentId;
    int createdAt = data['createdAt'];
    String adminId = data['adminId'];
    String adminName = data['adminName'];
    String adminNationality = data['adminNationality'];
    String action = data['action'];
    String centerId = data['centerId'];
    String centerName = data['centerName'];
    String state = data['state'];

    return GlobalAdminRequest(
      id: id,
      createdAt: createdAt,
      adminId: adminId,
      adminName: adminName,
      adminNationality: adminNationality,
      action: action,
      centerId: centerId,
      centerName: centerName,
      state: state,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt,
      'adminId': adminId,
      'adminName': adminName,
      'adminNationality': adminNationality,
      'action': action,
      'centerId': centerId,
      'centerName': centerName,
      'state': state,
    };
  }
}
