import 'package:alhalaqat/app/common_forms/center_form.dart';
import 'package:alhalaqat/app/home/approved/globalAdmin/ga_centers/ga_centers_bloc.dart';
import 'package:alhalaqat/app/models/study_center.dart';
import 'package:alhalaqat/common_widgets/firebase_exception_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/platform_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/platform_exception_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/progress_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

@immutable
class GaNewCenterScreen extends StatefulWidget {
  GaNewCenterScreen({
    Key key,
    @required this.bloc,
    @required this.centersList,
    @required this.center,
    @required this.isEnabled,
  }) : super(key: key);
  final StudyCenter center;
  final GaCentersBloc bloc;
  final List<StudyCenter> centersList;
  final bool isEnabled;

  @override
  _GaNewCenterScreenState createState() => _GaNewCenterScreenState();
}

class _GaNewCenterScreenState extends State<GaNewCenterScreen> {
  GaCentersBloc get bloc => widget.bloc;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  StudyCenter center;
  ProgressDialog pr;
  String title;

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
    title = !widget.isEnabled ? 'حول المركز' : 'إنشاء مركز جديد';
    super.initState();
  }

  void save() async {
    if (_formKey.currentState.validate()) {
      try {
        await pr.show();
        await bloc.createCenter(center, widget.centersList);
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
        title: Text(title),
        centerTitle: true,
        actions: <Widget>[
          widget.isEnabled
              ? Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: InkWell(
                    onTap: () => save(),
                    child: Icon(
                      Icons.save,
                      size: 26.0,
                    ),
                  ),
                )
              : Container(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CenterForm(
          showReadableId: false,
          showCenterOptions: widget.isEnabled,
          isEnabled: widget.isEnabled,
          formKey: _formKey,
          center: widget.center,
          onSaved: (newcenter) => center = newcenter,
        ),
      ),
    );
  }
}
