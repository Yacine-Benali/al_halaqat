import 'package:alhalaqat/app/home/approved/globalAdmin/ga_centers/ga_about_center_screen.dart';
import 'package:alhalaqat/app/home/approved/globalAdmin/ga_centers/ga_center_admins/ga_center_admins_screen.dart';
import 'package:alhalaqat/app/home/approved/globalAdmin/ga_centers/ga_centers_bloc.dart';
import 'package:alhalaqat/app/home/approved/globalAdmin/ga_centers/ga_new_center_screen.dart';
import 'package:alhalaqat/app/models/study_center.dart';
import 'package:alhalaqat/common_widgets/firebase_exception_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/platform_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/platform_exception_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/progress_dialog.dart';
import 'package:alhalaqat/constants/key_translate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'ga_about_admin_screen.dart';
// import 'package:progress_dialog/progress_dialog.dart';

enum WhyFarther { edit, archive, centerAction }

class GaCentersTileWidget extends StatefulWidget {
  GaCentersTileWidget({
    Key key,
    @required this.bloc,
    @required this.center,
    @required this.scaffoldKey,
    @required this.centersList,
  }) : super(key: key);

  final StudyCenter center;
  final GaCentersBloc bloc;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final List<StudyCenter> centersList;

  @override
  _GaCentersTileWidgetState createState() => _GaCentersTileWidgetState();
}

class _GaCentersTileWidgetState extends State<GaCentersTileWidget> {
  ProgressDialog pr;

  @override
  void initState() {
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
            centersList: widget.centersList,
            isEnabled: true,
          ),
          fullscreenDialog: true,
        ),
      );
    } else if (action == 'aboutCenter') {
      await Navigator.of(context, rootNavigator: false).push(
        MaterialPageRoute(
          builder: (context) => GaAboutCenterScreen(
            center: widget.center,
          ),
          fullscreenDialog: true,
        ),
      );
    } else if (action == 'aboutAdmin') {
      await Navigator.of(context, rootNavigator: false).push(
        MaterialPageRoute(
          builder: (context) => GaAboutAdminScreen(
            bloc: widget.bloc,
            createdById: widget.center.createdBy['id'],
          ),
          fullscreenDialog: true,
        ),
      );
    } else if (action == 'findAdmins') {
      await Navigator.of(context, rootNavigator: false).push(
        MaterialPageRoute(
          builder: (context) => GaCenterAdminsScreen.create(
            context: context,
            studyCenter: widget.center,
          ),
          fullscreenDialog: true,
        ),
      );
    } else {
      final bool didRequestSignOut = await PlatformAlertDialog(
        title: KeyTranslate.actionsList[action],
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
        } catch (e) {
          await pr.hide();
          if (e is PlatformException) {
            PlatformExceptionAlertDialog(
              title: 'فشلت العملية',
              exception: e,
            ).show(widget.scaffoldKey.currentContext);
          } else if (e is FirebaseException)
            FirebaseExceptionAlertDialog(
              title: 'فشلت العملية',
              exception: e,
            ).show(widget.scaffoldKey.currentContext);
          else
            PlatformAlertDialog(
              title: 'فشلت العملية',
              content: 'فشلت العملية',
              defaultActionText: 'حسنا',
            ).show(widget.scaffoldKey.currentContext);
        }
      }
    }
  }

  Widget _buildAction() {
    List<String> actions = List();
    switch (widget.center.state) {
      case 'approved':
        actions.addAll([
          'aboutCenter',
          'aboutAdmin',
          'edit',
          'archive',
          'delete',
          'findAdmins'
        ]);
        break;
      case 'archived':
        actions.addAll(['aboutCenter', 'aboutAdmin', 'reApprove']);
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
            child: Text(KeyTranslate.actionsList[actions[i]] ?? actions[i]),
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
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              KeyTranslate.isoCountryToArabic[widget.center.country] +
                  ' ' +
                  widget.center.city,
            ),
            Text(widget.center.readableId),
          ],
        ),
        trailing: widget.center.state == 'deleted'
            ? Container(
                height: 1,
                width: 1,
              )
            : _buildAction(),
        enabled: widget.center.state == 'approved' ? true : false,
        onTap: () async {
          // await Navigator.of(context, rootNavigator: false).push(
          //   MaterialPageRoute(
          //     builder: (context) => AdminHomePage(
          //       isGlobalAdmin: true,
          //       centerId: widget.center.id,
          //     ),
          //     fullscreenDialog: true,
          //   ),
          // );
        });
  }
}
