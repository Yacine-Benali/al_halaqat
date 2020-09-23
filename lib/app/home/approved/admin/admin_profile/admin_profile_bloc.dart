import 'package:alhalaqat/app/home/approved/admin/admin_profile/admin_profile_provider.dart';
import 'package:alhalaqat/app/models/user.dart';
import 'package:flutter/material.dart';

class AdminProfileBloc {
  AdminProfileBloc({@required this.provider});

  final AdminProfileProvider provider;

  Future<void> updateProfile(User user) async => provider.updateProfile(user);
}
