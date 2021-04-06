import 'package:alhalaqat/app/home/approved/admin/admin_teachers/teacher_profile/a_teacher_profile_bloc.dart';
import 'package:alhalaqat/app/models/teacher_center_attendance.dart';
import 'package:alhalaqat/common_widgets/date_picker.dart';
import 'package:alhalaqat/common_widgets/firebase_exception_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/platform_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/platform_exception_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/progress_dialog.dart';
import 'package:alhalaqat/common_widgets/text_form_field2.dart';
import 'package:alhalaqat/common_widgets/time_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ATNewCenterAttendance extends StatefulWidget {
  const ATNewCenterAttendance({
    Key key,
    @required this.bloc,
    @required this.teacherCenterAttendance,
  }) : super(key: key);

  final ATeacherProfileBloc bloc;
  final TeacherCenterAttendance teacherCenterAttendance;

  @override
  _ATNewCenterAttendanceState createState() => _ATNewCenterAttendanceState();
}

class _ATNewCenterAttendanceState extends State<ATNewCenterAttendance> {
  ATeacherProfileBloc get bloc => widget.bloc;
  ProgressDialog pr;
  Timestamp date;
  TimeOfDay timeIn;
  TimeOfDay timeOut;
  int noSessions;
  int noHours;
  String note;
  String id;
  GlobalKey<FormState> fromKey = GlobalKey<FormState>();

  @override
  void initState() {
    date = widget?.teacherCenterAttendance?.date ?? Timestamp.now();
    timeIn = widget?.teacherCenterAttendance?.timeIn ?? TimeOfDay.now();
    timeOut = widget?.teacherCenterAttendance?.timeOut ?? TimeOfDay.now();
    note = widget?.teacherCenterAttendance?.note;
    id = widget?.teacherCenterAttendance?.id;
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
    if (fromKey.currentState.validate()) {
      if (timeIn.isLaterThen(timeOut)) {
        PlatformAlertDialog(
          title: 'فشلت العملية',
          content: 'وقت الخروج يجب أن يكون أكبر من وقت الدخول',
          defaultActionText: 'حسنا',
        ).show(context);
      } else {
        var teacherCenterAt = TeacherCenterAttendance(
          id: id,
          date: date,
          timeIn: timeIn,
          timeOut: timeOut,
          note: note,
        );
        try {
          await pr.show();
          await bloc.saveTcenterAttendance(teacherCenterAt);
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('حضور ${bloc.studyCenter.name}'),
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
          child: Form(
            key: fromKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildDatePicker(),
                Divider(
                  color: Colors.black,
                  height: 10,
                ),
                SizedBox(height: 30),
                buildTimeInPicker(),
                Divider(
                  color: Colors.black,
                  height: 10,
                ),
                SizedBox(height: 30),
                buildTimeOutPicker(),
                Divider(
                  color: Colors.black,
                  height: 10,
                ),
                SizedBox(height: 30),
                buildNote(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDatePicker() {
    return DatePicker(
      labelText: 'اليوم',
      selectedDate: date.toDate(),
      onSelectedDate: (t) {
        date = Timestamp.fromDate(t);
        setState(() {});
      },
    );
  }

  Widget buildTimeInPicker() {
    return TimePicker(
      labelText: 'وقت الدخول',
      selectedTime: timeIn,
      onSelectedTime: (t) {
        timeIn = t;
        setState(() {});
      },
    );
  }

  Widget buildTimeOutPicker() {
    return TimePicker(
      labelText: 'وقت الخروج',
      selectedTime: timeOut,
      onSelectedTime: (t) {
        timeOut = t;
        setState(() {});
      },
    );
  }

  Widget buildNote() {
    return TextFormField2(
      isEnabled: true,
      title: 'ملاحظة',
      initialValue: note ?? '',
      hintText: 'أدخل ملاحظة',
      errorText: 'خطأ',
      maxLength: 100,
      inputFormatter: FilteringTextInputFormatter.deny(''),
      isPhoneNumber: false,
      onChanged: (value) => note = value,
      validator: (value) => null,
    );
  }
}
