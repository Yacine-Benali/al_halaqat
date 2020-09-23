import 'package:alhalaqat/app/models/admin.dart';
import 'package:alhalaqat/app/models/study_center.dart';
import 'package:flutter/foundation.dart';

class GaAdminReportRow {
  GaAdminReportRow({
    @required this.admin,
    @required this.center,
    @required this.state,
  });

  final Admin admin;
  final StudyCenter center;
  final String state;
}
