import 'package:alhalaqat/app/home/approved/common_screens/student_profile/student_profile_bloc.dart';
import 'package:alhalaqat/app/models/instance.dart';
import 'package:alhalaqat/app/models/local_attendance_summery.dart';
import 'package:alhalaqat/app/models/student_attendance.dart';
import 'package:alhalaqat/common_widgets/platform_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/size_config.dart';
import 'package:alhalaqat/constants/key_translate.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class StudentAttendanceScreen extends StatefulWidget {
  const StudentAttendanceScreen({
    Key key,
    @required this.bloc,
    @required this.instancesList,
  }) : super(key: key);

  final StudentProfileBloc bloc;
  final List<Instance> instancesList;

  @override
  _StudentAttendanceScreenState createState() =>
      _StudentAttendanceScreenState();
}

class _StudentAttendanceScreenState extends State<StudentAttendanceScreen> {
  StudentProfileBloc get bloc => widget.bloc;
  List<StudentAttendance> studentAttendaceList;
  List<String> attendanceState;
  LocalAttendanceSummery studentAttendanceSummery;

  @override
  initState() {
    studentAttendaceList = bloc.getStudentAttendance(widget.instancesList);
    studentAttendanceSummery =
        bloc.getStudentAttendanceSummery(studentAttendaceList);
    attendanceState = KeyTranslate.attendanceState.keys.toList();
    super.initState();
  }

  Future<void> _studentNoteWidget(StudentAttendance studentAttendance) async {
    PlatformAlertDialog(
      title: 'ملاحظة',
      content: studentAttendance.note ?? 'لا توجد أي ملاحظة',
      defaultActionText: 'حسنا',
    ).show(context);
  }

  TableRow buildColumnBlock() {
    List<String> columnTitleList = bloc.getAttendaceTableTitle();
    List<TableCell> cells = [];

    for (String columnTitle in columnTitleList) {
      TableCell cell = TableCell(
        child: Container(
          padding: EdgeInsets.all(8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: AutoSizeText(
              '$columnTitle',
              wrapWords: false,
            ),
          ),
        ),
      );
      cells.add(cell);
    }
    return TableRow(children: cells);
  }

  TableRow buildSummery() {
    return TableRow(children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          alignment: Alignment.center,
          child: Text(KeyTranslate.sum),
        ),
      ),
      // TODO create function that returns the following container
      Container(
          alignment: Alignment.center,
          height: kMinInteractiveDimension,
          child: Text(studentAttendanceSummery.present.toString())),
      Container(
          alignment: Alignment.center,
          height: kMinInteractiveDimension,
          child: Text(studentAttendanceSummery.latee.toString())),
      Container(
          alignment: Alignment.center,
          height: kMinInteractiveDimension,
          child: Text(studentAttendanceSummery.absent.toString())),
      Container(
          alignment: Alignment.center,
          height: kMinInteractiveDimension,
          child: Text(studentAttendanceSummery.absentWithExecuse.toString())),
      Container(
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.center,
          height: kMinInteractiveDimension,
          child: Text(studentAttendanceSummery.note.toString())),
    ]);
  }

  List<TableRow> buildRowList() {
    List<TableRow> tableRowList = List();
    tableRowList.add(buildSummery());

    for (int i = 0; i < studentAttendaceList.length; i++) {
      StudentAttendance studentAttendance = studentAttendaceList[i];
      TableRow tableRow = TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.center,
            child: Text(bloc
                .format(widget.instancesList.elementAt(i).createdAt.toDate())),
          ),
        ),
        // TODO create function that returns the following container
        Container(
          alignment: Alignment.center,
          height: kMinInteractiveDimension,
          child: Checkbox(
            onChanged: (value) {},
            value: studentAttendance.state == attendanceState[0],
          ),
        ),
        Container(
          alignment: Alignment.center,
          height: kMinInteractiveDimension,
          child: Checkbox(
            onChanged: (value) {},
            value: studentAttendance.state == attendanceState[1],
          ),
        ),
        Container(
          alignment: Alignment.center,
          height: kMinInteractiveDimension,
          child: Checkbox(
            onChanged: (value) {},
            value: studentAttendance.state == attendanceState[2],
          ),
        ),
        Container(
          alignment: Alignment.center,
          height: kMinInteractiveDimension,
          child: Checkbox(
            onChanged: (value) {},
            value: studentAttendance.state == attendanceState[3],
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.center,
          height: kMinInteractiveDimension,
          child: TextButton(
            child: Icon(
              Icons.message,
              color:
                  studentAttendance.note == null ? Colors.grey : Colors.indigo,
            ),
            onPressed: () {
              _studentNoteWidget(studentAttendance);
            },
          ),
        ),
      ]);

      tableRowList.add(tableRow);
    }
    return tableRowList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(bloc.student.name),
      ),
      body: SingleChildScrollView(
        child: Card(
          margin: EdgeInsets.all(4.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: SizeConfig.screenWidth,
              maxWidth: SizeConfig.screenWidth,
            ),
            child: Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              border: TableBorder(
                horizontalInside:
                    BorderSide(width: 1.0, color: Colors.grey[350]),
                bottom: BorderSide(width: 1.0, color: Colors.grey[350]),
              ),
              children: [
                    buildColumnBlock(),
                  ] +
                  buildRowList(),
            ),
          ),
        ),
      ),
    );
  }
}
