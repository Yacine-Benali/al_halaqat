import 'package:al_halaqat/app/home/approved/admin/admin_teachers/admin_new_teacher_screen.dart';
import 'package:al_halaqat/app/home/approved/admin/admin_teachers/admin_teacher_bloc.dart';
import 'package:al_halaqat/app/home/approved/admin/admin_teachers/admin_teacher_provider.dart';
import 'package:al_halaqat/app/home/approved/admin/admin_teachers/admin_teacher_tile_widget.dart';
import 'package:al_halaqat/app/models/study_center.dart';
import 'package:al_halaqat/app/models/teacher.dart';
import 'package:al_halaqat/app/models/user.dart';
import 'package:al_halaqat/common_widgets/empty_content.dart';
import 'package:al_halaqat/constants/key_translate.dart';
import 'package:al_halaqat/services/auth.dart';
import 'package:al_halaqat/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminTeachersScreen extends StatefulWidget {
  const AdminTeachersScreen._({
    Key key,
    @required this.bloc,
    @required this.centers,
  }) : super(key: key);

  final AdminTeacherBloc bloc;
  final List<StudyCenter> centers;

  static Widget create({
    @required BuildContext context,
    @required List<StudyCenter> centers,
  }) {
    Database database = Provider.of<Database>(context, listen: false);
    User user = Provider.of<User>(context, listen: false);
    Auth auth = Provider.of<Auth>(context, listen: false);

    AdminTeachersProvider provider = AdminTeachersProvider(database: database);
    AdminTeacherBloc bloc = AdminTeacherBloc(
      auth: auth,
      admin: user,
      provider: provider,
    );

    return AdminTeachersScreen._(
      bloc: bloc,
      centers: centers,
    );
  }

  @override
  _AdminTeachersScreenState createState() => _AdminTeachersScreenState();
}

class _AdminTeachersScreenState extends State<AdminTeachersScreen> {
  AdminTeacherBloc get bloc => widget.bloc;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> teachersStateList = KeyTranslate.centersStateList.keys.toList();

  String chosenTeacherState;
  StudyCenter chosenCenter;

  Stream<List<Teacher>> teachersListStream;
  @override
  void initState() {
    teachersListStream = bloc.fetchTeachers(widget.centers);
    chosenCenter = widget.centers[0];
    chosenTeacherState = teachersStateList[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Center(
              child: DropdownButton<String>(
                dropdownColor: Colors.indigo,
                value: chosenTeacherState,
                icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                iconSize: 24,
                underline: Container(),
                elevation: 0,
                style: TextStyle(color: Colors.white, fontSize: 20),
                onChanged: (String newValue) {
                  setState(() {
                    chosenTeacherState = newValue;
                  });
                },
                items: teachersStateList
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(KeyTranslate.usersStateList[value]),
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
            builder: (context) => AdminNewTeacherScreen(
              bloc: bloc,
              chosenCenter: chosenCenter,
              teacher: null,
            ),
            fullscreenDialog: true,
          ),
        ),
        tooltip: 'add',
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<List<Teacher>>(
        stream: teachersListStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Teacher> teachersList = bloc.getFilteredTeachersList(
              snapshot.data,
              chosenCenter,
              chosenTeacherState,
            );
            if (teachersList.isNotEmpty) {
              return _buildList(teachersList);
            } else {
              return EmptyContent(
                title: 'لا يوجد مراكز ',
                message: 'لا يوجد مراكز في هذه الحالة',
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

  Widget _buildList(List<Teacher> teachersList) {
    return ListView.separated(
      itemCount: teachersList.length + 2,
      separatorBuilder: (context, index) => Divider(height: 0.5),
      itemBuilder: (context, index) {
        if (index == 0 || index == teachersList.length + 1) {
          return Container();
        }
        return AdminTeacherTileWidget(
          teacher: teachersList[index - 1],
          chosenTeacherState: chosenTeacherState,
          bloc: bloc,
          scaffoldKey: _scaffoldKey,
          chosenCenter: chosenCenter,
        );
      },
    );
  }
}
