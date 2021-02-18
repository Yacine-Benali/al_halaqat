import 'package:alhalaqat/app/common_forms/teacher_form.dart';
import 'package:alhalaqat/app/home/approved/admin/admin_teachers/teacher_profile/a_t_center_attendance_screen.dart';
import 'package:alhalaqat/app/home/approved/admin/admin_teachers/teacher_profile/a_teacher_profile_bloc.dart';
import 'package:alhalaqat/app/home/approved/admin/admin_teachers/teacher_profile/a_teacher_profile_provider.dart';
import 'package:alhalaqat/app/models/global_admin.dart';
import 'package:alhalaqat/app/models/halaqa.dart';
import 'package:alhalaqat/app/models/study_center.dart';
import 'package:alhalaqat/app/models/teacher.dart';
import 'package:alhalaqat/app/models/user.dart';
import 'package:alhalaqat/common_widgets/empty_content.dart';
import 'package:alhalaqat/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ATeacherProfileScreen extends StatefulWidget {
  const ATeacherProfileScreen._({
    Key key,
    @required this.bloc,
  }) : super(key: key);
  final ATeacherProfileBloc bloc;

  static Widget create({
    @required BuildContext context,
    @required List<Halaqa> halaqatList,
    @required Teacher teacher,
    @required StudyCenter studyCenter,
  }) {
    Database database = Provider.of<Database>(context, listen: false);

    ATeacherProfileProvider provider =
        ATeacherProfileProvider(database: database);
    ATeacherProfileBloc bloc = ATeacherProfileBloc(
      provider: provider,
      halaqatList: halaqatList,
      teacher: teacher,
      studyCenter: studyCenter,
    );

    return ATeacherProfileScreen._(
      bloc: bloc,
    );
  }

  @override
  _ATeacherProfileScreenState createState() => _ATeacherProfileScreenState();
}

class _ATeacherProfileScreenState extends State<ATeacherProfileScreen> {
  ATeacherProfileBloc get bloc => widget.bloc;
  List<String> titles;
  bool hidePassword;
  final GlobalKey<FormState> teacherFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    titles = bloc.getTabBarTitles();
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
    tabBarViewList[0] = TeacherForm(
      halaqatList: bloc.halaqatList,
      isEnabled: false,
      teacher: bloc.teacher,
      onSaved: (Teacher value) {},
      includeCenterIdInput: false,
      includeUsernameAndPassword: true,
      teacherFormKey: teacherFormKey,
      showUserHalaqa: true,
      center: null,
      includeCenterForm: false,
      hidePassword: hidePassword,
    );

    for (int i = 1; i < titles.length; i++) {
      tabBarViewList[i] = ATCenterAttendanceScreen(bloc: bloc);
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
          title: Text(''),
          centerTitle: true,
          bottom: TabBar(
            isScrollable: true,
            tabs: buildTabBars(),
          ),
        ),
        body: TabBarView(children: getTabBarView()),
      ),
    );
  }
}
