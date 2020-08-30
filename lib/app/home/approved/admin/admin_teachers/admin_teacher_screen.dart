import 'package:al_halaqat/app/conversation_helper/conversation_helper_bloc.dart';
import 'package:al_halaqat/app/home/approved/admin/admin_teachers/admin_new_teacher_screen.dart';
import 'package:al_halaqat/app/home/approved/admin/admin_teachers/admin_teacher_bloc.dart';
import 'package:al_halaqat/app/home/approved/admin/admin_teachers/admin_teacher_provider.dart';
import 'package:al_halaqat/app/home/approved/admin/admin_teachers/admin_teacher_tile_widget.dart';
import 'package:al_halaqat/app/models/admin.dart';
import 'package:al_halaqat/app/models/halaqa.dart';
import 'package:al_halaqat/app/models/study_center.dart';
import 'package:al_halaqat/app/models/teacher.dart';
import 'package:al_halaqat/app/models/user.dart';
import 'package:al_halaqat/app/models/user_halaqa.dart';
import 'package:al_halaqat/common_widgets/empty_content.dart';
import 'package:al_halaqat/constants/key_translate.dart';
import 'package:al_halaqat/services/auth.dart';
import 'package:al_halaqat/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//! TODO load teacher lazly
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
    ConversationHelpeBloc conversationHelper =
        Provider.of<ConversationHelpeBloc>(context, listen: false);
    AdminTeacherBloc bloc = AdminTeacherBloc(
      auth: auth,
      admin: user,
      provider: provider,
      conversationHelper: conversationHelper,
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
  List<String> teachersStateList;

  String chosenTeacherState;
  StudyCenter chosenCenter;

  Stream<UserHalaqa<Teacher>> teachersListStream;
  @override
  void initState() {
    if (bloc.admin is Admin) {
      teachersStateList = KeyTranslate.adminCentersStateList.keys.toList();
    } else {
      teachersStateList = KeyTranslate.centersStateList.keys.toList();
    }
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
        title: Center(child: Text('')),
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
      body: StreamBuilder<UserHalaqa<Teacher>>(
        stream: teachersListStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Teacher> teachersList = bloc.getFilteredTeachersList(
              snapshot.data.usersList,
              chosenCenter,
              chosenTeacherState,
            );

            List<Halaqa> halaqatList = snapshot.data.halaqatList;
            List<Halaqa> availableHalaqat = bloc.getAvailableHalaqat(
              halaqatList,
              teachersList,
              chosenCenter,
            );
            return Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () =>
                    Navigator.of(context, rootNavigator: false).push(
                  MaterialPageRoute(
                    builder: (context) => AdminNewTeacherScreen(
                      halaqatList: halaqatList,
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
              body: buildBody(teachersList, halaqatList, availableHalaqat),
            );
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

  Widget buildBody(
    List<Teacher> teachersList,
    List<Halaqa> halaqatList,
    List<Halaqa> availableHalaqatList,
  ) {
    if (teachersList.isNotEmpty) {
      return ListView.separated(
        itemCount: teachersList.length + 2,
        separatorBuilder: (context, index) => Divider(height: 0.5),
        itemBuilder: (context, index) {
          if (index == 0 || index == teachersList.length + 1) {
            return Container();
          }
          List<Halaqa> currentHalaqaList = List();
          currentHalaqaList.addAll(availableHalaqatList);

          Teacher teacher = teachersList[index - 1];
          if (teacher.halaqatTeachingIn.isNotEmpty) {
            for (String currentHalaqaId in teacher.halaqatTeachingIn) {
              for (Halaqa halaqa in halaqatList) {
                if (currentHalaqaId == halaqa.id) currentHalaqaList.add(halaqa);
              }
            }
          }
          return AdminTeacherTileWidget(
            halaqatList: currentHalaqaList,
            teacher: teacher,
            chosenTeacherState: chosenTeacherState,
            bloc: bloc,
            scaffoldKey: _scaffoldKey,
            chosenCenter: chosenCenter,
          );
        },
      );
    } else {
      return EmptyContent(
        title: 'لا يوجد  ',
        message: 'لا يوجد  ',
      );
    }
  }
}
