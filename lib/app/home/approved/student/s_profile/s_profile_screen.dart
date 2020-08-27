import 'package:al_halaqat/app/common_forms/student_form.dart';
import 'package:al_halaqat/app/home/approved/student/s_profile/s_profile_bloc.dart';
import 'package:al_halaqat/app/home/approved/student/s_profile/s_profile_provider.dart';
import 'package:al_halaqat/app/models/student.dart';
import 'package:al_halaqat/app/models/user.dart';
import 'package:al_halaqat/common_widgets/platform_alert_dialog.dart';
import 'package:al_halaqat/common_widgets/platform_exception_alert_dialog.dart';
import 'package:al_halaqat/common_widgets/progress_dialog.dart';
import 'package:al_halaqat/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SProfileScreen extends StatefulWidget {
  const SProfileScreen._({
    Key key,
    @required this.bloc,
    @required this.user,
  }) : super(key: key);

  final SProfileBloc bloc;
  final User user;

  static Widget create({@required BuildContext context}) {
    Database database = Provider.of<Database>(context, listen: false);
    User user = Provider.of<User>(context, listen: false);

    SProfileProvider provider = SProfileProvider(database: database);
    SProfileBloc bloc = SProfileBloc(
      provider: provider,
    );
    return SProfileScreen._(
      bloc: bloc,
      user: user,
    );
  }

  @override
  _SProfileScreenState createState() => _SProfileScreenState();
}

class _SProfileScreenState extends State<SProfileScreen> {
  final GlobalKey<FormState> studentAdminFormKey = GlobalKey<FormState>();
  Student modifiedStudent;
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
    if (studentAdminFormKey.currentState.validate()) {
      try {
        //   print(admin.centers);
        await pr.show();
        await widget.bloc.updateProfile(modifiedStudent);
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
        studentFormKey: studentAdminFormKey,
        student: widget.user,
        isEnabled: true,
        center: null,
        includeCenterForm: false,
        includeCenterIdInput: false,
        includeUsernameAndPassword: true,
        onSaved: (Student value) => modifiedStudent = value,
        showUserHalaqa: false,
      ),
    );
  }
}
