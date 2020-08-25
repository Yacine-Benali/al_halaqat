import 'package:al_halaqat/app/common_forms/student_form.dart';
import 'package:al_halaqat/app/common_forms/teacher_form.dart';
import 'package:al_halaqat/app/home/approved/admin/admin_requests/center_requests_bloc.dart';
import 'package:al_halaqat/app/models/center_request.dart';
import 'package:al_halaqat/app/models/student.dart';
import 'package:al_halaqat/app/models/study_center.dart';
import 'package:al_halaqat/app/models/teacher.dart';
import 'package:al_halaqat/common_widgets/menu_button_widget.dart';
import 'package:al_halaqat/common_widgets/platform_alert_dialog.dart';
import 'package:al_halaqat/common_widgets/platform_exception_alert_dialog.dart';
import 'package:al_halaqat/common_widgets/progress_dialog.dart';
import 'package:al_halaqat/common_widgets/text_form_field2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CenterRequestDetailsScreen extends StatefulWidget {
  const CenterRequestDetailsScreen({
    Key key,
    @required this.centerRequest,
    @required this.bloc,
    @required this.center,
  }) : super(key: key);

  final CenterRequest centerRequest;
  final CenterRequestsBloc bloc;
  final StudyCenter center;

  @override
  _GaRequestDetailsScreenState createState() => _GaRequestDetailsScreenState();
}

class _GaRequestDetailsScreenState extends State<CenterRequestDetailsScreen> {
  ProgressDialog pr;
  StudyCenter center;
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

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

  void updateRequest(BuildContext context, bool isApproved) async {
    try {
      await pr.show();
      await widget.bloc
          .updateRequest(widget.center, widget.centerRequest, isApproved);
      await pr.hide();
      PlatformAlertDialog(
        title: 'نجحت العملية',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('معلومات الطلب'),
      ),
      body: widget.centerRequest.halaqa != null
          ? _buildHalaqaRequist()
          : Column(
              children: [
                if (widget.centerRequest.user is Student) ...[
                  Expanded(
                    child: StudentForm(
                      student: widget.centerRequest.user,
                      onSaved: (t) {},
                      includeCenterIdInput: false,
                      includeUsernameAndPassword: false,
                      isEnabled: false,
                      studentFormKey: formkey,
                      showUserHalaqa: false,
                      center: center,
                      includeCenterForm: true,
                    ),
                  ),
                ],
                if (widget.centerRequest.halaqa == null &&
                    widget.centerRequest.user is Teacher) ...[
                  Expanded(
                    child: TeacherForm(
                      teacher: widget.centerRequest.user,
                      onSaved: (t) {},
                      includeCenterIdInput: false,
                      includeUsernameAndPassword: false,
                      isEnabled: false,
                      teacherFormKey: formkey,
                      showUserHalaqa: false,
                      center: center,
                      includeCenterForm: true,
                    ),
                  ),
                ],
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MenuButtonWidget(
                          text: 'قبول',
                          onPressed: () => updateRequest(context, true),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MenuButtonWidget(
                          text: 'رفض',
                          onPressed: () => updateRequest(context, false),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  Widget _buildHalaqaRequist() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextFormField2(
                    isEnabled: false,
                    title: 'إسم المتستخدم',
                    initialValue: widget.centerRequest.user.username
                        .replaceAll('@al-halaqat.firebaseapp.com', ''),
                    hintText: 'إدخل إسم المتستخدم',
                    errorText: 'خطأ',
                    maxLength: 30,
                    inputFormatter: FilteringTextInputFormatter.deny(''),
                    onChanged: (value) {},
                    isPhoneNumber: false,
                    validator: (value) {
                      return null;
                    },
                  ),
                  TextFormField2(
                    isEnabled: false,
                    title: 'الإسم',
                    initialValue: widget.centerRequest.user.name,
                    hintText: 'إدخل إسمك',
                    errorText: 'خطأ',
                    maxLength: 30,
                    inputFormatter: FilteringTextInputFormatter.deny(''),
                    onChanged: (value) {},
                  ),
                  TextFormField2(
                    isEnabled: false,
                    title: 'إسم الحلقة',
                    initialValue: widget.centerRequest.halaqa.name,
                    hintText: 'إدخل إسم الحلقة',
                    errorText: 'خطأ',
                    maxLength: 30,
                    inputFormatter: FilteringTextInputFormatter.deny(''),
                    onChanged: (value) {},
                    isPhoneNumber: false,
                  ),
                  TextFormField2(
                    isEnabled: false,
                    title: 'مستوى الحلقة',
                    initialValue: widget.centerRequest.halaqa.level,
                    hintText: 'إدخل مستوى الحلقة',
                    errorText: 'خطأ',
                    maxLength: 30,
                    inputFormatter: FilteringTextInputFormatter.deny(''),
                    onChanged: (value) {},
                    isPhoneNumber: false,
                  ),
                  TextFormField2(
                    isEnabled: false,
                    title: 'وصف الحلقة',
                    initialValue: widget.centerRequest.halaqa.description,
                    hintText: 'وصف الحلقة',
                    errorText: 'خطأ',
                    maxLength: 30,
                    inputFormatter: FilteringTextInputFormatter.deny(''),
                    onChanged: (value) {},
                  ),
                ],
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: MenuButtonWidget(
                  text: 'قبول',
                  onPressed: () => updateRequest(context, true),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: MenuButtonWidget(
                  text: 'رفض',
                  onPressed: () => updateRequest(context, false),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
