// import 'package:al_halaqat/app/home/approved/common_screens/conversation/conversations_bloc.dart';
// import 'package:al_halaqat/app/home/approved/common_screens/conversation/conversations_provider.dart';
// import 'package:al_halaqat/app/models/conversation_model.dart';
// import 'package:al_halaqat/services/database.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// import 'package:provider/provider.dart';

// import 'chat/chat_screen.dart';

// class ConversationScreen extends StatefulWidget {
//   final ConversationsBloc conversationsBloc;

// final Database database;
//   ConversationScreen._({
//     Key key,
//     @required this.conversationsBloc,
//     @required this.database,
//   }) : super(key: key);

//   static Widget create({@required BuildContext context}) {
//     Database database = Provider.of<Database>(context, listen: false);
//     StudentModel student = Provider.of<StudentModel>(context, listen: false);
//     ConversationsProvider conversationsProvider = ConversationsProvider(database: database);

//     return Provider<ConversationsBloc>(
//       create: (_) => ConversationsBloc(
//         conversationsProvider: conversationsProvider,
//         student: student,
//       ),
//       child: Consumer<ConversationsBloc>(
//         builder: (_, conversationsBloc, __) =>
//             ConversationScreen._(conversationsBloc: conversationsBloc,database: database,),
//       ),
//     );
//   }

//   @override
//   _TeachersSceenState createState() => _TeachersSceenState();
// }

// class _TeachersSceenState extends State<ConversationScreen> {
//   ConversationsBloc get bloc => widget.conversationsBloc;

//   Stream conversationStream;
//   @override
//   void initState() {
//     conversationStream = bloc.getConversationStream();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Center(child: Text('messages_screen_title')),
//       ),
//       body: Material(
//         child: StreamBuilder<List<ConversationModel>>(
//           stream: conversationStream,
//           builder: (context, snapshot) {
//             if (!snapshot.hasData) {
//               return Center(child: CircularProgressIndicator());
//             } else {
//               return SnapshotItemBuilder(
//                 title: 'nothing here',
//                 message: 'assinged teachers will show up here',
//                 snapshot: snapshot,
//                 itemBuilder: (context, conversation) => ConversationTile(
//                   conversation: conversation,
//                   onTap: () async {
//                     await Navigator.push(context,
//                       CupertinoPageRoute(
//                         builder: (context) => ChatScreen.create(
//                           conversation: conversation,
//                           database: widget.database,
//                           student: bloc.student,
//                         ),
//                         fullscreenDialog: false,
//                       ),
//                     );
//                   },
//                 ),
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
// }
