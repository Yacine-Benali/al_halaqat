import 'package:al_halaqat/app/models/admin.dart';
import 'package:al_halaqat/app/models/global_admin.dart';
import 'package:al_halaqat/services/api_path.dart';
import 'package:al_halaqat/services/database.dart';
import 'package:flutter/foundation.dart';

class GaProfileProvider {
  GaProfileProvider({@required this.database});

  final Database database;

  Future<void> updateProfile(GlobalAdmin globalAdmin) async => database.setData(
        data: globalAdmin.toMap(),
        path: APIPath.userDocument(globalAdmin.id),
        merge: true,
      );
}
