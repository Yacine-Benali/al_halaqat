import 'package:al_halaqat/app/home/approved/admin/admin_students/admin_students_screen.dart';
import 'package:al_halaqat/app/home/approved/globalAdmin/ga_admins/ga_admins_screen.dart';
import 'package:al_halaqat/app/home/approved/globalAdmin/ga_centers/ga_centers_screen.dart';
import 'package:al_halaqat/app/home/approved/globalAdmin/ga_global_admins/ga_global_admins_screen.dart';
import 'package:al_halaqat/app/home/approved/globalAdmin/ga_requests/ga_requests_screen.dart';
import 'package:al_halaqat/app/models/admin.dart';
import 'package:al_halaqat/app/models/study_center.dart';
import 'package:al_halaqat/app/models/user.dart';
import 'package:al_halaqat/common_widgets/empty_content.dart';
import 'package:al_halaqat/common_widgets/menu_button_widget.dart';
import 'package:al_halaqat/common_widgets/platform_alert_dialog.dart';
import 'package:al_halaqat/common_widgets/platform_exception_alert_dialog.dart';
import 'package:al_halaqat/services/api_path.dart';
import 'package:al_halaqat/services/auth.dart';
import 'package:al_halaqat/services/database.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AdminHomePage extends StatefulWidget {
  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  Stream<List<StudyCenter>> studyCentersStream;
  Future<List<StudyCenter>> centersListFuture;
  @override
  initState() {
    Database database = Provider.of<Database>(context, listen: false);
    Admin admin = Provider.of<User>(context, listen: false);
    List<String> centerIds = admin.centers;
    List<Future<StudyCenter>> futures = List();

    for (String centerId in centerIds) {
      Future<StudyCenter> temp = database.fetchDocument(
        path: APIPath.centerDocument(centerId),
        builder: (data, documentId) => StudyCenter.fromMap(data, documentId),
      );
      futures.add(temp);
    }

    centersListFuture = Future.wait(futures);

    super.initState();
  }

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
      ),
      body: FutureBuilder<List<StudyCenter>>(
          future: centersListFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final List<StudyCenter> items = snapshot.data;
              if (items.isNotEmpty) {
                return _buildContent(items);
              } else {
                return EmptyContent(
                  title: 'title',
                  message: 'message',
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

  Widget _buildContent(List<StudyCenter> items) {
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
                  ))),
              SizedBox(height: 50.0),
              SizedBox(height: 10),
              MenuButtonWidget(
                text: 'إدارة الحلقات',
                onPressed: () {},
              ),
              SizedBox(height: 10),
              MenuButtonWidget(
                text: 'إدارة المعلمين',
                onPressed: () {},
              ),
              SizedBox(height: 10),
              MenuButtonWidget(
                text: ' إدارة الطلاب',
                onPressed: () =>
                    Navigator.of(context, rootNavigator: false).push(
                  MaterialPageRoute(
                    builder: (context) => AdminsStudentsScreen.create(
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
                onPressed: () {},
              ),
              SizedBox(height: 10),
              MenuButtonWidget(
                text: 'تقارير',
                onPressed: () {},
              ),
              SizedBox(height: 10),
              MenuButtonWidget(
                text: 'الطلبات',
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}