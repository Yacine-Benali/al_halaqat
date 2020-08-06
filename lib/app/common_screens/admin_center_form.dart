import 'package:al_halaqat/app/common_screens/admin_form.dart';
import 'package:al_halaqat/app/common_screens/user_bloc.dart';
import 'package:al_halaqat/app/models/admin.dart';
import 'package:al_halaqat/app/models/study_center.dart';
import 'package:al_halaqat/common_widgets/empty_content.dart';
import 'package:al_halaqat/common_widgets/platform_alert_dialog.dart';
import 'package:al_halaqat/common_widgets/platform_exception_alert_dialog.dart';
import 'package:al_halaqat/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'center_form.dart';

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
  final GlobalKey<FormState> centerKey = GlobalKey<FormState>();

  @override
  void initState() {
    admin = widget.admin;
    super.initState();
  }

  void save(BuildContext context) async {
    UserBloc bloc = Provider.of<UserBloc>(context, listen: false);

    try {
      await bloc.createAdminAndCenter(admin, center);

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

  @override
  Widget build(BuildContext context) {
    UserBloc bloc = Provider.of<UserBloc>(context, listen: false);

    if (widget?.admin?.centers?.isEmpty ?? true) {
      return AdminForm(
        admin: widget.admin,
        includeCenterForm: true,
        onSavedAdmin: (newAdmin) => admin = newAdmin,
        onSavedCenter: (newCenter) => center = newCenter,
        callback: () => save(context),
      );
    } else {
      return FutureBuilder<StudyCenter>(
        future: bloc.getCenter(widget.admin.centers[0]),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            StudyCenter studyCenter = snapshot.data;
            return AdminForm(
              admin: widget.admin,
              center: studyCenter,
              includeCenterForm: true,
              onSavedAdmin: (newAdmin) => admin = newAdmin,
              onSavedCenter: (newCenter) => center = newCenter,
              callback: () => save(context),
            );
          } else if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                title: Text('dm'),
              ),
              body: EmptyContent(
                title: 'Something went wrong',
                message: 'Can\'t load items right now',
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      );
    }
  }
}
