import 'package:alhalaqat/app/home/approved/common_screens/conversation/chat/chat_bloc.dart';
import 'package:alhalaqat/app/home/approved/common_screens/conversation/chat/message_tile.dart';
import 'package:alhalaqat/app/models/message.dart';
import 'package:alhalaqat/common_widgets/empty_content.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatList extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  Stream<List<Message>> messagesStream;
  final ScrollController listScrollController = ScrollController();
  List<Message> messages;
  ChatBloc bloc;
  bool isSelf = false;
  bool isLoadingNextMessages;

  @override
  void initState() {
    bloc = Provider.of<ChatBloc>(context, listen: false);
    messagesStream = bloc.messagesStream;
    isLoadingNextMessages = false;
    bloc.fetchFirstMessages();
    listScrollController.addListener(() {
      double maxScroll = listScrollController.position.maxScrollExtent;
      double currentScroll = listScrollController.position.pixels;
      if (maxScroll == currentScroll) {
        print('load more messages');

        if (messages.isNotEmpty) {
          setState(() {
            isLoadingNextMessages = true;
          });
          bloc.fetchNextMessages(messages.last).then((value) {
            setState(() {
              isLoadingNextMessages = false;
            });
          });
        }
      }
    });

    super.initState();
  }

  /// show progress indicator when user upload old messages
  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Opacity(
          opacity: isLoadingNextMessages ? 1 : 0,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
        stream: messagesStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            messages = snapshot.data;
            if (messages.isNotEmpty) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  if (index == messages.length) {
                    // oups u have reached the top of messages list
                    return _buildProgressIndicator();
                  } else {
                    isSelf = bloc.checkMessageSender(messages[index]);

                    return MessageTile(
                      message: messages[index],
                      isSelf: isSelf,
                    );
                  }
                },
                // +1 to include the loading widget
                itemCount: messages.length + 1,
                reverse: true,
                controller: listScrollController,
              );
            } else {
              return EmptyContent(
                title: 'مرحبا بك في الرسائل',
                message:
                    'هنا يمكنك إرسال واستقبال الرسائل من المعلمين والمديرين',
              );
            }
          } else if (snapshot.hasError) {
            return EmptyContent(
              title: 'Something went wrong',
              message: 'Can\'t load items right now',
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  @override
  void dispose() {
    //print('disposed called');
    bloc.dispose();
    listScrollController.dispose();
    super.dispose();
  }
}
