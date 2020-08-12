import 'package:al_halaqat/app/common_screens/admin_form.dart';
import 'package:al_halaqat/app/common_screens/user_bloc.dart';
import 'package:al_halaqat/app/models/admin.dart';
import 'package:al_halaqat/app/models/study_center.dart';
import 'package:al_halaqat/common_widgets/empty_content.dart';
import 'package:al_halaqat/common_widgets/platform_alert_dialog.dart';
import 'package:al_halaqat/common_widgets/platform_exception_alert_dialog.dart';
import 'package:al_halaqat/common_widgets/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AdminCenterForm extends StatefulWidget {
  const AdminCenterForm({
    Key key,
    @required this.admin,
  }) : super(key: key);

  final Admin admin;

  @override
  _AdminCenterFormState createState() => _AdminCenterFormState();
}

class _AdminCenterFormState extends State<AdminCenterForm> {
  Admin admin;
  StudyCenter center;
  bool isSaved = false;
  final GlobalKey<FormState> adminFormKey = GlobalKey<FormState>();
  ProgressDialog pr;

  @override
  void initState() {
    admin = widget.admin;
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

  void _save(BuildContext context) async {
    UserBloc bloc = Provider.of<UserBloc>(context, listen: false);

    if (adminFormKey.currentState.validate()) {
      try {
        await pr.show();
        await bloc.createAdminAndCenter(admin, center);
        await pr.hide();

        PlatformAlertDialog(
          title: 'نجح الحفظ',
          content: 'تم حفظ البيانات',
          defaultActionText: 'حسنا',
        ).show(context);
        Navigator.of(context).pop();
      } on PlatformException catch (e) {
        PlatformExceptionAlertDialog(
          title: 'فشلت العملية',
          exception: e,
        ).show(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    UserBloc bloc = Provider.of<UserBloc>(context, listen: false);
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
      body: _buildBody(bloc),
    );
  }

  Widget _buildBody(UserBloc bloc) {
    if (widget?.admin?.centers?.isEmpty ?? true) {
      return AdminForm(
        includeUsernameAndPassword: false,
        includeCenterForm: true,
        includeCenterIdInput: false,
        admin: widget.admin,
        onSavedAdmin: (newAdmin) => admin = newAdmin,
        center: null,
        onSavedCenter: (newCenter) => center = newCenter,
        isEnabled: true,
        adminFormKey: adminFormKey,
      );
    } else {
      return FutureBuilder<StudyCenter>(
        future: bloc.getCenter(widget.admin.centers[0]),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            StudyCenter studyCenter = snapshot.data;
            return AdminForm(
              includeUsernameAndPassword: false,
              includeCenterIdInput: false,
              admin: widget.admin,
              center: studyCenter,
              onSavedAdmin: (newAdmin) => admin = newAdmin,
              onSavedCenter: (newCenter) => center = newCenter,
              isEnabled: true,
              adminFormKey: adminFormKey,
              includeCenterForm: true,
            );
          } else if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                title: Text(''),
              ),
              body: EmptyContent(
                title: 'Something went wrong',
                message: 'Can\'t load items right now',
              ),
            );
          }
          return Scaffold(
            appBar: AppBar(
              title: Text(''),
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      );
    }
  }
}
