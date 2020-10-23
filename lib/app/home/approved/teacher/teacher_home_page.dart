import 'package:alhalaqat/app/home/approved/common_screens/conversation/conversations_screen.dart';
import 'package:alhalaqat/app/home/approved/teacher/teacher_center_request/teacher_center_request_screen.dart';
import 'package:alhalaqat/app/home/approved/teacher/teacher_halaqat/teacher_halaqat_screen.dart';
import 'package:alhalaqat/app/home/approved/teacher/teacher_profile/teacher_profile_screen.dart';
import 'package:alhalaqat/app/home/approved/teacher/teacher_reports/teacher_reports_screen.dart';
import 'package:alhalaqat/app/home/approved/teacher/teacher_students/teacher_students_screen.dart';
import 'package:alhalaqat/app/models/study_center.dart';
import 'package:alhalaqat/app/models/teacher.dart';
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
import 'package:alhalaqat/services/firebase_messaging_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class TeacherHomePage extends StatefulWidget {
  @override
  _TeacherHomePageState createState() => _TeacherHomePageState();
}

class _TeacherHomePageState extends State<TeacherHomePage> {
  Stream<List<StudyCenter>> studyCentersStream;
  Database database;
  List<String> getApprovedCenterIds(Teacher teacher) {
    List<String> approvedCenters = List();
    teacher.centerState.forEach((key, value) {
      if (value == 'approved') approvedCenters.add(key);
    });
    return approvedCenters;
  }

  @override
  initState() {
    database = Provider.of<Database>(context, listen: false);
    Teacher teacher = Provider.of<User>(context, listen: false);
    final User user = Provider.of<User>(context, listen: false);
    FirebaseMessagingService messagingService = FirebaseMessagingService();
    messagingService.configFirebaseNotification(user.id, database);
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
    Teacher teacher = Provider.of<User>(context, listen: true);

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
          FutureBuilder(
            future: FirebaseFirestore.instance.waitForPendingWrites(),
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.done)
                return Container();
              else
                return Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Icon(
                    Icons.cloud_upload,
                    size: 26.0,
                  ),
                );
            },
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: InkWell(
              onTap: () => Navigator.of(context, rootNavigator: false).push(
                MaterialPageRoute(
                  builder: (context) =>
                      TeacherCenterRequestScreen.create(context: context),
                  fullscreenDialog: true,
                ),
              ),
              child: Icon(
                Icons.add,
                size: 26.0,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: InkWell(
              onTap: () => Navigator.of(context, rootNavigator: false).push(
                MaterialPageRoute(
                  builder: (context) =>
                      TeacherProfileScreen.create(context: context),
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
      body: StreamBuilder<List<StudyCenter>>(
          stream: database.collectionStream(
            path: APIPath.centersCollection(),
            builder: (data, documentId) =>
                StudyCenter.fromMap(data, documentId),
            queryBuilder: (query) => query
                .where(
                  FieldPath.documentId,
                  whereIn: getApprovedCenterIds(teacher),
                )
                .where('state', isEqualTo: 'approved'),
          ),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final List<StudyCenter> items = snapshot.data;

              if (items.isNotEmpty) {
                return _buildContent(items, teacher);
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

  Widget _buildContent(List<StudyCenter> items, Teacher teacher) {
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
                  text: 'إدارة الحلقات',
                  onPressed: () async {
                    await Navigator.of(context, rootNavigator: false).push(
                      MaterialPageRoute(
                        builder: (context) => TeacherHalaqatScreen.create(
                          context: context,
                          centers: items,
                        ),
                        fullscreenDialog: true,
                      ),
                    );
                    setState(() {});
                  }),
              SizedBox(height: 10),
              MenuButtonWidget(
                text: ' إدارة الطلاب',
                onPressed: () =>
                    Navigator.of(context, rootNavigator: false).push(
                  MaterialPageRoute(
                    builder: (context) => TeacherStudentsScreen.create(
                      context: context,
                      centers: items,
                    ),
                    fullscreenDialog: true,
                  ),
                ),
              ),
              SizedBox(height: 10),
              MenuButtonWidget(
                  text: 'المحادثات',
                  onPressed: () async {
                    await Navigator.of(context, rootNavigator: false).push(
                      MaterialPageRoute(
                        builder: (context) => ConversationScreen.create(
                          context: context,
                        ),
                        fullscreenDialog: true,
                      ),
                    );
                    setState(() {});
                  }),
              SizedBox(height: 10),
              MenuButtonWidget(
                text: 'التقارير ',
                onPressed: () async =>
                    await Navigator.of(context, rootNavigator: false).push(
                  MaterialPageRoute(
                    builder: (context) => TeacherReportsScreen.create(
                      context: context,
                      halaqatId: teacher.halaqatTeachingIn,
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
