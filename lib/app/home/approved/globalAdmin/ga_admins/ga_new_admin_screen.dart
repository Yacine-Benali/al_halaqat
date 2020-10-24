import 'package:alhalaqat/app/common_forms/admin_form.dart';
import 'package:alhalaqat/app/home/approved/globalAdmin/ga_admins/ga_admins_bloc.dart';
import 'package:alhalaqat/app/models/admin.dart';
import 'package:alhalaqat/common_widgets/firebase_exception_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/platform_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/platform_exception_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/progress_dialog.dart';
import 'package:alhalaqat/constants/key_translate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GaNewAdminScreen extends StatefulWidget {
  const GaNewAdminScreen({
    Key key,
    @required this.admin,
    @required this.bloc,
    @required this.isEnabled,
  }) : super(key: key);

  final Admin admin;
  final GaAdminsBloc bloc;
  final bool isEnabled;

  @override
  _GaNewAdminScreenState createState() => _GaNewAdminScreenState();
}

class _GaNewAdminScreenState extends State<GaNewAdminScreen> {
  final GlobalKey<FormState> adminFormKey = GlobalKey<FormState>();
  ProgressDialog pr;
  bool includeUsernameAndPassword;
  List<String> authTypeList;
  String chosenAdminAuthType;
  Admin admin;
  @override
  void initState() {
    authTypeList = KeyTranslate.createUserAuthType.keys.toList();
    chosenAdminAuthType = authTypeList[0];
    includeUsernameAndPassword = true;

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
        await widget.bloc.setAdmin(widget.admin, admin);
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
      body: AdminForm(
        includeCenterIdInput: false,
        includeCenterForm: false,
        includeUsernameAndPassword: includeUsernameAndPassword,
        adminFormKey: adminFormKey,
        onSavedAdmin: (Admin newAdmin) => admin = newAdmin,
        admin: widget.admin,
        center: null,
        isEnabled: widget.isEnabled,
        onSavedCenter: (value) {},
        centersList: widget.bloc.centersList,
        includeCenterState: true,
      ),
    );
  }
}
