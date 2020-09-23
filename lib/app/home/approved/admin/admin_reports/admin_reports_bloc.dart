import 'package:alhalaqat/app/home/approved/admin/admin_reports/admin_reports_provider.dart';
import 'package:alhalaqat/app/models/halaqa.dart';
import 'package:flutter/foundation.dart';

class AdminReportsBloc {
  AdminReportsBloc({
    @required this.provider,
  });

  final AdminReportsProvider provider;

  Future<List<Halaqa>> fetchHalaqat(String centerId) =>
      provider.fetchHalaqat(centerId);
}
