import 'package:al_halaqat/app/home/approved/student/student_halaqa_information/student__halaqa_info_bloc.dart';
import 'package:al_halaqat/app/home/approved/student/student_halaqa_information/student_halaqa_attendance_screen.dart';
import 'package:al_halaqat/app/home/approved/student/student_halaqa_information/student_halaqa_evaluations_screen.dart';
import 'package:al_halaqat/app/models/student_profile.dart';
import 'package:al_halaqat/app/models/user.dart';
import 'package:al_halaqat/common_widgets/empty_content.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudentHalaqaInfoScreen extends StatefulWidget {
  final StudentProfile studentProfile;

  const StudentHalaqaInfoScreen({
    Key key,
    this.studentProfile,
  }) : super(key: key);

  @override
  _StudentHalaqaInfoScreenState createState() =>
      _StudentHalaqaInfoScreenState();
}

class _StudentHalaqaInfoScreenState extends State<StudentHalaqaInfoScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<String> titles;
  StudentHalaqaInfoBloc bloc;

  @override
  void initState() {
    titles = ['التقييمات', 'الحضور'];

    User user = Provider.of<User>(context, listen: false);

    bloc = StudentHalaqaInfoBloc(student: user);
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
    tabBarViewList[0] = StudentHalaqaEvaluationScreen(
      bloc: bloc,
      evaluationsList: widget.studentProfile.evaluationsList,
    );
    tabBarViewList[1] = StudentHalaqaAttendanceScreen(
      bloc: bloc,
      instancesList: widget.studentProfile.instancesList,
    );

    return tabBarViewList;
  }

  List<Widget> buildErrorTabBarView() {
    List<Widget> tabBarList = List(titles.length);
    for (int i = 0; i < titles.length; i++) {
      tabBarList[i] = EmptyContent(
        title: 'empty',
        message: 'empty',
      );
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
        body: Builder(
          builder: (context) {
            if (widget.studentProfile.evaluationsList.isNotEmpty &&
                widget.studentProfile.instancesList.isNotEmpty) {
              return TabBarView(children: getTabBarView());
            } else {
              return TabBarView(children: buildErrorTabBarView());
            }
          },
        ),
      ),
    );
  }
}
