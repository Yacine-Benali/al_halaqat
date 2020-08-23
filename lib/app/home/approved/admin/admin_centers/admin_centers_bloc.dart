import 'package:al_halaqat/app/home/approved/admin/admin_centers/admin_centers_provider.dart';
import 'package:al_halaqat/app/home/approved/globalAdmin/ga_centers/ga_centers_provider.dart';
import 'package:al_halaqat/app/models/study_center.dart';
import 'package:al_halaqat/app/models/user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class AdminCentersBloc {
  AdminCentersBloc({
    @required this.user,
    @required this.provider,
    @required this.centers,
  });
  final AdminCentersProvider provider;
  final User user;
  final List<StudyCenter> centers;
  Stream<List<StudyCenter>> getCentersStream() {
    List<String> centersId = centers.map((e) => e.id).toList();
    return provider.getCentersStream(centersId);
  }

  Future<void> createCenter(
    StudyCenter center,
  ) async {
    if (center.id == null) {
      center.id = provider.getUniqueId();
      center.createdBy = {
        'name': user.name,
        'id': user.id,
      };
      center.state = 'approved';
      center.nextHalaqaReadableId = 1000;
    }
    bool isNameDuplicated = await checkIfNameUnique(
      center,
    );
    if (isNameDuplicated)
      throw PlatformException(
        code: 'ERROR_DUPLICATE_NAME',
      );

    await provider.createCenter(center);
  }

  Future<bool> checkIfNameUnique(
    StudyCenter newcenter,
  ) async {
    List<StudyCenter> duplicate = await provider.getCenter(newcenter.name);

    for (StudyCenter studyCenter in duplicate)
      if (newcenter.id != studyCenter.id) return false;

    return false;
  }
}
