import 'package:flutter/foundation.dart';

class TeacherSummery {
  TeacherSummery({
    @required this.id,
    @required this.name,
    @required this.state,
    @required this.note,
  });
  String id;
  String name;
  String state;
  String note;

  factory TeacherSummery.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    String id = data['id'];
    String name = data['name'];
    String state = data['state'];
    String note = data['note'];

    return TeacherSummery(
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
