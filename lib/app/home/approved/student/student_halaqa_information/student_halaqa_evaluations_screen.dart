import 'package:al_halaqat/app/home/approved/student/student_halaqa_information/student__halaqa_info_bloc.dart';
import 'package:al_halaqat/app/models/evaluation.dart';
import 'package:al_halaqat/common_widgets/size_config.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class StudentHalaqaEvaluationScreen extends StatefulWidget {
  const StudentHalaqaEvaluationScreen({
    Key key,
    @required this.bloc,
    @required this.evaluationsList,
  }) : super(key: key);

  final StudentHalaqaInfoBloc bloc;
  final List<Evaluation> evaluationsList;

  @override
  _StudentAttendanceScreenState createState() =>
      _StudentAttendanceScreenState();
}

class _StudentAttendanceScreenState
    extends State<StudentHalaqaEvaluationScreen> {
  StudentHalaqaInfoBloc get bloc => widget.bloc;
  List<String> studentEvaluationsTitle;

  @override
  void initState() {
    studentEvaluationsTitle = bloc.getEvaluationsTableTitle();
    super.initState();
  }

  TableRow buildColumnBlock() {
    List<TableCell> cells = [];

    for (int i = 0; i < studentEvaluationsTitle.length; i++) {
      if (i == 2) {
        TableCell cell = TableCell(
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: Colors.grey, width: 2),
              ),
            ),
            padding: EdgeInsets.all(8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: AutoSizeText(
                '${studentEvaluationsTitle[i]}',
                wrapWords: false,
              ),
            ),
          ),
        );
        cells.add(cell);
      } else {
        TableCell cell = TableCell(
          child: Container(
            padding: EdgeInsets.all(8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: AutoSizeText(
                '${studentEvaluationsTitle[i]}',
                wrapWords: false,
              ),
            ),
          ),
        );
        cells.add(cell);
      }
    }
    return TableRow(children: cells);
  }

  List<TableRow> buildRowList() {
    List<TableRow> tableRowList = List();

    for (Evaluation evaluation in widget.evaluationsList) {
      TableRow tableRow = TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.center,
            child: AutoSizeText(
              bloc.format(
                evaluation?.createdAt?.toDate() ?? DateTime.now(),
              ),
              wrapWords: false,
            ),
          ),
        ),
        Container(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              bloc.format2(evaluation.memorized),
            ),
          ),
        ),
        Container(
          height: kMinInteractiveDimension,
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: Colors.grey, width: 2),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            evaluation.memorized.mark.toString(),
          ),
        ),
        Container(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              bloc.format2(evaluation.rehearsed),
            ),
          ),
        ),
        Container(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              evaluation.rehearsed.mark.toString(),
            ),
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
