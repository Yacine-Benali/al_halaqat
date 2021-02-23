import 'package:alhalaqat/app/home/approved/common_screens/user_instances/instances_screen.dart';
import 'package:alhalaqat/app/home/approved/supervisor/supervisor_halaqat/supervisor_halaqat_bloc.dart';
import 'package:alhalaqat/app/models/halaqa.dart';
import 'package:alhalaqat/app/models/study_center.dart';
import 'package:flutter/material.dart';

class SupervisorHalqaTileWidget extends StatefulWidget {
  SupervisorHalqaTileWidget({
    Key key,
    @required this.halaqa,
    @required this.bloc,
    @required this.chosenCenter,
    @required this.halaqatList,
  }) : super(key: key);

  final Halaqa halaqa;
  final SupervisorHalaqaBloc bloc;
  final StudyCenter chosenCenter;
  final List<Halaqa> halaqatList;

  @override
  _SupervisorHalqaTileWidgetState createState() =>
      _SupervisorHalqaTileWidgetState();
}

class _SupervisorHalqaTileWidgetState extends State<SupervisorHalqaTileWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(widget.halaqa.name),
          subtitle: Text(widget.halaqa.readableId),
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
