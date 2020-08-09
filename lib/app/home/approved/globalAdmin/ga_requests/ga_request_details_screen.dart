import 'package:al_halaqat/app/common_screens/admin_form.dart';
import 'package:al_halaqat/app/home/approved/globalAdmin/ga_requests/ga_requests_bloc.dart';
import 'package:al_halaqat/app/models/global_admin_request.dart';
import 'package:al_halaqat/app/models/user.dart';
import 'package:al_halaqat/common_widgets/menu_button_widget.dart';
import 'package:al_halaqat/common_widgets/platform_alert_dialog.dart';
import 'package:al_halaqat/common_widgets/platform_exception_alert_dialog.dart';
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
  final String approved = 'قبول';
  final String disapproved = 'رفض';

  bool isLoading = false;

  void updateRequest(BuildContext context, bool isApproved) async {
    try {
      setState(() => isLoading = true);
      await widget.bloc.updateRequest(widget.gaRequest, isApproved);
      setState(() => isLoading = false);
      PlatformAlertDialog(
        title: 'نجحت العملية',
        content: 'تم حفظ البيانات',
        defaultActionText: 'حسنا',
      ).show(context);
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'فشلت العملية',
        exception: e,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          Expanded(
            child: AdminForm(
              admin: widget.gaRequest.admin,
              center: widget.gaRequest.center,
              onSavedAdmin: (User value) {},
              callback: () {},
              includeCenterForm: true,
              isEnabled: false,
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
                    onPressed: () =>
                        isLoading ? null : updateRequest(context, true),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MenuButtonWidget(
                    text: 'رفض',
                    onPressed: () =>
                        isLoading ? null : updateRequest(context, false),
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
