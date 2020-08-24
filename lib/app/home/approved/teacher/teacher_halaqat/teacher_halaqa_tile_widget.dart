import 'package:al_halaqat/app/home/approved/admin/admin_halaqat/admin_new_halaqa_screen.dart';
import 'package:al_halaqat/app/home/approved/common_screens/user_instances/instances_screen.dart';
import 'package:al_halaqat/app/home/approved/teacher/teacher_halaqat/teacher_halaqat_bloc.dart';
import 'package:al_halaqat/app/models/halaqa.dart';
import 'package:al_halaqat/app/models/study_center.dart';
import 'package:al_halaqat/common_widgets/platform_alert_dialog.dart';
import 'package:al_halaqat/common_widgets/platform_exception_alert_dialog.dart';
import 'package:al_halaqat/common_widgets/progress_dialog.dart';
import 'package:al_halaqat/constants/key_translate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TeacherHalqaTileWidget extends StatefulWidget {
  TeacherHalqaTileWidget({
    Key key,
    @required this.halaqa,
    @required this.bloc,
    @required this.chosenCenter,
  }) : super(key: key);

  final Halaqa halaqa;
  final TeacherHalaqaBloc bloc;
  final StudyCenter chosenCenter;

  @override
  _TeacherHalqaTileWidgetState createState() => _TeacherHalqaTileWidgetState();
}

class _TeacherHalqaTileWidgetState extends State<TeacherHalqaTileWidget> {
  Future<void> _executeAction(String action) async {
    if (action == 'edit') {
      // await Navigator.of(context, rootNavigator: false).push(
      //   MaterialPageRoute(
      //     builder: (context) => AdminNewHalaqaScreen(
      //       bloc: widget.bloc,
      //       chosenCenter: widget.chosenCenter,
      //       halaqa: widget.halaqa,
      //     ),
      //     fullscreenDialog: true,
      //   ),
      // );
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
    actions = ['edit'];
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
