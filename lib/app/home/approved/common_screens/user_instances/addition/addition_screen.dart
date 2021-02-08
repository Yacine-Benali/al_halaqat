import 'package:alhalaqat/app/conversation_helper/conversation_helper_bloc.dart';
import 'package:alhalaqat/app/home/approved/common_screens/user_instances/addition/addition_bloc.dart';
import 'package:alhalaqat/app/home/approved/common_screens/user_instances/addition/addition_provider.dart';
import 'package:alhalaqat/app/home/approved/common_screens/user_instances/addition/addition_student_tile_widget.dart';
import 'package:alhalaqat/app/models/halaqa.dart';
import 'package:alhalaqat/app/models/student.dart';
import 'package:alhalaqat/common_packages/pk_search_bar/pk_search_bar.dart';
import 'package:alhalaqat/common_widgets/empty_content.dart';
import 'package:alhalaqat/common_widgets/firebase_exception_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/platform_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/platform_exception_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/progress_dialog.dart';
import 'package:alhalaqat/services/database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'addition_bloc.dart';

class AdditionScreen extends StatefulWidget {
  final AdditionBloc bloc;
  final Halaqa halaqa;

  AdditionScreen._({
    Key key,
    @required this.bloc,
    @required this.halaqa,
  }) : super(key: key);

  static Widget create({
    @required BuildContext context,
    @required Halaqa halaqa,
  }) {
    Database database = Provider.of<Database>(context, listen: false);

    AdditionProvider provider = AdditionProvider(database: database);
    ConversationHelpeBloc conversationHelper =
        Provider.of<ConversationHelpeBloc>(context, listen: false);

    AdditionBloc bloc = AdditionBloc(
      provider: provider,
      conversationHelpeBloc: conversationHelper,
      halaqa: halaqa,
    );

    return AdditionScreen._(
      bloc: bloc,
      halaqa: halaqa,
    );
  }

  @override
  _AdditionScreenState createState() => _AdditionScreenState();
}

class _AdditionScreenState extends State<AdditionScreen> {
  AdditionBloc get bloc => widget.bloc;

  ProgressDialog pr;
  Stream<List<Student>> studentsStream;
  List<Student> changedStudentList;

  @override
  void initState() {
    changedStudentList = List();
    studentsStream = bloc.fetchStudents();
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

  void save(List<Student> studentsList) async {
    try {
      //   print(admin.centers);
      await pr.show();
      await bloc.saveChanges(studentsList, changedStudentList);
      await pr.hide();
      PlatformAlertDialog(
        title: 'نجح الحفظ',
        content: 'تم حفظ البيانات',
        defaultActionText: 'حسنا',
      ).show(context);
      //Navigator.of(context).pop();
    } catch (e) {
      await pr.hide();
      if (e is PlatformException) {
        PlatformExceptionAlertDialog(
          title: 'فشلت العملية',
          exception: e,
        ).show(context);
      } else if (e is FirebaseException)
        FirebaseExceptionAlertDialog(
          title: 'فشلت العملية',
          exception: e,
        ).show(context);
      else
        PlatformAlertDialog(
          title: 'فشلت العملية',
          content: 'فشلت العملية',
          defaultActionText: 'حسنا',
        ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Student>>(
        stream: studentsStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Student> studentsList = snapshot.data;
            return Scaffold(
              appBar: AppBar(
                actions: [
                  Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: InkWell(
                      onTap: () => save(studentsList),
                      child: Icon(
                        Icons.save,
                        size: 26.0,
                      ),
                    ),
                  ),
                ],
              ),
              body: buildBody(studentsList),
            );
          } else if (snapshot.hasError) {
            return EmptyContent(
              title: 'Something went wrong',
              message: 'Can\'t load items right now',
            );
          }
          return Scaffold(
              appBar: AppBar(),
              body: Center(child: CircularProgressIndicator()));
        },
      ),
    );
  }

  void addStudentToSelectedList(Student student) {
    List<String> halaqatLearningIn = List.from(student.halaqatLearningIn);
    if (halaqatLearningIn.contains(bloc.halaqa.id)) {
      //print('unselected from');
      halaqatLearningIn.remove(bloc.halaqa.id);
    } else {
      //print('selected to halaqa');
      halaqatLearningIn.add(bloc.halaqa.id);
    }
    Student tempStudent =
        student.copyWith(halaqatLearningIn: halaqatLearningIn);
    bool isFound = false;
    for (Student existingStudent in changedStudentList) {
      if (existingStudent.id == tempStudent.id) {
        isFound = true;
        existingStudent.halaqatLearningIn =
            List.from(student.halaqatLearningIn);
      }
    }
    if (!isFound) {
      changedStudentList.add(tempStudent);
    }
  }

  Widget buildBody(List<Student> studentsList) {
    if (studentsList.isNotEmpty) {
      return _buildList(studentsList);
    } else {
      return EmptyContent(
        title: 'لا يوجد  ',
        message: '',
      );
    }
  }

  Widget buildStudentTile(Student student) {
    return AdditionStudentTileWidget(
      student: student,
      halaqa: bloc.halaqa,
      onStudentSelected: addStudentToSelectedList,
    );
  }

  Widget _buildList(List<Student> studentsList) {
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
              buildStudentTile(student),
              SizedBox(height: 75),
            ],
          );
        }
        return buildStudentTile(student);
      },
      onItemFound: (Student student, int index) {
        return buildStudentTile(student);
      },
    );
  }
}
