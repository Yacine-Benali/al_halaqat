import 'package:al_halaqat/app/common_forms/student_form.dart';
import 'package:al_halaqat/app/home/approved/common_screens/student_profile/student_attendance_screen.dart';
import 'package:al_halaqat/app/home/approved/common_screens/student_profile/student_evaluations_screen.dart';
import 'package:al_halaqat/app/home/approved/common_screens/student_profile/student_profile_bloc.dart';
import 'package:al_halaqat/app/home/approved/common_screens/student_profile/student_profile_provider.dart';
import 'package:al_halaqat/app/home/approved/common_screens/student_profile/student_report_card_screen.dart';
import 'package:al_halaqat/app/models/halaqa.dart';
import 'package:al_halaqat/app/models/quran.dart';
import 'package:al_halaqat/app/models/student.dart';
import 'package:al_halaqat/app/models/student_profile.dart';
import 'package:al_halaqat/common_widgets/empty_content.dart';
import 'package:al_halaqat/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudentProfileScreen extends StatefulWidget {
  final StudentProfileBloc bloc;

  const StudentProfileScreen._({Key key, this.bloc}) : super(key: key);

  static Widget create({
    @required BuildContext context,
    @required List<Halaqa> halaqatList,
    @required Student student,
    @required Quran quran,
  }) {
    Database database = Provider.of<Database>(context, listen: false);
    // User admin = Provider.of<User>(context, listen: false);
    // Auth auth = Provider.of<Auth>(context, listen: false);

    StudentProfileProvider provider =
        StudentProfileProvider(database: database);
    StudentProfileBloc bloc = StudentProfileBloc(
      provider: provider,
      student: student,
      halaqatList: halaqatList,
      quran: quran,
    );

    return StudentProfileScreen._(
      bloc: bloc,
    );
  }

  @override
  _StudentProfileScreenState createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  StudentProfileBloc get bloc => widget.bloc;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Future<List<StudentProfile>> studentProfileFuture;
  List<StudentProfile> studentProfileList;
  List<String> titles;

  @override
  void initState() {
    studentProfileFuture = bloc.getStudentProfile();
    titles = bloc.getTitles();
    super.initState();
  }

  List<Widget> buildTabBars() {
    List<Widget> tabBarList = List(titles.length);
    for (int i = 0; i < titles.length; i++) {
      tabBarList[i] = Tab(
        text: titles.elementAt(i),
      );
    }
    return tabBarList;
  }

  List<Widget> getTabBarView() {
    List<Widget> tabBarViewList = List(titles.length);
    tabBarViewList[0] = StudentForm(
      student: bloc.student,
      onSaved: (t) {},
      studentFormKey: formKey,
      isEnabled: false,
      includeCenterIdInput: false,
      includeUsernameAndPassword: true,
      includeCenterForm: false,
      center: null,
      showUserHalaqa: false,
    );

    tabBarViewList[1] = StudentReportCardScreen(
      bloc: bloc,
      studentProfileList: studentProfileList,
    );
    for (int i = 2; i < titles.length; i++) {
      // print(
      //     'instance of ${studentProfileList.first.halaqaId}: ${studentProfileList.first.instancesList.length}');
      tabBarViewList[i] = Column(
        children: [
          ListTile(
            title: Text('الحضور'),
            onTap: () => Navigator.of(context, rootNavigator: false).push(
              MaterialPageRoute(
                builder: (context) => StudentAttendanceScreen(
                  bloc: bloc,
                  instancesList: studentProfileList[i - 1].instancesList,
                ),
                fullscreenDialog: true,
              ),
            ),
          ),
          Divider(height: 0.5),
          ListTile(
            title: Text('التقييمات'),
            onTap: () => Navigator.of(context, rootNavigator: false).push(
              MaterialPageRoute(
                builder: (context) => StudentEvaluationScreen(
                  bloc: bloc,
                  evaluationsList: studentProfileList[i - 1].evaluationsList,
                ),
                fullscreenDialog: true,
              ),
            ),
          ),
          Divider(height: 0.5),
        ],
      );
    }
    return tabBarViewList;
  }

  List<Widget> buildErrorTabBarView() {
    List<Widget> tabBarList = List(titles.length);
    for (int i = 0; i < titles.length; i++) {
      tabBarList[i] = EmptyContent(
        title: 'Something went wrong',
        message: 'Can\'t load items right now',
      );
    }
    return tabBarList;
  }

  List<Widget> buildLoadingTabBarView() {
    List<Widget> tabBarList = List(titles.length);
    for (int i = 0; i < titles.length; i++) {
      tabBarList[i] = Center(child: CircularProgressIndicator());
    }
    return tabBarList;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: titles.length,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: buildTabBars(),
          ),
        ),
        body: FutureBuilder<List<StudentProfile>>(
            future: studentProfileFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                studentProfileList = snapshot.data;

                return TabBarView(children: getTabBarView());
              } else if (snapshot.hasError) {
                return TabBarView(children: buildErrorTabBarView());
              }
              return TabBarView(children: buildLoadingTabBarView());
            }),
      ),
    );
  }
}
