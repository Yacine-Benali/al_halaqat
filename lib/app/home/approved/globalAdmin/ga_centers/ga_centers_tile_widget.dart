import 'package:al_halaqat/app/home/approved/globalAdmin/ga_centers/ga_centers_bloc.dart';
import 'package:al_halaqat/app/home/approved/globalAdmin/ga_centers/ga_new_center_screen.dart';
import 'package:al_halaqat/app/models/study_center.dart';
import 'package:al_halaqat/common_widgets/platform_alert_dialog.dart';
import 'package:al_halaqat/common_widgets/platform_exception_alert_dialog.dart';
import 'package:al_halaqat/common_widgets/progress_dialog.dart';
import 'package:al_halaqat/constants/key_translate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:progress_dialog/progress_dialog.dart';

enum WhyFarther { edit, archive, centerAction }

class GaCentersTileWidget extends StatefulWidget {
  GaCentersTileWidget({
    Key key,
    @required this.bloc,
    @required this.center,
    @required this.scaffoldKey,
  }) : super(key: key);

  final StudyCenter center;
  final GaCentersBloc bloc;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  _GaCentersTileWidgetState createState() => _GaCentersTileWidgetState();
}

class _GaCentersTileWidgetState extends State<GaCentersTileWidget> {
  ProgressDialog pr;

  @override
  initState() {
    pr = ProgressDialog(
      widget.scaffoldKey.currentContext,
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

  Future<void> _executeAction(String action) async {
    if (action == 'edit') {
      await Navigator.of(context, rootNavigator: false).push(
        MaterialPageRoute(
          builder: (context) => GaNewCenterScreen(
            bloc: widget.bloc,
            center: widget.center,
          ),
          fullscreenDialog: true,
        ),
      );
    } else {
      final bool didRequestSignOut = await PlatformAlertDialog(
        title: KeyTranslate.centersActionsList[action],
        content: 'هل أنت متأكد ؟',
        cancelActionText: 'إلغاء',
        defaultActionText: 'حسنا',
      ).show(widget.scaffoldKey.currentContext);
      if (didRequestSignOut == true) {
        try {
          await pr.show();
          await widget.bloc.executeAction(widget.center, action);
          await pr.hide();
          PlatformAlertDialog(
            title: 'نجحت العملية',
            content: 'تمت العملية بنجاح',
            defaultActionText: 'حسنا',
          ).show(widget.scaffoldKey.currentContext);
        } on PlatformException catch (e) {
          PlatformExceptionAlertDialog(
            title: 'فشلت العملية',
            exception: e,
          ).show(widget.scaffoldKey.currentContext);
        }
      }
    }
  }

  Widget _buildAction() {
    List<String> actions;
    switch (widget.center.state) {
      case 'approved':
        actions = ['edit', 'archive', 'delete'];
        break;
      case 'archived':
        actions = ['reApprove'];
        break;
      case 'deleted':
        actions = [];
        break;
    }

    return PopupMenuButton<String>(
      itemBuilder: (BuildContext context) => List.generate(
        actions.length,
        (i) {
          return PopupMenuItem<String>(
            value: actions[i],
            child: Text(KeyTranslate.centersActionsList[actions[i]]),
          );
        },
      ),
      onSelected: (value) => _executeAction(value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.center.name),
      subtitle: Text(
        KeyTranslate.isoCountryToArabic[widget.center.country] +
            ' ' +
            widget.center.city,
      ),
      trailing: widget.center.state == 'deleted'
          ? Container(
              height: 1,
              width: 1,
            )
          : _buildAction(),
      enabled: widget.center.state == 'approved' ? true : false,
      onTap: () {},
    );
  }
}
