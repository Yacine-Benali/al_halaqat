import 'package:al_halaqat/app/models/center_numbers.dart';
import 'package:al_halaqat/common_widgets/size_config.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CenterNumbersCard extends StatefulWidget {
  const CenterNumbersCard({
    Key key,
    @required this.centerNumbers,
    @required this.showArchived,
  }) : super(key: key);

  final CenterNumbers centerNumbers;
  final bool showArchived;

  @override
  _CenterNumbersCardState createState() => _CenterNumbersCardState();
}

class _CenterNumbersCardState extends State<CenterNumbersCard> {
  CenterNumbers get centerNumbers => widget.centerNumbers;
  List<String> columnTitleList = List();

  @override
  void initState() {
    columnTitleList.add('إسم');
    columnTitleList.addAll(['المعلمين', 'الطلاب', 'الحلقات']);
    super.initState();
  }

  TableRow buildColumnBlock() {
    List<TableCell> cells = [];

    for (String columnTitle in columnTitleList) {
      TableCell cell = TableCell(
        child: Container(
          padding: EdgeInsets.fromLTRB(8, 8, 0, 8),
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

    TableRow tableRow = TableRow(children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          alignment: Alignment.centerRight,
          child: Text(
            centerNumbers.centerName,
          ),
        ),
      ),
      Container(
        alignment: Alignment.centerRight,
        height: kMinInteractiveDimension,
        child: Text(
          !widget.showArchived
              ? centerNumbers.activeTeachers.toString()
              : centerNumbers.archivedTeachers.toString(),
        ),
      ),
      Container(
        alignment: Alignment.centerRight,
        height: kMinInteractiveDimension,
        child: Text(
          !widget.showArchived
              ? centerNumbers.activeStudents.toString()
              : centerNumbers.archivedStudents.toString(),
        ),
      ),
      Container(
        alignment: Alignment.centerRight,
        height: kMinInteractiveDimension,
        child: Text(
          !widget.showArchived
              ? centerNumbers.activeHalaqat.toString()
              : centerNumbers.archivedHalaqat.toString(),
        ),
      ),
    ]);

    tableRowList.add(tableRow);

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
