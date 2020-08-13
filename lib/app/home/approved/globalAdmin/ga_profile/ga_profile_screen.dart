import 'package:al_halaqat/app/common_screens/admin_form.dart';
import 'package:al_halaqat/app/common_screens/global_admin_form.dart';
import 'package:al_halaqat/app/home/approved/globalAdmin/ga_admins/ga_admins_bloc.dart';
import 'package:al_halaqat/app/home/approved/globalAdmin/ga_profile/ga_profile_bloc.dart';
import 'package:al_halaqat/app/home/approved/globalAdmin/ga_profile/ga_profile_provider.dart';
import 'package:al_halaqat/app/models/admin.dart';
import 'package:al_halaqat/app/models/global_admin.dart';
import 'package:al_halaqat/app/models/user.dart';
import 'package:al_halaqat/common_widgets/platform_alert_dialog.dart';
import 'package:al_halaqat/common_widgets/platform_exception_alert_dialog.dart';
import 'package:al_halaqat/common_widgets/progress_dialog.dart';
import 'package:al_halaqat/constants/key_translate.dart';
import 'package:al_halaqat/services/database.dart';
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
        await widget.bloc.updateProfile(modifiedGlobalAdmin);
        await pr.hide();

        PlatformAlertDialog(
          title: 'نجح الحفظ',
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
