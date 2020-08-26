import 'package:al_halaqat/app/home/approved/common_screens/student_profile/student_profile_screen.dart';
import 'package:al_halaqat/app/home/approved/teacher/teacher_students/teacher_new_student_screen.dart';
import 'package:al_halaqat/app/home/approved/teacher/teacher_students/teacher_students_bloc.dart';
import 'package:al_halaqat/app/models/halaqa.dart';
import 'package:al_halaqat/app/models/quran.dart';
import 'package:al_halaqat/app/models/student.dart';
import 'package:al_halaqat/app/models/study_center.dart';
import 'package:al_halaqat/common_widgets/progress_dialog.dart';
import 'package:al_halaqat/constants/key_translate.dart';
import 'package:flutter/material.dart';

class TeacherStudentTileWidget extends StatefulWidget {
  TeacherStudentTileWidget({
    Key key,
    @required this.student,
    @required this.chosenStudentState,
    @required this.bloc,
    @required this.scaffoldKey,
    @required this.chosenCenter,
    @required this.halaqatList,
    @required this.quran,
  }) : super(key: key);

  final Student student;
  final String chosenStudentState;
  final TeacherStudentsBloc bloc;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final StudyCenter chosenCenter;
  final List<Halaqa> halaqatList;
  final Quran quran;

  @override
  _AdminStudentTileWidgetState createState() => _AdminStudentTileWidgetState();
}

class _AdminStudentTileWidgetState extends State<TeacherStudentTileWidget> {
  ProgressDialog pr;

  @override
  void initState() {
    pr = ProgressDialog(
      widget.scaffoldKey.currentContext,
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

  Future<void> _executeAction(String action) async {
    await Navigator.of(context, rootNavigator: false).push(
      MaterialPageRoute(
        builder: (context) => TeacherNewStudentScreen(
          bloc: widget.bloc,
          student: widget.student,
          chosenCenter: widget.chosenCenter,
          halaqatList: widget.halaqatList,
          isRemovable: widget.chosenCenter.canTeacherRemoveStudentsFromHalaqa,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  Widget _buildAction() {
    List<String> actions;
    if (widget.chosenCenter.canTeachersEditStudents) {
      actions = ['edit'];
    } else {
      return SizedBox();
    }

    return PopupMenuButton<String>(
      itemBuilder: (BuildContext context) => List.generate(
        actions.length,
        (i) {
          return PopupMenuItem<String>(
            value: actions[i],
            child: Text(KeyTranslate.centersActionsList[actions[i]]),
          );
        },
      ),
      onSelected: (value) => _executeAction(value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(widget.student.name),
          subtitle: Text(widget.student.readableId),
          trailing: widget.student.state == 'deleted'
              ? Container(
                  height: 1,
                  width: 1,
                )
              : _buildAction(),
          enabled: widget.student.state == 'approved' ? true : false,
          onTap: () => Navigator.of(context, rootNavigator: false).push(
            MaterialPageRoute(
              builder: (context) => StudentProfileScreen.create(
                context: context,
                halaqatList: widget.halaqatList,
                student: widget.student,
                quran: widget.quran,
              ),
              fullscreenDialog: true,
            ),
          ),
        ),
        Divider(
          height: 0.5,
        )
      ],
    );
  }
}
