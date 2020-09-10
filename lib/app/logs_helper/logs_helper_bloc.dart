import 'package:al_halaqat/app/logs_helper/logs_helper_provider.dart';
import 'package:al_halaqat/app/models/conversation_user.dart';
import 'package:al_halaqat/app/models/halaqa.dart';
import 'package:al_halaqat/app/models/instance.dart';
import 'package:al_halaqat/app/models/log_object.dart';
import 'package:al_halaqat/app/models/student.dart';
import 'package:al_halaqat/app/models/teacher.dart';
import 'package:al_halaqat/app/models/teacher_log.dart';

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
      nature: 'student',
    );

    TeacherLog teacherLog = TeacherLog(
      createdAt: null,
      teacher: ConversationUser.fromUser(teacher),
      action: _getAction(action),
      object: logObject,
    );
    return await provider.createCenterLog(teacherLog, student.center);
  }
}
