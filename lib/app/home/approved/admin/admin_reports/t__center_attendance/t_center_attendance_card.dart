import 'package:alhalaqat/app/home/approved/admin/admin_reports/t__center_attendance/t_center_attendance_bloc.dart';
import 'package:alhalaqat/app/models/local_t_c_a_report.dart';
import 'package:alhalaqat/common_widgets/size_config.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class TCenterAttendanceCard extends StatefulWidget {
  const TCenterAttendanceCard({
    Key key,
    @required this.list,
    @required this.bloc,
  }) : super(key: key);

  final List<LocalTCAReport> list;
  final TCenterAttendanceBloc bloc;

  @override
  _TCenterAttendanceCardState createState() => _TCenterAttendanceCardState();
}

class _TCenterAttendanceCardState extends State<TCenterAttendanceCard> {
  List<LocalTCAReport> get list => widget.list;
  TCenterAttendanceBloc get bloc => widget.bloc;
  List<String> columnTitleList = List();

  @override
  void initState() {
    columnTitleList = bloc.getColumnTitle();
    super.initState();
  }

  TableRow buildColumnBlock() {
    List<TableCell> cells = [];

    for (String columnTitle in columnTitleList) {
      TableCell cell = TableCell(
        child: Container(
          padding: EdgeInsets.all(8),
          child: Align(
            alignment: Alignment.centerRight,
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

    for (LocalTCAReport teacherAttendance in list) {
      TableRow tableRow = TableRow(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              alignment: Alignment.centerRight,
              child: Text(
                teacherAttendance.teacherName,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            height: kMinInteractiveDimension,
            child: Text(teacherAttendance.hoursThought.toString()),
          ),
          Container(
            alignment: Alignment.centerRight,
            height: kMinInteractiveDimension,
            child: Text(teacherAttendance.noSessions.toString()),
          ),
          Container(
            alignment: Alignment.centerRight,
            height: kMinInteractiveDimension,
            child: Text(teacherAttendance.hoursStayed.toString()),
          ),
        ],
      );

      tableRowList.add(tableRow);
    }
    return tableRowList;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
              horizontalInside: BorderSide(width: 1.0, color: Colors.grey[350]),
              bottom: BorderSide(width: 1.0, color: Colors.grey[350]),
            ),
            children: [
                  buildColumnBlock(),
                ] +
                buildRowList(),
          ),
        ),
      ),
    );
  }
}
