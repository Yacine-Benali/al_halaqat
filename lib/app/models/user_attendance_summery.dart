import 'package:flutter/foundation.dart';

class UsersAttendanceSummery {
  UsersAttendanceSummery({
    @required this.id,
    @required this.name,
    @required this.present,
    @required this.latee,
    @required this.absent,
    @required this.absentWithExecuse,
  });
  String name;
  String id;
  double present;
  double latee;
  double absent;
  double absentWithExecuse;
}
