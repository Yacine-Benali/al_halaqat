import 'package:alhalaqat/app/home/approved/teacher/teacher_center_attendance/t_center_attendance_bloc.dart';
import 'package:alhalaqat/common_widgets/date_picker.dart';
import 'package:alhalaqat/common_widgets/firebase_exception_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/platform_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/platform_exception_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/progress_dialog.dart';
import 'package:alhalaqat/common_widgets/time_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TNewCenterAttendance extends StatefulWidget {
  const TNewCenterAttendance({
    Key key,
    @required this.bloc,
  }) : super(key: key);

  final TCenterAttendanceBloc bloc;

  @override
  _TNewCenterAttendanceState createState() => _TNewCenterAttendanceState();
}

class _TNewCenterAttendanceState extends State<TNewCenterAttendance> {
  TCenterAttendanceBloc get bloc => widget.bloc;
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
    //

    super.initState();
  }

  void save() async {
    try {
      await pr.show();
      // bloc.validateEvaluation(evaluation);
      // widget.bloc.setEvaluation(evaluation, widget.evaluationsList);
      await Future.delayed(Duration(seconds: 1));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تقييم'),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildDatePicker(),
              buildTimePicker(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDatePicker() {
    return DatePicker(
      labelText: 'rr',
      selectedDate: DateTime.now(),
      onSelectedDate: (t) {},
    );
  }

  Widget buildTimePicker() {
    return TimePicker(
      labelText: 'rr',
      selectedTime: TimeOfDay.now(),
      onSelectedTime: (t) {},
    );
  }
}
