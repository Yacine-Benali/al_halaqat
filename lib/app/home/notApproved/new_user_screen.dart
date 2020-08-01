import 'package:al_halaqat/app/common_screens/new_student_form.dart';
import 'package:al_halaqat/app/home/models/user.dart';
import 'package:al_halaqat/app/home/notApproved/new_user_bloc.dart';
import 'package:al_halaqat/app/home/notApproved/new_user_provider.dart';
import 'package:al_halaqat/common_widgets/menu_button_widget.dart';
import 'package:al_halaqat/common_widgets/platform_alert_dialog.dart';
import 'package:al_halaqat/common_widgets/platform_exception_alert_dialog.dart';
import 'package:al_halaqat/services/auth.dart';
import 'package:al_halaqat/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

//! change to user form screen

enum UserType { student, teacher, admin }

class NewUserScreen extends StatefulWidget {
  const NewUserScreen._({
    Key key,
    @required this.bloc,
    this.user,
  }) : super(key: key);

  final NewUserBloc bloc;
  final User user;

  static Widget create({
    @required BuildContext context,
    @required UserType userType,
    User user,
  }) {
    Database database = Provider.of<Database>(context, listen: false);
    AuthUser authUser = Provider.of<AuthUser>(context, listen: false);
    NewUserProvider provider = NewUserProvider(database: database);
    NewUserBloc bloc = NewUserBloc(
      provider: provider,
      userType: userType,
      authUser: authUser,
    );
    return NewUserScreen._(
      bloc: bloc,
      user: user,
    );
  }

  @override
  _NewUserScreenState createState() => _NewUserScreenState();
}

class _NewUserScreenState extends State<NewUserScreen> {
  NewUserBloc get bloc => widget.bloc;
  User get user => widget.user;

  Future<void> _save(User user) async {
    try {
      await bloc.creatUser(user);
      // PlatformAlertDialog(
      //   title: 'نجح الحفظ',
      //   content: 'تم حفظ البيانات',
      //   defaultActionText: 'حسنا',
      // ).show(context);
    } on PlatformException catch (e) {
      // PlatformExceptionAlertDialog(
      //   title: 'فشلت العملية',
      //   exception: e,
      // ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (bloc.userType == UserType.admin) {}
    if (bloc.userType == UserType.teacher) {}
    if (bloc.userType == UserType.student) {
      return NewStudentForm(
        student: user,
        onSaved: (student) => _save(student),
      );
    } else
      return Container();
  }
}
