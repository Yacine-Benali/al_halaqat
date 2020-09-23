import 'package:alhalaqat/app/conversation_helper/conversation_helper_bloc.dart';
import 'package:alhalaqat/app/home/approved/globalAdmin/ga_requests/ga_requests_provider.dart';
import 'package:alhalaqat/app/models/admin.dart';
import 'package:alhalaqat/app/models/global_admin_request.dart';
import 'package:alhalaqat/app/models/study_center.dart';
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
    globalAdminRequest.admin.centerState[globalAdminRequest.centerId] = state;
    admin = globalAdminRequest.admin;
    center = globalAdminRequest.center;

    //join-new
    if (globalAdminRequest.action == 'join-new') {
      globalAdminRequest.center.state = state;
      center = globalAdminRequest.center;
      return await provider.updateJoinNewRequest(
        globalAdminRequest,
        center,
        admin,
      );
    } else if (globalAdminRequest.action == 'join-existing') {
      //join-existing

      if (globalAdminRequest.state == 'approved') {
        //approved
        // print("approved");
        await conversationHelper.onAdminAcceptance(admin, center.id);
        return await provider.updateJoinExistingRequestAccepted(
          globalAdminRequest,
          admin,
        );
      } else {
        // print('dissapproved');
        //disapproved
        return await provider.updateJoinExistingRequestRefused(
          globalAdminRequest,
          admin,
        );
      }
    }
  }

  void dispose() async {
    //  print('closing stream');
    await gaRequestsListController.close();
  }
}
