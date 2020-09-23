import 'package:alhalaqat/app/home/approved/common_screens/conversation/chat/chat_screen.dart';
import 'package:alhalaqat/app/models/conversation.dart';
import 'package:alhalaqat/app/models/conversation_user.dart';
import 'package:alhalaqat/common_widgets/size_config.dart';
import 'package:flutter/material.dart';

class ConversationTile extends StatelessWidget {
  const ConversationTile({
    Key key,
    @required this.conversation,
    @required this.conversationUser,
    @required this.isTeacher,
  }) : super(key: key);

  final Conversation conversation;
  final ConversationUser conversationUser;
  final bool isTeacher;

  @override
  Widget build(BuildContext context) {
    bool notification = false;
    String name = '';
    if (conversation.latestMessage.senderId != conversationUser.id) {
      notification = conversation.latestMessage.seen ?? true;
      notification = !notification;
    }
    if (isTeacher)
      name = conversation.student.name;
    else
      name = conversation.teacher.name;
    return ListTile(
      onTap: () async => await Navigator.of(context, rootNavigator: false).push(
        MaterialPageRoute(
          builder: (context) => ChatScreen.create(
            context: context,
            conversation: conversation,
          ),
          fullscreenDialog: true,
        ),
      ),
      title: Text(
        name,
        // diffrent style if there is unseen message
        style: notification
            ? TextStyle(
                color: Colors.black,
                fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                fontWeight: FontWeight.w700)
            : TextStyle(
                color: Colors.black,
              ),
      ),
      trailing: notification
          ? Container(
              width: SizeConfig.safeBlockHorizontal * 4,
              height: SizeConfig.safeBlockVertical * 1.87,
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            )
          : Container(
              width: SizeConfig.safeBlockHorizontal * 4,
              height: SizeConfig.safeBlockVertical * 1.87,
            ),
    );
  }
}
