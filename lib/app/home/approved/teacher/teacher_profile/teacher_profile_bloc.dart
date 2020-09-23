import 'package:alhalaqat/app/home/approved/teacher/teacher_profile/teacher_profile_provider.dart';
import 'package:alhalaqat/app/models/user.dart';
import 'package:flutter/material.dart';

class TeacherProfileBloc {
  TeacherProfileBloc({@required this.provider});

  final TeacherProfileProvider provider;

  Future<void> updateProfile(User user) async => provider.updateProfile(user);
}
