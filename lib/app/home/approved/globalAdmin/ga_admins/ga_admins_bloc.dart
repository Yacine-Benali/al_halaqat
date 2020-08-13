import 'package:al_halaqat/app/home/approved/globalAdmin/ga_admins/ga_admins_provider.dart';
import 'package:al_halaqat/app/models/admin.dart';
import 'package:al_halaqat/app/models/study_center.dart';
import 'package:al_halaqat/app/models/user.dart';
import 'package:al_halaqat/common_widgets/password_generator.dart';
import 'package:al_halaqat/services/auth.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

class GaAdminsBloc {
  GaAdminsBloc({
    @required this.provider,
    @required this.gaAdmin,
    @required this.auth,
  });
  final User gaAdmin;
  final Auth auth;
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
        case 'empty':
          {
            if (adminStatesList.contains('empty') &&
                !adminStatesList.contains('deleted') &&
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
    // await auth.createUserWithEmailAndPassword(admin.username, admin.password);

    if (admin.createdBy.isEmpty) {
      admin.createdBy = {
        'name': gaAdmin.name,
        'id': gaAdmin.id,
      };
      List<String> testList =
          await auth.fetchSignInMethodsForEmail(email: admin.username);
      if (testList.contains('password'))
        throw PlatformException(
          code: 'ERROR_USED_USERNAME',
        );
    }
    if (admin.centers.isEmpty && admin.centerState.isEmpty) {
      admin.centers.add('empty');
      admin.centerState['empty'] = 'empty';
    }
    if (admin.id == null) {
      admin.id = provider.getUniqueId();
    }
    await provider.createAdmin(admin);
  }
}
