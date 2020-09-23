import 'package:alhalaqat/app/home/approved/admin/admin_halaqat/admin_halaqa_tile_widget.dart';
import 'package:alhalaqat/app/home/approved/admin/admin_halaqat/admin_halaqat_bloc.dart';
import 'package:alhalaqat/app/home/approved/admin/admin_halaqat/admin_halaqat_provider.dart';
import 'package:alhalaqat/app/home/approved/admin/admin_halaqat/admin_new_halaqa_screen.dart';
import 'package:alhalaqat/app/logs_helper/logs_helper_bloc.dart';
import 'package:alhalaqat/app/models/admin.dart';
import 'package:alhalaqat/app/models/halaqa.dart';
import 'package:alhalaqat/app/models/study_center.dart';
import 'package:alhalaqat/app/models/teacher.dart';
import 'package:alhalaqat/app/models/user.dart';
import 'package:alhalaqat/app/models/user_halaqa.dart';
import 'package:alhalaqat/common_widgets/empty_content.dart';
import 'package:alhalaqat/constants/key_translate.dart';
import 'package:alhalaqat/services/auth.dart';
import 'package:alhalaqat/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminHalaqatScreen extends StatefulWidget {
  const AdminHalaqatScreen._({
    Key key,
    @required this.bloc,
    @required this.centers,
  }) : super(key: key);

  final AdminHalaqaBloc bloc;
  final List<StudyCenter> centers;

  static Widget create({
    @required BuildContext context,
    @required List<StudyCenter> centers,
  }) {
    Database database = Provider.of<Database>(context, listen: false);
    User user = Provider.of<User>(context, listen: false);
    Auth auth = Provider.of<Auth>(context, listen: false);
    LogsHelperBloc logsHelperBloc =
        Provider.of<LogsHelperBloc>(context, listen: false);

    AdminHalaqatProvider provider = AdminHalaqatProvider(database: database);
    AdminHalaqaBloc bloc = AdminHalaqaBloc(
      auth: auth,
      admin: user,
      provider: provider,
      logsHelperBloc: logsHelperBloc,
    );

    return AdminHalaqatScreen._(
      bloc: bloc,
      centers: centers,
    );
  }

  @override
  _AdminHalaqatScreenState createState() => _AdminHalaqatScreenState();
}

class _AdminHalaqatScreenState extends State<AdminHalaqatScreen> {
  AdminHalaqaBloc get bloc => widget.bloc;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> halaqatStateList;

  String chosenHalaqaState;
  StudyCenter chosenCenter;
  Stream<UserHalaqa<Teacher>> teachersHalaqatListStream;

  @override
  void initState() {
    if (bloc.admin is Admin) {
      halaqatStateList = KeyTranslate.adminCentersStateList.keys.toList();
    } else {
      halaqatStateList = KeyTranslate.centersStateList.keys.toList();
    }
    chosenCenter = widget.centers[0];
    chosenHalaqaState = halaqatStateList[0];
    teachersHalaqatListStream = bloc.fetchTeachers(widget.centers);

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
                value: chosenHalaqaState,
                icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                iconSize: 24,
                underline: Container(),
                elevation: 0,
                style: TextStyle(color: Colors.white, fontSize: 20),
                onChanged: (String newValue) {
                  setState(() {
                    chosenHalaqaState = newValue;
                  });
                },
                items: halaqatStateList
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
            builder: (context) => AdminNewHalaqaScreen(
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
      body: StreamBuilder<UserHalaqa<Teacher>>(
        stream: teachersHalaqatListStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Teacher> teachersList = snapshot.data.usersList;
            List<Halaqa> halaqatList = bloc.getFilteredHalaqatList(
              snapshot.data.halaqatList,
              chosenHalaqaState,
              chosenCenter,
            );
            if (halaqatList.isNotEmpty) {
              return _buildList(halaqatList, teachersList);
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

  Widget _buildList(List<Halaqa> halaqatList, List<Teacher> teachersLis) {
    return ListView.separated(
      itemCount: halaqatList.length + 2,
      separatorBuilder: (context, index) => Divider(height: 0.5),
      itemBuilder: (context, index) {
        if (index == 0 || index == halaqatList.length + 1) {
          return Container();
        }
        Halaqa halaqa = halaqatList[index - 1];
        Teacher teacher = bloc.getTeacherOfHalaqa(halaqa, teachersLis);

        return AdminHalqaTileWidget(
          teacher: teacher,
          bloc: bloc,
          halaqa: halaqa,
          scaffoldKey: _scaffoldKey,
          chosenHalaqaState: chosenHalaqaState,
          chosenCenter: chosenCenter,
          halaqatList: halaqatList,
        );
      },
    );
  }
}
