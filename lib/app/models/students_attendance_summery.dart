import 'package:flutter/foundation.dart';

class StudentsAttendanceSummery {
  StudentsAttendanceSummery({
    @required this.present,
    @required this.latee,
    @required this.absent,
    @required this.absentWithExecuse,
  });
  int present;
  int latee;
  int absent;
  int absentWithExecuse;

  factory StudentsAttendanceSummery.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    int present = data['present'];
    int latee = data['latee'];
    int absent = data['absent'];
    int absentWithExecuse = data['absentWithExecuse'];

    return StudentsAttendanceSummery(
      present: present,
      latee: latee,
      absent: absent,
      absentWithExecuse: absentWithExecuse,
    );
  }

  Map<String, int> toMap() {
    return {
      'present': present,
      'latee': latee,
      'absent': absent,
      'absentWithExecuse': absentWithExecuse,
    };
  }
}
