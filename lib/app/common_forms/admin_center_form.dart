import 'package:al_halaqat/app/common_forms/admin_form.dart';
import 'package:al_halaqat/app/common_forms/user_bloc.dart';
import 'package:al_halaqat/app/common_forms/user_info_screen.dart';
import 'package:al_halaqat/app/common_forms/user_provider.dart';
import 'package:al_halaqat/app/models/admin.dart';
import 'package:al_halaqat/app/models/study_center.dart';
import 'package:al_halaqat/app/models/user.dart';
import 'package:al_halaqat/common_widgets/empty_content.dart';
import 'package:al_halaqat/common_widgets/platform_alert_dialog.dart';
import 'package:al_halaqat/common_widgets/platform_exception_alert_dialog.dart';
import 'package:al_halaqat/common_widgets/progress_dialog.dart';
import 'package:al_halaqat/services/auth.dart';
import 'package:al_halaqat/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AdminCenterForm extends StatefulWidget {
  const AdminCenterForm._({
    Key key,
    @required this.admin,
    @required this.bloc,
  }) : super(key: key);

  final Admin admin;
  final UserBloc bloc;

  static Widget create({
    @required BuildContext context,
    @required User user,
  }) {
    Database database = Provider.of<Database>(context, listen: false);
    AuthUser authUser = Provider.of<AuthUser>(context, listen: false);
    UserProvider provider = UserProvider(database: database);
    UserBloc bloc = UserBloc(
      provider: provider,
      userType: FormType.adminAndCenter,
      authUser: authUser,
    );
    return Provider<UserBloc>.value(
      value: bloc,
      child: AdminCenterForm._(
        bloc: bloc,
        admin: user,
      ),
    );
  }

  @override
  _AdminCenterFormState createState() => _AdminCenterFormState();
}

class _AdminCenterFormState extends State<AdminCenterForm> {
  Admin admin;
  StudyCenter center;
  bool isSaved = false;
  final GlobalKey<FormState> adminFormKey = GlobalKey<FormState>();
  ProgressDialog pr;
  Future<StudyCenter> centerFutre;
  @override
  void initState() {
    admin = widget.admin;
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
    UserBloc bloc = Provider.of<UserBloc>(context, listen: false);
    if (widget.admin != null)
      centerFutre = bloc.getCenter(widget.admin.centers[0]);
    super.initState();
  }

  void _save(BuildContext context) async {
    UserBloc bloc = Provider.of<UserBloc>(context, listen: false);

    if (adminFormKey.currentState.validate()) {
      try {
        await pr.show();
        await bloc.createAdminAndCenter(admin, center);
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
    UserBloc bloc = Provider.of<UserBloc>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('إملأ الإستمارة'),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: InkWell(
              onTap: () => _save(context),
              child: Icon(
                Icons.save,
                size: 26.0,
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder(
          future: Future.delayed(Duration(seconds: 1)),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.done)
              return buildForm(bloc);

            return Center(child: CircularProgressIndicator());
          }),
    );
  }

  Widget buildForm(UserBloc bloc) {
    if (widget.admin == null) {
      return AdminForm(
        includeUsernameAndPassword: false,
        includeCenterState: false,
        includeCenterIdInput: false,
        admin: widget.admin,
        center: null,
        onSavedAdmin: (newAdmin) => admin = newAdmin,
        onSavedCenter: (newCenter) => center = newCenter,
        isEnabled: true,
        adminFormKey: adminFormKey,
        includeCenterForm: true,
      );
    }
    return FutureBuilder<StudyCenter>(
      future: centerFutre,
      initialData: null,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          StudyCenter studyCenter = snapshot.data;

          return AdminForm(
            includeUsernameAndPassword: false,
            includeCenterIdInput: false,
            includeCenterState: false,
            admin: widget.admin,
            center: studyCenter,
            onSavedAdmin: (newAdmin) => admin = newAdmin,
            onSavedCenter: (newCenter) => center = newCenter,
            isEnabled: true,
            adminFormKey: adminFormKey,
            includeCenterForm: true,
          );
        } else if (snapshot.hasError) {
          return EmptyContent(
            title: 'Something went wrong',
            message: 'Can\'t load items right now',
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
