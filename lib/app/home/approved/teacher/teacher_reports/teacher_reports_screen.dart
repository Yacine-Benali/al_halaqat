import 'package:al_halaqat/app/home/approved/common_screens/reports/s_attendance/s_attendance_screen.dart';
import 'package:al_halaqat/app/home/approved/common_screens/reports/s_learning/s_learning_screen.dart';
import 'package:al_halaqat/app/models/teacher.dart';
import 'package:al_halaqat/app/models/user.dart';
import 'package:al_halaqat/common_widgets/menu_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TeacherReportsScreen extends StatefulWidget {
  @override
  _TeacherHomePageState createState() => _TeacherHomePageState();
}

class _TeacherHomePageState extends State<TeacherReportsScreen> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context, listen: false);
    Teacher teacher;
    if (user is Teacher) teacher = user;
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text('تقارير')),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 70.0),
              MenuButtonWidget(
                text: 'حضور الطلاب',
                onPressed: () =>
                    Navigator.of(context, rootNavigator: false).push(
                  MaterialPageRoute(
                    builder: (context) => SAttendanceScreen.create(
                      context: context,
                      halaqatId: teacher.halaqatTeachingIn,
                    ),
                    fullscreenDialog: true,
                  ),
                ),
              ),
              SizedBox(height: 10),
              MenuButtonWidget(
                text: 'حفظ الطلاب',
                onPressed: () =>
                    Navigator.of(context, rootNavigator: false).push(
                  MaterialPageRoute(
                    builder: (context) => SLearningScreen.create(
                      context: context,
                      halaqatId: teacher.halaqatTeachingIn,
                    ),
                    fullscreenDialog: true,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
