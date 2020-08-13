import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'user.dart';

class GlobalAdmin extends User {
  GlobalAdmin({
    @required String id,
    @required String name,
    @required int dateOfBirth,
    @required String gender,
    @required String nationality,
    @required String address,
    @required String phoneNumber,
    @required String educationalLevel,
    @required String etablissement,
    @required String note,
    @required String readableId,
    @required String username,
    @required String password,
    @required Timestamp createdAt,
    @required Map<String, String> createdBy,
    @required this.state,
    @required this.isGlobalAdmin,
  }) : super(
          id,
          name,
          dateOfBirth,
          gender,
          nationality,
          address,
          phoneNumber,
          educationalLevel,
          etablissement,
          note,
          readableId,
          username,
          password,
          createdAt,
          createdBy,
        );

  bool isGlobalAdmin;
  String state;
  factory GlobalAdmin.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    String id = documentId;
    String name = data['name'];
    int dateOfBirth = data['dateOfBirth'];
    String gender = data['gender'];
    String nationality = data['nationality'];
    String address = data['address'];
    String phoneNumber = data['phoneNumber'];
    String educationalLevel = data['educationalLevel'];
    String etablissement = data['etablissement'];
    String note = data['note'];
    String readableId = data['readableId'].toString();
    String username = data['username'];
    String password = data['password'];
    Timestamp createdAt = data['createdAt'];
    Map<String, String> createdBy = Map<String, String>.from(data['createdBy']);
    //
    String state = data['state'];

    bool isGlobalAdmin = data['isGlobalAdmin'];

    return GlobalAdmin(
      id: id,
      name: name,
      dateOfBirth: dateOfBirth,
      gender: gender,
      nationality: nationality,
      address: address,
      phoneNumber: phoneNumber,
      educationalLevel: educationalLevel,
      etablissement: etablissement,
      note: note,
      readableId: readableId,
      username: username,
      password: password,
      createdAt: createdAt,
      createdBy: createdBy,
      //
      isGlobalAdmin: isGlobalAdmin,
      state: state,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'nationality': nationality,
      'address': address,
      'phoneNumber': phoneNumber,
      'educationalLevel': educationalLevel,
      'etablissement': etablissement,
      'note': note,
      'readableId': readableId,
      'username': username,
      'password': password,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'createdBy': createdBy,
      //
      'state': state,
      'isGlobalAdmin': isGlobalAdmin,
    };
  }
}
