import 'package:alhalaqat/app/home/approved/student/organizer_halaqat/organizer_halaqa_tile_widget.dart';
import 'package:alhalaqat/app/home/approved/student/organizer_halaqat/organizer_halaqat_bloc.dart';
import 'package:alhalaqat/app/home/approved/student/organizer_halaqat/organizer_halaqat_provider.dart';
import 'package:alhalaqat/app/models/halaqa.dart';
import 'package:alhalaqat/app/models/student.dart';
import 'package:alhalaqat/app/models/student_profile.dart';
import 'package:alhalaqat/app/models/study_center.dart';
import 'package:alhalaqat/app/models/user.dart';
import 'package:alhalaqat/common_widgets/empty_content.dart';
import 'package:alhalaqat/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrganizerHalaqatScreen extends StatefulWidget {
  const OrganizerHalaqatScreen._({
    Key key,
    @required this.bloc,
    @required this.studyCenter,
  }) : super(key: key);

  final OrganizerHalaqaBloc bloc;
  final StudyCenter studyCenter;

  static Widget create({
    @required BuildContext context,
    @required StudyCenter studyCenter,
  }) {
    Database database = Provider.of<Database>(context, listen: false);
    User user = Provider.of<User>(context, listen: false);

    OrganizerHalaqatProvider provider =
        OrganizerHalaqatProvider(database: database);
    OrganizerHalaqaBloc bloc = OrganizerHalaqaBloc(
      provider: provider,
      student: user,
    );

    return OrganizerHalaqatScreen._(
      bloc: bloc,
      studyCenter: studyCenter,
    );
  }

  @override
  _OrganizerHalaqatScreenState createState() => _OrganizerHalaqatScreenState();
}

class _OrganizerHalaqatScreenState extends State<OrganizerHalaqatScreen> {
  OrganizerHalaqaBloc get bloc => widget.bloc;

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
          title: Text('الحلقات'),
          centerTitle: true,
        ),
        body: StreamBuilder<List<Halaqa>>(
          stream: bloc.fetchHalaqat(user.halaqatOrganizingIn),
          builder: (context, snapshot) {
            // if (numberOfHalaqatTeachingIn == 0)
            //   return EmptyContent(
            //     title: 'لا يوجد أي حلقات ',
            //     message: '',
            //   );

            if (snapshot.hasData) {
              final List<Halaqa> halaqatList = snapshot.data;

              if (halaqatList.isNotEmpty) {
                return ListView.separated(
                  itemCount: halaqatList.length + 2,
                  separatorBuilder: (context, index) => Divider(height: 0.5),
                  itemBuilder: (context, index) {
                    if (index == 0 || index == halaqatList.length + 1) {
                      return Container();
                    }
                    return OrganizerHalaqaTileWidget(
                      halaqa: halaqatList[index - 1],
                      bloc: bloc,
                      studyCenter: widget.studyCenter,
                    );
                  },
                );
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
        ),
      );
    }
    return Container();
  }
}
