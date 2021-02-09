import 'package:alhalaqat/app/home/approved/common_screens/conversation/conversations_screen.dart';
import 'package:alhalaqat/app/home/approved/student/organizer_halaqat/organizer_halaqat_screen.dart';
import 'package:alhalaqat/app/home/approved/student/s_profile/s_profile_screen.dart';
import 'package:alhalaqat/app/home/approved/student/student_halaqat/student_halaqat_screen.dart';
import 'package:alhalaqat/app/home/approved/student/student_summery/student_summery_screen.dart';
import 'package:alhalaqat/app/models/student.dart';
import 'package:alhalaqat/app/models/study_center.dart';
import 'package:alhalaqat/app/models/user.dart';
import 'package:alhalaqat/common_widgets/empty_content.dart';
import 'package:alhalaqat/common_widgets/home_screen_popup.dart';
import 'package:alhalaqat/common_widgets/logo.dart';
import 'package:alhalaqat/common_widgets/menu_button_widget.dart';
import 'package:alhalaqat/common_widgets/platform_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/platform_exception_alert_dialog.dart';
import 'package:alhalaqat/constants/strings.dart';
import 'package:alhalaqat/services/api_path.dart';
import 'package:alhalaqat/services/auth.dart';
import 'package:alhalaqat/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'student_halaqat/student_halaqat_screen.dart';

class StudentHomePage extends StatefulWidget {
  @override
  _StudentHomePageState createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  Stream<List<StudyCenter>> studyCentersStream;
  Database database;
  Student student;
  bool isOrganizer;

  @override
  initState() {
    isOrganizer = false;
    student = Provider.of<User>(context, listen: false);
    database = Provider.of<Database>(context, listen: false);

    super.initState();
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      final Auth auth = Provider.of<Auth>(context, listen: false);
      await auth.signOut();
    } on PlatformException catch (e) {
      await PlatformExceptionAlertDialog(
        title: Strings.logoutFailed,
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
    student = Provider.of<User>(context, listen: false);
    if (student.halaqatOrganizingIn != null) {
      if (student.halaqatOrganizingIn.length > 0)
        isOrganizer = true;
      else
        isOrganizer = false;
    }
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('')),
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
        actions: [
          HomeScreenPopUp(),
          Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: InkWell(
              onTap: () => Navigator.of(context, rootNavigator: false).push(
                MaterialPageRoute(
                  builder: (context) => SProfileScreen.create(context: context),
                  fullscreenDialog: true,
                ),
              ),
              child: Icon(
                Icons.account_circle,
                size: 26.0,
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder<StudyCenter>(
          stream: database.documentStream(
            path: APIPath.centerDocument(student.center),
            builder: (data, documentId) =>
                StudyCenter.fromMap(data, documentId),
          ),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final StudyCenter item = snapshot.data;

              if (item.state == 'approved') {
                return _buildContent(item);
              } else {
                return EmptyContent(
                  title: Strings.yourCenterisArchived,
                  message: '',
                );
              }
            } else if (snapshot.hasError) {
              return EmptyContent(
                title: 'Something went wrong',
                message: 'Can\'t load items right now',
              );
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }

  Widget _buildContent(StudyCenter item) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 32.0),
              Logo(),
              SizedBox(height: 30.0),
              MenuButtonWidget(
                text: ' الحلقات كطالب',
                onPressed: () async =>
                    await Navigator.of(context, rootNavigator: false).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        StudentHalaqatScreen.create(context: context),
                    fullscreenDialog: true,
                  ),
                ),
              ),
              SizedBox(height: 10),
              if (isOrganizer) ...[
                MenuButtonWidget(
                  text: 'الحلقات كمساعد',
                  onPressed: () async =>
                      await Navigator.of(context, rootNavigator: false).push(
                    MaterialPageRoute(
                      builder: (context) => OrganizerHalaqatScreen.create(
                          context: context, studyCenter: item),
                      fullscreenDialog: true,
                    ),
                  ),
                ),
                SizedBox(height: 10),
              ],
              MenuButtonWidget(
                text: ' ملخص الحفظ',
                onPressed: () async =>
                    await Navigator.of(context, rootNavigator: false).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        StudentSummeryScreen.create(context: context),
                    fullscreenDialog: true,
                  ),
                ),
              ),
              SizedBox(height: 10),
              MenuButtonWidget(
                text: 'المحادثات',
                onPressed: () =>
                    Navigator.of(context, rootNavigator: false).push(
                  MaterialPageRoute(
                    builder: (context) => ConversationScreen.create(
                      context: context,
                    ),
                    fullscreenDialog: true,
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
