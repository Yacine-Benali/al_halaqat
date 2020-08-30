import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Message {
  Message({
    @required this.content,
    @required this.receiverId,
    @required this.seen,
    @required this.senderId,
    @required this.timestamp,
    @required this.id,
  });
  final String id;
  final String content;
  final String receiverId;
  bool seen;
  final String senderId;
  final Timestamp timestamp;

  factory Message.fromMap(Map<String, dynamic> data, String documentId) {
    final String content = data['content'];
    final String receiverId = data['content'];
    final bool seen = data['seen'];
    final String senderId = data['senderId'];
    final Timestamp timestamp = data['timestamp'];
    final String id = documentId;

    return Message(
      content: content,
      receiverId: receiverId,
      seen: seen,
      senderId: senderId,
      timestamp: timestamp,
      id: id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'content': content,
      'receiverId': receiverId,
      'seen': seen,
      'senderId': senderId,
      'timestamp': timestamp ?? FieldValue.serverTimestamp(),
    };
  }

  Map<String, dynamic> toMapmerge() {
    return <String, dynamic>{
      'content': content,
      'receiverId': receiverId,
      'senderId': senderId,
      'timestamp': timestamp ?? FieldValue.serverTimestamp(),
    };
  }

  @override
  String toString() {
    print('message content: ${this.content}  timestamp${this.timestamp} ');
    return super.toString();
  }
}
