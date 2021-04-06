import 'package:alhalaqat/app/home/approved/admin/admin_teachers/teacher_profile/a_t_new_center_attendance_screen.dart';
import 'package:alhalaqat/app/home/approved/admin/admin_teachers/teacher_profile/a_teacher_profile_bloc.dart';
import 'package:alhalaqat/app/models/teacher_center_attendance.dart';
import 'package:alhalaqat/common_widgets/firebase_exception_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/format.dart';
import 'package:alhalaqat/common_widgets/platform_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/platform_exception_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/progress_dialog.dart';
import 'package:alhalaqat/constants/key_translate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ATCenterAttendanceTile extends StatefulWidget {
  ATCenterAttendanceTile({
    Key key,
    @required this.teacherCenterAttendance,
    @required this.bloc,
    @required this.scaffoldKey,
  }) : super(key: key);

  final TeacherCenterAttendance teacherCenterAttendance;
  final ATeacherProfileBloc bloc;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  _ATCenterAttendanceTileState createState() => _ATCenterAttendanceTileState();
}

class _ATCenterAttendanceTileState extends State<ATCenterAttendanceTile> {
  ProgressDialog pr;
  String subtitle1;
  @override
  void initState() {
    pr = ProgressDialog(
      widget.scaffoldKey.currentContext,
      type: ProgressDialogType.Normal,
      textDirection: TextDirection.ltr,
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

  Future<void> _executeAction(String action) async {
    final bool didRequestSignOut = await PlatformAlertDialog(
      title: KeyTranslate.actionsList[action],
      content: 'هل أنت متأكد ؟',
      cancelActionText: 'إلغاء',
      defaultActionText: 'حسنا',
    ).show(widget.scaffoldKey.currentContext);
    if (didRequestSignOut == true) {
      try {
        await pr.show();
        await widget.bloc.executeAction(widget.teacherCenterAttendance, action);
        await pr.hide();
        PlatformAlertDialog(
          title: 'نجحت العملية',
          content: 'تمت العملية بنجاح',
          defaultActionText: 'حسنا',
        ).show(widget.scaffoldKey.currentContext);
      } catch (e) {
        await pr.hide();
        if (e is PlatformException) {
          PlatformExceptionAlertDialog(
            title: 'فشلت العملية',
            exception: e,
          ).show(widget.scaffoldKey.currentContext);
        } else if (e is FirebaseException)
          FirebaseExceptionAlertDialog(
            title: 'فشلت العملية',
            exception: e,
          ).show(widget.scaffoldKey.currentContext);
        else
          PlatformAlertDialog(
            title: 'فشلت العملية',
            content: 'فشلت العملية',
            defaultActionText: 'حسنا',
          ).show(widget.scaffoldKey.currentContext);
      }
    }
  }

  Widget _buildAction() {
    List<String> actions;

    actions = ['delete'];

    return PopupMenuButton<String>(
      itemBuilder: (BuildContext context) => List.generate(
        actions.length,
        (i) {
          return PopupMenuItem<String>(
            value: actions[i],
            child: Text(KeyTranslate.actionsList[actions[i]]),
          );
        },
      ),
      onSelected: (value) => _executeAction(value),
    );
  }

  @override
  Widget build(BuildContext context) {
    subtitle1 =
        'من${widget.teacherCenterAttendance.timeIn.format(context)} إلى${widget.teacherCenterAttendance.timeOut.format(context)}';

    return ListTile(
      title: Text(Format.date(widget.teacherCenterAttendance.date.toDate())),
      subtitle: Text(subtitle1),
      onTap: () {
        Navigator.of(context, rootNavigator: false).push(
          MaterialPageRoute(
            builder: (context) => ATNewCenterAttendance(
              bloc: widget.bloc,
              teacherCenterAttendance: widget.teacherCenterAttendance,
            ),
            fullscreenDialog: true,
          ),
        );
      },
      trailing: _buildAction(),
    );
  }
}
