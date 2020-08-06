import 'package:al_halaqat/app/models/admin.dart';
import 'package:al_halaqat/app/models/study_center.dart';
import 'package:al_halaqat/app/models/user.dart';
import 'package:al_halaqat/app/common_screens/user_provider.dart';
import 'package:al_halaqat/app/common_screens/user_info_screen.dart';
import 'package:al_halaqat/services/auth.dart';
import 'package:flutter/foundation.dart';

class UserBloc {
  UserBloc({
    @required this.authUser,
    @required this.provider,
    @required this.userType,
  });

  final UserProvider provider;
  final FormType userType;
  final AuthUser authUser;

  Future<void> createUser(User user) async {
    user.createdBy = {
      'name': user.name,
      'id': authUser.uid,
    };

    user.email = authUser.email;
    user.createdAt = DateTime.now().millisecondsSinceEpoch;
    await provider.createUser(
      user,
      authUser.uid,
    );
  }

  Future<void> createAdminAndCenter(Admin admin, StudyCenter center) async {
    admin.createdBy = {
      'name': admin.name,
      'id': authUser.uid,
    };
    admin.email = authUser.email;

    center.createdBy = {'name': admin.name, 'id': admin.id};
    center.createdAt = DateTime.now().millisecondsSinceEpoch;
    if (center.id == null) center.id = provider.getUniqueId();
    //
    admin.centers[0] = center.id;
    admin.createdAt = DateTime.now().millisecondsSinceEpoch;
    //
    await provider.createUser(admin, authUser.uid);
    await provider.createCenter(center, center.id);
  }

  Future<StudyCenter> getCenter(String centerId) async =>
      await provider.getCenter(centerId);
}
