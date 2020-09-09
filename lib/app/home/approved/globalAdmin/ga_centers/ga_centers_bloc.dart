import 'package:al_halaqat/app/home/approved/globalAdmin/ga_centers/ga_centers_provider.dart';
import 'package:al_halaqat/app/models/admin.dart';
import 'package:al_halaqat/app/models/study_center.dart';
import 'package:al_halaqat/app/models/user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class GaCentersBloc {
  GaCentersBloc({
    @required this.user,
    @required this.provider,
  });
  final GaCentersProvider provider;
  final User user;

  Stream<List<StudyCenter>> getCentersStream() => provider.getCentersStream();
  Future<Admin> getAdminById(String id) => provider.getAdminById(id);
  List<StudyCenter> getFilteredCentersList(
    List<StudyCenter> centersList,
    String chosenCentersState,
  ) {
    List<StudyCenter> filteredCentersList = List();

    for (StudyCenter center in centersList) {
      if (center.state == chosenCentersState) {
        filteredCentersList.add(center);
      }
    }
    return filteredCentersList;
  }

  Future<void> createCenter(
    StudyCenter center,
    List<StudyCenter> centersList,
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
    bool isNameDuplicated = checkIfNameUnique(
      center,
      centersList,
    );
    if (isNameDuplicated)
      throw PlatformException(
        code: 'ERROR_DUPLICATE_NAME',
      );

    await provider.createCenter(center);
  }

  bool checkIfNameUnique(
    StudyCenter newcenter,
    List<StudyCenter> centersList,
  ) {
    for (StudyCenter center in centersList) {
      bool condition = newcenter.name == center.name &&
          newcenter.id != center.id &&
          (center.state == 'approved' || center.state == 'archived');

      if (condition) return true;
    }

    return false;
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
    await provider.createCenter(center);
  }
}
