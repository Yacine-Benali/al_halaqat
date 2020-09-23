import 'package:alhalaqat/app/common_forms/center_form.dart';
import 'package:alhalaqat/app/home/approved/admin/admin_centers/admin_centers_bloc.dart';
import 'package:alhalaqat/app/models/study_center.dart';
import 'package:alhalaqat/common_widgets/firebase_exception_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/platform_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/platform_exception_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/progress_dialog.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdminNewCenterScreen extends StatefulWidget {
  AdminNewCenterScreen({
    Key key,
    @required this.bloc,
    @required this.center,
  }) : super(key: key);
  final StudyCenter center;
  final AdminCentersBloc bloc;

  @override
  _AdminNewCenterScreenState createState() => _AdminNewCenterScreenState();
}

class _AdminNewCenterScreenState extends State<AdminNewCenterScreen> {
  AdminCentersBloc get bloc => widget.bloc;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  StudyCenter center;
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
    if (_formKey.currentState.validate()) {
      try {
        await pr.show();
        await bloc.createCenter(center);
        await pr.hide();

        PlatformAlertDialog(
          title: 'نجح الحفظ',
          content: 'تم حفظ البيانات',
          defaultActionText: 'حسنا',
        ).show(context);
        Navigator.of(context).pop();
      } catch (e) {
        print(e);
        print(e.runtimeType);
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
        title: Text('تعديل المركز'),
        centerTitle: true,
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
        child: CenterForm(
          showReadableId: false,
          showCenterOptions: true,
          isEnabled: true,
          formKey: _formKey,
          center: widget.center,
          onSaved: (newcenter) => center = newcenter,
        ),
      ),
    );
  }
}
