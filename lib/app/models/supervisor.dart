import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'user.dart';

class Supervisor extends User {
  Supervisor({
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
    @required this.isSupervisor,
    @required this.halaqatSupervisingIn,
    @required this.centers,
    @required this.centerState,
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

  bool isSupervisor;
  List<String> halaqatSupervisingIn;
  Map<String, String> centerState;
  List<String> centers;

  factory Supervisor.fromMap(Map<String, dynamic> data, String documentId) {
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
    Map<String, String> centerState =
        Map<String, String>.from(data['centerState']);
    Timestamp createdAt = data['createdAt'];
    Map<String, String> createdBy = Map<String, String>.from(data['createdBy']);
    List<String> centers = data['centers']?.cast<String>();
    //
    bool isSupervisor = data['isSupervisor'];
    List<String> halaqatSupervisingIn =
        data['halaqatSupervisingIn']?.cast<String>();

    return Supervisor(
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
      centerState: centerState,
      createdAt: createdAt,
      createdBy: createdBy,
      centers: centers,
      //
      isSupervisor: isSupervisor,
      halaqatSupervisingIn: halaqatSupervisingIn,
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
      'centerState': centerState,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'createdBy': createdBy,
      'centers': centers,
      //
      'isSupervisor': isSupervisor,
      'halaqatSupervisingIn': halaqatSupervisingIn,
    };
  }
}
