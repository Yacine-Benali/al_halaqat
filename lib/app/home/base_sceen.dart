import 'package:al_halaqat/app/common_screens/admin_center_form.dart';
import 'package:al_halaqat/app/home/approved/admin/admin_home_page.dart';
import 'package:al_halaqat/app/home/approved/globalAdmin/global_admin_home_page.dart';
import 'package:al_halaqat/app/models/admin.dart';
import 'package:al_halaqat/app/models/global_admin.dart';
import 'package:al_halaqat/app/models/teacher.dart';
import 'package:al_halaqat/app/models/user.dart';
import 'package:al_halaqat/app/home/notApproved/join_us_screen.dart';
import 'package:al_halaqat/app/home/notApproved/pending_screen.dart';
import 'package:al_halaqat/common_widgets/empty_content.dart';
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

  @override
  Widget build(BuildContext context) {
    AsyncSnapshot<User> snapshot =
        Provider.of<AsyncSnapshot<User>>(context, listen: false);
    if (snapshot.hasData) {
      final User user = snapshot.data;

      if (user is GlobalAdmin) {
        return GlobalAdminHomePage();
      }
      if (user is Admin) {
        if (!isThereAnApprovedCenter(user.centerState)) {
          return AdminHomePage();
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
