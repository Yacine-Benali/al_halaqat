import 'package:alhalaqat/app/home/approved/globalAdmin/ga_reports/ga_teachers_report/ga_teacher_report_row.dart';
import 'package:alhalaqat/common_widgets/format.dart';
import 'package:alhalaqat/constants/key_translate.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class GaTeachersReportCard extends StatelessWidget {
  const GaTeachersReportCard({
    Key key,
    @required this.rowList,
    @required this.columnTitleList,
  }) : super(key: key);

  final List<GaTeacherReportRow> rowList;
  final List<String> columnTitleList;

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

    for (GaTeacherReportRow row in rowList) {
      TableRow tableRow = TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.centerRight,
            child: AutoSizeText(
              row.center?.name ?? '',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.centerRight,
            child: AutoSizeText(
              KeyTranslate.reportsState[row.state],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.centerRight,
            height: kMinInteractiveDimension,
            child: AutoSizeText(row.teacher.readableId),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.centerRight,
            height: kMinInteractiveDimension,
            child: AutoSizeText(row.teacher.name),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              alignment: Alignment.centerRight,
              height: kMinInteractiveDimension,
              child: AutoSizeText(row.teacher.dateOfBirth.toString())),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.centerRight,
            height: kMinInteractiveDimension,
            child: AutoSizeText(row.teacher.gender),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.centerRight,
            height: kMinInteractiveDimension,
            child: AutoSizeText(
                KeyTranslate.isoCountryToArabic[row.teacher.nationality]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.centerRight,
            height: kMinInteractiveDimension,
            child: AutoSizeText(row.teacher.address),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.centerRight,
            height: kMinInteractiveDimension,
            child: AutoSizeText(row.teacher.phoneNumber),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.centerRight,
            height: kMinInteractiveDimension,
            child: AutoSizeText(row.teacher.educationalLevel),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.centerRight,
            height: kMinInteractiveDimension,
            child: AutoSizeText(row.teacher.etablissement),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.centerRight,
            height: kMinInteractiveDimension,
            child: AutoSizeText(row.teacher.note),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.centerRight,
            height: kMinInteractiveDimension,
            child: AutoSizeText(Format.date(row.teacher.createdAt.toDate())),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.centerRight,
            height: kMinInteractiveDimension,
            child: AutoSizeText(row.teacher.createdBy['name']),
          ),
        ),
      ]);

      tableRowList.add(tableRow);
    }
    return tableRowList;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          child: Card(
            child: Table(
              defaultColumnWidth: FixedColumnWidth(125),
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
