import 'package:al_halaqat/app/home/approved/common_screens/user_instances/attendance/attendance_provider.dart';
import 'package:al_halaqat/app/models/instance.dart';
import 'package:al_halaqat/app/models/quran.dart';
import 'package:al_halaqat/app/models/student.dart';
import 'package:al_halaqat/app/models/student_attendance.dart';
import 'package:al_halaqat/app/models/students_attendance_summery.dart';
import 'package:al_halaqat/app/models/teacher.dart';
import 'package:al_halaqat/app/models/user.dart';
import 'package:al_halaqat/constants/key_translate.dart';
import 'package:flutter/foundation.dart';

class AttendanceBloc {
  AttendanceBloc({
    @required this.provider,
    @required this.instance,
    @required this.user,
  });
  final AttendanceProvider provider;
  final Instance instance;
  final User user;

  Future<Quran> fetchQuran() async => await provider.fetchQuran();
  List<String> getColumnTitle() {
    List<String> columnTitleList = List();
    columnTitleList.add('إسم');
    columnTitleList.addAll(KeyTranslate.attendanceState.values);
    columnTitleList.addAll([
      'ملاحظة',
      'تقييم',
    ]);
    return columnTitleList;
  }

  Future<Instance> fetchInstance() async {
    bool temp = instance.studentAttendanceList == null;
    if (!temp) {
      if (instance.studentAttendanceList.length == 0) temp = true;
    }

    Instance newInstance = getNewInstance();
    if (temp) {
      print(instance.halaqaId);
      Teacher halaqaTeacher =
          await provider.fetchHalaqaTeacher(instance.halaqaId);

      List<Student> studentsList =
          await provider.fetchHalaqaStudents(instance.halaqaId);

      // setting teacher info
      try {
        newInstance.teacherSummery.id = halaqaTeacher.id;
        newInstance.teacherSummery.name = halaqaTeacher.name;
      } catch (_) {
        newInstance.teacherSummery.id = user.id;
        newInstance.teacherSummery.name = user.name;
      }

      //setting current students info
      List<StudentAttendance> studentAttendaceList = List();

      for (Student student in studentsList) {
        StudentAttendance temp = StudentAttendance(
          id: student.id,
          name: student.name,
          state: null,
          note: null,
        );
        studentAttendaceList.add(temp);
      }
      newInstance.studentAttendanceList = studentAttendaceList;
      return newInstance;
    }
    return newInstance;
  }

  // Future<void> setInstance(Instance instance) async => await database.setData(
  //       path: APIPath.instanceDocument(instance.id),
  //       data: instance.toMap(),
  //       merge: true,
  //     );

  Instance getNewInstance() {
    return Instance(
      id: this.instance.id,
      halaqaName: this.instance.halaqaName,
      halaqaId: this.instance.halaqaId,
      centerId: this.instance.centerId,
      createdAt: this.instance.createdAt,
      note: this.instance.note,
      createdBy: this.instance.createdBy,
      teacherSummery: this.instance.teacherSummery,
      studentAttendanceSummery: this.instance.studentAttendanceSummery,
      studentAttendanceList: this.instance.studentAttendanceList,
      studentIdsList: this.instance.studentIdsList,
    );
  }

  Future<void> saveInstance(Instance instance) async {
    int present = 0;
    int latee = 0;
    int absent = 0;
    int absentWithExecuse = 0;
    List<String> studentsIds = List();
    for (StudentAttendance studentAttendance
        in instance.studentAttendanceList) {
      studentsIds.add(studentAttendance.id);
      switch (studentAttendance.state) {
        case 'present':
          present++;
          break;
        case 'latee':
          latee++;
          break;
        case 'absent':
          absent++;
          break;
        case 'absentWithExecuse':
          absentWithExecuse++;
          break;
      }
    }
    StudentsAttendanceSummery summery = StudentsAttendanceSummery(
      present: present,
      latee: latee,
      absent: absent,
      absentWithExecuse: absentWithExecuse,
    );
    instance.studentIdsList = studentsIds;
    instance.studentAttendanceSummery = summery;
    await provider.setInstance(instance);
  }
}
