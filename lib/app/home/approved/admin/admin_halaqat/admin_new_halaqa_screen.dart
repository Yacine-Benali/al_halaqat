import 'package:alhalaqat/app/common_forms/halaqa_form.dart';
import 'package:alhalaqat/app/home/approved/admin/admin_halaqat/admin_halaqat_bloc.dart';
import 'package:alhalaqat/app/models/halaqa.dart';
import 'package:alhalaqat/app/models/study_center.dart';
import 'package:alhalaqat/common_widgets/firebase_exception_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/platform_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/platform_exception_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/progress_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdminNewHalaqaScreen extends StatefulWidget {
  const AdminNewHalaqaScreen({
    Key key,
    @required this.bloc,
    @required this.halaqa,
    @required this.chosenCenter,
  }) : super(key: key);

  final AdminHalaqaBloc bloc;
  final Halaqa halaqa;
  final StudyCenter chosenCenter;

  @override
  _AdminNewHalaqaScreenState createState() => _AdminNewHalaqaScreenState();
}

class _AdminNewHalaqaScreenState extends State<AdminNewHalaqaScreen> {
  final GlobalKey<FormState> halaqaFormKey = GlobalKey<FormState>();
  Halaqa halaqa;
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
    if (halaqaFormKey.currentState.validate()) {
      try {
        await pr.show();
        await widget.bloc.createHalaqa(halaqa, widget.chosenCenter);
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
      body: HalaqaForm(
        halaqa: widget.halaqa,
        onSaved: (Halaqa value) => halaqa = value,
        halaqaFormKey: halaqaFormKey,
      ),
    );
  }
}
