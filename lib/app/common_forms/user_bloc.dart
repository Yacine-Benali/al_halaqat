import 'package:al_halaqat/app/models/admin.dart';
import 'package:al_halaqat/app/models/center_request.dart';
import 'package:al_halaqat/app/models/global_admin_request.dart';
import 'package:al_halaqat/app/models/student.dart';
import 'package:al_halaqat/app/models/study_center.dart';
import 'package:al_halaqat/app/models/teacher.dart';
import 'package:al_halaqat/app/models/user.dart';
import 'package:al_halaqat/app/common_forms/user_provider.dart';
import 'package:al_halaqat/app/common_forms/user_info_screen.dart';
import 'package:al_halaqat/services/auth.dart';
import 'package:flutter/foundation.dart';

//! cant send request to not active centrs
class UserBloc {
  UserBloc({
    @required this.authUser,
    @required this.provider,
    @required this.userType,
  });

  final UserProvider provider;
  final FormType userType;
  final AuthUser authUser;

  Future<void> createStudent(Student student) async {
    String joinRequestCenterId;
    CenterRequest joinRequest;
    if (student.createdBy.isEmpty) {
      student.createdBy = {
        'name': student.name,
        'id': authUser.uid,
      };
      student.username = authUser.email;
      student.password = authUser.password;
    }

    StudyCenter center = await provider.queryCenterbyRId(student.center);

    student.state = 'pending';

    if (center != null) {
      joinRequestCenterId = center.id;
      joinRequest = CenterRequest(
        id: 'join-' + authUser.uid,
        createdAt: null,
        userId: authUser.uid,
        user: student,
        action: 'join-existing',
        state: 'pending',
        halaqa: null,
      );
      student.center = center.id;
      student.state = 'pending';
    }

    await provider.createTeacherOrStudent(
      student,
      authUser.uid,
      joinRequest,
      joinRequestCenterId,
    );
  }

  Future<void> createTeacher(Teacher teacher) async {
    String joinRequestCenterId;
    CenterRequest joinRequest;
    if (teacher.createdBy.isEmpty) {
      teacher.createdBy = {
        'name': teacher.name,
        'id': authUser.uid,
      };
      teacher.username = authUser.email;
      teacher.password = authUser.password;
    }

    StudyCenter center = await provider.queryCenterbyRId(teacher.centers[0]);

    if (teacher.centerState.isEmpty) {
      teacher.centerState = {
        '${teacher.centers[0]}': 'pending',
      };
    }

    if (center != null) {
      joinRequestCenterId = center.id;
      joinRequest = CenterRequest(
        id: 'join-' + authUser.uid,
        createdAt: null,
        userId: authUser.uid,
        user: teacher,
        action: 'join-existing',
        state: 'pending',
        halaqa: null,
      );
      teacher.centers[0] = center.id;
      teacher.centerState = {
        '${teacher.centers[0]}': 'pending',
      };
    }

    await provider.createTeacherOrStudent(
      teacher,
      authUser.uid,
      joinRequest,
      joinRequestCenterId,
    );
  }

  Future<void> createAdmin(Admin user) async {
    GlobalAdminRequest joinGlobalAdminRequest;

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
