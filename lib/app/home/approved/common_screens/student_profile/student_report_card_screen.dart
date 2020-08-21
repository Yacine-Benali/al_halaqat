import 'package:al_halaqat/app/home/approved/common_screens/student_profile/student_profile_bloc.dart';
import 'package:al_halaqat/app/models/evaluation.dart';
import 'package:al_halaqat/app/models/report_card.dart';
import 'package:al_halaqat/app/models/report_card_summery.dart';
import 'package:al_halaqat/common_widgets/size_config.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

//JORDAN PETERSON 2:06:20
class StudentReportCardScreen extends StatefulWidget {
  const StudentReportCardScreen({
    Key key,
    @required this.bloc,
    @required this.reportCard,
  }) : super(key: key);

  final StudentProfileBloc bloc;
  final ReportCard reportCard;

  @override
  _StudentReportCardScreenState createState() =>
      _StudentReportCardScreenState();
}

class _StudentReportCardScreenState extends State<StudentReportCardScreen> {
  StudentProfileBloc get bloc => widget.bloc;
  List<String> studentReportCardTitle;

  @override
  void initState() {
    studentReportCardTitle = bloc.getReportCardTitles();
    super.initState();
  }

  TableRow buildColumnBlock() {
    List<TableCell> cells = [];

    for (int i = 0; i < studentReportCardTitle.length; i++) {
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
              alignment: Alignment.center,
              child: AutoSizeText(
                '${studentReportCardTitle[i]}',
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
              alignment: Alignment.center,
              child: AutoSizeText(
                '${studentReportCardTitle[i]}',
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
    print(widget.reportCard.summery.length);
    for (ReportCardSummery summery in widget.reportCard.summery) {
      TableRow tableRow = TableRow(children: [
        Container(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              summery.soura,
            ),
          ),
        ),
        Container(
          height: kMinInteractiveDimension,
          alignment: Alignment.center,
          child: Text(
            summery.percentage.toString() + '%',
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
        title: Text('تقييم'),
        centerTitle: true,
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
