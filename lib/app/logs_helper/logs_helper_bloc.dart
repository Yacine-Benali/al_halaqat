import 'package:alhalaqat/app/logs_helper/logs_helper_provider.dart';
import 'package:alhalaqat/app/models/admin.dart';
import 'package:alhalaqat/app/models/admin_log.dart';
import 'package:alhalaqat/app/models/conversation_user.dart';
import 'package:alhalaqat/app/models/halaqa.dart';
import 'package:alhalaqat/app/models/instance.dart';
import 'package:alhalaqat/app/models/log_object.dart';
import 'package:alhalaqat/app/models/mini_center.dart';
import 'package:alhalaqat/app/models/student.dart';
import 'package:alhalaqat/app/models/study_center.dart';
import 'package:alhalaqat/app/models/teacher.dart';
import 'package:alhalaqat/app/models/teacher_log.dart';
import 'package:alhalaqat/app/models/user.dart';

enum ObjectAction { add, edit, delete }
enum Nature {
  maleStudent,
  femaleStudnet,
  maleTeacher,
  femaleTeacher,
  halaqa,
  instance
}

class LogsHelperBloc {
  LogsHelperBloc({this.provider});
  LogsHelperProvider provider;

  String _getAction(ObjectAction action) {
    switch (action) {
      case ObjectAction.add:
        return 'add';
        break;
      case ObjectAction.edit:
        return 'edit';
        break;
      case ObjectAction.delete:
        return 'delete';
        break;
      default:
        return '';
    }
  }

  String getUserNature(User user) {
    if (user is Student) {
      if (user.gender == 'ذكر')
        return 'maleStudent';
      else
        return 'femaleStudent';
    } else if (user is Teacher) {
      if (user.gender == 'ذكر')
        return 'maleTeacher';
      else
        return 'femaleTeacher';
    } else
      return '';
  }

  Future<void> teacherHalaqaLog(
    Teacher teacher,
    Halaqa halaqa,
    ObjectAction action,
  ) async {
    LogObject logObject = LogObject(
      name: halaqa.name,
      id: halaqa.id,
      nature: 'halaqa',
    );

    TeacherLog teacherLog = TeacherLog(
      id: '',
      createdAt: null,
      teacher: ConversationUser.fromUser(teacher),
      action: _getAction(action),
      object: logObject,
    );
    return await provider.createCenterLog(teacherLog, halaqa.centerId);
  }

  Future<void> teacherInstanceLog(
    Teacher teacher,
    Instance instance,
    ObjectAction action,
  ) async {
    LogObject logObject = LogObject(
      name: instance.halaqaName,
      id: instance.halaqaId,
      nature: 'instance',
    );

    TeacherLog teacherLog = TeacherLog(
      id: '',
      createdAt: null,
      teacher: ConversationUser.fromUser(teacher),
      action: _getAction(action),
      object: logObject,
    );
    return await provider.createCenterLog(teacherLog, instance.centerId);
  }

  Future<void> teacherStudentLog(
    Teacher teacher,
    Student student,
    ObjectAction action,
  ) async {
    LogObject logObject = LogObject(
      name: student.name,
      id: student.id,
      nature: getUserNature(student),
    );

    TeacherLog teacherLog = TeacherLog(
      id: '',
      createdAt: null,
      teacher: ConversationUser.fromUser(teacher),
      action: _getAction(action),
      object: logObject,
    );
    return await provider.createCenterLog(teacherLog, student.center);
  }

  Future<void> adminHalaqaLog(
    User admin,
    Halaqa halaqa,
    ObjectAction action,
    StudyCenter center,
  ) async {
    if (!(admin is Admin)) return;
    LogObject logObject = LogObject(
      name: halaqa.name,
      id: halaqa.id,
      nature: 'halaqa',
    );

    AdminLog adminLog = AdminLog(
      id: '',
      createdAt: null,
      admin: ConversationUser.fromUser(admin),
      action: _getAction(action),
      object: logObject,
      center: MiniCenter.fromCenter(center),
    );
    return await provider.createAdminLog(adminLog);
  }

  Future<void> adminInstanceLog(
    User admin,
    Instance instance,
    ObjectAction action,
    StudyCenter center,
  ) async {
    if (!(admin is Admin)) return;

    LogObject logObject = LogObject(
      name: instance.halaqaName,
      id: instance.halaqaId,
      nature: 'instance',
    );

    AdminLog adminLog = AdminLog(
      id: '',
      createdAt: null,
      admin: ConversationUser.fromUser(admin),
      action: _getAction(action),
      object: logObject,
      center: MiniCenter.fromCenter(center),
    );
    return await provider.createAdminLog(adminLog);
  }

  Future<void> adminStudentLog(
    User admin,
    Student student,
    ObjectAction action,
    StudyCenter center,
  ) async {
    if (!(admin is Admin)) return;

    LogObject logObject = LogObject(
      name: student.name,
      id: student.id,
      nature: getUserNature(student),
    );

    AdminLog adminLog = AdminLog(
      id: '',
      createdAt: null,
      admin: ConversationUser.fromUser(admin),
      action: _getAction(action),
      object: logObject,
      center: MiniCenter.fromCenter(center),
    );
    return await provider.createAdminLog(adminLog);
  }

  Future<void> adminTeacherLog(
    User admin,
    Teacher teacher,
    ObjectAction action,
    StudyCenter center,
  ) async {
    if (!(admin is Admin)) return;

    LogObject logObject = LogObject(
      name: teacher.name,
      id: teacher.id,
      nature: getUserNature(teacher),
    );

    AdminLog adminLog = AdminLog(
      id: '',
      createdAt: null,
      admin: ConversationUser.fromUser(admin),
      action: _getAction(action),
      object: logObject,
      center: MiniCenter.fromCenter(center),
    );
    return await provider.createAdminLog(adminLog);
  }
}
