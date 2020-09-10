import 'package:al_halaqat/app/models/study_center.dart';
import 'package:flutter/foundation.dart';

class MiniCenter {
  MiniCenter({
    @required this.id,
    @required this.name,
  });

  String id;
  String name;

  factory MiniCenter.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    String id = data['id'];
    String name = data['name'];

    return MiniCenter(
      id: id,
      name: name,
    );
  }

  factory MiniCenter.fromCenter(StudyCenter center) {
    if (center == null) {
      return null;
    }
    String id = center.id;
    String name = center.name;

    return MiniCenter(
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
