import 'package:al_halaqat/app/home/approved/globalAdmin/ga_admins/ga_admins_provider.dart';
import 'package:al_halaqat/app/home/approved/globalAdmin/ga_centers/ga_centers_provider.dart';
import 'package:al_halaqat/app/models/study_center.dart';
import 'package:al_halaqat/app/models/user.dart';
import 'package:flutter/foundation.dart';

class GaAdminsBloc {
  GaAdminsBloc({
    @required this.provider,
  });
  final GaAdminsProvider provider;
}
