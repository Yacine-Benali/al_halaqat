import 'package:al_halaqat/app/models/user.dart';
import 'package:flutter/foundation.dart';

class ConversationUser {
  ConversationUser({
    @required this.id,
    @required this.name,
  });

  String id;
  String name;

  factory ConversationUser.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    String id = data['id'];
    String name = data['name'];

    return ConversationUser(
      id: id,
      name: name,
    );
  }

  factory ConversationUser.fromUser(User user) {
    if (user == null) {
      return null;
    }
    String id = user.id;
    String name = user.name;

    return ConversationUser(
      id: id,
      name: name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}
