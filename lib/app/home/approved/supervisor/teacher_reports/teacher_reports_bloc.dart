import 'package:alhalaqat/app/home/approved/teacher/teacher_reports/teacher_reports_provider.dart';
import 'package:alhalaqat/app/models/halaqa.dart';
import 'package:flutter/foundation.dart';

class TeacherReportsBloc {
  TeacherReportsBloc({
    @required this.provider,
    @required this.halaqatId,
  });

  final TeacherReportsProvider provider;
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
}
