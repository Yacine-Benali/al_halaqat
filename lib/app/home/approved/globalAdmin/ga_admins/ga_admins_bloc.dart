import 'package:al_halaqat/app/home/approved/globalAdmin/ga_admins/ga_admins_provider.dart';
import 'package:al_halaqat/app/models/admin.dart';
import 'package:al_halaqat/app/models/study_center.dart';
import 'package:al_halaqat/app/models/user.dart';

import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

class GaAdminsBloc {
  GaAdminsBloc({
    @required this.provider,
    @required this.gaAdmin,
  });
  final User gaAdmin;
  final GaAdminsProvider provider;
  List<Admin> adminsList = [];
  List<Admin> emptyList = [];

  BehaviorSubject<List<Admin>> adminsListStreamController =
      BehaviorSubject<List<Admin>>();
  int limit = 20;
  List<StudyCenter> centersList;

  Future<List<StudyCenter>> fetchCenters() async =>
      this.centersList = await provider.fetchCenters();
  Stream<List<Admin>> get adminsListStream => adminsListStreamController.stream;
  Future<void> fetchMoreAdminsList() async {
    if (limit >= 1000)
      limit = 1000;
    else
      limit += 20;
    await Future.delayed(const Duration(milliseconds: 750));
  }

  Future<void> fetchAdminsList() async {
    await fetchCenters();
    Stream stream = provider.fetcheGaAdmins(limit);

    stream.listen((list) {
      if (!adminsListStreamController.isClosed) {
        if (list.isNotEmpty) {
          adminsList = list;
          adminsListStreamController.sink.add(adminsList);
        } else {
          adminsListStreamController.sink.add(emptyList);
        }
      }
    });
  }

  List<Admin> getFilteredAdminsList(
      List<Admin> adminsList, String chosenAdminsState) {
    List<Admin> filteredAdminsList = List();

    for (Admin admin in adminsList) {
      List<String> adminStatesList = admin.centerState.values.toList();

      switch (chosenAdminsState) {
        case 'approved':
          {
            if (adminStatesList.contains('approved')) {
              filteredAdminsList.add(admin);
            }
            break;
          }
        case 'archived':
          {
            if (adminStatesList.contains('archived') &&
                !adminStatesList.contains('approved')) {
              filteredAdminsList.add(admin);
            }
            break;
          }
        case 'deleted':
          {
            if (adminStatesList.contains('deleted') &&
                !adminStatesList.contains('archived') &&
                !adminStatesList.contains('approved')) {
              filteredAdminsList.add(admin);
            }
            break;
          }
      }
    }
    return filteredAdminsList;
  }

  void dispose() async {
    await adminsListStreamController.close();
  }

  Future<void> setAdmin(Admin admin) async {
    if (admin.createdBy.isEmpty) {
      admin.createdBy = {
        'name': gaAdmin.name,
        'id': gaAdmin.id,
      };
    }
    await provider.createAdmin(admin);
  }
}
