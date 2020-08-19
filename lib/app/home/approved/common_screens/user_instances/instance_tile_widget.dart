import 'dart:math';

import 'package:al_halaqat/app/home/approved/common_screens/user_instances/attendance/attendance_screen.dart';
import 'package:al_halaqat/app/home/approved/common_screens/user_instances/intances_bloc.dart';
import 'package:al_halaqat/app/models/instance.dart';
import 'package:al_halaqat/app/models/study_center.dart';
import 'package:al_halaqat/common_widgets/platform_alert_dialog.dart';
import 'package:al_halaqat/common_widgets/platform_exception_alert_dialog.dart';
import 'package:al_halaqat/common_widgets/progress_dialog.dart';
import 'package:al_halaqat/constants/key_translate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' as intl;

class InstanceTileWidget extends StatefulWidget {
  InstanceTileWidget({
    Key key,
    @required this.bloc,
    @required this.instance,
    @required this.scaffoldKey,
    @required this.index,
  }) : super(key: key);

  final Instance instance;
  final InstancesBloc bloc;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final int index;

  @override
  _InstanceTileWidgetState createState() => _InstanceTileWidgetState();
}

class _InstanceTileWidgetState extends State<InstanceTileWidget> {
  ProgressDialog pr;
  String newNote;

  @override
  initState() {
    newNote = '';
    pr = ProgressDialog(
      widget.scaffoldKey.currentContext,
      type: ProgressDialogType.Normal,
      textDirection: TextDirection.rtl,
      isDismissible: false,
    );
    pr.style(
      message: 'جاري تحميل',
      messageTextStyle: TextStyle(fontSize: 14),
      progressWidget: Container(
        padding: EdgeInsets.all(8.0),
        child: CircularProgressIndicator(),
      ),
    );
    super.initState();
  }

  Future<void> _showDialog() async {
    bool isConfirm = await showDialog<bool>(
      context: context,
      child: AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: Row(
          children: <Widget>[
            Expanded(
              child: TextFormField(
                maxLength: 100,
                initialValue: widget.instance.note,
                onChanged: (value) => newNote = value,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'ملاحظة',
                  hintText: 'ملاحظة',
                  counter: Text(''),
                ),
              ),
            )
          ],
        ),
        actions: <Widget>[
          FlatButton(
            child: const Text('إلغاء'),
            onPressed: () =>
                Navigator.of(context, rootNavigator: true).pop(false),
          ),
          FlatButton(
            child: const Text('حفظ'),
            onPressed: () =>
                Navigator.of(context, rootNavigator: true).pop(true),
          ),
        ],
      ),
    );
    if (isConfirm && widget.instance.note.toString() != newNote) {
      widget.instance.note = newNote;
      try {
        await pr.show();
        await widget.bloc.setInstance(widget.instance);
        await Future.delayed(Duration(milliseconds: 500));
        await pr.hide();
        PlatformAlertDialog(
          title: 'نجحت العملية',
          content: 'تمت العملية بنجاح',
          defaultActionText: 'حسنا',
        ).show(widget.scaffoldKey.currentContext);
      } on PlatformException catch (e) {
        await pr.hide();
        PlatformExceptionAlertDialog(
          title: 'فشلت العملية',
          exception: e,
        ).show(widget.scaffoldKey.currentContext);
      }
    }
  }

  Future<void> _executeAction(String action) async {
    if (action == 'note') {
      await _showDialog();
    } else {
      final bool didRequestSignOut = await PlatformAlertDialog(
        title: KeyTranslate.instanceActions[action],
        content: 'هل أنت متأكد ؟',
        cancelActionText: 'إلغاء',
        defaultActionText: 'حسنا',
      ).show(widget.scaffoldKey.currentContext);
      if (didRequestSignOut == true) {
        try {
          await pr.show();
          await widget.bloc.deleteInstance(widget.instance);
          await pr.hide();
          PlatformAlertDialog(
            title: 'نجحت العملية',
            content: 'تمت العملية بنجاح',
            defaultActionText: 'حسنا',
          ).show(widget.scaffoldKey.currentContext);
        } on PlatformException catch (e) {
          await pr.hide();
          PlatformExceptionAlertDialog(
            title: 'فشلت العملية',
            exception: e,
          ).show(widget.scaffoldKey.currentContext);
        }
      }
    }
  }

  Widget _buildAction() {
    List<String> actions = KeyTranslate.instanceActions.keys.toList();
    return PopupMenuButton<String>(
      itemBuilder: (BuildContext context) => List.generate(
        actions.length,
        (i) {
          return PopupMenuItem<String>(
            value: actions[i],
            child: Text(KeyTranslate.instanceActions[actions[i]]),
          );
        },
      ),
      onSelected: (value) => _executeAction(value),
    );
  }

  String getTitle() {
    DateTime createdAt2 =
        widget.instance.createdAt?.toDate()?.toLocal() ?? DateTime.now();
    String dateString = intl.DateFormat.yMMMEd('ar').format(createdAt2);
    return dateString;
  }

  String getSubtitles() {
    int present = widget.instance.studentAttendanceSummery.present ?? 0;
    int latee = widget.instance.studentAttendanceSummery.latee ?? 0;
    int absentWithExecuse =
        widget.instance.studentAttendanceSummery.absentWithExecuse ?? 0;
    int absent = widget.instance.studentAttendanceSummery.absent ?? 0;

    String one = '${KeyTranslate.attendanceState['present']} ($present) ';
    String two = '  ${KeyTranslate.attendanceState['latee']} ($latee) ';
    String three =
        '${KeyTranslate.attendanceState['absentWithExecuse']} ($absentWithExecuse) ';
    String four = '${KeyTranslate.attendanceState['absent']} ($absent) ';
    return one + two + three + four;
    //that ten quick maths
  }

  List colors = [Colors.red, Colors.green, Colors.yellow];
  Random random = Random();
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(getTitle()),
      // title: Text(widget.instance.createdAt.toDate().toIso8601String()),
      subtitle: Text(getSubtitles()),
      trailing: _buildAction(),

      onTap: () => Navigator.of(context, rootNavigator: false).push(
        MaterialPageRoute(
          builder: (context) => AttendanceScreen.create(
            context: context,
            instance: widget.instance,
          ),
          fullscreenDialog: true,
        ),
      ),
    );
  }
}
