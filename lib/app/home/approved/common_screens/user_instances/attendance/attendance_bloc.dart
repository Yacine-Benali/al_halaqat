import 'package:alhalaqat/app/home/approved/common_screens/user_instances/attendance/attendance_provider.dart';
import 'package:alhalaqat/app/models/instance.dart';
import 'package:alhalaqat/app/models/local_attendance_summery.dart';
import 'package:alhalaqat/app/models/quran.dart';
import 'package:alhalaqat/app/models/student.dart';
import 'package:alhalaqat/app/models/student_attendance.dart';
import 'package:alhalaqat/app/models/students_attendance_summery.dart';
import 'package:alhalaqat/app/models/teacher.dart';
import 'package:alhalaqat/app/models/user.dart';
import 'package:alhalaqat/constants/key_translate.dart';
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
  List<Student> gStudentsList;

  LocalAttendanceSummery getStudentAttendanceSummery(
      List<StudentAttendance> studentAttendanceList) {
    List<String> attendanceState = KeyTranslate.attendanceState.keys.toList();
    LocalAttendanceSummery summery = LocalAttendanceSummery();

    for (StudentAttendance attendance in studentAttendanceList) {
      if (attendance.state == attendanceState[0]) {
        summery.present++;
      } else if (attendance.state == attendanceState[1]) {
        summery.latee++;
      } else if (attendance.state == attendanceState[2]) {
        summery.absent++;
      } else if (attendance.state == attendanceState[3]) {
        summery.absentWithExecuse++;
      }
    }
    return summery;
  }

  Future<Quran> fetchQuran() async => await provider.fetchQuran();
  List<String> getColumnTitle() {
    List<String> columnTitleList = List();
    columnTitleList.add('الاسم');
    columnTitleList.addAll(KeyTranslate.attendanceState.values);

    if (!(user is Student)) {
      columnTitleList.addAll([
        'ملاحظة',
        'تقييم',
      ]);
    } else {
      columnTitleList.addAll([
        'ملاحظة',
      ]);
    }

    return columnTitleList;
  }

  Future<Instance> fetchInstance() async {
    bool temp = instance.studentAttendanceList == null;
    if (!temp) {
      if (instance.studentAttendanceList.length == 0) temp = true;
    }

    Instance newInstance = getNewInstance();
    if (temp) {
      Teacher halaqaTeacher =
          await provider.fetchHalaqaTeacher(instance.halaqaId);

      List<Student> studentsList =
          await provider.fetchHalaqaStudents(instance.halaqaId);
      this.gStudentsList = studentsList;

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

  Student getStudentFromId(String studentId) {
    Student student =
        gStudentsList.firstWhere((element) => element.id == studentId);
    return student;
  }
}
