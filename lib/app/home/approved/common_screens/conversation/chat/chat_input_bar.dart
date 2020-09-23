import 'dart:io';

import 'package:alhalaqat/app/home/approved/common_screens/conversation/chat/chat_bloc.dart';
import 'package:alhalaqat/app/models/message.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

/// handles the input of the chat screen
/// send messages and photos
class ChatInputBar extends StatefulWidget {
  ChatInputBar({
    Key key,
  }) : super(key: key);

  @override
  _ChatInputBarState createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  TextEditingController textEditingController = TextEditingController();
  bool isLoading = false;

  File imageFile;
  String imageUrl;
  int timestamp;
  Message message;

  ChatBloc bloc;

  // this app is specefic for students so this var is cosnt

  @override
  Widget build(BuildContext context) {
    bloc = Provider.of<ChatBloc>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10, 20),
      child: Material(
        child: Container(
          child: Row(
            children: <Widget>[
              // send message button
              Container(
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                child: !isLoading
                    ? RotatedBox(
                        quarterTurns: 2,
                        child: IconButton(
                          icon: Icon(Icons.send),
                          onPressed: () =>
                              sendTextMessage(textEditingController.text, 0),
                          color: Colors.indigo,
                          iconSize: 30.0,
                        ),
                      )
                    : CircularProgressIndicator(),
              ),
              // Edit text
              Flexible(
                child: Container(
                  child: TextField(
                    maxLines: 4,
                    minLines: 1,
                    style: TextStyle(color: Colors.black, fontSize: 15.0),
                    controller: textEditingController,
                    decoration: InputDecoration.collapsed(
                      hintText: 'Type your message...',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ],
          ),
          width: double.infinity,
          margin: EdgeInsets.all(9),
        ),
        type: MaterialType.button,
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.white,
        elevation: 5.0,
      ),
    );
  }

  /// responsible for sending the message to the cloud
  void sendTextMessage(String content, int type) {
    // type: 0 = text, 1 = image
    if (content.trim() != '') {
      textEditingController.clear();

      bloc.sendMessage(content);
    } else {
      Fluttertoast.showToast(msg: 'Nothing to send');
    }
  }
}
