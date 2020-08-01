import 'package:al_halaqat/app/home/models/student.dart';
import 'package:al_halaqat/app/home/models/user.dart';
import 'package:al_halaqat/app/common_screens/user_info_screen.dart';
import 'package:al_halaqat/common_widgets/empty_content.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PendingScreen extends StatefulWidget {
  @override
  _PendingScreenState createState() => _PendingScreenState();
}

class _PendingScreenState extends State<PendingScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<User>(
      builder: (BuildContext context, user, Widget child) {
        UserType userType;
        if (user is Student) userType = UserType.student;

        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('fill info'),
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: InkWell(
                  onTap: () => Navigator.of(context, rootNavigator: false).push(
                    MaterialPageRoute(
                      builder: (context) => UserInfoScreen.create(
                        context: context,
                        userType: UserType.student,
                        user: user,
                      ),
                      fullscreenDialog: true,
                    ),
                  ),
                  child: Icon(
                    Icons.edit,
                    size: 26.0,
                  ),
                ),
              ),
            ],
          ),
          body: EmptyContent(
            title: 'طلبك قيد المراجعة',
            message: 'يرجى الإنتظار',
          ),
        );
      },
    );
  }
}
