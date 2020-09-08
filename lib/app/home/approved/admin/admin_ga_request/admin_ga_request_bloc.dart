import 'package:al_halaqat/app/home/approved/admin/admin_ga_request/admin_ga_request_provider.dart';
import 'package:al_halaqat/app/models/admin.dart';
import 'package:al_halaqat/app/models/global_admin_request.dart';
import 'package:al_halaqat/app/models/study_center.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdminGaRequestBloc {
  AdminGaRequestBloc({
    @required this.provider,
    @required this.admin,
  });

  final AdminGaRequestProvider provider;
  final Admin admin;

  Future<void> sendJoinRequest(String centerReadableId) async {
    List<String> centersIdList = admin.centerState.keys.toList();

    StudyCenter center = await provider.queryCenterbyRId(centerReadableId);
    if (center == null) {
      throw PlatformException(
        code: 'CENTE_DOES_NOT_EXIST',
        message: 'لا يوجد مركز بذلك الرقم التعريفي',
      );
    } else if (centersIdList.contains(center.id)) {
      return;
    } else {
      admin.centerState[center.id] = 'pending';
      GlobalAdminRequest gaRequest = GlobalAdminRequest(
        id: 'join-' + provider.getUniqueId(),
        createdAt: null,
        adminId: admin.id,
        admin: admin,
        action: 'join-existing',
        centerId: center.id,
        center: center,
        state: 'pending',
      );

      await provider.sendJoinRequest(admin, gaRequest);
    }
  }
}
