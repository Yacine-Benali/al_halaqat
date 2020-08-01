import 'package:flutter/foundation.dart';
import 'user.dart';

class Teacher extends User {
  Teacher({
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
    @required String state,
    @required int createdAt,
    @required Map<String, String> createdBy,
    @required this.isStudent,
    @required this.halaqatLearningIn,
    @required this.centers,
    @required this.isTeacher,
    @required this.halaqatTeachingIn,
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

  bool isStudent;
  List<String> halaqatLearningIn;
  List<String> centers;
  bool isTeacher;
  List<String> halaqatTeachingIn;

  factory Teacher.fromMap(Map<String, dynamic> data, String documentId) {
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
    String state = data['state'];
    int createdAt = data['createdAt'];
    Map<String, String> createdBy = Map<String, String>.from(data['createdBy']);
    //
    bool isStudent = data['isStudent'];
    List<String> halaqatLearningIn = data['halaqatLearningIn'];
    List<String> centers = data['centers'].cast<String>();
    bool isTeacher = data['isTeacher'];
    List<String> halaqatTeachingIn = data['halaqatTeachingIn'].cast<String>();

    return Teacher(
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
      state: state,
      createdAt: createdAt,
      createdBy: createdBy,
      //
      isStudent: isStudent,
      halaqatLearningIn: halaqatLearningIn,
      centers: centers,
      isTeacher: isTeacher,
      halaqatTeachingIn: halaqatTeachingIn,
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
      'state': state,
      'createdAt': createdAt,
      'createdBy': createdBy,
      //
      'isStudent': isStudent,
      'halaqatLearningIn': halaqatLearningIn,
      'centers': centers,
      'isTeacher': isTeacher,
      'halaqatTeachingIn': halaqatTeachingIn,
    };
  }
}
