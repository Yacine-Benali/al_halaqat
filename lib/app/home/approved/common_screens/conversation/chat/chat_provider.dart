import 'package:alhalaqat/app/models/message.dart';
import 'package:alhalaqat/services/api_path.dart';
import 'package:alhalaqat/services/database.dart';
import 'package:flutter/foundation.dart';

class ChatProvider {
  Database database;

  ChatProvider({@required this.database});

  Stream<List<Message>> latestMessagesStream(String groupChatId) {
    return database.collectionStream(
      path: APIPath.messagesCollection(groupChatId),
      builder: (data, documentId) => Message.fromMap(data, documentId),
      queryBuilder: (query) =>
          query.orderBy('timestamp', descending: true).limit(20),
    );
  }

  Future<List<Message>> fetchMessages(
    String groupChatId,
    Message message,
    int numberOfMessages,
  ) {
    return database.fetchCollection(
      path: APIPath.messagesCollection(groupChatId),
      builder: (data, documentId) => Message.fromMap(data, documentId),
      queryBuilder: (query) => query
          .orderBy('timestamp', descending: true)
          .startAfter([message.timestamp]).limit(numberOfMessages),
    );
  }

  Future<void> addMessage(String groupChatId, Message message) async {
    // todo combine the futures
    await database.addDocument(
      path: APIPath.messagesCollection(groupChatId),
      data: message.toMap(),
    );
    await database.setData(
      path: APIPath.conversationDocument(groupChatId),
      data: {
        'latestMessage': message.toMap(),
      },
      merge: true,
    );
  }

  Future<void> updateLatestMessage(String groupChatId, Message message) async {
    await database.setData(
      path: APIPath.conversationDocument(
        groupChatId,
      ),
      data: {'latestMessage': message.toMap()},
      merge: true,
    );
  }
}
