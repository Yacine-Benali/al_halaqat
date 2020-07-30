import 'package:flutter/foundation.dart';
import 'user.dart';

class Student extends User {
  Student({
    @required this.id,
    @required this.name,
    @required this.dateOfBirth,
    @required this.gender,
    @required this.nationality,
    @required this.address,
    @required this.phoneNumber,
    @required this.educationalLevel,
    @required this.school,
    @required this.note,
    @required this.readableId,
    @required this.username,
    @required this.email,
    @required this.password,
    @required this.parentPhoneNumber,
    @required this.isStudent,
    @required this.centerId,
    @required this.state,
    @required this.createdAt,
    @required this.createdBy,
    @required this.halaqatLearningIn,
  });

  final String id;
  final String name;
  final int dateOfBirth;
  final int gender;
  final String nationality;
  final String address;
  final String phoneNumber;
  final String educationalLevel;
  final String school;
  final String note;
  final String readableId;
  final String username;
  final String email;
  final String password;
  final String parentPhoneNumber;
  final String isStudent;
  final String centerId;
  final String state;
  final int createdAt;
  final Map<String, String> createdBy;
  final List<String> halaqatLearningIn;

  factory Student.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }

    final String id = data[''];
    final String name = data[''];
    final int dateOfBirth = data[''];
    final int gender = data[''];
    final String nationality = data[''];
    final String address = data[''];
    final String phoneNumber = data[''];
    final String educationalLevel = data[''];
    final String school = data[''];
    final String note = data[''];
    final String readableId = data[''];
    final String username = data[''];
    final String email = data[''];
    final String password = data[''];
    final String parentPhoneNumber = data[''];
    final String isStudent = data[''];
    final String centerId = data[''];
    final String state = data[''];
    final int createdAt = data[''];
    final Map<String, String> createdBy = data[''];
    final List<String> halaqatLearningIn = data[''];

    return Student(
      id: id,
      name: name,
      dateOfBirth: dateOfBirth,
      gender: gender,
      nationality: nationality,
      address: address,
      phoneNumber: phoneNumber,
      educationalLevel: educationalLevel,
      school: school,
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
      'school': school,
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
