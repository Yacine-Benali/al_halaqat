import 'package:alhalaqat/app/home/approved/common_screens/reports/s_attendance/s_attendance_screen.dart';
import 'package:alhalaqat/app/home/approved/common_screens/reports/s_learning/s_learning_screen.dart';
import 'package:alhalaqat/app/home/approved/supervisor/supervisor_reports/supervisor_reports_bloc.dart';
import 'package:alhalaqat/app/home/approved/supervisor/supervisor_reports/supervisor_reports_provider.dart';
import 'package:alhalaqat/app/models/halaqa.dart';
import 'package:alhalaqat/common_widgets/empty_content.dart';
import 'package:alhalaqat/common_widgets/menu_button_widget.dart';
import 'package:alhalaqat/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SupervisorReportsScreen extends StatefulWidget {
  const SupervisorReportsScreen._({Key key, @required this.bloc})
      : super(key: key);

  final SupervisorReportsBloc bloc;

  static Widget create({
    @required BuildContext context,
    @required List<String> halaqatId,
  }) {
    Database database = Provider.of<Database>(context, listen: false);

    SupervisorReportsProvider provider =
        SupervisorReportsProvider(database: database);
    SupervisorReportsBloc bloc = SupervisorReportsBloc(
      provider: provider,
      halaqatId: halaqatId,
    );
    return SupervisorReportsScreen._(
      bloc: bloc,
    );
  }

  @override
  _SupervisorHomePageState createState() => _SupervisorHomePageState();
}

class _SupervisorHomePageState extends State<SupervisorReportsScreen> {
  SupervisorReportsBloc get bloc => widget.bloc;
  Future<List<List<Halaqa>>> halaqatFuture;

  @override
  initState() {
    halaqatFuture = bloc.fetchHalaqat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('التقارير '),
      ),
      body: FutureBuilder(
        future: halaqatFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<List<Halaqa>> temp = snapshot.data;
            final List<Halaqa> items = temp.expand((x) => x).toList();
            if (items.isNotEmpty) {
              return Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    SizedBox(height: 70.0),
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
                  ],
                ),
              );
            } else {
              return EmptyContent(
                title: '',
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
        },
      ),
    );
  }
}
