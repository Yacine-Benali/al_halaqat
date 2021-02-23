import 'package:alhalaqat/app/home/approved/supervisor/supervisor_halaqat/supervisor_halaqat_provider.dart';
import 'package:alhalaqat/app/models/halaqa.dart';
import 'package:alhalaqat/app/models/study_center.dart';
import 'package:alhalaqat/app/models/supervisor.dart';
import 'package:alhalaqat/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class SupervisorHalaqaBloc {
  SupervisorHalaqaBloc({
    @required this.provider,
    @required this.supervisor,
    @required this.auth,
    // @required this.logsHelperBloc,
  });

  final SupervisorHalaqatProvider provider;
  //final LogsHelperBloc logsHelperBloc;
  final Supervisor supervisor;
  final Auth auth;

  Stream<List<Halaqa>> fetchHalaqat(List<String> halaqatId) {
    List<List<String>> partitionedList = List();

    for (var i = 0; i < halaqatId.length; i += 10) {
      partitionedList.add(halaqatId.sublist(
          i, i + 10 > halaqatId.length ? halaqatId.length : i + 10));
    }
    List<Stream<List<Halaqa>>> halaqatStreamList = partitionedList
        .map((sublist) => provider.fetchHalaqat(sublist))
        .toList();

    return Rx.combineLatest(halaqatStreamList,
        (List<List<Halaqa>> values) => values.expand((x) => x).toList());
  }

  List<Halaqa> getFilteredHalaqatList(
      List<Halaqa> data, StudyCenter chosenCenter) {
    List<Halaqa> filteredHalaqat = List();

    for (Halaqa halaqa in data)
      if (halaqa?.centerId == chosenCenter.id) filteredHalaqat.add(halaqa);

    return filteredHalaqat;
  }
}
