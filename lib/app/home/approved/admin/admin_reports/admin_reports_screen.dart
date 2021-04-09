import 'package:alhalaqat/app/home/approved/admin/admin_reports/admin_reports_bloc.dart';
import 'package:alhalaqat/app/home/approved/admin/admin_reports/admin_reports_provider.dart';
import 'package:alhalaqat/app/home/approved/admin/admin_reports/center_logs/center_logs_screen.dart';
import 'package:alhalaqat/app/home/approved/admin/admin_reports/center_numbers/center_numbers_screen.dart';
import 'package:alhalaqat/app/home/approved/admin/admin_reports/t__center_attendance/t_center_attendance_screen.dart';
import 'package:alhalaqat/app/home/approved/admin/admin_reports/t_attendance/t_attendance_screen.dart';
import 'package:alhalaqat/app/home/approved/common_screens/reports/s_attendance/s_attendance_screen.dart';
import 'package:alhalaqat/app/home/approved/common_screens/reports/s_learning/s_learning_screen.dart';
import 'package:alhalaqat/app/models/halaqa.dart';
import 'package:alhalaqat/app/models/study_center.dart';
import 'package:alhalaqat/common_widgets/empty_content.dart';
import 'package:alhalaqat/common_widgets/menu_button_widget.dart';
import 'package:alhalaqat/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'centers_reports/admin_centers_report_screen.dart';

class AdminReportsScreen extends StatefulWidget {
  const AdminReportsScreen._({
    Key key,
    @required this.bloc,
    @required this.centers,
    @required this.center,
  }) : super(key: key);

  final AdminReportsBloc bloc;
  final List<StudyCenter> centers;
  final StudyCenter center;

  static Widget create({
    @required BuildContext context,
    @required List<StudyCenter> centers,
    @required StudyCenter center,
  }) {
    Database database = Provider.of<Database>(context, listen: false);
    AdminReportsProvider provider = AdminReportsProvider(database: database);
    AdminReportsBloc bloc = AdminReportsBloc(
      provider: provider,
    );
    return AdminReportsScreen._(
      bloc: bloc,
      centers: centers,
      center: center,
    );
  }

  @override
  _AdminReportsScreenState createState() => _AdminReportsScreenState();
}

class _AdminReportsScreenState extends State<AdminReportsScreen> {
  AdminReportsBloc get bloc => widget.bloc;
  StudyCenter chosenCenter;

  @override
  initState() {
    chosenCenter = widget.center;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('التقارير'),
      ),
      body: FutureBuilder(
        future: bloc.fetchHalaqat(chosenCenter.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<Halaqa> items = snapshot.data;
            if (items.isNotEmpty) {
              return Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    SizedBox(height: 70.0),
                    MenuButtonWidget(
                      text: 'ملخص كل المراكز',
                      onPressed: () =>
                          Navigator.of(context, rootNavigator: false).push(
                        MaterialPageRoute(
                          builder: (context) => AdminCentersReportScreen.create(
                            context: context,
                            centersList: widget.centers,
                          ),
                          fullscreenDialog: true,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    MenuButtonWidget(
                      text: 'المركز',
                      onPressed: () =>
                          Navigator.of(context, rootNavigator: false).push(
                        MaterialPageRoute(
                          builder: (context) => CenterNumbersScreen.create(
                            context: context,
                            center: chosenCenter,
                          ),
                          fullscreenDialog: true,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    MenuButtonWidget(
                      text: 'حضور المعلمين',
                      onPressed: () =>
                          Navigator.of(context, rootNavigator: false).push(
                        MaterialPageRoute(
                          builder: (context) => TAttendanceScreen.create(
                            context: context,
                            halaqatList: items,
                            center: chosenCenter,
                          ),
                          fullscreenDialog: true,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    MenuButtonWidget(
                      text: 'دوام المعلمين',
                      onPressed: () =>
                          Navigator.of(context, rootNavigator: false).push(
                        MaterialPageRoute(
                          builder: (context) => TCenterAttendanceScreen.create(
                            context: context,
                            center: chosenCenter,
                          ),
                          fullscreenDialog: true,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    MenuButtonWidget(
                      text: 'حضور الطلاب',
                      onPressed: () =>
                          Navigator.of(context, rootNavigator: false).push(
                        MaterialPageRoute(
                          builder: (context) => SAttendanceScreen.create(
                            context: context,
                            halaqatList: items,
                          ),
                          fullscreenDialog: true,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    MenuButtonWidget(
                      text: 'حفظ الطلاب',
                      onPressed: () =>
                          Navigator.of(context, rootNavigator: false).push(
                        MaterialPageRoute(
                          builder: (context) => SLearningScreen.create(
                            context: context,
                            halaqatList: items,
                          ),
                          fullscreenDialog: true,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    MenuButtonWidget(
                      text: 'السجلات',
                      onPressed: () =>
                          Navigator.of(context, rootNavigator: false).push(
                        MaterialPageRoute(
                          builder: (context) => CenterLogsScreen.create(
                            context: context,
                            chosenCenter: chosenCenter,
                          ),
                          fullscreenDialog: true,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return EmptyContent(
                title: '',
                message: 'يجب إنشاء حلقات لإنشاء التقارير',
              );
            }
          } else if (snapshot.hasError) {
            return EmptyContent(
              title: 'Something went wrong',
              message: 'Can\'t load items right now',
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
