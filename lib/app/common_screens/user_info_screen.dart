import 'package:al_halaqat/app/common_screens/admin_form.dart';
import 'package:al_halaqat/app/common_screens/student_form.dart';
import 'package:al_halaqat/app/common_screens/teacher_form.dart';
import 'package:al_halaqat/app/models/admin.dart';
import 'package:al_halaqat/app/models/study_center.dart';
import 'package:al_halaqat/app/models/user.dart';
import 'package:al_halaqat/app/common_screens/user_bloc.dart';
import 'package:al_halaqat/app/common_screens/user_provider.dart';
import 'package:al_halaqat/common_widgets/menu_button_widget.dart';
import 'package:al_halaqat/common_widgets/platform_alert_dialog.dart';
import 'package:al_halaqat/common_widgets/platform_exception_alert_dialog.dart';
import 'package:al_halaqat/services/auth.dart';
import 'package:al_halaqat/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:al_halaqat/app/common_screens/admin_center_form.dart';

//! change to user form screen

enum FormType { student, teacher, admin, adminAndCenter }

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen._({
    Key key,
    @required this.bloc,
    @required this.userType,
    this.user,
  }) : super(key: key);

  final UserBloc bloc;
  final User user;
  final FormType userType;

  static Widget create({
    @required BuildContext context,
    @required FormType userType,
    User user,
    StudyCenter center,
  }) {
    Database database = Provider.of<Database>(context, listen: false);
    AuthUser authUser = Provider.of<AuthUser>(context, listen: false);
    UserProvider provider = UserProvider(database: database);
    UserBloc bloc = UserBloc(
      provider: provider,
      userType: userType,
      authUser: authUser,
    );
    return Provider<UserBloc>.value(
      value: bloc,
      child: UserInfoScreen._(
        bloc: bloc,
        user: user,
        userType: userType,
      ),
    );
  }

  @override
  _NewUserScreenState createState() => _NewUserScreenState();
}

class _NewUserScreenState extends State<UserInfoScreen> {
  UserBloc get bloc => widget.bloc;

  Future<void> _save(User user, BuildContext context) async {
    try {
      if (widget.userType == FormType.student ||
          widget.userType == FormType.teacher) {
        print('creat student or teacher');
        await bloc.createTeacherOrStudent(user);
      } else {
        await bloc.createAdmin(user);
      }

      PlatformAlertDialog(
        title: 'نجح الحفظ',
        content: 'تم حفظ البيانات',
        defaultActionText: 'حسنا',
      ).show(context);
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'فشلت العملية',
        exception: e,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (bloc.userType == FormType.adminAndCenter)
      return AdminCenterForm(
        admin: widget.user,
      );
    if (bloc.userType == FormType.admin)
      return AdminForm(
        admin: widget.user,
        onSavedAdmin: (admin) => _save(admin, context),
        callback: () {},
        includeCenterForm: false,
      );
    if (bloc.userType == FormType.teacher)
      return TeacherForm(
        teacher: widget.user,
        onSaved: (teacher) => _save(teacher, context),
      );

    if (bloc.userType == FormType.student)
      return StudentForm(
        student: widget.user,
        onSaved: (student) => _save(student, context),
      );
    else
      return Container();
  }
}
