import 'package:flutter/foundation.dart';

class StudentAttendance {
  StudentAttendance({
    @required this.id,
    @required this.name,
    @required this.state,
    @required this.note,
  });
  String id;
  String name;
  String state;
  String note;

  factory StudentAttendance.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    String id = data['id'];
    String name = data['name'];
    String state = data['state'];
    String note = data['note'];

    return StudentAttendance(
      id: id,
      name: name,
      state: state,
      note: note,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'state': state,
      'note': note,
    };
  }
}
