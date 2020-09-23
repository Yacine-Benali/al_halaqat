import 'package:alhalaqat/app/common_forms/center_form.dart';
import 'package:alhalaqat/app/models/study_center.dart';
import 'package:alhalaqat/common_widgets/progress_dialog.dart';
import 'package:flutter/material.dart';

@immutable
class GaAboutCenterScreen extends StatefulWidget {
  GaAboutCenterScreen({
    Key key,
    @required this.center,
  }) : super(key: key);
  final StudyCenter center;

  @override
  _GaAboutCenterScreenState createState() => _GaAboutCenterScreenState();
}

class _GaAboutCenterScreenState extends State<GaAboutCenterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  StudyCenter center;
  ProgressDialog pr;
  String title;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('حول المركز'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CenterForm(
          showReadableId: true,
          showCenterOptions: false,
          isEnabled: false,
          formKey: _formKey,
          center: widget.center,
          onSaved: (newcenter) => center = newcenter,
        ),
      ),
    );
  }
}
