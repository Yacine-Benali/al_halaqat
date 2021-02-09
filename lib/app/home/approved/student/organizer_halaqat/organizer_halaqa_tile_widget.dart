import 'package:alhalaqat/app/home/approved/common_screens/user_instances/instances_screen.dart';
import 'package:alhalaqat/app/home/approved/student/organizer_halaqat/organizer_halaqat_bloc.dart';
import 'package:alhalaqat/app/models/halaqa.dart';
import 'package:alhalaqat/app/models/study_center.dart';
import 'package:flutter/material.dart';

class OrganizerHalaqaTileWidget extends StatefulWidget {
  OrganizerHalaqaTileWidget({
    Key key,
    @required this.halaqa,
    @required this.bloc,
    @required this.studyCenter,
  }) : super(key: key);

  final Halaqa halaqa;
  final OrganizerHalaqaBloc bloc;
  final StudyCenter studyCenter;

  @override
  _OrganizerHalaqaTileWidgetState createState() =>
      _OrganizerHalaqaTileWidgetState();
}

class _OrganizerHalaqaTileWidgetState extends State<OrganizerHalaqaTileWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(widget.halaqa.name),
          subtitle: Text(widget.halaqa.readableId),
          enabled: widget.halaqa.state == 'approved' ? true : false,
          onTap: () async => widget.halaqa.state == 'approved'
              ? await Navigator.of(context, rootNavigator: false).push(
                  MaterialPageRoute(
                    builder: (context) => InstancesScreen.create(
                      context: context,
                      halaqa: widget.halaqa,
                      chosenCenter: widget.studyCenter,
                      halaqatList: [],
                    ),
                    fullscreenDialog: true,
                  ),
                )
              : null,
        ),
        Divider(
          height: 0.5,
        )
      ],
    );
  }
}
