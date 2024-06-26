import 'package:alhalaqat/app/home/approved/supervisor/supervisor_halaqat/supervisor_halaqat_screen.dart';
import 'package:alhalaqat/app/home/approved/supervisor/supervisor_profile/teacher_profile_screen.dart';
import 'package:alhalaqat/app/home/approved/supervisor/supervisor_reports/supervisor_reports_screen.dart';
import 'package:alhalaqat/app/home/approved/supervisor/supervisor_students/supervisor_students_screen.dart';
import 'package:alhalaqat/app/models/study_center.dart';
import 'package:alhalaqat/app/models/supervisor.dart';
import 'package:alhalaqat/app/models/user.dart';
import 'package:alhalaqat/common_widgets/center_drop_down.dart';
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
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SupervisorHomePage extends StatefulWidget {
  @override
  _SupervisorHomePageState createState() => _SupervisorHomePageState();
}

class _SupervisorHomePageState extends State<SupervisorHomePage> {
  Stream<List<StudyCenter>> studyCentersStream;
  Database database;
  StudyCenter chosenCenter;

  List<String> getApprovedCenterIds(Supervisor supervisor) {
    List<String> approvedCenters = List();
    supervisor.centerState.forEach((key, value) {
      if (value == 'approved') approvedCenters.add(key);
    });
    return approvedCenters;
  }

  @override
  initState() {
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
    Supervisor supervisor = Provider.of<User>(context, listen: true);

    return StreamBuilder<List<StudyCenter>>(
      stream: database.collectionStream(
        path: APIPath.centersCollection(),
        builder: (data, documentId) => StudyCenter.fromMap(data, documentId),
        queryBuilder: (query) => query
            .where(
              FieldPath.documentId,
              whereIn: getApprovedCenterIds(supervisor),
            )
            .where('state', isEqualTo: 'approved'),
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<StudyCenter> items = snapshot.data;
          if (items.isNotEmpty) {
            return Scaffold(
              appBar: _buildAppBar(items),
              body: _buildContent(items, supervisor),
            );
          } else {
            return Scaffold(
              appBar: AppBar(),
              body: EmptyContent(
                title: Strings.yourCenterisArchived,
                message: '',
              ),
            );
          }
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(),
            body: EmptyContent(
              title: 'Something went wrong',
              message: 'Can\'t load items right now',
            ),
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildAppBar(List<StudyCenter> centers) {
    return AppBar(
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
        CenterDropDown(
          centers: centers,
          onChanged: (center) {
            chosenCenter = center;
          },
        ),
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
        // Padding(
        //   padding: EdgeInsets.only(left: 20.0),
        //   child: InkWell(
        //     onTap: () => Navigator.of(context, rootNavigator: false).push(
        //       MaterialPageRoute(
        //         builder: (context) =>
        //             SupervisorCenterRequestScreen.create(context: context),
        //         fullscreenDialog: true,
        //       ),
        //     ),
        //     child: Icon(
        //       Icons.add,
        //       size: 26.0,
        //     ),
        //   ),
        // ),
        Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: InkWell(
            onTap: () => Navigator.of(context, rootNavigator: false).push(
              MaterialPageRoute(
                builder: (context) =>
                    SupervisorProfileScreen.create(context: context),
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
    );
  }

  Widget _buildContent(List<StudyCenter> items, Supervisor supervisor) {
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
                        builder: (context) => SupervisorHalaqatScreen.create(
                          context: context,
                          center: chosenCenter,
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
                    builder: (context) => SupervisorStudentsScreen.create(
                      context: context,
                      center: chosenCenter,
                    ),
                    fullscreenDialog: true,
                  ),
                ),
              ),
              SizedBox(height: 10),
              MenuButtonWidget(
                text: 'التقارير ',
                onPressed: () async =>
                    await Navigator.of(context, rootNavigator: false).push(
                  MaterialPageRoute(
                    builder: (context) => SupervisorReportsScreen.create(
                      context: context,
                      halaqatId: supervisor.halaqatSupervisingIn,
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
