import 'package:alhalaqat/app/home/approved/student/student_halaqa_information/student_halaqa_info_screen.dart';
import 'package:alhalaqat/app/home/approved/student/student_halaqat/student_halaqat_bloc.dart';
import 'package:alhalaqat/app/models/halaqa.dart';
import 'package:alhalaqat/app/models/student_profile.dart';
import 'package:flutter/material.dart';

class StudentHalaqaTileWidget extends StatefulWidget {
  StudentHalaqaTileWidget({
    Key key,
    @required this.halaqa,
    @required this.studentProfileList,
    @required this.bloc,
  }) : super(key: key);

  final Halaqa halaqa;
  final List<StudentProfile> studentProfileList;
  final StudentHalaqaBloc bloc;

  @override
  _StudentHalaqaTileWidgetState createState() =>
      _StudentHalaqaTileWidgetState();
}

class _StudentHalaqaTileWidgetState extends State<StudentHalaqaTileWidget> {
  StudentProfile studentProfile;

  @override
  void initState() {
    studentProfile = widget.bloc.getHalaqaProfile(
      widget.studentProfileList,
      widget.halaqa,
    );
    super.initState();
  }

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
                    builder: (context) =>
                        StudentHalaqaInfoScreen(studentProfile: studentProfile),
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
