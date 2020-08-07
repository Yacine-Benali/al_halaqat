import 'package:al_halaqat/app/models/admin.dart';
import 'package:al_halaqat/app/models/global_admin.dart';
import 'package:al_halaqat/app/models/teacher.dart';

import 'student.dart';

abstract class User {
  String id;
  String name;
  int dateOfBirth;
  String gender;
  String nationality;
  String address;
  String phoneNumber;
  String educationalLevel;
  String etablissement;
  String note;
  String readableId;
  String username;
  String email;
  String password;
  int createdAt;
  Map<String, String> createdBy;
  Map<String, String> centerState;
  List<String> centers;
  List<String> halaqatLearningIn;
  bool isStudent;
  User(
    this.id,
    this.name,
    this.dateOfBirth,
    this.gender,
    this.nationality,
    this.address,
    this.phoneNumber,
    this.educationalLevel,
    this.etablissement,
    this.note,
    this.readableId,
    this.username,
    this.email,
    this.password,
    this.centerState,
    this.createdAt,
    this.createdBy,
    this.centers,
    this.halaqatLearningIn,
    this.isStudent,
  );

  factory User.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) return null;
    final bool isGloabalAdmin =
        data.containsKey('isGlobalAdmin') ? data['isGlobalAdmin'] : false;
    final bool isAdmin = data['isAdmin'] ?? false;
    final bool isTeacher = data['isTeacher'] ?? false;
    final bool isStudent = data['isStudent'] ?? false;
    User user;
    if (isGloabalAdmin)
      user = GlobalAdmin.fromMap(data, documentId);
    else if (isAdmin)
      user = Admin.fromMap(data, documentId);
    else if (isTeacher)
      user = Teacher.fromMap(data, documentId);
    else if (isStudent) user = Student.fromMap(data, documentId);

    return user;
  }
  Map<String, dynamic> toMap();
}
