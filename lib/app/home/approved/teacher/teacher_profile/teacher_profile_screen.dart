import 'package:alhalaqat/app/common_forms/teacher_form.dart';
import 'package:alhalaqat/app/home/approved/teacher/teacher_profile/teacher_profile_bloc.dart';
import 'package:alhalaqat/app/home/approved/teacher/teacher_profile/teacher_profile_provider.dart';
import 'package:alhalaqat/app/models/teacher.dart';
import 'package:alhalaqat/app/models/user.dart';
import 'package:alhalaqat/common_widgets/platform_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/platform_exception_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/progress_dialog.dart';
import 'package:alhalaqat/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class TeacherProfileScreen extends StatefulWidget {
  const TeacherProfileScreen._({
    Key key,
    @required this.bloc,
    @required this.user,
  }) : super(key: key);

  final TeacherProfileBloc bloc;
  final User user;

  static Widget create({@required BuildContext context}) {
    Database database = Provider.of<Database>(context, listen: false);
    User user = Provider.of<User>(context, listen: false);

    TeacherProfileProvider provider =
        TeacherProfileProvider(database: database);
    TeacherProfileBloc bloc = TeacherProfileBloc(
      provider: provider,
    );
    return TeacherProfileScreen._(
      bloc: bloc,
      user: user,
    );
  }

  @override
  _TeacherProfileScreenState createState() => _TeacherProfileScreenState();
}

class _TeacherProfileScreenState extends State<TeacherProfileScreen> {
  final GlobalKey<FormState> teacherAdminFormKey = GlobalKey<FormState>();
  Teacher modifiedTeacher;
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
    if (teacherAdminFormKey.currentState.validate()) {
      try {
        //   print(admin.centers);
        await pr.show();
        widget.bloc.updateProfile(modifiedTeacher);
        await Future.delayed(Duration(seconds: 1));
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
      body: TeacherForm(
        teacherFormKey: teacherAdminFormKey,
        teacher: widget.user,
        isEnabled: true,
        center: null,
        includeCenterForm: false,
        includeCenterIdInput: false,
        includeUsernameAndPassword: true,
        onSaved: (Teacher value) => modifiedTeacher = value,
        showUserHalaqa: false,
        hidePassword: false,
      ),
    );
  }
}
