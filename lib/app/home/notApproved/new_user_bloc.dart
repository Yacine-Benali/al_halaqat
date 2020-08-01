import 'package:al_halaqat/app/home/models/user.dart';
import 'package:al_halaqat/app/home/notApproved/new_user_provider.dart';
import 'package:al_halaqat/app/home/notApproved/new_user_screen.dart';
import 'package:al_halaqat/services/auth.dart';
import 'package:al_halaqat/services/database.dart';
import 'package:flutter/foundation.dart';

class NewUserBloc {
  NewUserBloc({
    @required this.authUser,
    @required this.provider,
    @required this.userType,
  });

  final NewUserProvider provider;
  final UserType userType;
  final AuthUser authUser;

  Future<void> creatUser(User user) async {
    user.createdBy = {
      'name': user.name,
      'id': '',
    };
    user.state = 'pending';
    await provider.creatUser(
      user,
      authUser.uid,
    );
  }
}
