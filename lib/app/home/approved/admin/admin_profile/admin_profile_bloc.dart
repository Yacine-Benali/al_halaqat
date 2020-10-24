import 'package:alhalaqat/app/home/approved/admin/admin_profile/admin_profile_provider.dart';
import 'package:alhalaqat/app/models/user.dart';
import 'package:alhalaqat/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdminProfileBloc {
  AdminProfileBloc({@required this.provider, @required this.auth});

  final AdminProfileProvider provider;
  final Auth auth;
  Future<void> updateProfile(User oldUser, User newUser) async {
    if (oldUser.username != newUser.username) {
      List<String> testList =
          await auth.fetchSignInMethodsForEmail(email: newUser.username);
      if (testList.contains('password'))
        throw PlatformException(
          code: 'ERROR_USED_USERNAME',
        );
    }
    provider.updateProfile(newUser);
  }
}
