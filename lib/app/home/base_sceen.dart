import 'package:al_halaqat/app/home/approved/admin/admin_home_page.dart';
import 'package:al_halaqat/app/home/approved/archived_deleted_screen.dart';
import 'package:al_halaqat/app/home/approved/globalAdmin/global_admin_home_page.dart';
import 'package:al_halaqat/app/home/approved/student/student_home_page.dart';
import 'package:al_halaqat/app/home/approved/teacher/teacher_home_page.dart';
import 'package:al_halaqat/app/home/notApproved/join_us_screen.dart';
import 'package:al_halaqat/app/home/notApproved/pending_screen.dart';
import 'package:al_halaqat/app/models/admin.dart';
import 'package:al_halaqat/app/models/global_admin.dart';
import 'package:al_halaqat/app/models/student.dart';
import 'package:al_halaqat/app/models/teacher.dart';
import 'package:al_halaqat/app/models/user.dart';
import 'package:al_halaqat/common_widgets/empty_content.dart';
import 'package:al_halaqat/common_widgets/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BaseScreen extends StatelessWidget {
  bool isThereAnApprovedCenter(Map<String, String> centerState) {
    List<String> states = centerState.values.toList();
    bool isThereAnActive = false;
    for (String state in states)
      if (state == 'approved') isThereAnActive = true;
    return isThereAnActive;
  }

  bool isTherePendingCenter(Map<String, String> centerState) {
    List<String> states = centerState.values.toList();
    bool isThereAnActive = false;
    for (String state in states)
      if (state == 'pending' || state == 'pendingWithCenter')
        isThereAnActive = true;
    return isThereAnActive;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    AsyncSnapshot<User> snapshot =
        Provider.of<AsyncSnapshot<User>>(context, listen: false);
    if (snapshot.hasData) {
      final User user = snapshot.data;

      if (user is GlobalAdmin) {
        if (user.state == 'approved')
          return GlobalAdminHomePage();
        else
          return ArchivedDeletedEmptyScreen(user: user);
      } else if (user is Admin) {
        if (isThereAnApprovedCenter(user.centerState)) {
          return AdminHomePage(
            isGlobalAdmin: false,
            centerId: null,
          );
        } else if (isTherePendingCenter(user.centerState)) {
          return PendingScreen();
        } else {
          return ArchivedDeletedEmptyScreen(user: user);
        }
      } else if (user is Teacher) {
        if (isThereAnApprovedCenter(user.centerState)) {
          return TeacherHomePage();
        } else if (isTherePendingCenter(user.centerState)) {
          return PendingScreen();
        } else {
          return ArchivedDeletedEmptyScreen(user: user);
        }
      } else if (user is Student) {
        if (user.state == 'pending') {
          return PendingScreen();
        } else if (user.state == 'approved') {
          return StudentHomePage();
        }
      }
    } else if (snapshot.hasError) {
      return Scaffold(
        body: EmptyContent(
          title: 'Something went wrong',
          message: 'Can\'t load items right now',
        ),
      );
    }
    if (snapshot.connectionState == ConnectionState.active &&
        snapshot.data == null) {
      return JoinUsScreen();
      //return AdminCenterForm();
    }
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
