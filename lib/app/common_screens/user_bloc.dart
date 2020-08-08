import 'package:al_halaqat/app/models/admin.dart';
import 'package:al_halaqat/app/models/center_request.dart';
import 'package:al_halaqat/app/models/global_admin_request.dart';
import 'package:al_halaqat/app/models/study_center.dart';
import 'package:al_halaqat/app/models/teacher.dart';
import 'package:al_halaqat/app/models/user.dart';
import 'package:al_halaqat/app/common_screens/user_provider.dart';
import 'package:al_halaqat/app/common_screens/user_info_screen.dart';
import 'package:al_halaqat/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    String userRole;
    String joinRequestCenterId;
    CenterRequest joinRequest;

    user.email = authUser.email;
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
        id: 'join-' + authUser.uid,
        createdAt: null,
        userId: authUser.uid,
        user: user,
        action: 'join',
        state: 'pending',
        halaqaId: null,
        halaqaName: null,
      );
      user.centers[0] = center.id;
      user.centerState = {
        '${user.centers[0]}': 'pending',
      };
    }

    await provider.createTeacherOrStudent(
      user,
      authUser.uid,
      joinRequest,
      joinRequestCenterId,
    );
  }

  Future<void> createAdmin(User user) async {
    GlobalAdminRequest joinGlobalAdminRequest;

    user.email = authUser.email;

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
        id: 'signup-' + authUser.uid,
        createdAt: null,
        adminId: authUser.uid,
        admin: user,
        centerId: center.id,
        center: center,
        action: 'join-existing',
        state: 'pending',
      );
      // change center readable id to the centerid
      user.centerState = {
        '${center.id}': 'pending',
      };
      user.centers[0] = center.id;
    }

    await provider.createAdmin(
      user,
      authUser.uid,
      joinGlobalAdminRequest,
      null,
    );
  }

  Future<void> createAdminAndCenter(Admin admin, StudyCenter center) async {
    GlobalAdminRequest joinGlobalAdminRequest;

    admin.email = authUser.email;

    admin.createdBy = {
      'name': admin.name,
      'id': authUser.uid,
    };
    if (center.id == null) center.id = provider.getUniqueId();

    admin.centerState = {
      '${center.id}': 'pendingWithCenter',
    };
    admin.centers[0] = center.id;
    //
    center.state = 'pending';
    center.createdBy = {
      'name': admin.name,
      'id': authUser.uid,
    };
    //
    joinGlobalAdminRequest = GlobalAdminRequest(
      id: 'signup-' + authUser.uid,
      createdAt: null,
      adminId: authUser.uid,
      admin: admin,
      centerId: center.id,
      center: center,
      action: 'join-new',
      state: 'pending',
    );

    await provider.createAdmin(
      admin,
      authUser.uid,
      joinGlobalAdminRequest,
      center,
    );
  }

  Future<StudyCenter> getCenter(String centerId) async =>
      await provider.getCenter(centerId);
}
