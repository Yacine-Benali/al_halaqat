import 'package:al_halaqat/app/common_forms/admin_form.dart';
import 'package:al_halaqat/app/common_forms/student_form.dart';
import 'package:al_halaqat/app/common_forms/teacher_form.dart';
import 'package:al_halaqat/app/models/study_center.dart';
import 'package:al_halaqat/app/models/user.dart';
import 'package:al_halaqat/app/common_forms/user_bloc.dart';
import 'package:al_halaqat/app/common_forms/user_provider.dart';
import 'package:al_halaqat/common_widgets/platform_alert_dialog.dart';
import 'package:al_halaqat/common_widgets/platform_exception_alert_dialog.dart';
import 'package:al_halaqat/common_widgets/progress_dialog.dart';
import 'package:al_halaqat/services/auth.dart';
import 'package:al_halaqat/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:al_halaqat/app/common_forms/admin_center_form.dart';

//! change to user form screen

enum FormType { student, teacher, admin, adminAndCenter }

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen._({
    Key key,
    @required this.bloc,
    @required this.userType,
    this.user,
  }) : super(key: key);

  final UserBloc bloc;
  final User user;
  final FormType userType;

  static Widget create({
    @required BuildContext context,
    @required FormType userType,
    User user,
    StudyCenter center,
  }) {
    Database database = Provider.of<Database>(context, listen: false);
    AuthUser authUser = Provider.of<AuthUser>(context, listen: false);
    UserProvider provider = UserProvider(database: database);
    UserBloc bloc = UserBloc(
      provider: provider,
      userType: userType,
      authUser: authUser,
    );
    return Provider<UserBloc>.value(
      value: bloc,
      child: UserInfoScreen._(
        bloc: bloc,
        user: user,
        userType: userType,
      ),
    );
  }

  @override
  _NewUserScreenState createState() => _NewUserScreenState();
}

class _NewUserScreenState extends State<UserInfoScreen> {
  UserBloc get bloc => widget.bloc;
  final GlobalKey<FormState> userFormKey = GlobalKey<FormState>();

  User user;
  ProgressDialog pr;

  @override
  initState() {
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

  Future<void> _save(BuildContext context) async {
    if (userFormKey.currentState.validate()) {
      try {
        await pr.show();

        if (widget.userType == FormType.teacher) {
          await bloc.createTeacher(user);
        } else if (widget.userType == FormType.student) {
          await bloc.createStudent(user);
        } else {
          await bloc.createAdmin(user);
        }
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
              onTap: () => _save(context),
              child: Icon(
                Icons.save,
                size: 26.0,
              ),
            ),
          ),
        ],
      ),
      body: _buildForm(),
    );
  }

  Widget _buildForm() {
    if (bloc.userType == FormType.admin)
      return AdminForm(
        includeUsernameAndPassword: false,
        includeCenterIdInput: true,
        includeCenterForm: false,
        admin: widget.user,
        onSavedAdmin: (admin) => user = admin,
        adminFormKey: userFormKey,
        center: null,
        isEnabled: true,
        onSavedCenter: (value) {},
      );
    if (bloc.userType == FormType.teacher)
      return TeacherForm(
        teacher: widget.user,
        onSaved: (teacher) => user = teacher,
        includeCenterIdInput: true,
        includeUsernameAndPassword: false,
        isEnabled: true,
        showUserHalaqa: false,
        teacherFormKey: userFormKey,
      );

    if (bloc.userType == FormType.student)
      return StudentForm(
        student: widget.user,
        onSaved: (student) => user = student,
        includeCenterIdInput: true,
        includeUsernameAndPassword: false,
        showUserHalaqa: false,
        studentFormKey: userFormKey,
      );
    else
      return Container();
  }
}
