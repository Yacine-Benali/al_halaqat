import 'package:al_halaqat/app/models/admin.dart';
import 'package:al_halaqat/app/models/student.dart';
import 'package:al_halaqat/app/models/teacher.dart';
import 'package:al_halaqat/app/models/user.dart';
import 'package:al_halaqat/app/common_screens/user_info_screen.dart';
import 'package:al_halaqat/common_widgets/empty_content.dart';
import 'package:al_halaqat/common_widgets/platform_alert_dialog.dart';
import 'package:al_halaqat/common_widgets/platform_exception_alert_dialog.dart';
import 'package:al_halaqat/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class PendingScreen extends StatefulWidget {
  @override
  _PendingScreenState createState() => _PendingScreenState();
}

class _PendingScreenState extends State<PendingScreen> {
  Future<void> _signOut(BuildContext context) async {
    try {
      final Auth auth = Provider.of<Auth>(context, listen: false);
      await auth.signOut();
    } on PlatformException catch (e) {
      await PlatformExceptionAlertDialog(
        title: 'Strings.logoutFailed',
        exception: e,
      ).show(context);
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final bool didRequestSignOut = await PlatformAlertDialog(
      title: 'تسجيل الخروج',
      content: 'هل أنت متأكد ؟',
      cancelActionText: 'إلغاء',
      defaultActionText: 'حسنا',
    ).show(context);
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<User>(
      builder: (BuildContext context, user, Widget child) {
        FormType userType;
        if (user is Teacher) userType = FormType.teacher;
        if (user is Student) userType = FormType.student;
        if (user is Admin) userType = FormType.admin;
        // if (user is Admin && user.centers.isNotEmpty)
        //   userType = FormType.adminAndCenter;

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
                        userType: userType,
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
            leading: Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: InkWell(
                onTap: () => _confirmSignOut(context),
                child: Icon(
                  Icons.exit_to_app,
                  size: 26.0,
                ),
              ),
            ),
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
