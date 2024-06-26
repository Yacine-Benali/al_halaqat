import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'user.dart';

class Student extends User {
  Student({
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
    @required this.isStudent,
    @required this.center,
    @required this.state,
    @required this.parentPhoneNumber,
    @required this.halaqatLearningIn,
    @required this.halaqatOrganizingIn,
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

  String parentPhoneNumber;
  String center;
  String state;
  bool isStudent;
  List<String> halaqatLearningIn;
  List<String> halaqatOrganizingIn;
  factory Student.fromMap(Map<String, dynamic> data, String documentId) {
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
    String state = data['state'];
    Timestamp createdAt = data['createdAt'];
    Map<String, String> createdBy = Map<String, String>.from(data['createdBy']);
    String center = data['center'];
    List<String> halaqatLearningIn = data['halaqatLearningIn']?.cast<String>();
    List<String> halaqatOrganizingIn =
        data['halaqatOrganizingIn']?.cast<String>();

    bool isStudent = data['isStudent'];

    //
    String parentPhoneNumber = data['parentPhoneNumber'];

    return Student(
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
      state: state,
      createdAt: createdAt,
      createdBy: createdBy,
      center: center,
      halaqatLearningIn: halaqatLearningIn,
      halaqatOrganizingIn: halaqatOrganizingIn,
      isStudent: isStudent,
      //
      parentPhoneNumber: parentPhoneNumber,
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
      'center': center,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'createdBy': createdBy,
      'state': state,
      'halaqatLearningIn': halaqatLearningIn,
      'halaqatOrganizingIn': halaqatOrganizingIn,

      'isStudent': isStudent,
      //
      'parentPhoneNumber': parentPhoneNumber,
    };
  }

  Student copyWith({List<String> halaqatLearningIn}) {
    return Student(
      id: this.id,
      name: this.name,
      dateOfBirth: this.dateOfBirth,
      gender: this.gender,
      nationality: this.nationality,
      address: this.address,
      phoneNumber: this.phoneNumber,
      educationalLevel: this.educationalLevel,
      etablissement: this.etablissement,
      note: this.note,
      readableId: this.readableId,
      username: this.username,
      password: this.password,
      state: this.state,
      createdAt: this.createdAt,
      createdBy: this.createdBy,
      center: this.center,
      halaqatLearningIn: halaqatLearningIn ?? this.halaqatLearningIn,
      isStudent: this.isStudent,
      halaqatOrganizingIn: this.halaqatOrganizingIn,
      //
      parentPhoneNumber: parentPhoneNumber,
    );
  }

  @override
  bool operator ==(other) => other is Student && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
