import 'package:alhalaqat/app/home/approved/student/s_profile/s_profile_provider.dart';
import 'package:alhalaqat/app/models/user.dart';
import 'package:alhalaqat/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SProfileBloc {
  SProfileBloc({@required this.provider, @required this.auth});

  final SProfileProvider provider;
  final Auth auth;
  Future<void> updateProfile(User oldUser, User newUSer) async {
    if (oldUser.username != newUSer.username) {
      List<String> testList =
          await auth.fetchSignInMethodsForEmail(email: newUSer.username);
      if (testList.contains('password'))
        throw PlatformException(
          code: 'ERROR_USED_USERNAME',
        );
    }
    provider.updateProfile(newUSer);
  }
}
