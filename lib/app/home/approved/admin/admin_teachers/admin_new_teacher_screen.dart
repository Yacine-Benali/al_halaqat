import 'package:alhalaqat/app/common_forms/teacher_form.dart';
import 'package:alhalaqat/app/home/approved/admin/admin_teachers/admin_teacher_bloc.dart';
import 'package:alhalaqat/app/models/global_admin.dart';
import 'package:alhalaqat/app/models/halaqa.dart';
import 'package:alhalaqat/app/models/study_center.dart';
import 'package:alhalaqat/app/models/teacher.dart';
import 'package:alhalaqat/app/models/user.dart';
import 'package:alhalaqat/common_widgets/firebase_exception_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/platform_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/platform_exception_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/progress_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AdminNewTeacherScreen extends StatefulWidget {
  const AdminNewTeacherScreen({
    Key key,
    @required this.bloc,
    @required this.teacher,
    @required this.chosenCenter,
    @required this.halaqatList,
    @required this.isEnabled,
  }) : super(key: key);

  final AdminTeacherBloc bloc;
  final Teacher teacher;
  final StudyCenter chosenCenter;
  final List<Halaqa> halaqatList;
  final bool isEnabled;

  @override
  _AdminNewTeacherScreenState createState() => _AdminNewTeacherScreenState();
}

class _AdminNewTeacherScreenState extends State<AdminNewTeacherScreen> {
  final GlobalKey<FormState> teacherFormKey = GlobalKey<FormState>();
  Teacher teacher;
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
    else if (widget.teacher == null)
      hidePassword = false;
    else
      hidePassword = true;

    super.initState();
  }

  void save() async {
    if (teacherFormKey.currentState.validate()) {
      try {
        //   print(admin.centers);
        await pr.show();
        if (widget.teacher != null)
          await widget.bloc
              .modifieTeacher(widget.teacher, teacher, widget.chosenCenter);
        else
          await widget.bloc.createTeacher(teacher, widget.chosenCenter);
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
      body: TeacherForm(
        halaqatList: widget.halaqatList,
        isEnabled: widget.isEnabled,
        teacher: widget.teacher,
        onSaved: (Teacher value) => teacher = value,
        includeCenterIdInput: false,
        includeUsernameAndPassword: true,
        teacherFormKey: teacherFormKey,
        showUserHalaqa: true,
        center: null,
        includeCenterForm: false,
        hidePassword: hidePassword,
      ),
    );
  }
}
