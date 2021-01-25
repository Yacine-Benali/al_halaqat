import 'package:alhalaqat/app/models/admin.dart';
import 'package:alhalaqat/app/models/study_center.dart';
import 'package:flutter/foundation.dart';

import 'ga_center_admins_provider.dart';

class GaCenterAdminsBloc {
  GaCenterAdminsBloc({
    @required this.provider,
    @required this.studyCenter,
  });

  final GaCenterAdminsProvider provider;
  final StudyCenter studyCenter;

  Stream<List<Admin>> fetchCenterAdmins() =>
      provider.fetchCenterAdmins(studyCenter.id);
}
