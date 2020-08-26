import 'package:al_halaqat/app/models/user.dart';
import 'package:al_halaqat/services/api_path.dart';
import 'package:al_halaqat/services/database.dart';
import 'package:flutter/foundation.dart';

class TeacherProfileProvider {
  TeacherProfileProvider({@required this.database});

  final Database database;

  Future<void> updateProfile(User user) async => database.setData(
        data: user.toMap(),
        path: APIPath.userDocument(user.id),
        merge: true,
      );
}
