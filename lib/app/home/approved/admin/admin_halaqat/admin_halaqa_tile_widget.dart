import 'package:al_halaqat/app/common_forms/admin_form.dart';
import 'package:al_halaqat/app/home/approved/admin/admin_halaqat/admin_halaqat_bloc.dart';
import 'package:al_halaqat/app/home/approved/admin/admin_halaqat/admin_new_halaqa_screen.dart';
import 'package:al_halaqat/app/home/approved/admin/admin_students/admin_new_student_screen.dart';
import 'package:al_halaqat/app/home/approved/admin/admin_students/admin_students_bloc.dart';
import 'package:al_halaqat/app/home/approved/admin/admin_students/admin_students_screen.dart';
import 'package:al_halaqat/app/home/approved/admin/admin_teachers/admin_new_teacher_screen.dart';
import 'package:al_halaqat/app/home/approved/admin/admin_teachers/admin_teacher_bloc.dart';
import 'package:al_halaqat/app/home/approved/common_screens/user_instances/instances_screen.dart';
import 'package:al_halaqat/app/home/approved/globalAdmin/ga_admins/ga_admins_bloc.dart';
import 'package:al_halaqat/app/home/approved/globalAdmin/ga_admins/ga_new_admin_screen.dart';
import 'package:al_halaqat/app/models/admin.dart';
import 'package:al_halaqat/app/models/global_admin.dart';
import 'package:al_halaqat/app/models/halaqa.dart';
import 'package:al_halaqat/app/models/student.dart';
import 'package:al_halaqat/app/models/study_center.dart';
import 'package:al_halaqat/app/models/teacher.dart';
import 'package:al_halaqat/common_widgets/platform_alert_dialog.dart';
import 'package:al_halaqat/common_widgets/platform_exception_alert_dialog.dart';
import 'package:al_halaqat/common_widgets/progress_dialog.dart';
import 'package:al_halaqat/constants/key_translate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdminHalqaTileWidget extends StatefulWidget {
  AdminHalqaTileWidget({
    Key key,
    @required this.halaqa,
    @required this.chosenHalaqaState,
    @required this.bloc,
    @required this.scaffoldKey,
    @required this.chosenCenter,
  }) : super(key: key);

  final Halaqa halaqa;
  final String chosenHalaqaState;
  final AdminHalaqaBloc bloc;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final StudyCenter chosenCenter;

  @override
  _AdminHalqaTileWidgetState createState() => _AdminHalqaTileWidgetState();
}

class _AdminHalqaTileWidgetState extends State<AdminHalqaTileWidget> {
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
          builder: (context) => AdminNewHalaqaScreen(
            bloc: widget.bloc,
            chosenCenter: widget.chosenCenter,
            halaqa: widget.halaqa,
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
          await widget.bloc.executeAction(
            widget.halaqa,
            action,
          );
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
    List<String> actions;
    switch (widget.halaqa.state) {
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
          title: Text(widget.halaqa.name),
          subtitle: Text(widget.halaqa.readableId),
          trailing: widget.halaqa.state == 'deleted'
              ? Container(
                  height: 1,
                  width: 1,
                )
              : _buildAction(),
          enabled: widget.halaqa.state == 'approved' ? true : false,
          onTap: () async => widget.halaqa.state != 'approved'
              ? null
              : await Navigator.of(context, rootNavigator: false).push(
                  MaterialPageRoute(
                    builder: (context) => InstancesScreen.create(
                      context: context,
                      halaqa: widget.halaqa,
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
