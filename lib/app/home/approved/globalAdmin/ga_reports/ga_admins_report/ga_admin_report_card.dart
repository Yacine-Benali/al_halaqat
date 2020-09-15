import 'package:al_halaqat/app/home/approved/globalAdmin/ga_reports/ga_admins_report/ga_admin_report_row.dart';
import 'package:al_halaqat/common_widgets/format.dart';
import 'package:al_halaqat/constants/key_translate.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class GaAdminReportCard extends StatelessWidget {
  const GaAdminReportCard({
    Key key,
    @required this.rowList,
    @required this.columnTitleList,
  }) : super(key: key);

  final List<GaAdminReportRow> rowList;
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

    for (GaAdminReportRow row in rowList) {
      TableRow tableRow = TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.centerRight,
            child: AutoSizeText(
              row.admin.readableId,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.centerRight,
            height: kMinInteractiveDimension,
            child: AutoSizeText(row.admin.name),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.centerRight,
            height: kMinInteractiveDimension,
            child: AutoSizeText(row.center?.name ?? ''),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              alignment: Alignment.centerRight,
              height: kMinInteractiveDimension,
              child: AutoSizeText(KeyTranslate.userStateList[row.state] ?? '')),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.centerRight,
            height: kMinInteractiveDimension,
            child: AutoSizeText(row.admin.dateOfBirth.toString()),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.centerRight,
            height: kMinInteractiveDimension,
            child: AutoSizeText(row.admin.gender),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.centerRight,
            height: kMinInteractiveDimension,
            child: AutoSizeText(
                KeyTranslate.isoCountryToArabic[row.admin.nationality]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.centerRight,
            height: kMinInteractiveDimension,
            child: AutoSizeText(row.admin.address),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.centerRight,
            height: kMinInteractiveDimension,
            child: AutoSizeText(row.admin.phoneNumber),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.centerRight,
            height: kMinInteractiveDimension,
            child: AutoSizeText(row.admin.educationalLevel),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.centerRight,
            height: kMinInteractiveDimension,
            child: AutoSizeText(row.admin.etablissement),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.centerRight,
            height: kMinInteractiveDimension,
            child: AutoSizeText(row.admin.note),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.centerRight,
            height: kMinInteractiveDimension,
            child: AutoSizeText(Format.date(row.admin.createdAt.toDate())),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.centerRight,
            height: kMinInteractiveDimension,
            child: AutoSizeText(row.admin.createdBy['name']),
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
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              defaultColumnWidth: FixedColumnWidth(125),
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
