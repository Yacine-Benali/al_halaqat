import 'package:alhalaqat/app/common_forms/user_info_screen.dart';
import 'package:alhalaqat/app/common_forms/user_provider.dart';
import 'package:alhalaqat/app/models/admin.dart';
import 'package:alhalaqat/app/models/center_request.dart';
import 'package:alhalaqat/app/models/global_admin_request.dart';
import 'package:alhalaqat/app/models/student.dart';
import 'package:alhalaqat/app/models/study_center.dart';
import 'package:alhalaqat/app/models/teacher.dart';
import 'package:alhalaqat/services/auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

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
        id: authUser.uid,
        createdAt: null,
        userId: authUser.uid,
        user: student,
        action: 'join-existing-new',
        state: 'pending',
        halaqa: null,
      );
      student.center = center.id;
      student.state = 'pending';
    } else {
      throw PlatformException(
        code: 'CENTE_DOES_NOT_EXIST',
        message: 'لا يوجد مركز بذلك الرقم التعريفي',
      );
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
        id: authUser.uid,
        createdAt: null,
        userId: authUser.uid,
        user: teacher,
        action: 'join-existing-new',
        state: 'pending',
        halaqa: null,
      );
      teacher.centers[0] = center.id;
      teacher.centerState = {
        '${teacher.centers[0]}': 'pending',
      };
    } else {
      throw PlatformException(
        code: 'CENTE_DOES_NOT_EXIST',
        message: 'لا يوجد مركز بذلك الرقم التعريفي',
      );
    }

    await provider.createTeacherOrStudent(
      teacher,
      authUser.uid,
      joinRequest,
      joinRequestCenterId,
    );
  }

  Future<void> createAdmin(Admin admin) async {
    GlobalAdminRequest joinGlobalAdminRequest;

    admin.createdBy = {
      'name': admin.name,
      'id': authUser.uid,
    };
    admin.centerState = {
      '${admin.centers[0]}': 'pending',
    };
    admin.username = authUser.email;
    admin.password = authUser.password;
    StudyCenter center = await provider.queryCenterbyRId(admin.centers[0]);
    if (center != null) {
      joinGlobalAdminRequest = GlobalAdminRequest(
        id: authUser.uid,
        createdAt: null,
        adminId: authUser.uid,
        admin: admin,
        centerId: center.id,
        center: center,
        action: 'join-existing',
        state: 'pending',
      );
      // change center readable id to the centerid
      admin.centerState = {
        '${center.id}': 'pending',
      };
      admin.centers[0] = center.id;
    } else {
      throw PlatformException(
        code: 'CENTE_DOES_NOT_EXIST',
        message: 'لا يوجد مركز بذلك الرقم التعريفي',
      );
    }

    await provider.createAdmin(
      admin,
      authUser.uid,
      joinGlobalAdminRequest,
      null,
    );
  }

  Future<bool> checkIfNameUnique(
    StudyCenter newcenter,
  ) async {
    List<StudyCenter> duplicate =
        await provider.getCenterByname(newcenter.name);
    for (StudyCenter studyCenter in duplicate)
      if (newcenter.name == studyCenter.name) return true;

    return false;
  }

  Future<void> createAdminAndCenter(Admin admin, StudyCenter center) async {
    GlobalAdminRequest joinGlobalAdminRequest;

    bool isNameDuplicated = await checkIfNameUnique(
      center,
    );
    if (isNameDuplicated)
      throw PlatformException(
        code: 'ERROR_DUPLICATE_NAME',
      );
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

    admin.username = authUser.email;
    admin.password = authUser.password;
    print('password: ${authUser.password}');
    //
    joinGlobalAdminRequest = GlobalAdminRequest(
      id: authUser.uid,
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
