import 'package:al_halaqat/app/models/teacher_log.dart';
import 'package:al_halaqat/common_widgets/format.dart';
import 'package:al_halaqat/constants/key_translate.dart';
import 'package:flutter/material.dart';

class CenterLogTile extends StatelessWidget {
  const CenterLogTile({Key key, @required this.teacherLog}) : super(key: key);

  final TeacherLog teacherLog;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          getDate +
              ', ' +
              teacherLog.teacher.name +
              ' ' +
              KeyTranslate.logActions[teacherLog.action] +
              ' ' +
              KeyTranslate.logObjectNature[teacherLog.object.nature] +
              ' ' +
              teacherLog.object.name,
        ),
      ),
    );
  }

  String get getDate =>
      Format.dateWithTime(teacherLog.createdAt.toDate() ?? DateTime.now());
}
