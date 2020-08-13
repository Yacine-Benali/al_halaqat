import 'package:al_halaqat/app/common_screens/center_form.dart';
import 'package:al_halaqat/app/home/approved/globalAdmin/ga_centers/ga_centers_bloc.dart';
import 'package:al_halaqat/app/models/study_center.dart';
import 'package:al_halaqat/common_widgets/platform_alert_dialog.dart';
import 'package:al_halaqat/common_widgets/platform_exception_alert_dialog.dart';
import 'package:al_halaqat/common_widgets/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

@immutable
class GaNewCenterScreen extends StatefulWidget {
  GaNewCenterScreen({
    Key key,
    @required this.bloc,
    @required this.centersList,
    @required this.center,
  }) : super(key: key);
  final StudyCenter center;
  final GaCentersBloc bloc;
  final List<StudyCenter> centersList;

  @override
  _GaNewCenterScreenState createState() => _GaNewCenterScreenState();
}

class _GaNewCenterScreenState extends State<GaNewCenterScreen> {
  GaCentersBloc get bloc => widget.bloc;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  StudyCenter center;
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
    if (_formKey.currentState.validate()) {
      try {
        await pr.show();
        await bloc.createCenter(center, widget.centersList);
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
        title: Text('إنشاء مركز جديد'),
        centerTitle: true,
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
        child: CenterForm(
          showCenterOptions: true,
          isEnabled: true,
          formKey: _formKey,
          center: widget.center,
          onSaved: (newcenter) => center = newcenter,
        ),
      ),
    );
  }
}
