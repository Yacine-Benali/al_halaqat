import 'package:al_halaqat/app/home/models/user.dart';
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
  final UserType userType;
  final AuthUser authUser;

  Future<void> createUser(User user) async {
    user.createdBy = {
      'name': user.name,
      'id': authUser.uid,
    };

    user.email = authUser.email;
    await provider.createUser(
      user,
      authUser.uid,
    );
  }
}
