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
    @required String email,
    @required String password,
    @required Map<String, String> centerState,
    @required int createdAt,
    @required Map<String, String> createdBy,
    @required List<String> centers,
    @required List<String> halaqatLearningIn,
    @required this.isStudent,
    @required this.parentPhoneNumber,
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
          centerState,
          createdAt,
          createdBy,
          centers,
          halaqatLearningIn,
        );

  bool isStudent;
  String parentPhoneNumber;

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
    String readableId = data['readableId'];
    String username = data['username'];
    String email = data['email'];
    String password = data['password'];
    Map<String, String> centerState =
        Map<String, String>.from(data['centerState']);
    int createdAt = data['createdAt'];
    Map<String, String> createdBy = Map<String, String>.from(data['createdBy']);
    List<String> centers = data['centers'].cast<String>();
    List<String> halaqatLearningIn = data['halaqatLearningIn'].cast<String>();
    //
    bool isStudent = data['isStudent'];
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
      email: email,
      password: password,
      centerState: centerState,
      createdAt: createdAt,
      createdBy: createdBy,
      centers: centers,
      halaqatLearningIn: halaqatLearningIn,
      //
      isStudent: isStudent,
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
      'email': email,
      'password': password,
      'centerState': centerState,
      'createdAt': createdAt,
      'createdBy': createdBy,
      'centers': centers,
      'halaqatLearningIn': halaqatLearningIn,
      //
      'isStudent': isStudent,
      'parentPhoneNumber': parentPhoneNumber,
    };
  }
}
