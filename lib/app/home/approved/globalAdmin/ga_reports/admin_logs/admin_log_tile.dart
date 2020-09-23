import 'package:alhalaqat/app/models/admin_log.dart';
import 'package:alhalaqat/common_widgets/format.dart';
import 'package:alhalaqat/constants/key_translate.dart';
import 'package:flutter/material.dart';

class AdminLogTile extends StatelessWidget {
  const AdminLogTile({Key key, @required this.adminLog}) : super(key: key);

  final AdminLog adminLog;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          getDate +
              ', ' +
              adminLog.admin.name +
              KeyTranslate.logActions[adminLog.action] +
              ' ' +
              KeyTranslate.logObjectNature[adminLog.object.nature] +
              ' ' +
              adminLog.object.name,
        ),
      ),
      subtitle: Text(adminLog.center.name),
    );
  }

  String get getDate =>
      Format.dateWithTime(adminLog.createdAt.toDate() ?? DateTime.now());
}
