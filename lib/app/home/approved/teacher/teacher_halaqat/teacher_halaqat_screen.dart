import 'package:al_halaqat/app/home/approved/teacher/teacher_halaqat/teacher_halaqa_tile_widget.dart';
import 'package:al_halaqat/app/home/approved/teacher/teacher_halaqat/teacher_halaqat_bloc.dart';
import 'package:al_halaqat/app/home/approved/teacher/teacher_halaqat/teacher_halaqat_provider.dart';
import 'package:al_halaqat/app/home/approved/teacher/teacher_halaqat/teacher_new_halaqa_screen.dart';
import 'package:al_halaqat/app/models/halaqa.dart';
import 'package:al_halaqat/app/models/study_center.dart';
import 'package:al_halaqat/app/models/teacher.dart';
import 'package:al_halaqat/app/models/user.dart';
import 'package:al_halaqat/common_widgets/empty_content.dart';
import 'package:al_halaqat/services/auth.dart';
import 'package:al_halaqat/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TeacherHalaqatScreen extends StatefulWidget {
  const TeacherHalaqatScreen._({
    Key key,
    @required this.bloc,
    @required this.centers,
  }) : super(key: key);

  final TeacherHalaqaBloc bloc;
  final List<StudyCenter> centers;

  static Widget create({
    @required BuildContext context,
    @required List<StudyCenter> centers,
  }) {
    Database database = Provider.of<Database>(context, listen: false);
    User user = Provider.of<User>(context, listen: false);
    Auth auth = Provider.of<Auth>(context, listen: false);

    TeacherHalaqatProvider provider =
        TeacherHalaqatProvider(database: database);
    TeacherHalaqaBloc bloc = TeacherHalaqaBloc(
      auth: auth,
      teacher: user,
      provider: provider,
    );

    return TeacherHalaqatScreen._(
      bloc: bloc,
      centers: centers,
    );
  }

  @override
  _TeacherHalaqatScreenState createState() => _TeacherHalaqatScreenState();
}

class _TeacherHalaqatScreenState extends State<TeacherHalaqatScreen> {
  TeacherHalaqaBloc get bloc => widget.bloc;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  StudyCenter chosenCenter;
  Stream<List<Halaqa>> halaqatListStream;
  int numberOfHalaqatTeachingIn;

  @override
  void initState() {
    chosenCenter = widget.centers[0];
    halaqatListStream = bloc.fetchHalaqat(bloc.teacher.halaqatTeachingIn);
    numberOfHalaqatTeachingIn = bloc.teacher.halaqatLearningIn?.length;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context, listen: false);
    if (user is Teacher) {
      if (user.halaqatTeachingIn?.length != numberOfHalaqatTeachingIn) {
        halaqatListStream = bloc.fetchHalaqat(user.halaqatTeachingIn);
        numberOfHalaqatTeachingIn = user.halaqatTeachingIn?.length;
      }
    }
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Center(child: Text('المراكز')),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Center(
              child: DropdownButton<StudyCenter>(
                dropdownColor: Colors.indigo,
                value: chosenCenter,
                icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                iconSize: 24,
                underline: Container(),
                elevation: 0,
                style: TextStyle(color: Colors.white, fontSize: 20),
                onChanged: (StudyCenter newValue) {
                  setState(() {
                    chosenCenter = newValue;
                  });
                },
                items: widget.centers
                    .map<DropdownMenuItem<StudyCenter>>((StudyCenter value) {
                  return DropdownMenuItem<StudyCenter>(
                    value: value,
                    child: Text(value.name),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context, rootNavigator: false).push(
          MaterialPageRoute(
            builder: (context) => TeacherNewHalaqaScreen(
              bloc: bloc,
              chosenCenter: chosenCenter,
              halaqa: null,
            ),
            fullscreenDialog: true,
          ),
        ),
        tooltip: 'add',
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<List<Halaqa>>(
        stream: halaqatListStream,
        builder: (context, snapshot) {
          if (numberOfHalaqatTeachingIn == 0)
            return EmptyContent(
              title: 'لا يوجد أي حلقات ',
              message: '',
            );

          if (snapshot.hasData) {
            final List<Halaqa> halaqatList = bloc.getFilteredHalaqatList(
              snapshot.data,
              chosenCenter,
            );
            if (halaqatList.isNotEmpty) {
              return _buildList(halaqatList);
            } else {
              return EmptyContent(
                title: 'لا يوجد أي حلقات ',
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

  Widget _buildList(List<Halaqa> halaqatList) {
    return ListView.separated(
      itemCount: halaqatList.length + 2,
      separatorBuilder: (context, index) => Divider(height: 0.5),
      itemBuilder: (context, index) {
        if (index == 0 || index == halaqatList.length + 1) {
          return Container();
        }
        return TeacherHalqaTileWidget(
          halaqa: halaqatList[index - 1],
          chosenCenter: chosenCenter,
          bloc: bloc,
        );
      },
    );
  }
}
