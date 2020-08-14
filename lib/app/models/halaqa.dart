import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Halaqa {
  Halaqa({
    @required this.id,
    @required this.readableId,
    @required this.centerId,
    @required this.name,
    @required this.level,
    @required this.description,
    @required this.state,
    @required this.createdBy,
    @required this.createdAt,
  });
  String id;
  String readableId;
  String centerId;
  String name;
  String level;
  String description;
  String state;
  Map<String, String> createdBy;
  Timestamp createdAt;

  factory Halaqa.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    String id = data['id'];
    String readableId = data['readableId'];
    String centerId = data['centerId'];
    String name = data['name'];
    String level = data['level'];
    String description = data['description'];
    String state = data['state'];
    Map<String, String> createdBy = Map<String, String>.from(data['createdBy']);
    Timestamp createdAt = data['createdAt'];

    return Halaqa(
      id: id,
      readableId: readableId,
      centerId: centerId,
      name: name,
      level: level,
      description: description,
      state: state,
      createdBy: createdBy,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'readableId': readableId,
      'centerId': centerId,
      'name': name,
      'level': level,
      'description': description,
      'state': state,
      'createdBy': createdBy,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }
}
