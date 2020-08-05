import 'package:al_halaqat/app/home/models/study_center.dart';
import 'package:al_halaqat/app/home/models/user.dart';
import 'package:al_halaqat/services/api_path.dart';
import 'package:al_halaqat/services/database.dart';
import 'package:al_halaqat/services/firestore_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class UserProvider {
  UserProvider({@required this.database});
  final Database database;

  Future<void> createUser(User user, String uid) async =>
      await database.setData(
        path: APIPath.userDocument(uid),
        data: user.toMap(),
        merge: true,
      );

  Future<void> createCenter(StudyCenter center, String uid) async {
    await database.setData(
      path: APIPath.centerDocument(uid),
      data: center.toMap(),
      merge: true,
    );
  }

  String getUniqueId() => database.getUniqueId();
}
