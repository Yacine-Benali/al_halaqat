import 'package:al_halaqat/app/home/approved/globalAdmin/ga_requests/ga_requests_provider.dart';
import 'package:al_halaqat/app/models/admin.dart';
import 'package:al_halaqat/app/models/global_admin_request.dart';
import 'package:al_halaqat/app/models/study_center.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

class GaRequestsBloc {
  GaRequestsBloc({@required this.provider});
  final GaRequestsProvider provider;

  List<GlobalAdminRequest> gaRequests = [];
  List<GlobalAdminRequest> emptyList = [];

  BehaviorSubject<List<GlobalAdminRequest>> gaRequestsListController =
      BehaviorSubject<List<GlobalAdminRequest>>();

  int limit = 20;

  Stream<List<GlobalAdminRequest>> get gaRequestsStream =>
      gaRequestsListController.stream;

  Future<bool> fetcheGaRequests(String chosenRequestsState) async {
    //print('detch gagin');
    limit += limit;
    Stream stream = provider.fetcheGaRequests(chosenRequestsState, limit);
    stream.listen((list) {
      // print('new');
      if (list.isNotEmpty) {
        gaRequests = list;

        if (!gaRequestsListController.isClosed) {
          gaRequestsListController.sink.add(gaRequests);
        }
      } else {
        gaRequestsListController.sink.add(emptyList);
      }
    });
    List<GlobalAdminRequest> first = await stream.first;
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  Future<void> updateRequest(
      GlobalAdminRequest globalAdminRequest, bool isApproved) async {
    String state = isApproved ? 'approved' : 'disapproved';
    StudyCenter center;
    Admin admin;
    // update ga request
    globalAdminRequest.state = state;
    // update center
    center = globalAdminRequest.center;
    if (globalAdminRequest.action == 'join-new') {
      globalAdminRequest.center.state = state;
      center = globalAdminRequest.center;
    }
    // update admin
    globalAdminRequest.admin.centerState[center.id] = state;
    admin = globalAdminRequest.admin;
    await provider.updateRequest(
      globalAdminRequest,
      center,
      admin,
    );
  }

  void dispose() {
    gaRequestsListController.close();
  }
}
