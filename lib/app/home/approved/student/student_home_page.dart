import 'package:al_halaqat/app/home/approved/common_screens/conversation/conversations_screen.dart';
import 'package:al_halaqat/app/home/approved/student/s_profile/s_profile_screen.dart';
import 'package:al_halaqat/app/home/approved/student/student_halaqat/student_halaqat_screen.dart';
import 'package:al_halaqat/app/home/approved/student/student_summery/student_summery_screen.dart';
import 'package:al_halaqat/app/models/student.dart';
import 'package:al_halaqat/app/models/study_center.dart';
import 'package:al_halaqat/app/models/user.dart';
import 'package:al_halaqat/common_widgets/empty_content.dart';
import 'package:al_halaqat/common_widgets/menu_button_widget.dart';
import 'package:al_halaqat/common_widgets/platform_alert_dialog.dart';
import 'package:al_halaqat/common_widgets/platform_exception_alert_dialog.dart';
import 'package:al_halaqat/constants/strings.dart';
import 'package:al_halaqat/services/api_path.dart';
import 'package:al_halaqat/services/auth.dart';
import 'package:al_halaqat/services/database.dart';
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

  @override
  initState() {
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
          PopupMenuButton<String>(
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: "حول التطبيق",
                child: Text("حول التطبيق"),
              ),
            ],
            onSelected: (value) => PlatformAlertDialog(
              content:
                  'هذا البرنامج صدقة عن روح المرحومة وفاء خليل صديق نرجو منكم لها الدعاء',
              defaultActionText: 'حسنا',
              title: 'حول التطبيق',
            ).show(context),
          ),
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
                return _buildContent();
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

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 32.0),
              Container(
                height: 100,
                width: 100,
                color: Colors.grey[300],
                child: Center(
                  child: Text(
                    'logo',
                    style: TextStyle(fontSize: 40),
                  ),
                ),
              ),
              SizedBox(height: 50.0),
              SizedBox(height: 10),
              MenuButtonWidget(
                text: ' الحلقات',
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
