import 'package:alhalaqat/app/common_forms/student_form.dart';
import 'package:alhalaqat/app/home/approved/teacher/teacher_students/teacher_students_bloc.dart';
import 'package:alhalaqat/app/models/global_admin.dart';
import 'package:alhalaqat/app/models/halaqa.dart';
import 'package:alhalaqat/app/models/student.dart';
import 'package:alhalaqat/app/models/study_center.dart';
import 'package:alhalaqat/app/models/user.dart';
import 'package:alhalaqat/common_widgets/firebase_exception_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/platform_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/platform_exception_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/progress_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class NewStudentScreen extends StatefulWidget {
  const NewStudentScreen({
    Key key,
    @required this.bloc,
    @required this.student,
    @required this.chosenCenter,
    @required this.halaqatList,
    @required this.isRemovable,
    @required this.preset,
  }) : super(key: key);

  final TeacherStudentsBloc bloc;
  final Student student;
  final StudyCenter chosenCenter;
  final List<Halaqa> halaqatList;
  final bool isRemovable;
  final String preset;

  @override
  _AdminNewStudentScreenState createState() => _AdminNewStudentScreenState();
}

class _AdminNewStudentScreenState extends State<NewStudentScreen> {
  final GlobalKey<FormState> studentFormKey = GlobalKey<FormState>();
  Student student;
  ProgressDialog pr;
  bool hidePassword;
  @override
  void initState() {
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
    User user = Provider.of<User>(context, listen: false);
    if (user is GlobalAdmin)
      hidePassword = false;
    else if (widget.student == null)
      hidePassword = false;
    else
      hidePassword = true;
    super.initState();
  }

  void save() async {
    if (studentFormKey.currentState.validate()) {
      if (student.halaqatLearningIn.length == 0) {
        PlatformAlertDialog(
          title: 'فشلت العملية',
          content: 'يجب إضافة الطالب إلى حلقة',
          defaultActionText: 'حسنا',
        ).show(context);
        return;
      }

      try {
        //   print(admin.centers);
        await pr.show();
        if (widget.student != null)
          await widget.bloc.modifieStudent(widget.student, student);
        else
          await widget.bloc.createStudent(student, widget.chosenCenter);

        await pr.hide();
        PlatformAlertDialog(
          title: 'نجح الحفظ',
          content: 'تم حفظ البيانات',
          defaultActionText: 'حسنا',
        ).show(context);
        Navigator.of(context).pop();
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('إملأ الإستمارة'),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: InkWell(
              onTap: () => save(),
              child: Icon(
                Icons.save,
                size: 26.0,
              ),
            ),
          ),
        ],
      ),
      body: StudentForm(
        halaqatList: widget.halaqatList,
        showUserHalaqa: true,
        includeUsernameAndPassword: true,
        includeCenterIdInput: false,
        student: widget.student,
        onSaved: (Student newStudent) => student = newStudent,
        studentFormKey: studentFormKey,
        center: null,
        includeCenterForm: false,
        isEnabled: true,
        isRemovable: widget.chosenCenter.canTeacherRemoveStudentsFromHalaqa,
        hidePassword: hidePassword,
        presetHalaqa: widget.preset,
      ),
    );
  }
}
