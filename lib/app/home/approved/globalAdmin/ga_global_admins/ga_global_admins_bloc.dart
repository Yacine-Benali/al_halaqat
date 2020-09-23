import 'package:alhalaqat/app/home/approved/globalAdmin/ga_global_admins/ga_global_admins_provider.dart';
import 'package:alhalaqat/app/models/global_admin.dart';
import 'package:alhalaqat/app/models/user.dart';
import 'package:alhalaqat/services/auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

class GaGlobalAdminsBloc {
  GaGlobalAdminsBloc({
    @required this.provider,
    @required this.gaAdmin,
    @required this.auth,
  });
  final User gaAdmin;
  final Auth auth;
  final GaGlobalAdminsProvider provider;
  List<GlobalAdmin> globalAdminList = [];
  List<GlobalAdmin> emptyList = [];

  BehaviorSubject<List<GlobalAdmin>> globalAdminsListStreamController =
      BehaviorSubject<List<GlobalAdmin>>();
  int limit = 20;

  Stream<List<GlobalAdmin>> get globalAdminsListStream =>
      globalAdminsListStreamController.stream;

  Future<void> fetchMoreGlobalAdminsList() async {
    if (limit >= 1000)
      limit = 1000;
    else
      limit += 20;
    await Future.delayed(const Duration(milliseconds: 750));
  }

  Future<void> fetchGlobalAdminsList() async {
    Stream stream = provider.fetcheGaAdmins(limit);

    stream.listen((list) {
      if (!globalAdminsListStreamController.isClosed) {
        if (list.isNotEmpty) {
          globalAdminList = list;
          globalAdminsListStreamController.sink.add(globalAdminList);
        } else {
          globalAdminsListStreamController.sink.add(emptyList);
        }
      }
    });
  }

  List<GlobalAdmin> getFilteredGlobalAdminsList(
      List<GlobalAdmin> globalAdminsList, String chosenAdminsState) {
    List<GlobalAdmin> filteredAdminsList = List();

    for (GlobalAdmin globalAdmin in globalAdminsList) {
      String gaAminStatet = globalAdmin.state;
      if (globalAdmin.id == gaAdmin.id) {
        break;
      }
      switch (chosenAdminsState) {
        case 'approved':
          {
            if (gaAminStatet == 'approved') {
              filteredAdminsList.add(globalAdmin);
            }
            break;
          }
        case 'archived':
          {
            if (gaAminStatet == 'archived') {
              filteredAdminsList.add(globalAdmin);
            }
            break;
          }
        case 'deleted':
          {
            if (gaAminStatet == 'deleted') {
              filteredAdminsList.add(globalAdmin);
            }
            break;
          }
      }
    }
    return filteredAdminsList;
  }

  void dispose() async {
    await globalAdminsListStreamController.close();
  }

  Future<void> executeAction(GlobalAdmin globalAdmin, String action) async {
    switch (action) {
      case 'reApprove':
        globalAdmin.state = 'approved';
        break;
      case 'archive':
        globalAdmin.state = 'archived';
        break;
      case 'delete':
        globalAdmin.state = 'deleted';
        break;
    }
    await provider.createGlobalAdmin(globalAdmin);
  }

  Future<void> setGlobalAdmin(GlobalAdmin globalAdmin) async {
    if (globalAdmin.id == null) {
      globalAdmin.id = provider.getUniqueId();
    }
    if (globalAdmin.createdBy.isEmpty) {
      globalAdmin.createdBy = {
        'name': gaAdmin.name,
        'id': gaAdmin.id,
      };
      List<String> testList =
          await auth.fetchSignInMethodsForEmail(email: globalAdmin.username);
      if (testList.contains('password'))
        throw PlatformException(
          code: 'ERROR_USED_USERNAME',
        );
    }
    if (globalAdmin.state == null) {
      globalAdmin.state = 'approved';
    }
    await provider.createGlobalAdmin(globalAdmin);
  }
}
