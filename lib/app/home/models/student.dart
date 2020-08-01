import 'package:flutter/foundation.dart';
import 'user.dart';

class Student extends User {
  Student({
    @required id,
    @required name,
    @required dateOfBirth,
    @required gender,
    @required nationality,
    @required address,
    @required phoneNumber,
    @required educationalLevel,
    @required etablissement,
    @required note,
    @required readableId,
    @required username,
    @required email,
    @required password,
    @required createdAt,
    @required createdBy,
    @required this.parentPhoneNumber,
    @required this.isStudent,
    @required this.centerId,
    @required state,
    @required this.halaqatLearningIn,
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
          email,
          password,
          state,
          createdAt,
          createdBy,
        );

  String parentPhoneNumber;
  bool isStudent;
  String centerId;
  List<String> halaqatLearningIn;

  factory Student.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }

    String id = data['id'];
    String name = data['name'];
    int dateOfBirth = data['dateOfBirth'];
    String gender = data['gender'];
    String nationality = data['nationality'];
    String address = data['address'];
    String phoneNumber = data['phoneNumber'];
    String educationalLevel = data['educationalLevel'];
    String etablissement = data['etablissement'];
    String note = data['note'];
    String readableId = data['readableId'];
    String username = data['username'];
    String email = data['email'];
    String password = data['password'];
    String parentPhoneNumber = data['parentPhoneNumber'];
    bool isStudent = data['isStudent'];
    String centerId = data['centerId'];
    String state = data['state'];
    int createdAt = data['createdAt'];
    Map<String, String> createdBy = Map<String, String>.from(data['createdBy']);
    List<String> halaqatLearningIn = data['halaqatLearningIn'];

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
      email: email,
      password: password,
      parentPhoneNumber: parentPhoneNumber,
      isStudent: isStudent,
      centerId: centerId,
      state: state,
      createdAt: createdAt,
      createdBy: createdBy,
      halaqatLearningIn: halaqatLearningIn,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
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
      'email': email,
      'password': password,
      'parentPhoneNumber': parentPhoneNumber,
      'isStudent': isStudent,
      'centerId': centerId,
      'state': state,
      'createdAt': createdAt,
      'createdBy': createdBy,
      'halaqatLearningIn': halaqatLearningIn,
    };
  }
}
