import 'package:alhalaqat/app/models/halaqa.dart';
import 'package:alhalaqat/app/models/user_attendance_summery.dart';
import 'package:alhalaqat/common_widgets/size_config.dart';
import 'package:alhalaqat/constants/key_translate.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class SAttendanceCard extends StatefulWidget {
  const SAttendanceCard({
    Key key,
    @required this.halaqa,
    @required this.firstDate,
    @required this.lastDate,
    @required this.showPercentages,
    @required this.list,
  }) : super(key: key);

  final Halaqa halaqa;
  final DateTime firstDate;
  final DateTime lastDate;
  final bool showPercentages;
  final List<UsersAttendanceSummery> list;

  @override
  _SAttendanceCardState createState() => _SAttendanceCardState();
}

class _SAttendanceCardState extends State<SAttendanceCard> {
  List<UsersAttendanceSummery> get list => widget.list;
  List<String> columnTitleList = List();

  @override
  void initState() {
    columnTitleList.add('إسم');
    columnTitleList.addAll(KeyTranslate.attendanceState.values);
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

    for (UsersAttendanceSummery studentAttendance in list) {
      TableRow tableRow = TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.centerRight,
            child: Text(
              studentAttendance.name,
            ),
          ),
        ),
        Container(
          alignment: Alignment.centerRight,
          height: kMinInteractiveDimension,
          child: Text(widget.showPercentages
              ? '${studentAttendance.present}%'
              : '${studentAttendance.present}'),
        ),
        Container(
          alignment: Alignment.centerRight,
          height: kMinInteractiveDimension,
          child: Text(widget.showPercentages
              ? '${studentAttendance.latee}%'
              : '${studentAttendance.latee}'),
        ),
        Container(
          alignment: Alignment.centerRight,
          height: kMinInteractiveDimension,
          child: Text(widget.showPercentages
              ? '${studentAttendance.absent}%'
              : '${studentAttendance.absent}'),
        ),
        Container(
          alignment: Alignment.centerRight,
          height: kMinInteractiveDimension,
          child: Text(widget.showPercentages
              ? '${studentAttendance.absentWithExecuse}%'
              : '${studentAttendance.absentWithExecuse}'),
        ),
      ]);

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
