import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class StudyCenter {
  StudyCenter({
    @required this.id,
    @required this.readableId,
    @required this.name,
    @required this.country,
    @required this.city,
    @required this.street,
    @required this.phoneNumber,
    @required this.isMessagingEnabled,
    @required this.studentRoaming,
    @required this.requestPermissionForHalaqaCreation,
    @required this.canTeachersEditStudents,
    @required this.canTeacherRemoveStudentsFromHalaqa,
    @required this.state,
    @required this.nextHalaqaReadableId,
    @required this.createdBy,
    @required this.createdAt,
  });
  String id;
  String readableId;
  String name;
  String country;
  String city;
  String street;
  String phoneNumber;
  bool isMessagingEnabled;
  bool studentRoaming;
  bool requestPermissionForHalaqaCreation;
  bool canTeachersEditStudents;
  bool canTeacherRemoveStudentsFromHalaqa;
  String state;
  int nextHalaqaReadableId;
  Map<String, String> createdBy;
  Timestamp createdAt;

  factory StudyCenter.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    String id = documentId;
    String readableId = data['readableId'];
    String name = data['name'];
    String country = data['country'];
    String city = data['city'];
    String street = data['street'];
    String phoneNumber = data['phoneNumber'];
    bool isMessagingEnabled = data['isMessagingEnabled'];
    bool studentRoaming = data['studentRoaming'];
    bool requestPermissionForHalaqaCreation =
        data['requestPermissionForHalaqaCreation'];
    bool canTeachersEditStudents = data['canTeachersEditStudents'];
    bool canTeacherRemoveStudentsFromHalaqa =
        data['canTeacherRemoveStudentsFromHalaqa'];
    String state = data['state'];
    int nextHalaqaReadableId = data['nextHalaqaReadableId'];
    Map<String, String> createdBy = Map<String, String>.from(data['createdBy']);
    Timestamp createdAt = data['createdAt'];

    return StudyCenter(
      id: id,
      readableId: readableId,
      name: name,
      country: country,
      city: city,
      street: street,
      phoneNumber: phoneNumber,
      isMessagingEnabled: isMessagingEnabled,
      studentRoaming: studentRoaming,
      requestPermissionForHalaqaCreation: requestPermissionForHalaqaCreation,
      canTeachersEditStudents: canTeachersEditStudents,
      canTeacherRemoveStudentsFromHalaqa: canTeacherRemoveStudentsFromHalaqa,
      state: state,
      nextHalaqaReadableId: nextHalaqaReadableId,
      createdBy: createdBy,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'readableId': readableId,
      'name': name,
      'country': country,
      'city': city,
      'street': street,
      'phoneNumber': phoneNumber,
      'isMessagingEnabled': isMessagingEnabled,
      'studentRoaming': studentRoaming,
      'requestPermissionForHalaqaCreation': requestPermissionForHalaqaCreation,
      'canTeachersEditStudents': canTeachersEditStudents,
      'canTeacherRemoveStudentsFromHalaqa': canTeacherRemoveStudentsFromHalaqa,
      'state': state,
      'nextHalaqaReadableId': nextHalaqaReadableId,
      'createdBy': createdBy,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }
}
