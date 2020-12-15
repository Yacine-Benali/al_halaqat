import 'package:alhalaqat/app/conversation_helper/conversation_helper_bloc.dart';
import 'package:alhalaqat/app/home/approved/teacher/teacher_students/fuck_you_screen.dart';
import 'package:alhalaqat/app/home/approved/teacher/teacher_students/teacher_new_student_screen.dart';
import 'package:alhalaqat/app/home/approved/teacher/teacher_students/teacher_student_tile_widget.dart';
import 'package:alhalaqat/app/home/approved/teacher/teacher_students/teacher_students_bloc.dart';
import 'package:alhalaqat/app/home/approved/teacher/teacher_students/teacher_students_provider.dart';
import 'package:alhalaqat/app/logs_helper/logs_helper_bloc.dart';
import 'package:alhalaqat/app/models/halaqa.dart';
import 'package:alhalaqat/app/models/quran.dart';
import 'package:alhalaqat/app/models/student.dart';
import 'package:alhalaqat/app/models/study_center.dart';
import 'package:alhalaqat/app/models/user.dart';
import 'package:alhalaqat/app/models/user_halaqa.dart';
import 'package:alhalaqat/common_packages/pk_search_bar/pk_search_bar.dart';
import 'package:alhalaqat/common_widgets/empty_content.dart';
import 'package:alhalaqat/common_widgets/platform_exception_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/progress_dialog.dart';
import 'package:alhalaqat/services/auth.dart';
import 'package:alhalaqat/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class TeacherStudentsScreen extends StatefulWidget {
  const TeacherStudentsScreen._({
    Key key,
    @required this.bloc,
    @required this.centers,
  }) : super(key: key);

  final TeacherStudentsBloc bloc;
  final List<StudyCenter> centers;

  static Widget create({
    @required BuildContext context,
    @required List<StudyCenter> centers,
  }) {
    Database database = Provider.of<Database>(context, listen: false);
    User teacher = Provider.of<User>(context, listen: false);
    Auth auth = Provider.of<Auth>(context, listen: false);

    TeacherStudentsProvider provider =
        TeacherStudentsProvider(database: database);
    ConversationHelpeBloc conversationHelper =
        Provider.of<ConversationHelpeBloc>(context, listen: false);
    LogsHelperBloc logsHelperBloc =
        Provider.of<LogsHelperBloc>(context, listen: false);
    TeacherStudentsBloc bloc = TeacherStudentsBloc(
      provider: provider,
      teacher: teacher,
      auth: auth,
      conversationHelper: conversationHelper,
      logsHelperBloc: logsHelperBloc,
    );

    return TeacherStudentsScreen._(
      bloc: bloc,
      centers: centers,
    );
  }

  @override
  _AdminsStudentsScreenState createState() => _AdminsStudentsScreenState();
}

class _AdminsStudentsScreenState extends State<TeacherStudentsScreen> {
  TeacherStudentsBloc get bloc => widget.bloc;
  Stream<UserHalaqa<Student>> studentsStream;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<Quran> quranFuture;
  Quran quran;
  StudyCenter chosenCenter;
  String chosenStudentState;
  ProgressDialog pr;
  List<Halaqa> halaqatList;

