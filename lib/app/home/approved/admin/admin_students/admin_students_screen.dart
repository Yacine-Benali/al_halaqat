import 'package:al_halaqat/app/home/approved/admin/admin_students/admin_new_student_screen.dart';
import 'package:al_halaqat/app/home/approved/admin/admin_students/admin_student_tile_widget.dart';
import 'package:al_halaqat/app/home/approved/admin/admin_students/admin_students_bloc.dart';
import 'package:al_halaqat/app/home/approved/admin/admin_students/admin_students_provider.dart';
import 'package:al_halaqat/app/home/approved/globalAdmin/ga_admins/ga_admins_bloc.dart';
import 'package:al_halaqat/app/home/approved/globalAdmin/ga_admins/ga_admins_provider.dart';
import 'package:al_halaqat/app/home/approved/globalAdmin/ga_admins/ga_admins_tile_widget.dart';
import 'package:al_halaqat/app/home/approved/globalAdmin/ga_admins/ga_new_admin_screen.dart';
import 'package:al_halaqat/app/models/admin.dart';
import 'package:al_halaqat/app/models/student.dart';
import 'package:al_halaqat/app/models/study_center.dart';
import 'package:al_halaqat/app/models/user.dart';
import 'package:al_halaqat/common_packages/pk_search_bar/pk_search_bar.dart';
import 'package:al_halaqat/common_widgets/empty_content.dart';
import 'package:al_halaqat/constants/key_translate.dart';
import 'package:al_halaqat/services/auth.dart';
import 'package:al_halaqat/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminsStudentsScreen extends StatefulWidget {
  const AdminsStudentsScreen._({
    Key key,
    @required this.bloc,
    @required this.centers,
  }) : super(key: key);

  final AdminStudentsBloc bloc;
  final List<StudyCenter> centers;

  static Widget create({
    @required BuildContext context,
    @required List<StudyCenter> centers,
  }) {
    Database database = Provider.of<Database>(context, listen: false);
    User admin = Provider.of<User>(context, listen: false);
    Auth auth = Provider.of<Auth>(context, listen: false);

    AdminStudentsProvider provider = AdminStudentsProvider(database: database);
    AdminStudentsBloc bloc = AdminStudentsBloc(
      provider: provider,
      admin: admin,
      auth: auth,
    );

    return AdminsStudentsScreen._(
      bloc: bloc,
      centers: centers,
    );
  }

  @override
  _AdminsStudentsScreenState createState() => _AdminsStudentsScreenState();
}

class _AdminsStudentsScreenState extends State<AdminsStudentsScreen> {
  AdminStudentsBloc get bloc => widget.bloc;
  Stream<List<Student>> studentsStream;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //
  List<String> studentStateList =
      KeyTranslate.globalAdminsStateList.keys.toList();

  StudyCenter chosenCenter;
  String chosenStudentState;

  @override
  void initState() {
    studentsStream = bloc.fetchStudents(widget.centers);
    chosenCenter = widget.centers[0];
    chosenStudentState = studentStateList[0];
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.only(left: 20.0),
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
          Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Center(
              child: DropdownButton<String>(
                dropdownColor: Colors.indigo,
                value: chosenStudentState,
                icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                iconSize: 24,
                underline: Container(),
                elevation: 0,
                style: TextStyle(color: Colors.white, fontSize: 20),
                onChanged: (String newValue) {
                  setState(() {
                    chosenStudentState = newValue;
                  });
                },
                items: studentStateList
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
            builder: (context) => AdminNewStudentScreen(
              bloc: bloc,
              student: null,
              chosenCenter: chosenCenter,
            ),
            fullscreenDialog: true,
          ),
        ),
        tooltip: 'add',
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<List<Student>>(
        stream: studentsStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Student> studentsList = bloc.getFilteredStudentsList(
              snapshot.data,
              chosenCenter,
              chosenStudentState,
            );
            if (studentsList.isNotEmpty) {
              return _buildList(studentsList);
            } else {
              return EmptyContent(
                title: 'لا يوجد أي طلاب',
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

  Widget _buildList(List<Student> studentsList) {
    return SearchBar<Student>(
      searchBarPadding: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 5),
      headerPadding: EdgeInsets.only(left: 0, right: 0),
      listPadding: EdgeInsets.only(left: 0, right: 0),
      hintText: "Search Placeholder",
      hintStyle: TextStyle(
        color: Colors.black54,
      ),
      textStyle: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.normal,
      ),
      iconActiveColor: Colors.deepPurple,
      shrinkWrap: true,
      mainAxisSpacing: 5,
      crossAxisSpacing: 5,
      suggestions: studentsList,
      minimumChars: 1,
      emptyWidget: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Text("There is no any data found"),
        ),
      ),
      onError: (error) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Text("$error", textAlign: TextAlign.center),
          ),
        );
      },
      onSearch: (s) async => bloc.getStudentSearch(studentsList, s),
      buildSuggestion: (Student student, int index) {
        return AdminStudentTileWidget(
          bloc: bloc,
          chosenCenter: chosenCenter,
          chosenStudentState: chosenStudentState,
          scaffoldKey: _scaffoldKey,
          student: student,
        );
      },
      onItemFound: (Student student, int index) {
        return AdminStudentTileWidget(
          bloc: bloc,
          chosenCenter: chosenCenter,
          chosenStudentState: chosenStudentState,
          scaffoldKey: _scaffoldKey,
          student: student,
        );
      },
    );
  }
}