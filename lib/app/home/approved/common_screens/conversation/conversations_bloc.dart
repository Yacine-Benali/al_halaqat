import 'package:al_halaqat/app/home/approved/common_screens/conversation/conversations_provider.dart';
import 'package:al_halaqat/app/models/admin.dart';
import 'package:al_halaqat/app/models/conversation.dart';
import 'package:al_halaqat/app/models/conversation_user.dart';
import 'package:al_halaqat/app/models/teacher.dart';
import 'package:al_halaqat/app/models/user.dart';
import 'package:meta/meta.dart';

class ConversationsBloc {
  ConversationsBloc({
    @required this.provider,
    @required this.user,
  });

  final ConversationsProvider provider;
  final User user;

  //TODO omptimize this
  Stream<List<Conversation>> getConversationStream() {
    if (user is Teacher || user is Admin)
      return provider.getTeacherConversationStream(user.id);
    else
      return provider.getStudentConversationStream(user.id);
  }

  bool checkIfTeacher() {
    if (user is Teacher || user is Admin)
      return true;
    else
      return false;
  }

  ConversationUser get conversationUser => ConversationUser.fromUser(user);
}
