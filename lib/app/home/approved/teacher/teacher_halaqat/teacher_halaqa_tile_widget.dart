import 'package:alhalaqat/app/home/approved/common_screens/user_instances/instances_screen.dart';
import 'package:alhalaqat/app/home/approved/teacher/teacher_halaqat/teacher_halaqat_bloc.dart';
import 'package:alhalaqat/app/home/approved/teacher/teacher_halaqat/teacher_new_halaqa_screen.dart';
import 'package:alhalaqat/app/models/halaqa.dart';
import 'package:alhalaqat/app/models/study_center.dart';
import 'package:alhalaqat/constants/key_translate.dart';
import 'package:flutter/material.dart';

class TeacherHalqaTileWidget extends StatefulWidget {
  TeacherHalqaTileWidget({
    Key key,
    @required this.halaqa,
    @required this.bloc,
    @required this.chosenCenter,
    @required this.halaqatList,
  }) : super(key: key);

  final Halaqa halaqa;
  final TeacherHalaqaBloc bloc;
  final StudyCenter chosenCenter;
  final List<Halaqa> halaqatList;

  @override
  _TeacherHalqaTileWidgetState createState() => _TeacherHalqaTileWidgetState();
}

class _TeacherHalqaTileWidgetState extends State<TeacherHalqaTileWidget> {
  Future<void> _executeAction(String action) async {
    if (action == 'edit') {
      await Navigator.of(context, rootNavigator: false).push(
        MaterialPageRoute(
          builder: (context) => TeacherNewHalaqaScreen(
            bloc: widget.bloc,
            chosenCenter: widget.chosenCenter,
            halaqa: widget.halaqa,
          ),
          fullscreenDialog: true,
        ),
      );
    }
  }

  Widget _buildAction() {
    List<String> actions = ['edit'];
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
                      chosenCenter: widget.chosenCenter,
                      halaqatList: widget.halaqatList,
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
