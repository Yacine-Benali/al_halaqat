import 'package:al_halaqat/app/home/approved/student/student_halaqat/student_halaqa_tile_widget.dart';
import 'package:al_halaqat/app/home/approved/student/student_halaqat/student_halaqat_bloc.dart';
import 'package:al_halaqat/app/home/approved/student/student_halaqat/student_halaqat_provider.dart';
import 'package:al_halaqat/app/models/halaqa.dart';
import 'package:al_halaqat/app/models/student.dart';
import 'package:al_halaqat/app/models/student_profile.dart';
import 'package:al_halaqat/app/models/study_center.dart';
import 'package:al_halaqat/app/models/user.dart';
import 'package:al_halaqat/common_widgets/empty_content.dart';
import 'package:al_halaqat/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudentHalaqatScreen extends StatefulWidget {
  const StudentHalaqatScreen._({
    Key key,
    @required this.bloc,
  }) : super(key: key);

  final StudentHalaqaBloc bloc;

  static Widget create({
    @required BuildContext context,
  }) {
    Database database = Provider.of<Database>(context, listen: false);
    User user = Provider.of<User>(context, listen: false);

    StudentHalaqatProvider provider =
        StudentHalaqatProvider(database: database);
    StudentHalaqaBloc bloc = StudentHalaqaBloc(
      provider: provider,
      student: user,
    );

    return StudentHalaqatScreen._(
      bloc: bloc,
    );
  }

  @override
  _StudentHalaqatScreenState createState() => _StudentHalaqatScreenState();
}

class _StudentHalaqatScreenState extends State<StudentHalaqatScreen> {
  StudentHalaqaBloc get bloc => widget.bloc;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Future<List<StudentProfile>> studentProfileFuture;

  StudyCenter chosenCenter;
  Stream<List<Halaqa>> halaqatListStream;

  int numberOfHalaqatLearningIn;

  @override
  void initState() {
    studentProfileFuture = bloc.getStudentProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context, listen: true);
    if (user is Student) {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Center(child: Text('المراكز')),
          centerTitle: true,
        ),
        body: FutureBuilder<List<StudentProfile>>(
          future: studentProfileFuture,
          builder: (context, futureSnapshot) {
            return StreamBuilder<List<Halaqa>>(
              stream: bloc.fetchHalaqat(user.halaqatLearningIn),
              builder: (context, snapshot) {
                // if (numberOfHalaqatTeachingIn == 0)
                //   return EmptyContent(
                //     title: 'لا يوجد أي حلقات ',
                //     message: '',
                //   );

                if (snapshot.hasData && futureSnapshot.hasData) {
                  final List<Halaqa> halaqatList = snapshot.data;
                  final List<StudentProfile> studentProfileList =
                      futureSnapshot.data;
                  if (halaqatList.isNotEmpty) {
                    return _buildList(halaqatList, studentProfileList);
                  } else {
                    return EmptyContent(
                      title: 'لا يوجد أي حلقات ',
                      message: '',
                    );
                  }
                } else if (snapshot.hasError) {
                  return EmptyContent(
                    title: 'لا يوجد أي حلقات ',
                    message: '',
                  );
                }
                return Center(child: CircularProgressIndicator());
              },
            );
          },
        ),
      );
    }
    return Container();
  }

  Widget _buildList(
    List<Halaqa> halaqatList,
    List<StudentProfile> studentProfileList,
  ) {
    return ListView.separated(
      itemCount: halaqatList.length + 2,
      separatorBuilder: (context, index) => Divider(height: 0.5),
      itemBuilder: (context, index) {
        if (index == 0 || index == halaqatList.length + 1) {
          return Container();
        }
        return StudentHalaqaTileWidget(
          halaqa: halaqatList[index - 1],
          studentProfileList: studentProfileList,
          bloc: bloc,
        );
      },
    );
  }
}
