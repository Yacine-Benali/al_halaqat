import 'package:alhalaqat/app/common_forms/global_admin_form.dart';
import 'package:alhalaqat/app/home/approved/globalAdmin/ga_profile/ga_profile_bloc.dart';
import 'package:alhalaqat/app/home/approved/globalAdmin/ga_profile/ga_profile_provider.dart';
import 'package:alhalaqat/app/models/global_admin.dart';
import 'package:alhalaqat/app/models/user.dart';
import 'package:alhalaqat/common_widgets/firebase_exception_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/platform_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/platform_exception_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/progress_dialog.dart';
import 'package:alhalaqat/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class GaProfileScreen extends StatefulWidget {
  const GaProfileScreen._({
    Key key,
    @required this.bloc,
    @required this.globalAdmin,
  }) : super(key: key);

  final GaProfileBloc bloc;
  final GlobalAdmin globalAdmin;

  static Widget create({@required BuildContext context}) {
    Database database = Provider.of<Database>(context, listen: false);
    User user = Provider.of<User>(context, listen: false);

    GaProfileProvider provider = GaProfileProvider(database: database);
    GaProfileBloc bloc = GaProfileBloc(
      provider: provider,
    );
    return GaProfileScreen._(
      bloc: bloc,
      globalAdmin: user,
    );
  }

  @override
  _GaProfileScreenState createState() => _GaProfileScreenState();
}

class _GaProfileScreenState extends State<GaProfileScreen> {
  final GlobalKey<FormState> globalAdminFormKey = GlobalKey<FormState>();
  GlobalAdmin modifiedGlobalAdmin;
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
    if (globalAdminFormKey.currentState.validate()) {
      try {
        //   print(admin.centers);
        await pr.show();
        widget.bloc.updateProfile(modifiedGlobalAdmin);
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
      body: GlobalAdminForm(
        adminFormKey: globalAdminFormKey,
        onSavedGlobalAdmin: (GlobalAdmin value) => modifiedGlobalAdmin = value,
        globalAdmin: widget.globalAdmin,
        isEnabled: true,
      ),
    );
  }
}
