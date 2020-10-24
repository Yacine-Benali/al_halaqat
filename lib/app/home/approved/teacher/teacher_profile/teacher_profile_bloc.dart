import 'package:alhalaqat/app/home/approved/teacher/teacher_profile/teacher_profile_provider.dart';
import 'package:alhalaqat/app/models/user.dart';
import 'package:alhalaqat/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TeacherProfileBloc {
  TeacherProfileBloc({@required this.provider, @required this.auth});

  final TeacherProfileProvider provider;
  final Auth auth;

  Future<void> updateProfile(User oldUser, User newUser) async {
    if (newUser.username != oldUser.username) {
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
