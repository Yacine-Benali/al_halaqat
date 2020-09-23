import 'package:alhalaqat/app/models/message.dart';
import 'package:alhalaqat/common_widgets/size_config.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageTile extends StatelessWidget {
  const MessageTile({Key key, @required this.message, this.isSelf})
      : super(key: key);
  final Message message;
  final bool isSelf;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Column(
          children: <Widget>[
            buildMessageContainer(isSelf, message, context),
            buildTimeStamp(context, isSelf, message)
          ],
        ),
      ),
    );
  }

  Row buildMessageContainer(
      bool isSelf, Message message, BuildContext context) {
    double lrEdgeInsets = 1.0;
    double tbEdgeInsets = 1.0;
    lrEdgeInsets = 15.0;
    tbEdgeInsets = 10.0;

    return Row(
      children: <Widget>[
        Container(
          child: buildMessageContent(isSelf, message, context),
          padding: EdgeInsets.fromLTRB(
              lrEdgeInsets, tbEdgeInsets, lrEdgeInsets, tbEdgeInsets),
          constraints: BoxConstraints(maxWidth: SizeConfig.screenWidth / 2),
          decoration: BoxDecoration(
            color: isSelf ? Colors.indigo : Colors.grey[300],
            borderRadius: BorderRadius.circular(8.0),
          ),
          margin: EdgeInsets.only(
              right: isSelf ? 10.0 : 0, left: isSelf ? 0 : 10.0),
        )
      ],
      mainAxisAlignment: isSelf
          ? MainAxisAlignment.start
          : MainAxisAlignment.end, // aligns the chatitem to right end
    );
  }

  buildMessageContent(bool isSelf, Message message, BuildContext context) {
    return Text(
      message.content,
      style: TextStyle(
        color: isSelf ? Colors.white : Colors.black,
      ),
    );
  }

  Row buildTimeStamp(BuildContext context, bool isSelf, Message message) {
    return Row(
        mainAxisAlignment:
            isSelf ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: <Widget>[
          Container(
            child: Text(
              DateFormat('dd MMM kk:mm')
                  .format(message.timestamp?.toDate() ?? DateTime.now()),
              style: Theme.of(context).textTheme.caption,
            ),
            margin: EdgeInsets.only(
                right: isSelf ? 10.0 : 0, left: isSelf ? 0 : 10.0),
          )
        ]);
  }
}
