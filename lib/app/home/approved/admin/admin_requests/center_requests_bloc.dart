import 'package:al_halaqat/app/home/approved/admin/admin_requests/center_requests_provider.dart';
import 'package:al_halaqat/app/models/admin.dart';
import 'package:al_halaqat/app/models/center_request.dart';
import 'package:al_halaqat/app/models/conversation.dart';
import 'package:al_halaqat/app/models/conversation_user.dart';
import 'package:al_halaqat/app/models/halaqa.dart';
import 'package:al_halaqat/app/models/message.dart';
import 'package:al_halaqat/app/models/student.dart';
import 'package:al_halaqat/app/models/study_center.dart';
import 'package:al_halaqat/app/models/teacher.dart';
import 'package:al_halaqat/app/models/user.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

class CenterRequestsBloc {
  CenterRequestsBloc({
    @required this.provider,
    @required this.admin,
  });
  final CenterRequestsProvider provider;
  final User admin;

  List<CenterRequest> centerRequests = [];
  List<CenterRequest> emptyList = [];

  BehaviorSubject<List<CenterRequest>> centerRequestsListController =
      BehaviorSubject<List<CenterRequest>>();

  int limit = 20;

  Stream<List<CenterRequest>> get centerRequestsStream =>
      centerRequestsListController.stream;

  Future<void> fetchMorecenterRequests() async {
    if (limit >= 1000)
      limit = 1000;
    else
      limit += 20;

    await Future.delayed(const Duration(milliseconds: 750));
  }

  Future<void> fetchecenterRequests(
      String chosenRequestsState, StudyCenter chosenStudyCenter) async {
    Stream stream = provider.fetchCenterRequests(
      chosenRequestsState,
      chosenStudyCenter.id,
      limit,
    );

    stream.listen((list) {
      if (!centerRequestsListController.isClosed) {
        if (list.isNotEmpty) {
          centerRequests = list;
          centerRequestsListController.sink.add(centerRequests);
        } else {
          centerRequestsListController.sink.add(emptyList);
        }
      }
    });
  }

  Future<void> updateRequest(
    StudyCenter chosenStudyCenter,
    CenterRequest centerRequest,
    bool isApproved,
  ) async {
    String state = isApproved ? 'approved' : 'disapproved';
    User requestUser = centerRequest.user;

    centerRequest.state = state;
    if (centerRequest.action == 'join-existing') {
      if (requestUser is Teacher)
        requestUser.centerState[chosenStudyCenter.id] = state;
      else if (requestUser is Student) {
        requestUser.state = state;
        if (admin is Admin) {
          String groupChatId = _calculateGroupeChatId(admin.id, requestUser.id);
          Message emptyMessage = Message(
            content: null,
            receiverId: requestUser.id,
            seen: null,
            senderId: admin.id,
            timestamp: null,
            uid: provider.getUniqueId(),
          );
          Conversation conversation = Conversation(
            groupChatId: groupChatId,
            latestMessage: emptyMessage,
            student: ConversationUser.fromUser(requestUser),
            teacher: ConversationUser.fromUser(admin),
            isMessagingEnabled: null,
            centerId: null,
          );
        }
      }

      await provider.updateJoinRequest(
          chosenStudyCenter.id, centerRequest, requestUser);
    } else if (centerRequest.action == 'create-halaqa') {
      Halaqa halaqa = centerRequest.halaqa;
      halaqa.state = state;
      await provider.updateNewHalaqaRequest(
        centerRequest,
        halaqa,
        chosenStudyCenter.id,
      );
    }
  }

  String _calculateGroupeChatId(String teacherUid, String studentUid) {
    String groupChatId;

    if (studentUid.hashCode <= teacherUid.hashCode) {
      groupChatId = '$studentUid-$teacherUid';
    } else {
      groupChatId = '$teacherUid-$studentUid';
    }
    return groupChatId;
  }

  void dispose() async {
    //  print('closing stream');
    await centerRequestsListController.close();
  }
}
