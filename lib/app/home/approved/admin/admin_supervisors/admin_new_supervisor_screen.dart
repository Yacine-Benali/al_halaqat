import 'package:alhalaqat/app/common_forms/supervisor_form.dart';
import 'package:alhalaqat/app/home/approved/admin/admin_supervisors/admin_supervisors_bloc.dart';
import 'package:alhalaqat/app/models/global_admin.dart';
import 'package:alhalaqat/app/models/halaqa.dart';
import 'package:alhalaqat/app/models/study_center.dart';
import 'package:alhalaqat/app/models/supervisor.dart';
import 'package:alhalaqat/app/models/user.dart';
import 'package:alhalaqat/common_widgets/firebase_exception_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/platform_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/platform_exception_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/progress_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AdminNewSupervisorScreen extends StatefulWidget {
  const AdminNewSupervisorScreen({
    Key key,
    @required this.bloc,
    @required this.supervisor,
    @required this.chosenCenter,
    @required this.halaqatList,
    @required this.isEnabled,
  }) : super(key: key);

  final AdminSupervisorsBloc bloc;
  final Supervisor supervisor;
  final StudyCenter chosenCenter;
  final List<Halaqa> halaqatList;
  final bool isEnabled;

  @override
  _AdminNewSupervisorScreenState createState() =>
      _AdminNewSupervisorScreenState();
}

class _AdminNewSupervisorScreenState extends State<AdminNewSupervisorScreen> {
  final GlobalKey<FormState> supervisorFormKey = GlobalKey<FormState>();
  Supervisor supervisor;
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
    else if (widget.supervisor == null)
      hidePassword = false;
    else
      hidePassword = true;

    super.initState();
  }

  void save() async {
    if (supervisorFormKey.currentState.validate()) {
      try {
        //   print(admin.centers);
        await pr.show();
        if (widget.supervisor != null)
          await widget.bloc.modifieSupervisor(
              widget.supervisor, supervisor, widget.chosenCenter);
        else
          await widget.bloc.createSupervisor(supervisor, widget.chosenCenter);
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
      body: SupervisorForm(
        halaqatList: widget.halaqatList,
        isEnabled: widget.isEnabled,
        supervisor: widget.supervisor,
        onSaved: (Supervisor value) => supervisor = value,
        includeCenterIdInput: false,
        includeUsernameAndPassword: true,
        supervisorFormKey: supervisorFormKey,
        showUserHalaqa: true,
        center: null,
        includeCenterForm: false,
        hidePassword: hidePassword,
      ),
    );
  }
}
