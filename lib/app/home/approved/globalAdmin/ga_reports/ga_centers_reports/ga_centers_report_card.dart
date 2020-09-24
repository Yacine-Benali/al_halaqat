import 'package:alhalaqat/app/home/approved/globalAdmin/ga_reports/ga_centers_reports/ga_center_report_row.dart';
import 'package:alhalaqat/app/models/study_center.dart';
import 'package:alhalaqat/common_widgets/format.dart';
import 'package:alhalaqat/constants/key_translate.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class GaCentersReportCard extends StatelessWidget {
  const GaCentersReportCard({
    Key key,
    @required this.rowList,
    @required this.columnTitleList,
  }) : super(key: key);

  final List<GaCenterReportRow> rowList;
  final List<String> columnTitleList;

  String getAddress(StudyCenter center) {
    return KeyTranslate.isoCountryToArabic[center.country] +
        ' ' +
        center.city +
        ' ' +
        center.street;
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

    for (GaCenterReportRow row in rowList) {
      TableRow tableRow = TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.centerRight,
            child: AutoSizeText(
              row.center.readableId,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.centerRight,
            height: kMinInteractiveDimension,
            child: AutoSizeText(row.center.name),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.centerRight,
            height: kMinInteractiveDimension,
            child: AutoSizeText(getAddress(row.center)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.centerRight,
            height: kMinInteractiveDimension,
            child: AutoSizeText(row.center.phoneNumber),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.centerRight,
            height: kMinInteractiveDimension,
            child: AutoSizeText(
                Format.date(row.center.createdAt.toDate() ?? DateTime.now())),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.centerRight,
            height: kMinInteractiveDimension,
            child: AutoSizeText(row.center.createdBy['name']),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.centerRight,
            height: kMinInteractiveDimension,
            child: AutoSizeText(row.numberOfApprovedStudents.toString()),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.centerRight,
            height: kMinInteractiveDimension,
            child: AutoSizeText(row.numberOfArchivedStudents.toString()),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.centerRight,
            height: kMinInteractiveDimension,
            child: AutoSizeText(row.numberOfApprovedTeachers.toString()),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.centerRight,
            height: kMinInteractiveDimension,
            child: AutoSizeText(row.numberOfArchivedTeachers.toString()),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.centerRight,
            height: kMinInteractiveDimension,
            child: AutoSizeText(row.numberOfApprovedHalaqat.toString()),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.centerRight,
            height: kMinInteractiveDimension,
            child: AutoSizeText(row.numberOfArchivedHalaqat.toString()),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.centerRight,
            height: kMinInteractiveDimension,
            child: AutoSizeText(KeyTranslate.reportsState[row.center.state]),
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
