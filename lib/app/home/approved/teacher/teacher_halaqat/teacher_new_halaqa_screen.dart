import 'package:al_halaqat/app/common_forms/halaqa_form.dart';
import 'package:al_halaqat/app/home/approved/teacher/teacher_halaqat/teacher_halaqat_bloc.dart';
import 'package:al_halaqat/app/models/halaqa.dart';
import 'package:al_halaqat/app/models/study_center.dart';
import 'package:al_halaqat/common_widgets/firebase_exception_alert_dialog.dart';
import 'package:al_halaqat/common_widgets/platform_alert_dialog.dart';
import 'package:al_halaqat/common_widgets/platform_exception_alert_dialog.dart';
import 'package:al_halaqat/common_widgets/progress_dialog.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TeacherNewHalaqaScreen extends StatefulWidget {
  const TeacherNewHalaqaScreen({
    Key key,
    @required this.bloc,
    @required this.halaqa,
    @required this.chosenCenter,
  }) : super(key: key);

  final TeacherHalaqaBloc bloc;
  final Halaqa halaqa;
  final StudyCenter chosenCenter;

  @override
  _TeacherNewHalaqaScreenState createState() => _TeacherNewHalaqaScreenState();
}

class _TeacherNewHalaqaScreenState extends State<TeacherNewHalaqaScreen> {
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
        //   print(admin.centers);
        await pr.show();
        if (widget.chosenCenter.requestPermissionForHalaqaCreation == false) {
          if (widget.halaqa != null)
            await widget.bloc.editHalaqa(halaqa, widget.chosenCenter);
          else
            await widget.bloc.creatHalaqa(halaqa, widget.chosenCenter);
          await pr.hide();

          PlatformAlertDialog(
            title: 'نجح الحفظ',
            content: 'تم حفظ البيانات',
            defaultActionText: 'حسنا',
          ).show(context);
        } else {
          print('no permission');
          await widget.bloc.creatHalaqa(halaqa, widget.chosenCenter);
          await pr.hide();

          PlatformAlertDialog(
            title: 'ليس لديك القدرة علي إنشاء حلقة',
            content: 'تم إسال طلب للمشرف',
            defaultActionText: 'حسنا',
          ).show(context);
        }
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
