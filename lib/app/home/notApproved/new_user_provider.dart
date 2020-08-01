import 'package:al_halaqat/app/home/models/user.dart';
import 'package:al_halaqat/services/api_path.dart';
import 'package:al_halaqat/services/database.dart';
import 'package:flutter/foundation.dart';

class NewUserProvider {
  NewUserProvider({@required this.database});
  final Database database;

  Future<void> creatUser(User user, String uid) async => await database.setData(
        path: APIPath.userDocument(uid),
        data: user.toMap(),
        merge: true,
      );
}
