import 'package:al_halaqat/app/home/approved/student/s_profile/s_profile_provider.dart';
import 'package:al_halaqat/app/models/user.dart';
import 'package:flutter/material.dart';

class SProfileBloc {
  SProfileBloc({@required this.provider});

  final SProfileProvider provider;

  Future<void> updateProfile(User user) async => provider.updateProfile(user);
}
