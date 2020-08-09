import 'package:al_halaqat/app/common_screens/center_form.dart';
import 'package:al_halaqat/app/home/approved/globalAdmin/ga_centers/ga_centers_bloc.dart';
import 'package:al_halaqat/app/models/study_center.dart';
import 'package:al_halaqat/common_widgets/platform_alert_dialog.dart';
import 'package:al_halaqat/common_widgets/platform_exception_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

@immutable
class GaNewCenterScreen extends StatefulWidget {
  GaNewCenterScreen({
    Key key,
    @required this.bloc,
    this.center,
  }) : super(key: key);
  final StudyCenter center;
  final GaCentersBloc bloc;

  @override
  _GaNewCenterScreenState createState() => _GaNewCenterScreenState();
}

class _GaNewCenterScreenState extends State<GaNewCenterScreen> {
  GaCentersBloc get bloc => widget.bloc;
  bool isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  StudyCenter center;

  void save() async {
    if (_formKey.currentState.validate()) {
      try {
        setState(() => isLoading = true);
        await bloc.createCenter(center);
        setState(() => isLoading = false);

        PlatformAlertDialog(
          title: 'نجح الحفظ',
          content: 'تم حفظ البيانات',
          defaultActionText: 'حسنا',
        ).show(context);
        Navigator.of(context).pop();
      } on PlatformException catch (e) {
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
        title: Text('المراكز'),
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: InkWell(
              onTap: () => isLoading ? null : save(),
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
          isEnabled: !isLoading,
          formKey: _formKey,
          center: widget.center,
          onSaved: (newcenter) => center = newcenter,
        ),
      ),
    );
  }
}