  @override
  void initState() {
    studentsStream = bloc.fetchStudents();
    quranFuture = bloc.fetchQuran();
    chosenCenter = widget.centers[0];
    chosenStudentState = 'approved';
    pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      textDirection: TextDirection.ltr,
      isDismissible: false,
    );
    pr.style(
      message: 'جاري تحميل',
      messageTextStyle: TextStyle(fontSize: 14),
      progressWidget: Container(
        padding: EdgeInsets.all(8.0),
        child: CircularProgressIndicator(),
      ),
    );
    super.initState();
  }

  Future<void> searchForStudent(String nameOrId) async {
    await pr.show();

    List<Student> students = await bloc.fetchStudent(nameOrId, chosenCenter);

    if (students != null) {
      if (students.length == 0) {
        await pr.hide();
        await PlatformExceptionAlertDialog(
          title: 'فشلت العملية',
          exception: PlatformException(
            code: 'NO_USER_FOUND',
            message: 'لايوجد طالب بهذا الرقم أو الاسم',
          ),
        ).show(context);
      }
      if (students.length == 1) {
        Student student = students[0];
        if (student != null) {
          await pr.hide();
          await Navigator.of(context, rootNavigator: false).push(
            MaterialPageRoute(
              builder: (context) => TeacherNewStudentScreen(
                bloc: bloc,
                student: student,
                chosenCenter: chosenCenter,
                halaqatList: halaqatList,
                isRemovable: chosenCenter.canTeacherRemoveStudentsFromHalaqa,
              ),
              fullscreenDialog: true,
            ),
          );
        }
      } else if (students.length > 1) {
        await pr.hide();
        await Navigator.of(context, rootNavigator: false).push(
          MaterialPageRoute(
            builder: (context) => FuckYouScreen(
              studentsList: students,
              bloc: bloc,
              chosenCenter: chosenCenter,
              halaqatList: halaqatList,
              quran: quran,
            ),
            fullscreenDialog: true,
          ),
        );
      }
    } else {
      await pr.hide();
      await PlatformExceptionAlertDialog(
        title: 'فشلت العملية',
        exception: PlatformException(
          code: 'NO_USER_FOUND',
          message: 'لايوجد طالب بهذا الرقم أو الاسم',
        ),
      ).show(context);
    }
  }

  Future<void> searchForStudentDialog() async {
    String nameOrId;
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        title: Center(
          child: Text(
            'أدخل اسم أو الرقم التعريفي :',
          ),
        ),
        content: StatefulBuilder(builder: (context, StateSetter setState) {
          return Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        counterText: '',
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.indigo,
                          ),
                        ),
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      onChanged: (value) => nameOrId = value,
                      validator: (value) => value.isEmpty ? 'خطأ' : null,
                      maxLength: 60,
                      keyboardAppearance: Brightness.light,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        side: BorderSide(color: Colors.indigo),
                      ),
                      onPressed: () async {
                        if (formKey.currentState.validate()) {
                          Navigator.of(context).pop();
                          await searchForStudent(nameOrId);
                        }
                      },
                      color: Colors.white,
                      textColor: Colors.indigo,
                      child: Text(
                        "إبحث",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: FutureBuilder(
        future: quranFuture,
        builder: (context, quranSnapshot) {
          return StreamBuilder<UserHalaqa<Student>>(
            stream: studentsStream,
            builder: (context, snapshot) {
              if (snapshot.hasData && quranSnapshot.hasData) {
                quran = quranSnapshot.data;
                List<Student> studentsList = bloc.getFilteredStudentsList(
                  snapshot.data.usersList,
                  chosenCenter,
                  chosenStudentState,
                );
                halaqatList = bloc.getFilteredHalaqaList(
                  snapshot.data.halaqatList,
                  chosenCenter,
                );

                return Scaffold(
                  appBar: AppBar(
                    actions: [
                      Padding(
                        padding: EdgeInsets.only(left: 20.0),
                        child: Center(
                          child: DropdownButton<StudyCenter>(
                            dropdownColor: Colors.indigo,
                            value: chosenCenter,
                            icon: Icon(Icons.arrow_drop_down,
                                color: Colors.white),
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
                                .map<DropdownMenuItem<StudyCenter>>(
                                    (StudyCenter value) {
                              return DropdownMenuItem<StudyCenter>(
                                value: value,
                                child: Text(value.name),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      chosenCenter.canTeachersEditStudents
                          ? Padding(
                              padding: EdgeInsets.only(left: 20.0),
                              child: Center(
                                child: InkWell(
                                  onTap: () => searchForStudentDialog(),
                                  child: Icon(
                                    Icons.search,
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                  floatingActionButton: chosenCenter.canTeachersEditStudents
                      ? FloatingActionButton(
                          onPressed: () =>
                              Navigator.of(context, rootNavigator: false).push(
                            MaterialPageRoute(
                              builder: (context) => TeacherNewStudentScreen(
                                bloc: bloc,
                                student: null,
                                chosenCenter: chosenCenter,
                                halaqatList: halaqatList,
                                isRemovable: chosenCenter
                                    .canTeacherRemoveStudentsFromHalaqa,
                              ),
                              fullscreenDialog: true,
                            ),
                          ),
                          tooltip: 'add',
                          child: Icon(Icons.add),
                        )
                      : Container(),
                  body: buildBody(studentsList, halaqatList),
                );
              } else if (snapshot.hasError || quranSnapshot.hasError) {
                return EmptyContent(
                  title: 'Something went wrong',
                  message: 'Can\'t load items right now',
                );
              }
              return Scaffold(
                  appBar: AppBar(),
                  body: Center(child: CircularProgressIndicator()));
            },
          );
        },
      ),
    );
  }

  Widget buildBody(List<Student> teachersList, List<Halaqa> halaqatList) {
    if (teachersList.isNotEmpty) {
      return _buildList(teachersList, halaqatList);
    } else {
      return EmptyContent(
        title: 'لا يوجد  ',
        message: '',
      );
    }
  }

  Widget _buildList(List<Student> studentsList, List<Halaqa> halaqatList) {
    return SearchBar<Student>(
      searchBarPadding: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 5),
      headerPadding: EdgeInsets.only(left: 0, right: 0),
      listPadding: EdgeInsets.only(left: 0, right: 0),
      hintText: "إبحث بالاسم  أو الرقم التعريفي",
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
          child: Text("لم يتم العثور على أي طالب"),
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
        if (index == studentsList.length - 1) {
          return Column(
            children: [
              TeacherStudentTileWidget(
                bloc: bloc,
                chosenCenter: chosenCenter,
                chosenStudentState: chosenStudentState,
                scaffoldKey: _scaffoldKey,
                student: student,
                halaqatList: halaqatList,
                quran: quran,
              ),
              SizedBox(height: 75),
            ],
          );
        }
        return TeacherStudentTileWidget(
          bloc: bloc,
          chosenCenter: chosenCenter,
          chosenStudentState: chosenStudentState,
          scaffoldKey: _scaffoldKey,
          student: student,
          halaqatList: halaqatList,
          quran: quran,
        );
      },
      onItemFound: (Student student, int index) {
        return TeacherStudentTileWidget(
          halaqatList: halaqatList,
          bloc: bloc,
          chosenCenter: chosenCenter,
          chosenStudentState: chosenStudentState,
          scaffoldKey: _scaffoldKey,
          student: student,
          quran: quran,
        );
      },
    );
  }
}
