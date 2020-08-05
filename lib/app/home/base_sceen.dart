import 'package:al_halaqat/app/common_screens/admin_center_form.dart';
import 'package:al_halaqat/app/home/models/user.dart';
import 'package:al_halaqat/app/home/notApproved/join_us_screen.dart';
import 'package:al_halaqat/app/home/notApproved/pending_screen.dart';
import 'package:al_halaqat/common_widgets/empty_content.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BaseScreen extends StatelessWidget {
  bool isThereAnActiveCenter(Map<String, String> centerState) {
    List<String> states = centerState.values.toList();
    bool isThereAnActive = false;
    for (String state in states) if (state == 'active') isThereAnActive = true;
    return isThereAnActive;
  }

  @override
  Widget build(BuildContext context) {
    AsyncSnapshot<User> snapshot =
        Provider.of<AsyncSnapshot<User>>(context, listen: false);

    if (snapshot.hasData) {
      final User user = snapshot.data;
      if (!isThereAnActiveCenter(user.centerState)) {
        return PendingScreen();
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
