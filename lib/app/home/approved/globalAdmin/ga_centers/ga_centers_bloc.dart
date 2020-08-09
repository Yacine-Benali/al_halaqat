import 'package:al_halaqat/app/home/approved/globalAdmin/ga_centers/ga_centers_provider.dart';
import 'package:al_halaqat/app/home/approved/globalAdmin/ga_requests/ga_requests_provider.dart';
import 'package:al_halaqat/app/models/admin.dart';
import 'package:al_halaqat/app/models/global_admin_request.dart';
import 'package:al_halaqat/app/models/study_center.dart';
import 'package:al_halaqat/app/models/user.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

class GaCentersBloc {
  GaCentersBloc({
    @required this.user,
    @required this.provider,
  });
  final GaCentersProvider provider;
  final User user;

  Stream<List<StudyCenter>> getCentersStream(String centerState) {
    return provider.getCentersStream(centerState);
  }

  Future<void> createCenter(StudyCenter center) async {
    if (center.id == null) {
      center.id = provider.getUniqueId();
      center.createdBy = {
        'name': user.name,
        'id': user.id,
      };
      center.state = 'approved';
    }

    await provider.createCenter(center);
  }

  Future<void> executeAction(StudyCenter center, String action) async {
    switch (action) {
      case 'reApprove':
        center.state = 'approved';
        break;
      case 'archive':
        center.state = 'archived';
        break;
      case 'delete':
        center.state = 'deleted';
        break;
    }
    await createCenter(center);
  }
}
