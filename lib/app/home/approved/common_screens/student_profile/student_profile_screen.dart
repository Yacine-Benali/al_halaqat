import 'package:alhalaqat/app/common_forms/student_form.dart';
import 'package:alhalaqat/app/home/approved/common_screens/student_profile/student_attendance_screen.dart';
import 'package:alhalaqat/app/home/approved/common_screens/student_profile/student_evaluations_screen.dart';
import 'package:alhalaqat/app/home/approved/common_screens/student_profile/student_profile_bloc.dart';
import 'package:alhalaqat/app/home/approved/common_screens/student_profile/student_profile_provider.dart';
import 'package:alhalaqat/app/home/approved/common_screens/student_profile/student_report_card_screen.dart';
import 'package:alhalaqat/app/models/global_admin.dart';
import 'package:alhalaqat/app/models/halaqa.dart';
import 'package:alhalaqat/app/models/quran.dart';
import 'package:alhalaqat/app/models/student.dart';
import 'package:alhalaqat/app/models/student_profile.dart';
import 'package:alhalaqat/app/models/user.dart';
import 'package:alhalaqat/common_widgets/empty_content.dart';
import 'package:alhalaqat/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudentProfileScreen extends StatefulWidget {
  final StudentProfileBloc bloc;
  final VoidCallback onTap;
  const StudentProfileScreen._({
    Key key,
    @required this.bloc,
    @required this.onTap,
  }) : super(key: key);

  static Widget create({
    @required BuildContext context,
    @required List<Halaqa> halaqatList,
    @required Student student,
    @required Quran quran,
    @required bool studentRoaming,
    @required VoidCallback onTap,
  }) {
    Database database = Provider.of<Database>(context, listen: false);

    StudentProfileProvider provider =
        StudentProfileProvider(database: database);
    StudentProfileBloc bloc = StudentProfileBloc(
      provider: provider,
      student: student,
      halaqatList: halaqatList,
      quran: quran,
      studentRoaming: studentRoaming,
    );

    return StudentProfileScreen._(
      bloc: bloc,
      onTap: onTap,
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
  bool hidePassword;
  @override
  void initState() {
    studentProfileFuture = bloc.getStudentProfile();
    titles = List();
    titles.add('ملف شخصي');
    titles.add('الحفظ');
    User user = Provider.of<User>(context, listen: false);
    if (user is GlobalAdmin)
      hidePassword = false;
    else
      hidePassword = true;
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
      hidePassword: hidePassword,
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
                  instancesList: studentProfileList[i - 2].instancesList,
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
                  evaluationsList: studentProfileList[i - 2].evaluationsList,
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
    return FutureBuilder<List<StudentProfile>>(
      future: studentProfileFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          studentProfileList = snapshot.data;
          titles.addAll(studentProfileList.map((e) => e.halaqaName).toList());
          return DefaultTabController(
            length: titles.length,
            child: Scaffold(
              appBar: AppBar(
                title: Text(bloc.student.name),
                centerTitle: true,
                actions: [
                  Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: InkWell(
                      onTap: widget.onTap,
                      child: Icon(
                        Icons.edit,
                        size: 26.0,
                      ),
                    ),
                  ),
                ],
                bottom: TabBar(
                  isScrollable: true,
                  tabs: buildTabBars(),
                ),
              ),
              body: TabBarView(children: getTabBarView()),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(),
            body: Text('error'),
          );
        }
        return Scaffold(
          appBar: AppBar(),
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
