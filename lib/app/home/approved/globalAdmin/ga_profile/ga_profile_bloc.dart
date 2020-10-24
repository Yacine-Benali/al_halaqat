import 'package:alhalaqat/app/home/approved/globalAdmin/ga_profile/ga_profile_provider.dart';
import 'package:alhalaqat/app/models/global_admin.dart';
import 'package:alhalaqat/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GaProfileBloc {
  GaProfileBloc({@required this.provider, @required this.auth});

  final GaProfileProvider provider;
  final Auth auth;

  Future<void> updateProfile(
      GlobalAdmin oldGlobalAdmin, GlobalAdmin newGlobalAdmin) async {
    if (oldGlobalAdmin.username != newGlobalAdmin.username) {
      List<String> testList =
          await auth.fetchSignInMethodsForEmail(email: newGlobalAdmin.username);
      if (testList.contains('password'))
        throw PlatformException(
          code: 'ERROR_USED_USERNAME',
        );
    }
    provider.updateProfile(newGlobalAdmin);
  }
}
