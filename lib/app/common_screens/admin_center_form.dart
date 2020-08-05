import 'package:al_halaqat/app/common_screens/admin_form.dart';
import 'package:al_halaqat/app/common_screens/user_bloc.dart';
import 'package:al_halaqat/app/home/models/admin.dart';
import 'package:al_halaqat/app/home/models/study_center.dart';
import 'package:al_halaqat/common_widgets/platform_alert_dialog.dart';
import 'package:al_halaqat/common_widgets/platform_exception_alert_dialog.dart';
import 'package:al_halaqat/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'center_form.dart';

class AdminCenterForm extends StatefulWidget {
  @override
  _AdminCenterFormState createState() => _AdminCenterFormState();
}

class _AdminCenterFormState extends State<AdminCenterForm> {
  Admin admin;
  StudyCenter center;
  bool isSaved = false;
  final GlobalKey<FormState> centerKey = GlobalKey<FormState>();

  void save(BuildContext context) async {
    print('zabi hada marabh');
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
    return AdminForm(
      includeCenterForm: true,
      onSavedAdmin: (newAdmin) => admin = newAdmin,
      onSavedCenter: (newCenter) => center = newCenter,
      callback: () => save(context),
    );
  }
}
