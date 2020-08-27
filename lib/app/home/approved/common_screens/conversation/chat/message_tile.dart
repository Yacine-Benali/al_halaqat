// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:b1_parent/app/conversation/chat/image_full_screen.dart';
// import 'package:b1_parent/app/conversation/message_model.dart';
// import 'package:b1_parent/constants/size_config.dart';

// class MessageTile extends StatelessWidget {
//   const MessageTile({Key key, @required this.message, this.isSelf})
//       : super(key: key);
//   final MessageModel message;
//   final bool isSelf;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Container(
//         child: Column(
//           children: <Widget>[
//             buildMessageContainer(isSelf, message, context),
//              buildTimeStamp(context,isSelf, message)
//           ],
//         ),
//       ),
//     );
//   }

//   Row buildMessageContainer(
//       bool isSelf, MessageModel message, BuildContext context) {
//     double lrEdgeInsets = 1.0;
//     double tbEdgeInsets = 1.0;
//     if (message.type == 0) {
//       lrEdgeInsets = 15.0;
//       tbEdgeInsets = 10.0;
//     }
//     return Row(
//       children: <Widget>[
//         Container(
//           child: buildMessageContent(isSelf, message, context),
//           padding: EdgeInsets.fromLTRB(
//               lrEdgeInsets, tbEdgeInsets, lrEdgeInsets, tbEdgeInsets),
//           constraints: BoxConstraints(maxWidth: SizeConfig.screenWidth / 2),
//           decoration: BoxDecoration(
//             color: (message.type == 0)
//                 ? isSelf ? Colors.indigo : Colors.grey[300]
//                 : Colors.transparent,
//             borderRadius: BorderRadius.circular(8.0),
//           ),
//           margin: EdgeInsets.only(
//               right: isSelf ? 10.0 : 0, left: isSelf ? 0 : 10.0),
//         )
//       ],
//       mainAxisAlignment: isSelf
//           ? MainAxisAlignment.end
//           : MainAxisAlignment.start, // aligns the chatitem to right end
//     );
//   }

//   buildMessageContent(bool isSelf, MessageModel message, BuildContext context) {
//     if (message.type == 0) {
//       return Text(
//         message.content,
//         style: TextStyle(
//           color: isSelf ? Colors.white : Colors.black,
//         ),
//       );
//     } else if (message.type == 1) {
//       return GestureDetector(
//         onTap: () => Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => ImageFullScreen(
//                 'ImageMessage_${message.timestamp}', message.content),
//           ),
//         ),
//         child: Hero(
//           tag: 'ImageMessage_${message.timestamp}',
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(8.0),
//             child: CachedNetworkImage(
//               imageUrl: message.content,
//               placeholder: (_, url) => CircularProgressIndicator(),
//             ),
//           ),
//         ),
//       );
//     }
//   }

//   Row buildTimeStamp(BuildContext context, bool isSelf, MessageModel message) {
//     return Row(
//         mainAxisAlignment:
//             isSelf ? MainAxisAlignment.end : MainAxisAlignment.start,
//         children: <Widget>[
//           Container(
//             child: Text(
//               DateFormat('dd MMM kk:mm').format(
//                   DateTime.fromMillisecondsSinceEpoch(message.timestamp)),
//               style: Theme.of(context).textTheme.caption,
//             ),
//             margin: EdgeInsets.only(
//                 right: isSelf ? 10.0 : 0, left: isSelf ? 0 : 10.0),
//           )
//         ]);
//   }
// }
