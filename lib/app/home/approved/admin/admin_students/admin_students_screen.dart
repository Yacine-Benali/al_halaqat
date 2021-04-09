import 'package:alhalaqat/app/conversation_helper/conversation_helper_bloc.dart';
import 'package:alhalaqat/app/home/approved/admin/admin_students/admin_new_student_screen.dart';
import 'package:alhalaqat/app/home/approved/admin/admin_students/admin_student_tile_widget.dart';
import 'package:alhalaqat/app/home/approved/admin/admin_students/admin_students_bloc.dart';
import 'package:alhalaqat/app/home/approved/admin/admin_students/admin_students_provider.dart';
import 'package:alhalaqat/app/logs_helper/logs_helper_bloc.dart';
import 'package:alhalaqat/app/models/admin.dart';
import 'package:alhalaqat/app/models/halaqa.dart';
import 'package:alhalaqat/app/models/quran.dart';
import 'package:alhalaqat/app/models/student.dart';
import 'package:alhalaqat/app/models/study_center.dart';
import 'package:alhalaqat/app/models/user.dart';
import 'package:alhalaqat/app/models/user_halaqa.dart';
import 'package:alhalaqat/common_packages/pk_search_bar/pk_search_bar.dart';
import 'package:alhalaqat/common_widgets/empty_content.dart';
import 'package:alhalaqat/common_widgets/platform_exception_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/platform_report_dialog.dart';
import 'package:alhalaqat/common_widgets/progress_dialog.dart';
import 'package:alhalaqat/constants/key_translate.dart';
import 'package:alhalaqat/services/auth.dart';
import 'package:alhalaqat/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

//! add halaqa-state widget
class AdminsStudentsScreen extends StatefulWidget {
  const AdminsStudentsScreen._({
    Key key,
    @required this.bloc,
    @required this.center,
  }) : super(key: key);

  final AdminStudentsBloc bloc;
  final StudyCenter center;

  static Widget create({
    @required BuildContext context,
    @required StudyCenter center,
  }) {
    Database database = Provider.of<Database>(context, listen: false);
    User admin = Provider.of<User>(context, listen: false);
    Auth auth = Provider.of<Auth>(context, listen: false);
    ConversationHelpeBloc conversationHelper =
        Provider.of<ConversationHelpeBloc>(context, listen: false);
    LogsHelperBloc logsHelperBloc =
        Provider.of<LogsHelperBloc>(context, listen: false);
    AdminStudentsProvider provider = AdminStudentsProvider(database: database);
    AdminStudentsBloc bloc = AdminStudentsBloc(
      provider: provider,
      admin: admin,
      auth: auth,
      conversationHelper: conversationHelper,
      logsHelperBloc: logsHelperBloc,
    );

    return AdminsStudentsScreen._(
      bloc: bloc,
      center: center,
    );
  }

  @override
  _AdminsStudentsScreenState createState() => _AdminsStudentsScreenState();
}

class _AdminsStudentsScreenState extends State<AdminsStudentsScreen> {
  AdminStudentsBloc get bloc => widget.bloc;
  Stream<UserHalaqa<Student>> studentsStream;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ProgressDialog pr;

  //
  List<String> studentStateList;
  Future<Quran> quranFuture;
  Quran quran;
  StudyCenter chosenCenter;
  String chosenStudentState;
  //
  UserHalaqa<Student> studentHalaqaList;

  @override
  void initState() {
    if (bloc.admin is Admin) {
      studentStateList = KeyTranslate.adminStudentsState.keys.toList();
    } else {
      studentStateList = KeyTranslate.gaStudentsState.keys.toList();
    }
    studentsStream = bloc.fetchStudents([widget.center]);
    quranFuture = bloc.fetchQuran();

    chosenCenter = widget.center;
    chosenStudentState = studentStateList[0];
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

  Future<void> downloadReport() async {
    try {
      final isPermissionStatusGranted = await _requestPermissions();

      if (isPermissionStatusGranted) {
        await pr.show();
        String filePath = await bloc.getReportasCsv(
          studentHalaqaList,
          chosenCenter,
          chosenStudentState,
        );
        await pr.hide();
        await PlatformReportDialog(filePath: filePath).show(context);
      } else {
        throw PlatformException(
          code: 'storage permission are required',
          message: 'storage permission are required',
        );
      }
    } on Exception catch (e) {
      await pr.hide();
      if (e is PlatformException)
        PlatformExceptionAlertDialog(
          title: 'فشلت العملية',
          exception: e,
        ).show(context);
    }
  }

  Future<bool> _requestPermissions() async {
    var permission = await Permission.storage.status;

    if (permission != PermissionStatus.granted)
      permission = await Permission.storage.request();

    return permission == PermissionStatus.granted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        actions: [
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
                    child: Text(KeyTranslate.gaStudentsState[value]),
                  );
                }).toList(),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: IconButton(
              icon: Icon(Icons.cloud_download),
              onPressed: () =>
                  studentHalaqaList == null ? null : downloadReport(),
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: quranFuture,
        builder: (context, quranSnapshot) {
          return StreamBuilder<UserHalaqa<Student>>(
            stream: studentsStream,
            builder: (context, snapshot) {
              if (snapshot.hasData && quranSnapshot.hasData) {
                quran = quranSnapshot.data;
                studentHalaqaList = snapshot.data;
                List<Student> studentsList = bloc.getFilteredStudentsList(
                  snapshot.data.usersList,
                  chosenCenter,
                  chosenStudentState,
                );
                List<Halaqa> halaqatList = bloc.getFilteredHalaqaList(
                  snapshot.data.halaqatList,
                  chosenCenter,
                );

                return Scaffold(
                  floatingActionButton: FloatingActionButton(
                    onPressed: () =>
                        Navigator.of(context, rootNavigator: false).push(
                      MaterialPageRoute(
                        builder: (context) => AdminNewStudentScreen(
                          bloc: bloc,
                          student: null,
                          chosenCenter: chosenCenter,
                          halaqatList: halaqatList,
                        ),
                        fullscreenDialog: true,
                      ),
                    ),
                    tooltip: 'add',
                    child: Icon(Icons.add),
                  ),
                  body: buildBody(studentsList, halaqatList),
                );
              } else if (snapshot.hasError || quranSnapshot.hasError) {
                return EmptyContent(
                  title: 'Something went wrong',
                  message: 'Can\'t load items right now',
                );
              }
              return Center(child: CircularProgressIndicator());
            },
          );
        },
      ),
    );
  }

  Widget buildBody(List<Student> studentsList, List<Halaqa> halaqatList) {
    if (studentsList.isNotEmpty) {
      return _buildList(studentsList, halaqatList);
    } else {
      return EmptyContent(
        title: 'لا يوجد أي طلاب',
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
              AdminStudentTileWidget(
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
        return AdminStudentTileWidget(
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
        return AdminStudentTileWidget(
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
