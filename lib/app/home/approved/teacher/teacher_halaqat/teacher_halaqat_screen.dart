import 'package:alhalaqat/app/home/approved/teacher/teacher_halaqat/teacher_halaqa_tile_widget.dart';
import 'package:alhalaqat/app/home/approved/teacher/teacher_halaqat/teacher_halaqat_bloc.dart';
import 'package:alhalaqat/app/home/approved/teacher/teacher_halaqat/teacher_halaqat_provider.dart';
import 'package:alhalaqat/app/home/approved/teacher/teacher_halaqat/teacher_new_halaqa_screen.dart';
import 'package:alhalaqat/app/logs_helper/logs_helper_bloc.dart';
import 'package:alhalaqat/app/models/halaqa.dart';
import 'package:alhalaqat/app/models/study_center.dart';
import 'package:alhalaqat/app/models/teacher.dart';
import 'package:alhalaqat/app/models/user.dart';
import 'package:alhalaqat/common_widgets/empty_content.dart';
import 'package:alhalaqat/constants/key_translate.dart';
import 'package:alhalaqat/services/auth.dart';
import 'package:alhalaqat/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TeacherHalaqatScreen extends StatefulWidget {
  const TeacherHalaqatScreen._({
    Key key,
    @required this.bloc,
    @required this.center,
  }) : super(key: key);

  final TeacherHalaqaBloc bloc;
  final StudyCenter center;

  static Widget create({
    @required BuildContext context,
    @required StudyCenter center,
  }) {
    Database database = Provider.of<Database>(context, listen: false);
    User user = Provider.of<User>(context, listen: false);
    Auth auth = Provider.of<Auth>(context, listen: false);
    LogsHelperBloc logsHelperBloc =
        Provider.of<LogsHelperBloc>(context, listen: false);

    TeacherHalaqatProvider provider =
        TeacherHalaqatProvider(database: database);
    TeacherHalaqaBloc bloc = TeacherHalaqaBloc(
      auth: auth,
      teacher: user,
      provider: provider,
      logsHelperBloc: logsHelperBloc,
    );

    return TeacherHalaqatScreen._(
      bloc: bloc,
      center: center,
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
  List<String> sortOptions = KeyTranslate.sort.keys.toList();
  String sortOption;
  List<Halaqa> halaqatList;
  @override
  void initState() {
    sortOption = sortOptions.elementAt(0);
    chosenCenter = widget.center;
    halaqatListStream = bloc.fetchHalaqat(bloc.teacher.halaqatTeachingIn);
    numberOfHalaqatTeachingIn = bloc.teacher.halaqatTeachingIn?.length;
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
        title: Text('إدارة الحلقات'),
        centerTitle: true,
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
            halaqatList = bloc.getFilteredHalaqatList(
              snapshot.data,
              chosenCenter,
            );
            sort();
            if (halaqatList.isNotEmpty) {
              return _buildList();
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

  Widget _buildList() {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: sortOption,
              isExpanded: false,
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
                  child: Text(
                    KeyTranslate.sort[value],
                    textAlign: TextAlign.right,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            itemCount: halaqatList.length,
            separatorBuilder: (context, index) => Divider(height: 0.5),
            itemBuilder: (context, index) {
              return Column(
                children: [
                  TeacherHalqaTileWidget(
                    halaqa: halaqatList[index],
                    chosenCenter: chosenCenter,
                    bloc: bloc,
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
