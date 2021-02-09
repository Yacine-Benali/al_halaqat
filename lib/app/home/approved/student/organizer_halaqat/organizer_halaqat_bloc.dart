import 'package:alhalaqat/app/home/approved/student/organizer_halaqat/organizer_halaqat_provider.dart';
import 'package:alhalaqat/app/models/evaluation.dart';
import 'package:alhalaqat/app/models/halaqa.dart';
import 'package:alhalaqat/app/models/instance.dart';
import 'package:alhalaqat/app/models/report_card.dart';
import 'package:alhalaqat/app/models/student.dart';
import 'package:alhalaqat/app/models/student_profile.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class OrganizerHalaqaBloc {
  OrganizerHalaqaBloc({
    @required this.provider,
    @required this.student,
  });

  final Student student;
  final OrganizerHalaqatProvider provider;

  Stream<List<Halaqa>> fetchHalaqat(List<String> halaqatId) {
    List<List<String>> partitionedList = List();

    for (var i = 0; i < halaqatId.length; i += 10) {
      partitionedList.add(halaqatId.sublist(
          i, i + 10 > halaqatId.length ? halaqatId.length : i + 10));
    }
    if (halaqatId.isEmpty) {
      partitionedList.add(['emptyId']);
    }
    List<Stream<List<Halaqa>>> halaqatStreamList = partitionedList
        .map((sublist) => provider.fetchHalaqat(sublist))
        .toList();

    return Rx.combineLatest(halaqatStreamList,
        (List<List<Halaqa>> values) => values.expand((x) => x).toList());
  }

  Future<List<StudentProfile>> getStudentProfile() async {
    List<StudentProfile> studentsProfileList = List();

    for (String halaqaLearingIn in student.halaqatLearningIn) {
      String reportCardId = student.id + '_' + halaqaLearingIn;

      Future<List<Instance>> instancesList =
          provider.fetchInstances(halaqaLearingIn);
      Future<List<Evaluation>> evaluationsList =
          provider.fetchEvaluations(reportCardId);
      Future<ReportCard> reportCard = provider.fetchReportCard(reportCardId);

      final snapshots =
          Future.wait([instancesList, evaluationsList, reportCard]);
      List<Object> snapshotsData = await snapshots;

      final temp = StudentProfile(
        halaqaName: '',
        halaqaId: halaqaLearingIn,
        instancesList: snapshotsData[0],
        evaluationsList: snapshotsData[1],
        reportCard: snapshotsData[2],
      );
      studentsProfileList.add(temp);
    }

    return studentsProfileList;
  }

  StudentProfile getHalaqaProfile(
      List<StudentProfile> studentProfileList, Halaqa halaqa) {
    for (StudentProfile studentProfile in studentProfileList) {
      if (studentProfile.halaqaId == halaqa.id) return studentProfile;
    }
    return StudentProfile(
      halaqaName: '',
      evaluationsList: [],
      halaqaId: null,
      instancesList: [],
      reportCard: null,
    );
  }
}
