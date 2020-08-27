// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// //import 'package:fluttertoast/fluttertoast.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:b1_parent/app/conversation/chat/chat_bloc.dart';
// import 'package:b1_parent/app/conversation/message_model.dart';
// import 'package:provider/provider.dart';

// /// handles the input of the chat screen
// /// send messages and photos
// class ChatInputBar extends StatefulWidget {
//   ChatInputBar({
//     Key key,
//   }) : super(key: key);

//   @override
//   _ChatInputBarState createState() => _ChatInputBarState();
// }

// class _ChatInputBarState extends State<ChatInputBar> {
//   TextEditingController textEditingController = TextEditingController();
//   bool isLoading = false;

//   File imageFile;
//   String imageUrl;
//   int timestamp;
//   MessageModel message;

//   ChatBloc bloc;

//   // this app is specefic for students so this var is cosnt

//   @override
//   Widget build(BuildContext context) {
//     bloc = Provider.of<ChatBloc>(context, listen: false);

//     return Padding(
//       padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10, 20),
//       child: Material(
//         child: Container(
//           child: Row(
//             children: <Widget>[
//               // send image Button
//               Container(
//                 child: IconButton(
//                   iconSize: 30.0,
//                   icon: Icon(Icons.image),
//                   onPressed: sendImageMessage, //getImage,
//                   color: Colors.indigo,
//                 ),
//               ),
//               // Edit text
//               Flexible(
//                 child: Container(
//                   child: TextField(
//                     maxLines: 4,
//                     minLines: 1,
//                     style: TextStyle(color: Colors.black, fontSize: 15.0),
//                     controller: textEditingController,
//                     decoration: InputDecoration.collapsed(
//                       hintText: 'Type your message...',
//                       hintStyle: TextStyle(color: Colors.grey),
//                     ),
//                   ),
//                 ),
//               ),
//               // send message button
//               Container(
//                 margin: EdgeInsets.symmetric(horizontal: 8.0),
//                 child: !isLoading
//                     ? IconButton(
//                         icon: Icon(Icons.send),
//                         onPressed: () =>
//                             sendTextMessage(textEditingController.text, 0),
//                         color: Colors.indigo,
//                         iconSize: 30.0,
//                       )
//                     : CircularProgressIndicator(),
//               ),
//             ],
//           ),
//           width: double.infinity,
//           margin: EdgeInsets.all(9),
//         ),
//         type: MaterialType.button,
//         borderRadius: BorderRadius.circular(20.0),
//         color: Colors.white,
//         elevation: 5.0,
//       ),
//     );
//   }

//   /// responsible for sending the message to the cloud
//   void sendTextMessage(String content, int type) {
//     // type: 0 = text, 1 = image
//     if (content.trim() != '') {
//       textEditingController.clear();

//       bloc.sendMessage(content, type);
//     } else {
//       Fluttertoast.showToast(msg: 'Nothing to send');
//     }
//   }

//   /// called on pressing the photo button
//   /// calls image_picker package to chose image from gallery
//   void sendImageMessage() async {
//     imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
//     // print('image file: ');
//     // print(imageFile);
//     if (imageFile == null) {
//       return;
//     }
//     // set loading state
//     setState(() {
//       isLoading = true;
//     });
//     bool result = await bloc.sendImageMessage(imageFile, 1);
//     if (result == true) {
//       setState(() {
//         isLoading = false;
//       });
//     } else {
//       Fluttertoast.showToast(msg: 'photo failed to upload');
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
// }
