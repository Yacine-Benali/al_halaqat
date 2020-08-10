import 'package:al_halaqat/app/home/approved/globalAdmin/ga_centers/ga_centers_provider.dart';
import 'package:al_halaqat/app/models/study_center.dart';
import 'package:al_halaqat/app/models/user.dart';
import 'package:flutter/foundation.dart';

class GaCentersBloc {
  GaCentersBloc({
    @required this.user,
    @required this.provider,
  });
  final GaCentersProvider provider;
  final User user;

  Stream<List<StudyCenter>> getCentersStream() => provider.getCentersStream();

  List<StudyCenter> getFilteredAdminsList(
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
    }
    bool isNameUnique = checkIfNameUnique(
      center,
      centersList,
    );
    print(isNameUnique);
    await provider.createCenter(center);
  }

  bool checkIfNameUnique(
    StudyCenter newcenter,
    List<StudyCenter> centersList,
  ) {
    for (StudyCenter center in centersList)
      if (newcenter.name == center.name &&
          newcenter.id != center.id &&
          center.state == 'approved') {
        return true;
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
