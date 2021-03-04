import 'package:alhalaqat/app/home/approved/student/student_halaqa_information/student__halaqa_info_bloc.dart';
import 'package:alhalaqat/app/models/evaluation.dart';
import 'package:alhalaqat/common_widgets/platform_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/size_config.dart';
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
            padding: EdgeInsets.all(4),
            child: Align(
              alignment: Alignment.center,
              child: RotatedBox(
                quarterTurns: 3,
                child: AutoSizeText(
                  '${studentEvaluationsTitle[i]}',
                  wrapWords: false,
                ),
              ),
            ),
          ),
        );
        cells.add(cell);
      } else {
        TableCell cell = TableCell(
          child: Container(
            padding: EdgeInsets.all(4),
            child: Align(
              alignment: Alignment.center,
              child: RotatedBox(
                quarterTurns: 3,
                child: AutoSizeText(
                  '${studentEvaluationsTitle[i]}',
                  wrapWords: false,
                ),
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
        Container(
          padding: const EdgeInsets.all(4.0),
          alignment: Alignment.center,
          child: AutoSizeText(
            bloc.format(
              evaluation?.createdAt?.toDate() ?? DateTime.now(),
            ),
            wrapWords: false,
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(4.0),
          child: AutoSizeText(
            bloc.format2(evaluation.rehearsed),
            maxLines: 2,
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
          padding: const EdgeInsets.all(4.0),
          child: AutoSizeText(
            bloc.format2(evaluation.rehearsed),
            maxLines: 2,
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(4.0),
          child: Text(
            evaluation.rehearsed.mark.toString(),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(4.0),
          alignment: Alignment.center,
          height: kMinInteractiveDimension,
          child: TextButton(
            child: Center(
              child: Icon(
                Icons.message,
                color: Colors.grey,
              ),
            ),
            onPressed: () {
              PlatformAlertDialog(
                content: evaluation.note,
                defaultActionText: 'حسنا',
                title: '',
              ).show(context);
            },
          ),
        ),
      ]);

      print(tableRowList.length);
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
              // columnWidths: {
              //   0: FlexColumnWidth(1.0),
              //   1: FlexColumnWidth(2.0),
              //   2: FlexColumnWidth(0.5),
              //   3: FlexColumnWidth(2.0),
              //   4: FlexColumnWidth(0.5),
              //   5: FlexColumnWidth(1),
              // },
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
