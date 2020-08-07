import 'package:flutter/foundation.dart';

class CenterRequest {
  CenterRequest({
    @required this.id,
    @required this.createdAt,
    @required this.userId,
    @required this.userRole,
    @required this.userName,
    @required this.userNationality,
    @required this.action,
    @required this.state,
    @required this.object,
  });
  String id;
  int createdAt;
  String userId;
  String userRole;
  String userName;
  String userNationality;
  String action;
  String state;
  Map<String, String> object;

  factory CenterRequest.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    String id = documentId;
    int createdAt = data['createdAt'];
    String userId = data['userId'];
    String userRole = data['userRole'];
    String userName = data['userName'];
    String userNationality = data['userNationality'];
    String action = data['action'];
    String state = data['state'];
    Map<String, String> object = Map<String, String>.from(data['object']);

    return CenterRequest(
      id: id,
      createdAt: createdAt,
      userId: userId,
      userRole: userRole,
      userName: userName,
      userNationality: userNationality,
      action: action,
      state: state,
      object: object,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'createdAt': createdAt,
      'userId': userId,
      'userRole': userRole,
      'userName': userName,
      'userNationality': userNationality,
      'action': action,
      'state': state,
      'object': object,
    };
  }
}
