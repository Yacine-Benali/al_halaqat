import 'package:al_halaqat/app/common_screens/new_student_form.dart';
import 'package:al_halaqat/app/home/models/user.dart';
import 'package:al_halaqat/common_widgets/menu_button_widget.dart';
import 'package:flutter/material.dart';

class NewUserScreen extends StatefulWidget {
  const NewUserScreen({Key key, @required this.userType}) : super(key: key);

  final String userType;

  @override
  _NewUserScreenState createState() => _NewUserScreenState();
}

class _NewUserScreenState extends State<NewUserScreen> {
  String get userType => widget.userType;

  void _save(User user) {}
  @override
  Widget build(BuildContext context) {
    if (userType == 'admin') {}
    if (userType == 'teacher') {}
    if (userType == 'student') {
      return NewStudentForm();
    } else
      return Container();
  }
}
