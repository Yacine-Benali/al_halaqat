// import 'package:flutter/material.dart';
// import 'package:b1_parent/app/conversation/chat/chat_app_bar.dart';
// import 'package:b1_parent/app/conversation/chat/chat_input_bar.dart';
// import 'package:b1_parent/app/conversation/chat/chat_list.dart';
// import 'package:b1_parent/app/conversation/chat/chat_bloc.dart';
// import 'package:b1_parent/app/conversation/chat/chat_provider.dart';
// import 'package:b1_parent/app/conversation/conversation_model.dart';
// import 'package:b1_parent/app/student_model.dart';
// import 'package:b1_parent/services/database.dart';
// import 'package:provider/provider.dart';

// class ChatScreen extends StatefulWidget {
//   ChatScreen._({this.chatBloc});
//   final ChatBloc chatBloc;

//   static Widget create({
//     @required ConversationModel conversation,
//     @required Database database,
//     @required StudentModel student,
//   }) {
//     return Provider(
//       create: (_) => ChatBloc(
//         conversation: conversation,
//         provider: ChatProvider(database:database),
//         student: student,
//       ),
//       child: Consumer<ChatBloc>(
//         builder: (_, chatBloc, __) => ChatScreen._(
//           chatBloc: chatBloc,
//         ),
//       ),
//     );
//   }

//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   ChatBloc get bloc => widget.chatBloc;

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: ChatAppBar(
//         photoUrl: bloc.conversation.teacher['photoUrl'],
//         appBar: AppBar(),
//         firstName: bloc.conversation.teacher['firstName'],
//         lastName:  bloc.conversation.teacher['lastName'],
//         description: bloc.conversation.teacher['subjects'],
//       ),
//       body: Column(
//         children: <Widget>[
//           Expanded(
//             child: ChatList(),
//           ),
//           ChatInputBar(),
//         ],
//       ),
//     );
//   }
// }
