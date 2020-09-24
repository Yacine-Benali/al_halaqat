import 'package:alhalaqat/app/home/approved/admin/admin_ga_request/admin_ga_request_bloc.dart';
import 'package:alhalaqat/app/home/approved/admin/admin_ga_request/admin_ga_request_provider.dart';
import 'package:alhalaqat/app/models/user.dart';
import 'package:alhalaqat/common_widgets/platform_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/platform_exception_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/progress_dialog.dart';
import 'package:alhalaqat/common_widgets/text_form_field2.dart';
import 'package:alhalaqat/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AdminGaRequestScreen extends StatefulWidget {
  const AdminGaRequestScreen._({
    Key key,
    @required this.bloc,
    @required this.user,
  }) : super(key: key);

  final AdminGaRequestBloc bloc;
  final User user;

  static Widget create({@required BuildContext context}) {
    Database database = Provider.of<Database>(context, listen: false);
    User user = Provider.of<User>(context, listen: false);

    AdminGaRequestProvider provider =
        AdminGaRequestProvider(database: database);
    AdminGaRequestBloc bloc = AdminGaRequestBloc(
      provider: provider,
      admin: user,
    );
    return AdminGaRequestScreen._(
      bloc: bloc,
      user: user,
    );
  }

  @override
  _AdminGaRequestScreenState createState() => _AdminGaRequestScreenState();
}

class _AdminGaRequestScreenState extends State<AdminGaRequestScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  ProgressDialog pr;
  String centerId;
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
    if (formKey.currentState.validate()) {
      try {
        //   print(admin.centers);
        await pr.show();
        await widget.bloc.sendJoinRequest(centerId);
        await pr.hide();

        PlatformAlertDialog(
          title: 'نجحت العملية',
          content: 'تم إرسال الدعوة',
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('إرسال دعوة انضمام'),
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
        child: Column(
          children: [
            Form(
              key: formKey,
              child: TextFormField2(
                title: 'أدخل الرقم التعريفي للمركز',
                hintText: 'الرقم التعريفي للمركز',
                errorText: 'خطأ',
                maxLength: 20,
                inputFormatter: WhitelistingTextInputFormatter.digitsOnly,
                onChanged: (value) => centerId = value,
                isEnabled: true,
                isPhoneNumber: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
