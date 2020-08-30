import 'package:al_halaqat/app/conversation_helper/conversation_helper_bloc.dart';
import 'package:al_halaqat/app/home/approved/globalAdmin/ga_requests/ga_requests_provider.dart';
import 'package:al_halaqat/app/models/admin.dart';
import 'package:al_halaqat/app/models/global_admin_request.dart';
import 'package:al_halaqat/app/models/study_center.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

class GaRequestsBloc {
  GaRequestsBloc({
    @required this.provider,
    @required this.conversationHelper,
  });
  final GaRequestsProvider provider;
  final ConversationHelpeBloc conversationHelper;

  List<GlobalAdminRequest> gaRequests = [];
  List<GlobalAdminRequest> emptyList = [];

  BehaviorSubject<List<GlobalAdminRequest>> gaRequestsListController =
      BehaviorSubject<List<GlobalAdminRequest>>();

  int limit = 20;

  Stream<List<GlobalAdminRequest>> get gaRequestsStream =>
      gaRequestsListController.stream;

  Future<void> fetchMoreGaRequests() async {
    if (limit >= 1000)
      limit = 1000;
    else
      limit += 20;

    await Future.delayed(const Duration(milliseconds: 750));
  }

  Future<void> fetcheGaRequests(String chosenRequestsState) async {
    Stream stream = provider.fetcheGaRequests(chosenRequestsState, limit);

    stream.listen((list) {
      if (!gaRequestsListController.isClosed) {
        if (list.isNotEmpty) {
          gaRequests = list;
          gaRequestsListController.sink.add(gaRequests);
        } else {
          gaRequestsListController.sink.add(emptyList);
        }
      }
    });
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
    if (globalAdminRequest.action == 'join-existing' &&
        globalAdminRequest.state == 'approved') {
      await conversationHelper.onAdminAcceptance(admin, center.id);
    }
    await provider.updateRequest(
      globalAdminRequest,
      center,
      admin,
    );
  }

  void dispose() async {
    //  print('closing stream');
    await gaRequestsListController.close();
  }
}
