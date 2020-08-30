import 'package:al_halaqat/app/models/conversation.dart';
import 'package:al_halaqat/app/models/conversation_user.dart';
import 'package:al_halaqat/common_widgets/size_config.dart';
import 'package:flutter/material.dart';

class ConversationTile extends StatelessWidget {
  const ConversationTile({
    Key key,
    @required this.conversation,
    @required this.onTap,
    @required this.conversationUser,
    @required this.isTeacher,
  }) : super(key: key);

  final Conversation conversation;
  final ConversationUser conversationUser;
  final bool isTeacher;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    bool notification = false;
    String name = '';
    if ('conversation.latestMessage.senderId' != conversationUser.id) {
      notification = conversation.latestMessage.seen ?? false;
    }
    if (isTeacher)
      name = conversation.student.name;
    else
      name = conversation.teacher.name;
    return ListTile(
      onTap: onTap,
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
