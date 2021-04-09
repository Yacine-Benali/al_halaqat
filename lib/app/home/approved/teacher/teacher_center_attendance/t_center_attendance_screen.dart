import 'package:alhalaqat/app/home/approved/teacher/teacher_center_attendance/a_t_center_attendace_tile.dart';
import 'package:alhalaqat/app/home/approved/teacher/teacher_center_attendance/t_center_attendance_bloc.dart';
import 'package:alhalaqat/app/home/approved/teacher/teacher_center_attendance/t_center_attendance_provider.dart';
import 'package:alhalaqat/app/home/approved/teacher/teacher_center_attendance/t_new_center_attendance_screen.dart';
import 'package:alhalaqat/app/models/study_center.dart';
import 'package:alhalaqat/app/models/teacher_center_attendance.dart';
import 'package:alhalaqat/app/models/user.dart';
import 'package:alhalaqat/common_widgets/snapshot_items_builder.dart';
import 'package:alhalaqat/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TCenterAttendanceScreen extends StatefulWidget {
  const TCenterAttendanceScreen._({
    Key key,
    @required this.bloc,
    @required this.center,
  }) : super(key: key);

  final TCenterAttendanceBloc bloc;
  final StudyCenter center;

  static Widget create({
    @required BuildContext context,
    @required StudyCenter center,
  }) {
    Database database = Provider.of<Database>(context, listen: false);
    User user = Provider.of<User>(context, listen: false);
    TCenterAttendanceProvider provider =
        TCenterAttendanceProvider(database: database);

    TCenterAttendanceBloc bloc = TCenterAttendanceBloc(
      provider: provider,
      teacher: user,
    );
    return TCenterAttendanceScreen._(
      bloc: bloc,
      center: center,
    );
  }

  @override
  _TCenterAttendanceScreenState createState() =>
      _TCenterAttendanceScreenState();
}

class _TCenterAttendanceScreenState extends State<TCenterAttendanceScreen> {
  TCenterAttendanceBloc get bloc => widget.bloc;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  StudyCenter chosenCenter;
  Stream<List<TeacherCenterAttendance>> teacherCenterAttendanceStream;
  @override
  void initState() {
    chosenCenter = widget.center;
    teacherCenterAttendanceStream = bloc.fetchTCenterAttendance(chosenCenter);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('إدارة الحضور'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context, rootNavigator: false).push(
          MaterialPageRoute(
            builder: (context) => TNewCenterAttendance(
              bloc: bloc,
              studyCenter: chosenCenter,
              teacherCenterAttendance: null,
            ),
            fullscreenDialog: true,
          ),
        ),
        tooltip: 'add',
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<List<TeacherCenterAttendance>>(
        stream: teacherCenterAttendanceStream,
        builder: (context, snapshot) {
          return SnapshotItemBuilder<TeacherCenterAttendance>(
            itemBuilder: (BuildContext context, item) {
              return ATCenterAttendanceTile(
                bloc: bloc,
                scaffoldKey: _scaffoldKey,
                teacherCenterAttendance: item,
                studyCenter: chosenCenter,
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
