// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:b1_parent/constants/size_config.dart';

// class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
//   const ChatAppBar({
//     Key key,
//     @required this.photoUrl,
//     @required this.appBar,
//     @required this.firstName,
//     @required this.lastName,
//     @required this.description,
//   }) : super(key: key);
//   final AppBar appBar;
//   final String photoUrl;
//   final String firstName;
//   final String lastName;
//   final String description;

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: AppBar(
//         title: ListTile(
//           leading: Material(
//             child: photoUrl == ''
//                 ? CircleAvatar(
//                     radius: SizeConfig.blockSizeHorizontal * 4,
//                     backgroundColor: Colors.white,
//                     child: Text(
//                         "${lastName[0].toUpperCase()}${firstName[0].toUpperCase()}",
//                         style: TextStyle(color: Colors.indigo)),
//                   )
//                 : CachedNetworkImage(
//                     placeholder: (context, url) => Container(
//                       child: CircularProgressIndicator(
//                         strokeWidth: 1.0,
//                         valueColor:
//                             AlwaysStoppedAnimation<Color>(Colors.indigo),
//                       ),
//                       width: SizeConfig.safeBlockHorizontal * 8.5,
//                       height: SizeConfig.safeBlockHorizontal * 8.5,
//                       padding: EdgeInsets.all(10.0),
//                     ),
//                     imageUrl: photoUrl,
//                     width: 35.0,
//                     height: 35.0,
//                     fit: BoxFit.cover,
//                   ),
//             borderRadius: BorderRadius.all(
//               Radius.circular(18.0),
//             ),
//             clipBehavior: Clip.hardEdge,
//           ),
//           title: Text(
//             lastName,
//             style: TextStyle(color: Colors.white),
//           ),
//           subtitle: Text(
//             description,
//             style: TextStyle(color: Colors.white),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);
// }
