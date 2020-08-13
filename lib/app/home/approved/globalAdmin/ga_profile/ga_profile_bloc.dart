import 'package:al_halaqat/app/home/approved/globalAdmin/ga_profile/ga_profile_provider.dart';
import 'package:al_halaqat/app/models/global_admin.dart';
import 'package:flutter/material.dart';

class GaProfileBloc {
  GaProfileBloc({@required this.provider});

  final GaProfileProvider provider;

  Future<void> updateProfile(GlobalAdmin globalAdmin) async =>
      provider.updateProfile(globalAdmin);
}
