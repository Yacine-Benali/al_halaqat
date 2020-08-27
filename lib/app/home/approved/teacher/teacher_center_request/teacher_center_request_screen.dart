import 'package:al_halaqat/app/home/approved/teacher/teacher_center_request/teacher_center_request_bloc.dart';
import 'package:al_halaqat/app/home/approved/teacher/teacher_center_request/teacher_center_request_provider.dart';
import 'package:al_halaqat/app/models/user.dart';
import 'package:al_halaqat/common_widgets/platform_alert_dialog.dart';
import 'package:al_halaqat/common_widgets/platform_exception_alert_dialog.dart';
import 'package:al_halaqat/common_widgets/progress_dialog.dart';
import 'package:al_halaqat/common_widgets/text_form_field2.dart';
import 'package:al_halaqat/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class TeacherCenterRequestScreen extends StatefulWidget {
  const TeacherCenterRequestScreen._({
    Key key,
    @required this.bloc,
    @required this.user,
  }) : super(key: key);

  final TeacherCenterRequestBloc bloc;
  final User user;

  static Widget create({@required BuildContext context}) {
    Database database = Provider.of<Database>(context, listen: false);
    User user = Provider.of<User>(context, listen: false);

    TeacherCenterRequestProvider provider =
        TeacherCenterRequestProvider(database: database);
    TeacherCenterRequestBloc bloc = TeacherCenterRequestBloc(
      provider: provider,
      teacher: user,
    );
    return TeacherCenterRequestScreen._(
      bloc: bloc,
      user: user,
    );
  }

  @override
  _TeacherCenterRequestScreenState createState() =>
      _TeacherCenterRequestScreenState();
}

class _TeacherCenterRequestScreenState
    extends State<TeacherCenterRequestScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  ProgressDialog pr;
  String centerId;
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
    if (formKey.currentState.validate()) {
      try {
        //   print(admin.centers);
        await pr.show();
        await widget.bloc.sendJoinRequest(centerId);
        await pr.hide();

        PlatformAlertDialog(
          title: 'نجحت العملية',
          content: 'تم إرسال الدعوة',
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
        title: Text('إرسال دعوة انضمام'),
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Form(
              key: formKey,
              child: TextFormField2(
                title: 'إدخل الرقم التعريفي للمركز',
                hintText: 'الرقم التعريفي للمركز',
                errorText: 'خطأ',
                maxLength: 20,
                inputFormatter: WhitelistingTextInputFormatter.digitsOnly,
                onChanged: (value) => centerId = value,
                isEnabled: true,
                isPhoneNumber: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
