// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:b1_parent/app/conversation/conversation_model.dart';
// import 'package:b1_parent/constants/size_config.dart';

// class ConversationTile extends StatelessWidget {
//   const ConversationTile(
//       {Key key, @required this.conversation, @required this.onTap})
//       : super(key: key);

//   final ConversationModel conversation;
//   final VoidCallback onTap;

//   @override
//   Widget build(BuildContext context) {
//     bool notification = false;
//     if (conversation.latestMessage.senderId == conversation.teacher['uid']) {
//       notification = conversation.latestMessage.seen;
//     }
//     return FlatButton(
//       onPressed: onTap,
//       child: ListTile(
//         leading: Material(
//           child: conversation.teacher['photoUrl'] == ''
//               ? CircleAvatar(
//                   radius: SizeConfig.blockSizeHorizontal * 6,
//                   backgroundColor: Colors.indigo,
//                   child: Text(
//                       "${conversation.teacher['lastName'][0].toUpperCase()}${conversation.teacher['firstName'][0].toUpperCase()}",
//                       style: TextStyle(color: Colors.white)),
//                 )
//               : CachedNetworkImage(
//                   placeholder: (context, url) => CircularProgressIndicator(),
//                   errorWidget: (context, url, error) => Icon(Icons.error),
//                   imageUrl: conversation.teacher['photoUrl'],
//                   width: SizeConfig.safeBlockHorizontal * 12.5,
//                   height: SizeConfig.safeBlockHorizontal * 12.5,
//                   fit: BoxFit.cover,
//                 ),
//           borderRadius: BorderRadius.all(Radius.circular(25.0)),
//           clipBehavior: Clip.hardEdge,
//         ),
//         title: Text(
//           '${conversation.teacher['lastName'] ?? 'Not available'}',
//           // diffrent style if there is unseen message
//           style: notification
//               ? TextStyle(
//                   color: Colors.black,
//                   fontSize: SizeConfig.safeBlockHorizontal * 3.5,
//                   fontWeight: FontWeight.w700)
//               : TextStyle(
//                   color: Colors.black,
//                 ),
//         ),
//         subtitle: Text(
//           'Subject: ${conversation.teacher['subjects'] ?? 'Not available'}',
//           // diffrent style if there is unseen message
//           style: notification
//               ? TextStyle(
//                   color: Colors.black,
//                   fontWeight: FontWeight.w700,
//                   fontSize: SizeConfig.safeBlockHorizontal * 3.5,
//                 )
//               : TextStyle(
//                   color: Colors.black.withOpacity(0.6),
//                 ),
//         ),
//         trailing: notification
//             ? Container(
//                 width: SizeConfig.safeBlockHorizontal * 4,
//                 height: SizeConfig.safeBlockVertical * 1.87,
//                 decoration: new BoxDecoration(
//                   color: Colors.blue,
//                   shape: BoxShape.circle,
//                 ))
//             : Container(
//                 width: SizeConfig.safeBlockHorizontal * 4,
//                 height: SizeConfig.safeBlockVertical * 1.87,
//               ),
//       ),
//     );
//   }
// }
