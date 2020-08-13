import 'package:al_halaqat/app/common_screens/student_form.dart';
import 'package:al_halaqat/app/home/approved/admin/admin_students/admin_students_bloc.dart';
import 'package:al_halaqat/app/models/student.dart';
import 'package:al_halaqat/app/models/study_center.dart';
import 'package:al_halaqat/common_widgets/platform_alert_dialog.dart';
import 'package:al_halaqat/common_widgets/platform_exception_alert_dialog.dart';
import 'package:al_halaqat/common_widgets/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdminNewStudentScreen extends StatefulWidget {
  const AdminNewStudentScreen({
    Key key,
    @required this.bloc,
    @required this.student,
    @required this.chosenCenter,
  }) : super(key: key);

  final AdminStudentsBloc bloc;
  final Student student;
  final StudyCenter chosenCenter;

  @override
  _AdminNewStudentScreenState createState() => _AdminNewStudentScreenState();
}

class _AdminNewStudentScreenState extends State<AdminNewStudentScreen> {
  final GlobalKey<FormState> studentFormKey = GlobalKey<FormState>();
  Student student;
  ProgressDialog pr;

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
    super.initState();
  }

  void save() async {
    if (studentFormKey.currentState.validate()) {
      try {
        //   print(admin.centers);
        await pr.show();
        await widget.bloc.createStudent(student, widget.chosenCenter);
        await pr.hide();

        PlatformAlertDialog(
          title: 'نجح الحفظ',
          content: 'تم حفظ البيانات',
          defaultActionText: 'حسنا',
        ).show(context);
        Navigator.of(context).pop();
      } on PlatformException catch (e) {
        await pr.hide();
        PlatformExceptionAlertDialog(
          title: 'فشلت العملية',
          exception: e,
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
        includeUsernameAndPassword: true,
        includeCenterIdInput: false,
        student: widget.student,
        onSaved: (Student newStudent) => student = newStudent,
        studentFormKey: studentFormKey,
      ),
    );
  }
}