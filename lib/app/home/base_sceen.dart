import 'package:al_halaqat/app/home/models/user.dart';
import 'package:al_halaqat/app/home/notApproved/join_us_screen.dart';
import 'package:al_halaqat/app/home/notApproved/pending_screen.dart';
import 'package:al_halaqat/common_widgets/empty_content.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BaseScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AsyncSnapshot<User> snapshot =
        Provider.of<AsyncSnapshot<User>>(context, listen: false);

    if (snapshot.hasData) {
      final User user = snapshot.data;
      if (user.state == 'pending') {
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
    }
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
