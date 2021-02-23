import 'package:alhalaqat/app/models/admin.dart';
import 'package:alhalaqat/app/models/global_admin.dart';
import 'package:alhalaqat/app/models/supervisor.dart';
import 'package:alhalaqat/app/models/teacher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  String password;
  Timestamp createdAt;
  Map<String, String> createdBy;
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
    this.password,
    this.createdAt,
    this.createdBy,
  );

  factory User.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) return null;
    final bool isGloabalAdmin =
        data.containsKey('isGlobalAdmin') ? data['isGlobalAdmin'] : false;
    final bool isAdmin = data['isAdmin'] ?? false;
    final bool isTeacher = data['isTeacher'] ?? false;
    final bool isSupervisor = data['isSupervisor'] ?? false;
    final bool isStudent = data['isStudent'] ?? false;
    User user;
    if (isGloabalAdmin)
      user = GlobalAdmin.fromMap(data, documentId);
    else if (isAdmin)
      user = Admin.fromMap(data, documentId);
    else if (isTeacher)
      user = Teacher.fromMap(data, documentId);
    else if (isSupervisor)
      user = Supervisor.fromMap(data, documentId);
    else if (isStudent) user = Student.fromMap(data, documentId);

    return user;
  }
  Map<String, dynamic> toMap();
}
