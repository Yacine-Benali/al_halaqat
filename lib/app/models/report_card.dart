import 'package:al_halaqat/app/models/report_card_summery.dart';
import 'package:flutter/foundation.dart';

class ReportCard {
  ReportCard({
    @required this.id,
    @required this.studentName,
    @required this.centerId,
    @required this.halaqaId,
    @required this.studentId,
    @required this.precentage,
    @required this.summery,
  });

  String id;
  String studentName;
  String centerId;
  String halaqaId;
  String studentId;
  double precentage;
  List<ReportCardSummery> summery;

  factory ReportCard.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    String id = data['id'];
    String studentName = data['studentName'];
    String centerId = data['centerId'];
    String halaqaId = data['halaqaId'];
    String studentId = data['studentId'];
    double precentage = data['precentage'];

    //! this is a fix for
    //! iterator was called on null
    List<dynamic> temp = data['studentAttendanceList']?.toList();
    List<ReportCardSummery> summery = List();
    int j = temp?.length ?? 0;
    for (int i = 0; i < j; i++) {
      summery.add(ReportCardSummery.fromMap(temp[i]));
    }
    return ReportCard(
      id: id,
      studentName: studentName,
      centerId: centerId,
      halaqaId: halaqaId,
      studentId: studentId,
      precentage: precentage,
      summery: summery,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'studentName': studentName,
      'centerId': centerId,
      'halaqaId': halaqaId,
      'studentId': studentId,
      'precentage': precentage,
      'summery': summery?.map((e) => e?.toMap())?.toList(),
    };
  }
}
