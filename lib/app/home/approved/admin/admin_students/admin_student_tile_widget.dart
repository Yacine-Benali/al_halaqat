import 'package:alhalaqat/app/home/approved/admin/admin_students/admin_students_bloc.dart';
import 'package:alhalaqat/app/home/approved/common_screens/student_profile/student_profile_screen.dart';
import 'package:alhalaqat/app/models/halaqa.dart';
import 'package:alhalaqat/app/models/quran.dart';
import 'package:alhalaqat/app/models/student.dart';
import 'package:alhalaqat/app/models/study_center.dart';
import 'package:alhalaqat/common_widgets/firebase_exception_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/platform_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/platform_exception_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/progress_dialog.dart';
import 'package:alhalaqat/constants/key_translate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'admin_new_student_screen.dart';

class AdminStudentTileWidget extends StatefulWidget {
  AdminStudentTileWidget({
    Key key,
    @required this.student,
    @required this.chosenStudentState,
    @required this.bloc,
    @required this.scaffoldKey,
    @required this.chosenCenter,
    @required this.halaqatList,
    @required this.quran,
  }) : super(key: key);

  final Student student;
  final String chosenStudentState;
  final AdminStudentsBloc bloc;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final StudyCenter chosenCenter;
  final List<Halaqa> halaqatList;
  final Quran quran;

  @override
  _AdminStudentTileWidgetState createState() => _AdminStudentTileWidgetState();
}

class _AdminStudentTileWidgetState extends State<AdminStudentTileWidget> {
  ProgressDialog pr;

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
    if (action == 'edit') {
      await Navigator.of(context, rootNavigator: false).push(
        MaterialPageRoute(
          builder: (context) => AdminNewStudentScreen(
            bloc: widget.bloc,
            student: widget.student,
            chosenCenter: widget.chosenCenter,
            halaqatList: widget.halaqatList,
          ),
          fullscreenDialog: true,
        ),
      );
    } else {
      final bool didRequestSignOut = await PlatformAlertDialog(
        title: KeyTranslate.centersActionsList[action],
        content: 'هل أنت متأكد ؟',
        cancelActionText: 'إلغاء',
        defaultActionText: 'حسنا',
      ).show(widget.scaffoldKey.currentContext);
      if (didRequestSignOut == true) {
        try {
          await pr.show();
          await widget.bloc
              .executeAction(widget.student, action, widget.chosenCenter);
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
  }

  Widget _buildAction() {
    List<String> actions;
    switch (widget.student.state) {
      case 'approved':
        actions = ['edit', 'archive', 'delete'];
        break;
      case 'archived':
        actions = ['reApprove'];
        break;
      case 'deleted':
        actions = [];
        break;
    }
    return PopupMenuButton<String>(
      itemBuilder: (BuildContext context) => List.generate(
        actions.length,
        (i) {
          return PopupMenuItem<String>(
            value: actions[i],
            child: Text(KeyTranslate.centersActionsList[actions[i]]),
          );
        },
      ),
      onSelected: (value) => _executeAction(value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(widget.student.name),
          subtitle: Text(widget.student.readableId),
          trailing: widget.student.state == 'deleted'
              ? Container(
                  height: 1,
                  width: 1,
                )
              : _buildAction(),
          enabled: widget.student.state == 'approved' ? true : false,
          onTap: () => Navigator.of(context, rootNavigator: false).push(
            MaterialPageRoute(
              builder: (context) => StudentProfileScreen.create(
                context: context,
                halaqatList: widget.halaqatList,
                student: widget.student,
                quran: widget.quran,
                studentRoaming: true,
              ),
              fullscreenDialog: true,
            ),
          ),
        ),
        Divider(
          height: 0.5,
        )
      ],
    );
  }
}
