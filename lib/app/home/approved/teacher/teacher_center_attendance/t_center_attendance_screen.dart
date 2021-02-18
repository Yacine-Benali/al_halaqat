import 'package:alhalaqat/app/home/approved/teacher/teacher_center_attendance/t_center_attendance_bloc.dart';
import 'package:alhalaqat/app/home/approved/teacher/teacher_center_attendance/t_center_attendance_provider.dart';
import 'package:alhalaqat/app/home/approved/teacher/teacher_center_attendance/t_new_center_attendance_screen.dart';
import 'package:alhalaqat/app/models/study_center.dart';
import 'package:alhalaqat/app/models/teacher_center_attendance.dart';
import 'package:alhalaqat/app/models/user.dart';
import 'package:alhalaqat/common_widgets/format.dart';
import 'package:alhalaqat/common_widgets/snapshot_items_builder.dart';
import 'package:alhalaqat/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TCenterAttendanceScreen extends StatefulWidget {
  const TCenterAttendanceScreen._({
    Key key,
    @required this.bloc,
    @required this.centers,
  }) : super(key: key);

  final TCenterAttendanceBloc bloc;
  final List<StudyCenter> centers;

  static Widget create({
    @required BuildContext context,
    @required List<StudyCenter> centers,
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
      centers: centers,
    );
  }

  @override
  _TCenterAttendanceScreenState createState() =>
      _TCenterAttendanceScreenState();
}

class _TCenterAttendanceScreenState extends State<TCenterAttendanceScreen> {
  TCenterAttendanceBloc get bloc => widget.bloc;

  StudyCenter chosenCenter;
  Stream<List<TeacherCenterAttendance>> teacherCenterAttendanceStream;
  @override
  void initState() {
    chosenCenter = widget.centers[0];
    teacherCenterAttendanceStream = bloc.fetchTCenterAttendance(chosenCenter);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('')),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Center(
              child: DropdownButton<StudyCenter>(
                dropdownColor: Colors.indigo,
                value: chosenCenter,
                icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                iconSize: 24,
                underline: Container(),
                elevation: 0,
                style: TextStyle(color: Colors.white, fontSize: 20),
                onChanged: (StudyCenter newValue) {
                  setState(() {
                    chosenCenter = newValue;
                  });
                  teacherCenterAttendanceStream =
                      bloc.fetchTCenterAttendance(chosenCenter);
                },
                items: widget.centers
                    .map<DropdownMenuItem<StudyCenter>>((StudyCenter value) {
                  return DropdownMenuItem<StudyCenter>(
                    value: value,
                    child: Text(value.name),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
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
                      builder: (context) => TNewCenterAttendance(
                        bloc: bloc,
                        studyCenter: chosenCenter,
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
