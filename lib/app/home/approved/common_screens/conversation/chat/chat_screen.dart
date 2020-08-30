import 'package:al_halaqat/app/home/approved/common_screens/conversation/chat/chat_bloc.dart';
import 'package:al_halaqat/app/home/approved/common_screens/conversation/chat/chat_input_bar.dart';
import 'package:al_halaqat/app/home/approved/common_screens/conversation/chat/chat_list.dart';
import 'package:al_halaqat/app/home/approved/common_screens/conversation/chat/chat_provider.dart';
import 'package:al_halaqat/app/models/conversation.dart';
import 'package:al_halaqat/app/models/user.dart';
import 'package:al_halaqat/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen._({this.chatBloc});
  final ChatBloc chatBloc;

  static Widget create({
    @required BuildContext context,
    @required Conversation conversation,
  }) {
    Database database = Provider.of<Database>(context, listen: false);
    User user = Provider.of<User>(context, listen: false);
    ChatProvider provider = ChatProvider(database: database);

    return Provider(
      create: (_) => ChatBloc(
        conversation: conversation,
        provider: provider,
        user: user,
      ),
      child: Consumer<ChatBloc>(
        builder: (_, chatBloc, __) => ChatScreen._(
          chatBloc: chatBloc,
        ),
      ),
    );
  }

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ChatBloc get bloc => widget.chatBloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(bloc.getChatScreenTitle()),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ChatList(),
          ),
          ChatInputBar(),
        ],
      ),
    );
  }
}
