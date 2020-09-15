import 'package:al_halaqat/app/home/approved/globalAdmin/ga_reports/ga_students_reports/ga_student_report_row.dart';
import 'package:al_halaqat/common_widgets/format.dart';
import 'package:al_halaqat/common_widgets/size_config.dart';
import 'package:al_halaqat/constants/key_translate.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class GaStudentReportCard extends StatelessWidget {
  const GaStudentReportCard({
    Key key,
    @required this.rowList,
    @required this.columnTitleList,
  }) : super(key: key);

  final List<GaStudentReportRow> rowList;
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

    for (GaStudentReportRow row in rowList) {
      TableRow tableRow = TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.centerRight,
            child: AutoSizeText(
              row.center.name,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.centerRight,
            height: kMinInteractiveDimension,
            child: AutoSizeText(row.student.readableId),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.centerRight,
            height: kMinInteractiveDimension,
            child: AutoSizeText(row.student.name),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.centerRight,
            height: kMinInteractiveDimension,
            child: AutoSizeText(row.student.dateOfBirth.toString()),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.centerRight,
            height: kMinInteractiveDimension,
            child: AutoSizeText(row.student.gender),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.centerRight,
            height: kMinInteractiveDimension,
            child: AutoSizeText(
                KeyTranslate.isoCountryToArabic[row.student.nationality]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.centerRight,
            height: kMinInteractiveDimension,
            child: AutoSizeText(row.student.address),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.centerRight,
            height: kMinInteractiveDimension,
            child: AutoSizeText(row.student.phoneNumber),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.centerRight,
            height: kMinInteractiveDimension,
            child: AutoSizeText(row.student.parentPhoneNumber),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.centerRight,
            height: kMinInteractiveDimension,
            child: AutoSizeText(row.student.educationalLevel),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.centerRight,
            height: kMinInteractiveDimension,
            child: AutoSizeText(row.student.etablissement),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.centerRight,
            height: kMinInteractiveDimension,
            child: AutoSizeText(row.student.note),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.centerRight,
            height: kMinInteractiveDimension,
            child: AutoSizeText(Format.date(row.student.createdAt.toDate())),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.centerRight,
            height: kMinInteractiveDimension,
            child: AutoSizeText(row.student.createdBy['name']),
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
          width: SizeConfig.screenWidth * 3,
          child: Card(
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
