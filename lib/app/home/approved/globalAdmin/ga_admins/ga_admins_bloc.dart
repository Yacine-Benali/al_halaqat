import 'package:alhalaqat/app/home/approved/globalAdmin/ga_admins/ga_admins_provider.dart';
import 'package:alhalaqat/app/models/admin.dart';
import 'package:alhalaqat/app/models/study_center.dart';
import 'package:alhalaqat/app/models/user.dart';
import 'package:alhalaqat/services/auth.dart';
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

  Future<void> fetchAdminsList() async {
    await fetchCenters();
    Stream stream = provider.fetcheGaAdmins();

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

  Future<void> setAdmin(Admin oldAdmin, Admin newAdmin) async {
    // await auth.createUserWithEmailAndPassword(admin.username, admin.password);
    if (oldAdmin != null) {
      if (oldAdmin.username != newAdmin.username) {
        List<String> testList =
            await auth.fetchSignInMethodsForEmail(email: newAdmin.username);
        if (testList.contains('password'))
          throw PlatformException(
            code: 'ERROR_USED_USERNAME',
          );
      }
    }

    if (newAdmin.createdBy.isEmpty) {
      newAdmin.createdBy = {
        'name': gaAdmin.name,
        'id': gaAdmin.id,
      };
      List<String> testList =
          await auth.fetchSignInMethodsForEmail(email: newAdmin.username);
      if (testList.contains('password'))
        throw PlatformException(
          code: 'ERROR_USED_USERNAME',
        );
    }
    if (newAdmin.centers.isEmpty && newAdmin.centerState.isEmpty) {
      newAdmin.centers.add('empty');
      newAdmin.centerState['empty'] = 'empty';
    }
    if (newAdmin.id == null) {
      newAdmin.id = provider.getUniqueId();
    }
    await provider.createAdmin(newAdmin);
  }
}
