import 'package:al_halaqat/app/home/approved/common_screens/reports/s_learning/s_learning_provider.dart';
import 'package:al_halaqat/app/models/halaqa.dart';
import 'package:al_halaqat/app/models/report_card.dart';
import 'package:al_halaqat/common_widgets/format.dart';
import 'package:flutter/foundation.dart';

class SLearningBloc {
  SLearningBloc({
    @required this.provider,
    @required this.halaqatId,
  });

  final SLearningProvider provider;
  final List<String> halaqatId;
  Future<List<List<Halaqa>>> fetchHalaqat() {
    List<List<String>> partitionedList = List();

    for (var i = 0; i < halaqatId.length; i += 10) {
      partitionedList.add(halaqatId.sublist(
          i, i + 10 > halaqatId.length ? halaqatId.length : i + 10));
    }
    List<Future<List<Halaqa>>> halaqatFuturesList = partitionedList
        .map((sublist) => provider.fetchHalaqat(sublist))
        .toList();

    return Future.wait(halaqatFuturesList);
  }

  Future<List<ReportCard>> fetchReportCards(
    Halaqa halaqa,
  ) =>
      provider.fetchReportCards(halaqa.id);

  List<String> getColumnTitle() {
    List<String> columnTitleList = List();
    columnTitleList.add('إسم');
    columnTitleList.add('النسبة المؤية');

    return columnTitleList;
  }

  // Future<String> getReportasCsv(
  //   List<UsersAttendanceSummery> list,
  //   DateTime first,
  //   DateTime last,
  // ) async {
  //   var excel = Excel.createExcel();
  //   Sheet sheetObject = excel['Sheet1'];

  //   List<List<String>> rows = List<List<String>>();
  //   List<String> row = List();
  //   row.addAll(getColumnTitle());
  //   sheetObject.insertRowIterables(row, 0);

  //   for (int i = 0; i < list.length; i++) {
  //     List<String> row = List();
  //     row.add(list[i].name);
  //     row.add(list[i].present.toString());
  //     row.add(list[i].latee.toString());
  //     row.add(list[i].absent.toString());
  //     row.add(list[i].absentWithExecuse.toString());
  //     sheetObject.appendRow(row);
  //   }
  //   Storage storage = Storage();
  //   String name = getFileName(first, last);
  //   File file = await storage.getLocalFile(name);
  //   await excel.encode().then((onValue) {
  //     file
  //       ..createSync(recursive: true)
  //       ..writeAsBytesSync(onValue);
  //   });
  //   return file.path;
  // }

  String getFileName(DateTime first, DateTime last) {
    String a = Format.date(first);
    String b = Format.date(last);
    return 'attendance-' + a + '-' + b + '.xlsx';
  }
}
