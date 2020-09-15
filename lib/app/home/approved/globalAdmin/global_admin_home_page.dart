import 'package:al_halaqat/app/home/approved/globalAdmin/ga_admins/ga_admins_screen.dart';
import 'package:al_halaqat/app/home/approved/globalAdmin/ga_centers/ga_centers_screen.dart';
import 'package:al_halaqat/app/home/approved/globalAdmin/ga_global_admins/ga_global_admins_screen.dart';
import 'package:al_halaqat/app/home/approved/globalAdmin/ga_profile/ga_profile_screen.dart';
import 'package:al_halaqat/app/home/approved/globalAdmin/ga_reports/ga_reports_screen.dart';
import 'package:al_halaqat/app/home/approved/globalAdmin/ga_requests/ga_requests_screen.dart';
import 'package:al_halaqat/common_widgets/menu_button_widget.dart';
import 'package:al_halaqat/common_widgets/platform_alert_dialog.dart';
import 'package:al_halaqat/common_widgets/platform_exception_alert_dialog.dart';
import 'package:al_halaqat/constants/strings.dart';
import 'package:al_halaqat/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'ga_requests/ga_requests_screen.dart';

class GlobalAdminHomePage extends StatelessWidget {
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
                  builder: (context) =>
                      GaProfileScreen.create(context: context),
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
      body: SingleChildScrollView(
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
                  text: 'إداراة المدراء عاميين',
                  onPressed: () =>
                      Navigator.of(context, rootNavigator: false).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          GaGlobalAdminsScreen.create(context: context),
                      fullscreenDialog: true,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                MenuButtonWidget(
                  text: 'إدارة المدراء',
                  onPressed: () =>
                      Navigator.of(context, rootNavigator: false).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          GaAdminsScreen.create(context: context),
                      fullscreenDialog: true,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                MenuButtonWidget(
                  text: ' المراكز',
                  onPressed: () =>
                      Navigator.of(context, rootNavigator: false).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          GaCentersScreen.create(context: context),
                      fullscreenDialog: true,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                MenuButtonWidget(
                  text: 'تقارير',
                  onPressed: () =>
                      Navigator.of(context, rootNavigator: false).push(
                    MaterialPageRoute(
                      builder: (context) => GaReportsScreen(),
                      fullscreenDialog: true,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                MenuButtonWidget(
                  text: 'الدعوات',
                  onPressed: () =>
                      Navigator.of(context, rootNavigator: false).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          GaRequestsScreen.create(context: context),
                      fullscreenDialog: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
