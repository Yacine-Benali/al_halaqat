import 'package:flutter/foundation.dart';

class EvaluationHelper {
  EvaluationHelper({
    @required this.fromAya,
    @required this.fromSoura,
    @required this.toAya,
    @required this.toSoura,
    @required this.mark,
  });
  String fromSoura;
  int fromAya;
  String toSoura;
  int toAya;
  int mark;

  factory EvaluationHelper.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    String fromSoura = data['fromSoura'];
    int fromAya = data['fromAya'];
    String toSoura = data['toSoura'];
    int toAya = data['toAya'];
    num mark = data['mark'];

    return EvaluationHelper(
      fromSoura: fromSoura,
      fromAya: fromAya,
      toSoura: toSoura,
      toAya: toAya,
      mark: mark,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fromSoura': fromSoura,
      'fromAya': fromAya,
      'toSoura': toSoura,
      'toAya': toAya,
      'mark': mark,
    };
  }

  @override
  String toString() {
    // print('eval ');
    return super.toString();
  }
}
