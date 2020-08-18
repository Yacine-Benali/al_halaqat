import 'package:al_halaqat/app/models/student_attendance.dart';
import 'package:al_halaqat/app/models/students_attendance_summery.dart';
import 'package:al_halaqat/app/models/teacher_summery.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Instance {
  Instance({
    @required this.id,
    @required this.halaqaName,
    @required this.halaqaId,
    @required this.centerId,
    @required this.createdAt,
    @required this.note,
    @required this.createdBy,
    @required this.teacherSummery,
    @required this.studentAttendanceSummery,
    @required this.studentAttendanceList,
    @required this.studentIdsList,
  });
  String id;
  String halaqaName;
  String halaqaId;
  String centerId;
  Timestamp createdAt;
  String note;
  Map<String, String> createdBy;
  TeacherSummery teacherSummery;
  StudentsAttendanceSummery studentAttendanceSummery;
  List<StudentAttendance> studentAttendanceList;
  List<String> studentIdsList;

  factory Instance.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    String id = documentId;
    String halaqaName = data['halaqaName'];
    String halaqaId = data['halaqaId'];
    String centerId = data['centerId'];
    Timestamp createdAt = data['createdAt'];
    String note = data['note'];
    Map<String, String> createdBy = Map<String, String>.from(data['createdBy']);
    TeacherSummery teacherSummery =
        TeacherSummery.fromMap(data['teacherSummery']);
    StudentsAttendanceSummery studentAttendanceSummery =
        StudentsAttendanceSummery.fromMap(data['studentAttendanceSummery']);

    //! this is a fix for
    //! iterator was called on null
    List<dynamic> temp = data['studentAttendanceList']?.toList();
    List<StudentAttendance> studentAttendanceList = List();
    int j = temp?.length ?? 0;
    for (int i = 0; i < j; i++) {
      studentAttendanceList.add(StudentAttendance.fromMap(temp[i]));
    }

    List<String> studentIdsList = data['studentIdsList'].cast<String>();

    return Instance(
      id: id,
      halaqaName: halaqaName,
      halaqaId: halaqaId,
      centerId: centerId,
      createdAt: createdAt,
      note: note,
      createdBy: createdBy,
      teacherSummery: teacherSummery,
      studentAttendanceSummery: studentAttendanceSummery,
      studentAttendanceList: studentAttendanceList,
      studentIdsList: studentIdsList,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'halaqaName': halaqaName,
      'halaqaId': halaqaId,
      'centerId': centerId,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'note': note,
      'createdBy': createdBy,
      'teacherSummery': teacherSummery?.toMap(),
      'studentAttendanceSummery': studentAttendanceSummery?.toMap(),
      'studentAttendanceList':
          studentAttendanceList?.map((e) => e?.toMap())?.toList(),
      'studentIdsList': studentIdsList,
    };
  }
}
