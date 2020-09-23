import 'package:alhalaqat/app/home/approved/teacher/teacher_students/teacher_student_tile_widget.dart';
import 'package:alhalaqat/app/home/approved/teacher/teacher_students/teacher_students_bloc.dart';
import 'package:alhalaqat/app/models/halaqa.dart';
import 'package:alhalaqat/app/models/quran.dart';
import 'package:alhalaqat/app/models/student.dart';
import 'package:alhalaqat/app/models/study_center.dart';
import 'package:flutter/material.dart';

class FuckYouScreen extends StatefulWidget {
  FuckYouScreen({
    Key key,
    @required this.studentsList,
    @required this.bloc,
    @required this.chosenCenter,
    @required this.halaqatList,
    @required this.quran,
  }) : super(key: key);

  final List<Student> studentsList;
  final TeacherStudentsBloc bloc;
  final StudyCenter chosenCenter;
  final List<Halaqa> halaqatList;
  final Quran quran;

  @override
  _FuckYouScreenState createState() => _FuckYouScreenState();
}

class _FuckYouScreenState extends State<FuckYouScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.separated(
        itemCount: widget.studentsList.length + 2,
        separatorBuilder: (context, index) => Divider(height: 0.5),
        itemBuilder: (context, index) {
          if (index == 0 || index == widget.studentsList.length + 1) {
            return Container();
          }

          return TeacherStudentTileWidget(
            bloc: widget.bloc,
            chosenCenter: widget.chosenCenter,
            chosenStudentState: 'approved',
            scaffoldKey: _scaffoldKey,
            student: widget.studentsList[index - 1],
            halaqatList: widget.halaqatList,
            quran: widget.quran,
          );
        },
      ),
    );
  }
}
