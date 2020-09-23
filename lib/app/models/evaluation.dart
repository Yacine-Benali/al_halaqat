import 'package:alhalaqat/app/models/evaluation_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Evaluation {
  Evaluation({
    @required this.id,
    @required this.createdAt,
    @required this.instanceId,
    @required this.studentName,
    @required this.createdBy,
    @required this.memorized,
    @required this.rehearsed,
  });

  String id;
  Timestamp createdAt;
  String instanceId;
  String studentName;
  Map<String, String> createdBy;
  EvaluationHelper memorized;
  EvaluationHelper rehearsed;

  factory Evaluation.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    String id = documentId;
    Timestamp createdAt = data['createdAt'];
    String instanceId = data['instanceId'];
    String studentName = data['studentName'];
    EvaluationHelper memorized = EvaluationHelper.fromMap(data['memorized']);
    EvaluationHelper rehearsed = EvaluationHelper.fromMap(data['rehearsed']);
    Map<String, String> createdBy = Map<String, String>.from(data['createdBy']);

    return Evaluation(
      id: id,
      createdAt: createdAt,
      instanceId: instanceId,
      studentName: studentName,
      memorized: memorized,
      rehearsed: rehearsed,
      createdBy: createdBy,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'instanceId': instanceId,
      'studentName': studentName,
      'createdBy': createdBy,
      'memorized': memorized.toMap(),
      'rehearsed': rehearsed.toMap(),
    };
  }
}
