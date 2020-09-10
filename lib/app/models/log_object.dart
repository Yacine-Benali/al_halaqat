import 'package:flutter/foundation.dart';

class LogObject {
  LogObject({
    @required this.name,
    @required this.id,
    @required this.nature,
  });
  final String name;
  final String id;
  final String nature;

  factory LogObject.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    String id = data['id'];
    String name = data['name'];
    String nature = data['nature'];

    return LogObject(
      name: name,
      id: id,
      nature: nature,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
      'nature': nature,
    };
  }
}
