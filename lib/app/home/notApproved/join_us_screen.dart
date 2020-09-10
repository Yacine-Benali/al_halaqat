import 'package:al_halaqat/app/common_forms/user_info_screen.dart';
import 'package:al_halaqat/app/models/global_admin.dart';
import 'package:al_halaqat/common_widgets/menu_button_widget.dart';
import 'package:al_halaqat/common_widgets/platform_alert_dialog.dart';
import 'package:al_halaqat/common_widgets/platform_exception_alert_dialog.dart';
import 'package:al_halaqat/services/api_path.dart';
import 'package:al_halaqat/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class JoinUsScreen extends StatefulWidget {
  @override
  _NewUserScreenState createState() => _NewUserScreenState();
}

class _NewUserScreenState extends State<JoinUsScreen> {
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

  void _temp() {
    GlobalAdmin admin = GlobalAdmin(
      id: 'WNSk1ey20IZ1GkwxrBoCTjlqqe53',
      name: 'a',
      dateOfBirth: 1950,
      gender: 'ذكر',
      nationality: 'LB',
      address: 'ga address',
      phoneNumber: 'ga phoneNumber',
      educationalLevel: 'سنة أولى',
      etablissement: 'ga etablissement',
      note: 'ga note',
      readableId: null,
      username: 'a.a',
      password: '123abc',
      createdAt: null,
      createdBy: {
        'name': 'super admin',
        'id': 'super admin Id',
      },
      isGlobalAdmin: true,
      state: 'approved',
    );

    final DocumentReference postRef = FirebaseFirestore.instance
        .doc('/globalConfiguration/globalConfiguration');
    FirebaseFirestore.instance.runTransaction((Transaction tx) async {
      if (admin.readableId == null) {
        DocumentSnapshot postSnapshot = await tx.get(postRef);
        tx.update(postRef, <String, dynamic>{
          'nextUserReadableId': postSnapshot.data()['nextUserReadableId'] + 1
        });
        admin.readableId = postSnapshot.data()['nextUserReadableId'].toString();
      }
      tx.set(
        FirebaseFirestore.instance.document(APIPath.userDocument(admin.id)),
        admin.toMap(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('إنضم إلى حلقات'),
        centerTitle: true,
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
        // actions: [
        //   Padding(
        //     padding: EdgeInsets.only(left: 20.0),
        //     child: InkWell(
        //       onTap: () => _temp(),
        //       child: Icon(
        //         Icons.bug_report,
        //         size: 26.0,
        //       ),
        //     ),
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 100.0),
              MenuButtonWidget(
                text: 'إنظم كمشرف لمركز موجود',
                onPressed: () =>
                    Navigator.of(context, rootNavigator: false).push(
                  MaterialPageRoute(
                    builder: (context) => UserInfoScreen.create(
                      context: context,
                      userType: FormType.admin,
                    ),
                    fullscreenDialog: true,
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              MenuButtonWidget(
                text: 'إنشاء مركز جديد',
                onPressed: () =>
                    Navigator.of(context, rootNavigator: false).push(
                  MaterialPageRoute(
                    builder: (context) => UserInfoScreen.create(
                      context: context,
                      userType: FormType.adminAndCenter,
                    ),
                    fullscreenDialog: true,
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              MenuButtonWidget(
                text: 'إنظم كمعلم',
                onPressed: () =>
                    Navigator.of(context, rootNavigator: false).push(
                  MaterialPageRoute(
                    builder: (context) => UserInfoScreen.create(
                      context: context,
                      userType: FormType.teacher,
                    ),
                    fullscreenDialog: true,
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              MenuButtonWidget(
                text: 'إنظم كطالب',
                onPressed: () =>
                    Navigator.of(context, rootNavigator: false).push(
                  MaterialPageRoute(
                    builder: (context) => UserInfoScreen.create(
                      context: context,
                      userType: FormType.student,
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
