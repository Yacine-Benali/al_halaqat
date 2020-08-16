import 'package:al_halaqat/app/common_forms/admin_form.dart';
import 'package:al_halaqat/app/common_forms/global_admin_form.dart';
import 'package:al_halaqat/app/home/approved/globalAdmin/ga_admins/ga_admins_bloc.dart';
import 'package:al_halaqat/app/home/approved/globalAdmin/ga_global_admins/ga_global_admins_bloc.dart';
import 'package:al_halaqat/app/models/admin.dart';
import 'package:al_halaqat/app/models/global_admin.dart';
import 'package:al_halaqat/common_widgets/platform_alert_dialog.dart';
import 'package:al_halaqat/common_widgets/platform_exception_alert_dialog.dart';
import 'package:al_halaqat/common_widgets/progress_dialog.dart';
import 'package:al_halaqat/constants/key_translate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GaNewGlobalAdminScreen extends StatefulWidget {
  const GaNewGlobalAdminScreen({
    Key key,
    @required this.globalAdmin,
    @required this.bloc,
  }) : super(key: key);

  final GlobalAdmin globalAdmin;
  final GaGlobalAdminsBloc bloc;

  @override
  _GaNewGlobalAdminScreenState createState() => _GaNewGlobalAdminScreenState();
}

class _GaNewGlobalAdminScreenState extends State<GaNewGlobalAdminScreen> {
  final GlobalKey<FormState> adminFormKey = GlobalKey<FormState>();
  ProgressDialog pr;

  GlobalAdmin globalAdmin;
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
    if (adminFormKey.currentState.validate()) {
      try {
        //   print(admin.centers);
        await pr.show();
        await widget.bloc.setGlobalAdmin(globalAdmin);
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
      body: GlobalAdminForm(
        adminFormKey: adminFormKey,
        globalAdmin: widget.globalAdmin,
        onSavedGlobalAdmin: (value) => globalAdmin = value,
        isEnabled: true,
      ),
    );
  }
}
