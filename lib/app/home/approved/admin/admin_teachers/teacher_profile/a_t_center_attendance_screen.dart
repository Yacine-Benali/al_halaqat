import 'package:alhalaqat/app/home/approved/admin/admin_teachers/teacher_profile/a_t_new_center_attendance_screen.dart';
import 'package:alhalaqat/app/home/approved/admin/admin_teachers/teacher_profile/a_teacher_profile_bloc.dart';
import 'package:alhalaqat/app/models/teacher_center_attendance.dart';
import 'package:alhalaqat/common_widgets/format.dart';
import 'package:alhalaqat/common_widgets/snapshot_items_builder.dart';
import 'package:flutter/material.dart';

class ATCenterAttendanceScreen extends StatefulWidget {
  const ATCenterAttendanceScreen({
    Key key,
    @required this.bloc,
  }) : super(key: key);

  final ATeacherProfileBloc bloc;

  @override
  _ATCenterAttendanceScreenState createState() =>
      _ATCenterAttendanceScreenState();
}

class _ATCenterAttendanceScreenState extends State<ATCenterAttendanceScreen> {
  ATeacherProfileBloc get bloc => widget.bloc;

  Stream<List<TeacherCenterAttendance>> teacherCenterAttendanceStream;
  @override
  void initState() {
    teacherCenterAttendanceStream = bloc.fetchTCenterAttendance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context, rootNavigator: false).push(
            MaterialPageRoute(
              builder: (context) => ATNewCenterAttendance(
                bloc: bloc,
                teacherCenterAttendance: null,
              ),
              fullscreenDialog: true,
            ),
          );
        },
        tooltip: 'add',
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<List<TeacherCenterAttendance>>(
        stream: teacherCenterAttendanceStream,
        builder: (context, snapshot) {
          return SnapshotItemBuilder<TeacherCenterAttendance>(
            itemBuilder: (BuildContext context, item) {
              String subtitle1 =
                  'من${item.timeIn.format(context)} إلى${item.timeOut.format(context)}';
              String subtitle2 = 'عدد الجلسات: ${item.noSessions}';
              return ListTile(
                title: Text(Format.date(item.date.toDate())),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(subtitle1), Text(subtitle2)],
                ),
                onTap: () {
                  Navigator.of(context, rootNavigator: false).push(
                    MaterialPageRoute(
                      builder: (context) => ATNewCenterAttendance(
                        bloc: bloc,
                        teacherCenterAttendance: item,
                      ),
                      fullscreenDialog: true,
                    ),
                  );
                },
              );
            },
            message: '',
            snapshot: snapshot,
            title: '',
          );
        },
      ),
    );
  }
}
