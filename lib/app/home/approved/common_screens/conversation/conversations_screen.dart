import 'package:alhalaqat/app/home/approved/common_screens/conversation/conversation_tile.dart';
import 'package:alhalaqat/app/home/approved/common_screens/conversation/conversations_bloc.dart';
import 'package:alhalaqat/app/home/approved/common_screens/conversation/conversations_provider.dart';
import 'package:alhalaqat/app/models/conversation.dart';
import 'package:alhalaqat/app/models/conversation_user.dart';
import 'package:alhalaqat/app/models/user.dart';
import 'package:alhalaqat/common_widgets/empty_content.dart';
import 'package:alhalaqat/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConversationScreen extends StatefulWidget {
  final ConversationsBloc conversationsBloc;

  final Database database;
  ConversationScreen._({
    Key key,
    @required this.conversationsBloc,
    @required this.database,
  }) : super(key: key);

  static Widget create({@required BuildContext context}) {
    Database database = Provider.of<Database>(context, listen: false);
    User user = Provider.of<User>(context, listen: false);
    ConversationsProvider conversationsProvider =
        ConversationsProvider(database: database);

    return Provider<ConversationsBloc>(
      create: (_) => ConversationsBloc(
        provider: conversationsProvider,
        user: user,
      ),
      child: Consumer<ConversationsBloc>(
        builder: (_, conversationsBloc, __) => ConversationScreen._(
          conversationsBloc: conversationsBloc,
          database: database,
        ),
      ),
    );
  }

  @override
  _TeachersSceenState createState() => _TeachersSceenState();
}

class _TeachersSceenState extends State<ConversationScreen> {
  ConversationsBloc get bloc => widget.conversationsBloc;

  Stream conversationStream;
  ConversationUser conversationUser;
  bool isTeacher;

  @override
  void initState() {
    conversationStream = bloc.getConversationStream();
    conversationUser = bloc.conversationUser;
    isTeacher = bloc.checkIfTeacher();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('المحادثات'),
      ),
      body: Material(
        child: StreamBuilder<List<Conversation>>(
          stream: conversationStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final List<Conversation> items = snapshot.data;
              if (items.isNotEmpty) {
                return _buildList(items);
              } else {
                return EmptyContent(
                  title: 'هنا يمكنك إرسال واستقبال الرسائل',
                  message: '',
                );
              }
            } else if (snapshot.hasError) {
              return EmptyContent(
                title: 'Something went wrong',
                message: 'Can\'t load items right now',
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _buildList(List<Conversation> items) {
    return ListView.separated(
      itemCount: items.length + 2,
      separatorBuilder: (context, index) => Divider(height: 0.5),
      itemBuilder: (context, index) {
        if (index == 0 || index == items.length + 1) {
          return Container();
        }
        //return Container();
        return ConversationTile(
          conversation: items[index - 1],
          conversationUser: conversationUser,
          isTeacher: isTeacher,
        );
      },
    );
  }
}
