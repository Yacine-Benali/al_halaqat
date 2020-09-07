import 'package:al_halaqat/app/home/approved/common_screens/conversation/chat/chat_provider.dart';
import 'package:al_halaqat/app/models/admin.dart';
import 'package:al_halaqat/app/models/conversation.dart';
import 'package:al_halaqat/app/models/message.dart';
import 'package:al_halaqat/app/models/teacher.dart';
import 'package:al_halaqat/app/models/user.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

class ChatBloc {
  ChatBloc({
    @required this.provider,
    @required this.user,
    @required this.conversation,
  });
  final User user;
  final Conversation conversation;

  final ChatProvider provider;

  List<Message> messagesList = [];
  List<Message> emptyList = [];
  BehaviorSubject<List<Message>> messagesListController =
      BehaviorSubject<List<Message>>();

  Stream<List<Message>> get messagesStream => messagesListController.stream;

  void fetchFirstMessages() {
    Stream<List<Message>> latestMessageStream =
        provider.latestMessagesStream(conversation.groupChatId);

    latestMessageStream.listen((latestMessageList) async {
      bool isMessageExist = false;

      if (latestMessageList.isNotEmpty) {
        if (messagesList.isNotEmpty) {
          for (Message existingMessage in messagesList) {
            if (existingMessage.id == latestMessageList.elementAt(0).id)
              isMessageExist = true;
          }
          if (!isMessageExist) {
            messagesList.insert(0, latestMessageList.elementAt(0));
          }
        } else {
          messagesList.insertAll(0, latestMessageList);
        }
        if (!messagesListController.isClosed) {
          //print('first fetch');
          messagesListController.sink.add(messagesList);
          if (latestMessageList.elementAt(0).senderId != user.id &&
              latestMessageList.elementAt(0).seen == false) {
            setLatesttMessageToSeen(latestMessageList.elementAt(0));
          }
        }
      } else {
        messagesListController.sink.add(emptyList);
        if (conversation.latestMessage.seen == false) {
          setLatesttMessageToSeen(conversation.latestMessage);
        }
      }
    });
  }

  Future<bool> fetchNextMessages(Message message) async {
    List<Message> moreMessages = await provider.fetchMessages(
      conversation.groupChatId,
      message,
      20,
    );
    messagesList.addAll(moreMessages);
    if (!messagesListController.isClosed) {
      messagesListController.sink.add(messagesList);
    }
    return true;
  }

  bool checkMessageSender(Message message) {
    if (message.senderId == user.id) {
      return true;
    } else {
      return false;
    }
  }

  String getReceiverId() {
    if (user is Teacher || user is Admin)
      return conversation.student.id;
    else
      return conversation.teacher.id;
  }

  Future<void> sendMessage(String content) async {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    Message message = Message(
      id: timestamp.toString(),
      content: content,
      receiverId: getReceiverId(),
      seen: false,
      senderId: user.id,
      timestamp: null,
    );
    provider.addMessage(
      conversation.groupChatId,
      message,
    );
  }

  String getChatScreenTitle() {
    if (user is Teacher || user is Admin)
      return conversation.student.name;
    else
      return conversation.teacher.name;
  }

  Future<void> setLatesttMessageToSeen(Message message) async {
    message.seen = true;
    await provider.updateLatestMessage(
      conversation.groupChatId,
      message,
    );
  }

  void dispose() {
    // print('bloc stream diposed called');
    messagesListController.close();
  }
}
