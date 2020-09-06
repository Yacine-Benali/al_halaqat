import 'package:al_halaqat/app/home/approved/common_screens/reports/s_learning/s_learning_bloc.dart';
import 'package:al_halaqat/app/models/report_card.dart';
import 'package:al_halaqat/common_widgets/size_config.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class SLearningCard extends StatefulWidget {
  const SLearningCard({
    Key key,
    @required this.bloc,
    @required this.list,
  }) : super(key: key);
  final SLearningBloc bloc;
  final List<ReportCard> list;

  @override
  _SLearningCardState createState() => _SLearningCardState();
}

class _SLearningCardState extends State<SLearningCard> {
  SLearningBloc get bloc => widget.bloc;
  List<ReportCard> get list => widget.list;

  TableRow buildColumnBlock() {
    List<String> columnTitleList = bloc.getColumnTitle();
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

    for (ReportCard reportCard in list) {
      TableRow tableRow = TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.centerRight,
            child: Text(
              reportCard.studentName,
            ),
          ),
        ),
        Container(
          alignment: Alignment.centerRight,
          height: kMinInteractiveDimension,
          child: Text(reportCard.precentage.toString() + '%'),
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
