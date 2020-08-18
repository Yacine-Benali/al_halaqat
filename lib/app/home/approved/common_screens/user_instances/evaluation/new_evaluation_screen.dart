import 'package:al_halaqat/app/home/approved/common_screens/user_instances/evaluation/evaluation_bloc.dart';
import 'package:al_halaqat/app/models/evaluation.dart';
import 'package:al_halaqat/app/models/evaluation_helper.dart';
import 'package:al_halaqat/app/models/instance.dart';
import 'package:al_halaqat/app/models/quran.dart';
import 'package:al_halaqat/common_widgets/drop_down_form_field2.dart';
import 'package:al_halaqat/common_widgets/platform_alert_dialog.dart';
import 'package:al_halaqat/common_widgets/platform_exception_alert_dialog.dart';
import 'package:al_halaqat/common_widgets/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NewEvaluationScreen extends StatefulWidget {
  const NewEvaluationScreen({
    Key key,
    @required this.bloc,
    @required this.evaluationsList,
  }) : super(key: key);

  final EvaluationBloc bloc;
  final List<Evaluation> evaluationsList;

  @override
  _NewEvaluationScreenState createState() => _NewEvaluationScreenState();
}

class _NewEvaluationScreenState extends State<NewEvaluationScreen> {
  EvaluationBloc get bloc => widget.bloc;
  //
  String memorizedFromSoura;
  int memorizedFromAya;
  String memorizedToSoura;
  int memorizedToAya;
  int memorizedMark;
  //
  String rehearsedFromSoura;
  int rehearsedFromAya;
  String rehearsedToSoura;
  int rehearsedToAya;
  int rehearsedMark;
  //
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
    //
    memorizedFromSoura = bloc.getSouratList().first;
    memorizedFromAya = 1;
    memorizedToSoura = bloc.getSouratList().first;
    memorizedToAya = 1;
    memorizedMark = 0;
    //
    rehearsedFromSoura = bloc.getSouratList().first;
    rehearsedFromAya = 1;
    rehearsedToSoura = bloc.getSouratList().first;
    rehearsedToAya = 1;
    rehearsedMark = 0;
    super.initState();
  }

  void save() async {
    EvaluationHelper memorized = EvaluationHelper(
      fromAya: memorizedFromAya,
      fromSoura: memorizedFromSoura,
      toAya: memorizedToAya,
      toSoura: memorizedToSoura,
      mark: memorizedMark,
    );
    EvaluationHelper rehearsed = EvaluationHelper(
      fromAya: rehearsedFromAya,
      fromSoura: rehearsedFromSoura,
      toAya: rehearsedToAya,
      toSoura: rehearsedToSoura,
      mark: rehearsedMark,
    );
    Evaluation evaluation = Evaluation(
      createdBy: null,
      id: null,
      createdAt: null,
      instanceId: null,
      studentName: null,
      memorized: memorized,
      rehearsed: rehearsed,
    );
    try {
      await pr.show();
      await widget.bloc.setEvaluation(evaluation, widget.evaluationsList);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('تقييم'),
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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الحفظ:',
                  style: TextStyle(fontSize: 24),
                ),
                if (true) ..._buildMemorizedForm(),
                SizedBox(height: 10),
                Text(
                  'المراجعة:',
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(height: 10),
                if (true) ..._buildRehearsedForm(),
              ],
            ),
          ),
        ));
  }

  List<Widget> _buildMemorizedForm() {
    return [
      Row(
        children: [
          Expanded(
            child: DropdownButtonFormField2(
              value: memorizedFromSoura,
              possibleValues: bloc.getSouratList(),
              title: 'من سورة',
              onSaved: (String value) {
                memorizedFromSoura = value;
                setState(() {});
              },
              isEnabled: true,
            ),
          ),
          Expanded(
            child: DropdownButtonFormField2(
              value: memorizedFromAya.toString(),
              possibleValues: bloc.getAyatList(memorizedFromSoura),
              title: 'من آية',
              onSaved: (String value) {
                int temp = int.parse(value);
                memorizedFromAya = temp;
              },
              isEnabled: true,
            ),
          ),
        ],
      ),
      Row(
        children: [
          Expanded(
            child: DropdownButtonFormField2(
              value: memorizedToSoura,
              possibleValues: bloc.getSouratList(),
              title: 'إلى سورة',
              onSaved: (String value) {
                memorizedToSoura = value;
                setState(() {});
              },
              isEnabled: true,
            ),
          ),
          Expanded(
            child: DropdownButtonFormField2(
              value: memorizedToAya.toString(),
              possibleValues: bloc.getAyatList(memorizedToSoura),
              title: 'إلى آية',
              onSaved: (String value) {
                int temp = int.parse(value);
                memorizedToAya = temp;
              },
              isEnabled: true,
            ),
          ),
        ],
      ),
      DropdownButtonFormField2(
        value: memorizedMark.toString(),
        possibleValues: bloc.getPossibleMarks(),
        title: 'التقييم',
        onSaved: (String value) {
          int temp = int.parse(value);
          memorizedMark = temp;
        },
        isEnabled: true,
      ),
    ];
  }

  List<Widget> _buildRehearsedForm() {
    return [
      Row(
        children: [
          Expanded(
            child: DropdownButtonFormField2(
              value: rehearsedFromSoura,
              possibleValues: bloc.getSouratList(),
              title: 'من سورة',
              onSaved: (String value) {
                rehearsedFromSoura = value;
                setState(() {});
              },
              isEnabled: true,
            ),
          ),
          Expanded(
            child: DropdownButtonFormField2(
              value: rehearsedFromAya.toString(),
              possibleValues: bloc.getAyatList(rehearsedFromSoura),
              title: 'من آية',
              onSaved: (String value) {
                int temp = int.parse(value);
                rehearsedFromAya = temp;
              },
              isEnabled: true,
            ),
          ),
        ],
      ),
      Row(
        children: [
          Expanded(
            child: DropdownButtonFormField2(
              value: rehearsedToSoura,
              possibleValues: bloc.getSouratList(),
              title: 'إلى سورة',
              onSaved: (String value) {
                rehearsedToSoura = value;
                setState(() {});
              },
              isEnabled: true,
            ),
          ),
          Expanded(
            child: DropdownButtonFormField2(
              value: rehearsedToAya.toString(),
              possibleValues: bloc.getAyatList(rehearsedToSoura),
              title: 'إلى آية',
              onSaved: (String value) {
                int temp = int.parse(value);
                rehearsedToAya = temp;
              },
              isEnabled: true,
            ),
          ),
        ],
      ),
      DropdownButtonFormField2(
        value: rehearsedMark.toString(),
        possibleValues: bloc.getPossibleMarks(),
        title: 'التقييم',
        onSaved: (String value) {
          int temp = int.parse(value);
          rehearsedMark = temp;
        },
        isEnabled: true,
      ),
    ];
  }
}
