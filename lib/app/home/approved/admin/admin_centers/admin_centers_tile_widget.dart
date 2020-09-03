import 'package:al_halaqat/app/home/approved/admin/admin_centers/admin_centers_bloc.dart';
import 'package:al_halaqat/app/home/approved/admin/admin_centers/admin_new_center_screen.dart';
import 'package:al_halaqat/app/models/study_center.dart';
import 'package:al_halaqat/common_widgets/progress_dialog.dart';
import 'package:al_halaqat/constants/key_translate.dart';
import 'package:flutter/material.dart';
// import 'package:progress_dialog/progress_dialog.dart';

enum WhyFarther { edit, archive, centerAction }

class AdminCenterTileWidget extends StatefulWidget {
  AdminCenterTileWidget({
    Key key,
    @required this.bloc,
    @required this.center,
    @required this.scaffoldKey,
    @required this.centersList,
  }) : super(key: key);

  final StudyCenter center;
  final AdminCentersBloc bloc;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final List<StudyCenter> centersList;

  @override
  _AdminCenterTileWidgetState createState() => _AdminCenterTileWidgetState();
}

class _AdminCenterTileWidgetState extends State<AdminCenterTileWidget> {
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

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.center.name),
      subtitle: Text(
        widget.center.readableId +
            ' ' +
            KeyTranslate.isoCountryToArabic[widget.center.country] +
            ' ' +
            widget.center.city,
      ),
      enabled: widget.center.state == 'approved' ? true : false,
      onTap: () => Navigator.of(context, rootNavigator: false).push(
        MaterialPageRoute(
          builder: (context) => AdminNewCenterScreen(
            bloc: widget.bloc,
            center: widget.center,
          ),
          fullscreenDialog: true,
        ),
      ),
    );
  }
}
