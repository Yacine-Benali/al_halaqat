import 'package:al_halaqat/app/home/approved/globalAdmin/ga_reports/admin_logs/admin_logs_screen.dart';
import 'package:al_halaqat/common_widgets/menu_button_widget.dart';
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
          title: Center(child: Text('تقارير')),
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
            ],
          ),
        ));
  }
}
