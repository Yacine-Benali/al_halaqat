import 'package:alhalaqat/app/home/approved/globalAdmin/ga_reports/admin_logs/admin_logs_screen.dart';
import 'package:alhalaqat/app/home/approved/globalAdmin/ga_reports/ga_admins_report/ga_admins_report_screen.dart';
import 'package:alhalaqat/app/home/approved/globalAdmin/ga_reports/ga_centers_reports/ga_centers_report_screen.dart';
import 'package:alhalaqat/app/home/approved/globalAdmin/ga_reports/ga_halaqat_reports/ga_halaqat_report_screen.dart';
import 'package:alhalaqat/app/home/approved/globalAdmin/ga_reports/ga_students_reports/ga_students_report_screen.dart';
import 'package:alhalaqat/app/home/approved/globalAdmin/ga_reports/ga_teachers_report/ga_teachers_report_screen.dart';
import 'package:alhalaqat/common_widgets/menu_button_widget.dart';
import 'package:flutter/material.dart';

class GaReportsScreen extends StatefulWidget {
  @override
  _GaReportsScreenState createState() => _GaReportsScreenState();
}

class _GaReportsScreenState extends State<GaReportsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('التقارير '),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 70.0),
              MenuButtonWidget(
                text: 'السجلات',
                onPressed: () =>
                    Navigator.of(context, rootNavigator: false).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        AdminLogsScreen.create(context: context),
                    fullscreenDialog: true,
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              MenuButtonWidget(
                text: 'المراكز',
                onPressed: () =>
                    Navigator.of(context, rootNavigator: false).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        GaCentersReportScreen.create(context: context),
                    fullscreenDialog: true,
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              MenuButtonWidget(
                text: 'حلقات',
                onPressed: () =>
                    Navigator.of(context, rootNavigator: false).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        GaHalaqaReportScreen.create(context: context),
                    fullscreenDialog: true,
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              MenuButtonWidget(
                text: 'المشرفين',
                onPressed: () =>
                    Navigator.of(context, rootNavigator: false).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        GaAdminReportScreen.create(context: context),
                    fullscreenDialog: true,
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              MenuButtonWidget(
                text: 'الطلاب',
                onPressed: () =>
                    Navigator.of(context, rootNavigator: false).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        GaStudentsReportScreen.create(context: context),
                    fullscreenDialog: true,
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              MenuButtonWidget(
                text: 'المعلمين',
                onPressed: () =>
                    Navigator.of(context, rootNavigator: false).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        GaTeachersReportScreen.create(context: context),
                    fullscreenDialog: true,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
