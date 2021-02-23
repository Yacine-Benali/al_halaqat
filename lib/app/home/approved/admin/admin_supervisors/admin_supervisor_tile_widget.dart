import 'package:alhalaqat/app/home/approved/admin/admin_supervisors/admin_new_supervisor_screen.dart';
import 'package:alhalaqat/app/home/approved/admin/admin_supervisors/admin_supervisors_bloc.dart';
import 'package:alhalaqat/app/models/halaqa.dart';
import 'package:alhalaqat/app/models/study_center.dart';
import 'package:alhalaqat/app/models/supervisor.dart';
import 'package:alhalaqat/common_widgets/firebase_exception_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/platform_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/platform_exception_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/progress_dialog.dart';
import 'package:alhalaqat/constants/key_translate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdminSupervisorTileWidget extends StatefulWidget {
  AdminSupervisorTileWidget({
    Key key,
    @required this.supervisor,
    @required this.chosenSupervisorState,
    @required this.bloc,
    @required this.scaffoldKey,
    @required this.chosenCenter,
    @required this.halaqatList,
  }) : super(key: key);

  final Supervisor supervisor;
  final String chosenSupervisorState;
  final AdminSupervisorsBloc bloc;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final StudyCenter chosenCenter;
  final List<Halaqa> halaqatList;

  @override
  _AdminSupervisorTileWidgetState createState() =>
      _AdminSupervisorTileWidgetState();
}

class _AdminSupervisorTileWidgetState extends State<AdminSupervisorTileWidget> {
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
          builder: (context) => AdminNewSupervisorScreen(
            bloc: widget.bloc,
            chosenCenter: widget.chosenCenter,
            supervisor: widget.supervisor,
            halaqatList: widget.halaqatList,
            isEnabled: true,
          ),
          fullscreenDialog: true,
        ),
      );
    } else {
      final bool didRequestSignOut = await PlatformAlertDialog(
        title: KeyTranslate.actionsList[action],
        content: 'هل أنت متأكد ؟',
        cancelActionText: 'إلغاء',
        defaultActionText: 'حسنا',
      ).show(widget.scaffoldKey.currentContext);
      if (didRequestSignOut == true) {
        try {
          await pr.show();
          await widget.bloc.executeAction(
            widget.supervisor,
            action,
            widget.chosenCenter,
          );
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
            ).show(context);
          } else if (e is FirebaseException)
            FirebaseExceptionAlertDialog(
              title: 'فشلت العملية',
              exception: e,
            ).show(context);
          else
            PlatformAlertDialog(
              title: 'فشلت العملية',
              content: 'فشلت العملية',
              defaultActionText: 'حسنا',
            ).show(context);
        }
      }
    }
  }

  Widget _buildAction() {
    List<String> actions;
    switch (widget.supervisor.centerState[widget.chosenCenter.id]) {
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
            child: Text(KeyTranslate.actionsList[actions[i]]),
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
          title: Text(widget.supervisor.name),
          subtitle: Text(widget.supervisor.readableId),
          trailing:
              widget.supervisor.centerState[widget.chosenCenter.id] == 'deleted'
                  ? Container(
                      height: 1,
                      width: 1,
                    )
                  : _buildAction(),
          enabled: widget.supervisor.centerState[widget.chosenCenter.id] ==
                  'approved'
              ? true
              : false,
          onTap: widget.supervisor.centerState[widget.chosenCenter.id] !=
                  'approved'
              ? null
              : () => Navigator.of(context, rootNavigator: false).push(
                    MaterialPageRoute(
                      builder: (context) => AdminNewSupervisorScreen(
                        bloc: widget.bloc,
                        chosenCenter: widget.chosenCenter,
                        supervisor: widget.supervisor,
                        halaqatList: widget.halaqatList,
                        isEnabled: false,
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
