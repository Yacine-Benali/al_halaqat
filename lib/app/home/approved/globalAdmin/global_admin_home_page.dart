import 'package:alhalaqat/app/home/approved/globalAdmin/ga_admins/ga_admins_screen.dart';
import 'package:alhalaqat/app/home/approved/globalAdmin/ga_centers/ga_centers_screen.dart';
import 'package:alhalaqat/app/home/approved/globalAdmin/ga_config/ga_config_screen.dart';
import 'package:alhalaqat/app/home/approved/globalAdmin/ga_global_admins/ga_global_admins_screen.dart';
import 'package:alhalaqat/app/home/approved/globalAdmin/ga_profile/ga_profile_screen.dart';
import 'package:alhalaqat/app/home/approved/globalAdmin/ga_reports/ga_reports_screen.dart';
import 'package:alhalaqat/app/home/approved/globalAdmin/ga_requests/ga_requests_screen.dart';
import 'package:alhalaqat/app/models/user.dart';
import 'package:alhalaqat/common_widgets/home_screen_popup.dart';
import 'package:alhalaqat/common_widgets/logo.dart';
import 'package:alhalaqat/common_widgets/menu_button_widget.dart';
import 'package:alhalaqat/common_widgets/platform_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/platform_exception_alert_dialog.dart';
import 'package:alhalaqat/constants/strings.dart';
import 'package:alhalaqat/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'ga_requests/ga_requests_screen.dart';

class GlobalAdminHomePage extends StatefulWidget {
  @override
  _GlobalAdminHomePageState createState() => _GlobalAdminHomePageState();
}

class _GlobalAdminHomePageState extends State<GlobalAdminHomePage> {
  @override
  void initState() {
    final User user = Provider.of<User>(context, listen: false);

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
          HomeScreenPopUp(),
          Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: InkWell(
              onTap: () => Navigator.of(context, rootNavigator: false).push(
                MaterialPageRoute(
                  builder: (context) => GaConfigScreen.create(context: context),
                  fullscreenDialog: true,
                ),
              ),
              child: Icon(
                Icons.settings,
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
                Logo(),
                SizedBox(height: 30.0),
                MenuButtonWidget(
                  text: 'إدارة المدراء',
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
                  text: 'إدارة المشرفين',
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
                  text: 'إدارة المراكز',
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
                  text: 'التقارير ',
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
                  text: 'الطلبات ',
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
