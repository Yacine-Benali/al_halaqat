import 'package:alhalaqat/app/home/approved/student/student_halaqa_information/student__halaqa_info_bloc.dart';
import 'package:alhalaqat/app/models/instance.dart';
import 'package:alhalaqat/app/models/student_attendance.dart';
import 'package:alhalaqat/common_widgets/size_config.dart';
import 'package:alhalaqat/constants/key_translate.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class StudentHalaqaAttendanceScreen extends StatefulWidget {
  const StudentHalaqaAttendanceScreen({
    Key key,
    @required this.bloc,
    @required this.instancesList,
  }) : super(key: key);

  final StudentHalaqaInfoBloc bloc;
  final List<Instance> instancesList;

  @override
  _StudentHalaqaAttendanceScreenState createState() =>
      _StudentHalaqaAttendanceScreenState();
}

class _StudentHalaqaAttendanceScreenState
    extends State<StudentHalaqaAttendanceScreen> {
  StudentHalaqaInfoBloc get bloc => widget.bloc;
  List<StudentAttendance> studentAttendaceList;
  List<String> attendanceState;

  @override
  initState() {
    studentAttendaceList = bloc.getStudentAttendance(widget.instancesList);
    attendanceState = KeyTranslate.attendanceState.keys.toList();
    print(widget.instancesList.length);
    super.initState();
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

  List<TableRow> buildRowList() {
    List<TableRow> tableRowList = List();

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
      ]);

      tableRowList.add(tableRow);
    }
    return tableRowList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
