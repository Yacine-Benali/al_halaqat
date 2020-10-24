import 'package:alhalaqat/app/models/admin.dart';
import 'package:alhalaqat/app/models/user.dart';
import 'package:alhalaqat/common_widgets/empty_content.dart';
import 'package:alhalaqat/common_widgets/platform_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/platform_exception_alert_dialog.dart';
import 'package:alhalaqat/constants/strings.dart';
import 'package:alhalaqat/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ArchivedDeletedEmptyScreen extends StatefulWidget {
  const ArchivedDeletedEmptyScreen({Key key, @required this.user})
      : super(key: key);
  final User user;

  @override
  _ArchivedDeletedEmptyScreenState createState() =>
      _ArchivedDeletedEmptyScreenState();
}

class _ArchivedDeletedEmptyScreenState
    extends State<ArchivedDeletedEmptyScreen> {
  String title;
  String subtitle;
  Future<void> _signOut(BuildContext context) async {
    try {
      final Auth auth = Provider.of<Auth>(context, listen: false);
      await auth.signOut();
    } on PlatformException catch (e) {
      await PlatformExceptionAlertDialog(
        title: Strings.logoutFailed,
        exception: e,
      ).show(context);
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final bool didRequestSignOut = await PlatformAlertDialog(
      title: 'تسجيل الخروج',
      content: 'هل أنت متأكد ؟',
      cancelActionText: 'إلغاء',
      defaultActionText: 'حسنا',
    ).show(context);
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  @override
  void initState() {
    title = Strings.youAreArchived;
    subtitle = Strings.contactUs;
    if (widget.user is Admin) {
      title = 'ليس لديك أي مركز مفعل';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        centerTitle: true,
        leading: Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: InkWell(
            onTap: () => _confirmSignOut(context),
            child: Icon(
              Icons.exit_to_app,
              size: 26.0,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: EmptyContent(
          title: Strings.youAreArchived,
          message: Strings.contactUs,
        ),
      ),
    );
  }
}
