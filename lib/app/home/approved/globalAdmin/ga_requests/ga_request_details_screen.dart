import 'package:alhalaqat/app/common_forms/admin_form.dart';
import 'package:alhalaqat/app/home/approved/globalAdmin/ga_requests/ga_requests_bloc.dart';
import 'package:alhalaqat/app/models/global_admin_request.dart';
import 'package:alhalaqat/common_widgets/firebase_exception_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/menu_button_widget.dart';
import 'package:alhalaqat/common_widgets/platform_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/platform_exception_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/progress_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GaRequestDetailsScreen extends StatefulWidget {
  const GaRequestDetailsScreen({
    Key key,
    @required this.gaRequest,
    @required this.bloc,
  }) : super(key: key);

  final GlobalAdminRequest gaRequest;
  final GaRequestsBloc bloc;

  @override
  _GaRequestDetailsScreenState createState() => _GaRequestDetailsScreenState();
}

class _GaRequestDetailsScreenState extends State<GaRequestDetailsScreen> {
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

  void updateRequest(BuildContext context, bool isApproved) async {
    try {
      await pr.show();
      await widget.bloc.updateRequest(widget.gaRequest, isApproved);
      await pr.hide();
      PlatformAlertDialog(
        title: 'نجحت العملية',
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
        centerTitle: true,
        title: Text('معلومات الطلب'),
      ),
      body: Column(
        children: [
          Expanded(
            child: AdminForm(
              includeCenterState: false,
              includeCenterIdInput: false,
              includeUsernameAndPassword: false,
              includeCenterForm: true,
              adminFormKey: null,
              admin: widget.gaRequest.admin,
              center: widget.gaRequest.center,
              isEnabled: false,
              onSavedCenter: (v) {},
              onSavedAdmin: (v) {},
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
      ),
    );
  }
}
