import 'package:al_halaqat/app/models/admin.dart';
import 'package:al_halaqat/app/models/center_request.dart';
import 'package:al_halaqat/app/models/global_admin_request.dart';
import 'package:al_halaqat/app/models/study_center.dart';
import 'package:al_halaqat/app/models/teacher.dart';
import 'package:al_halaqat/app/models/user.dart';
import 'package:al_halaqat/app/common_screens/user_provider.dart';
import 'package:al_halaqat/app/common_screens/user_info_screen.dart';
import 'package:al_halaqat/services/auth.dart';
import 'package:flutter/foundation.dart';

class UserBloc {
  UserBloc({
    @required this.authUser,
    @required this.provider,
    @required this.userType,
  });

  final UserProvider provider;
  final FormType userType;
  final AuthUser authUser;

  Future<void> createTeacherOrStudent(User user) async {
    int createdAt = DateTime.now().millisecondsSinceEpoch;
    String userRole;
    String joinRequestCenterId;
    CenterRequest joinRequest;

    user.email = authUser.email;
    user.createdAt = createdAt;
    if (user is Teacher) {
      userRole = 'admin';
    } else
      userRole = 'student';

    user.createdBy = {
      'name': user.name,
      'id': authUser.uid,
    };
    user.centerState = {
      '${user.centers[0]}': 'pending',
    };
    StudyCenter center = await provider.queryCenterbyRId(user.centers[0]);
    if (center != null) {
      joinRequestCenterId = center.id;
      joinRequest = CenterRequest(
        id: 'join' + authUser.uid,
        createdAt: createdAt,
        userId: authUser.uid,
        userRole: userRole,
        userName: user.name,
        userNationality: user.nationality,
        action: 'join',
        state: 'pending',
        object: null,
      );
      // change center readable id to the centerid

    }

    await provider.createTeacherOrStudent(
      user,
      authUser.uid,
      joinRequest,
      joinRequestCenterId,
    );
  }

  Future<void> createAdmin(User user) async {
    int createdAt = DateTime.now().millisecondsSinceEpoch;
    GlobalAdminRequest joinGlobalAdminRequest;

    user.email = authUser.email;
    user.createdAt = createdAt;

    user.createdBy = {
      'name': user.name,
      'id': authUser.uid,
    };
    user.centerState = {
      '${user.centers[0]}': 'pending',
    };
    StudyCenter center = await provider.queryCenterbyRId(user.centers[0]);
    if (center != null) {
      joinGlobalAdminRequest = GlobalAdminRequest(
        id: 'join' + authUser.uid,
        createdAt: createdAt,
        adminId: authUser.uid,
        adminName: user.name,
        adminNationality: user.nationality,
        action: 'join',
        centerId: center.id,
        centerName: center.name,
        state: 'pending',
      );
      // change center readable id to the centerid

    }

    await provider.createAdmin(
      user,
      authUser.uid,
      joinGlobalAdminRequest,
    );
  }

  Future<void> createAdminAndCenter(Admin admin, StudyCenter center) async {
    admin.createdBy = {
      'name': admin.name,
      'id': authUser.uid,
    };
    admin.email = authUser.email;

    center.createdBy = {'name': admin.name, 'id': admin.id};
    center.createdAt = DateTime.now().millisecondsSinceEpoch;
    if (center.id == null) center.id = provider.getUniqueId();
    //
    admin.centers[0] = center.id;
    admin.createdAt = DateTime.now().millisecondsSinceEpoch;
    //
    // await provider.createUser(admin, authUser.uid);
    // await provider.createCenter(center, center.id);
  }

  Future<StudyCenter> getCenter(String centerId) async =>
      await provider.getCenter(centerId);
}
