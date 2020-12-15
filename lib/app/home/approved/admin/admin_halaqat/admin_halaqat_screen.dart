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
  List<String> sortOptions = KeyTranslate.sort.keys.toList();
  String sortOption;
  List<Halaqa> halaqatList;
  @override
  void initState() {
    sortOption = sortOptions.elementAt(0);

    if (bloc.admin is Admin) {
      halaqatStateList = KeyTranslate.adminHalaqatState.keys.toList();
    } else {
      halaqatStateList = KeyTranslate.gaHalaqatState.keys.toList();
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
        title: Center(child: Text('الحلقات')),
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
                    child: Text(KeyTranslate.gaHalaqatState[value]),
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
            halaqatList = bloc.getFilteredHalaqatList(
              snapshot.data.halaqatList,
              chosenHalaqaState,
              chosenCenter,
            );
            sort();
            if (halaqatList.isNotEmpty) {
              return _buildList(teachersList);
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

  void sort() {
    if ((halaqatList?.length ?? 0) != 0) {
      if (sortOption == 'sortById') {
        halaqatList.sort((a, b) {
          return a.readableId.compareTo(b.readableId);
        });
      } else if (sortOption == 'sortByName') {
        halaqatList.sort((a, b) {
          return a.name.compareTo(b.name);
        });
      }
    }
  }

  Widget _buildList(List<Teacher> teachersLis) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButton<String>(
            value: sortOption,
            isExpanded: true,
            iconSize: 24,
            elevation: 16,
            onChanged: (String newValue) {
              sortOption = newValue;
              // sort() no need to call it since it will be called when
              // rebuilding the StreamBuilder widget
              setState(() {});
            },
            items: sortOptions.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(KeyTranslate.sort[value]),
              );
            }).toList(),
          ),
        ),
        Expanded(
          child: ListView.separated(
            itemCount: halaqatList.length,
            separatorBuilder: (context, index) => Divider(height: 0.5),
            itemBuilder: (context, index) {
              Halaqa halaqa = halaqatList[index];
              Teacher teacher = bloc.getTeacherOfHalaqa(halaqa, teachersLis);
              return Column(
                children: [
                  AdminHalqaTileWidget(
                    teacher: teacher,
                    bloc: bloc,
                    halaqa: halaqa,
                    scaffoldKey: _scaffoldKey,
                    chosenHalaqaState: chosenHalaqaState,
                    chosenCenter: chosenCenter,
                    halaqatList: halaqatList,
                  ),
                  if (index == halaqatList.length - 1) ...[
                    SizedBox(height: 75),
                  ],
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
