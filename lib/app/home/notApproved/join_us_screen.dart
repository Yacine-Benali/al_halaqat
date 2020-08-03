import 'package:al_halaqat/app/common_screens/user_info_screen.dart';
import 'package:al_halaqat/common_widgets/menu_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:al_halaqat/app/common_screens/center_form.dart';

class JoinUsScreen extends StatefulWidget {
  @override
  _NewUserScreenState createState() => _NewUserScreenState();
}

class _NewUserScreenState extends State<JoinUsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('إنضم إلى حلقات'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 100.0),
              MenuButtonWidget(
                text: 'كمشرف',
                onPressed: () =>
                    Navigator.of(context, rootNavigator: false).push(
                  MaterialPageRoute(
                    builder: (context) => UserInfoScreen.create(
                      context: context,
                      userType: UserType.admin,
                    ),
                    fullscreenDialog: true,
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              MenuButtonWidget(
                text: 'كمعلم',
                onPressed: () =>
                    Navigator.of(context, rootNavigator: false).push(
                  MaterialPageRoute(
                    builder: (context) => UserInfoScreen.create(
                      context: context,
                      userType: UserType.teacher,
                    ),
                    fullscreenDialog: true,
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              MenuButtonWidget(
                text: 'كطالب',
                onPressed: () =>
                    Navigator.of(context, rootNavigator: false).push(
                  MaterialPageRoute(
                    builder: (context) => UserInfoScreen.create(
                      context: context,
                      userType: UserType.student,
                    ),
                    fullscreenDialog: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
