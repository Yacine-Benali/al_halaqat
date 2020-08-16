import 'package:flutter/foundation.dart';

class StudentsAttendanceSummery {
  StudentsAttendanceSummery({
    @required this.present,
    @required this.latee,
    @required this.absent,
    @required this.absentWithExecuse,
  });
  String present;
  String latee;
  String absent;
  String absentWithExecuse;

  factory StudentsAttendanceSummery.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    String present = data['present'];
    String latee = data['latee'];
    String absent = data['absent'];
    String absentWithExecuse = data['absentWithExecuse'];

    return StudentsAttendanceSummery(
      present: present,
      latee: latee,
      absent: absent,
      absentWithExecuse: absentWithExecuse,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'present': present,
      'latee': latee,
      'absent': absent,
      'absentWithExecuse': absentWithExecuse,
    };
  }
}
