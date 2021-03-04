import 'package:alhalaqat/app/home/approved/common_screens/user_instances/evaluation/evaluation_bloc.dart';
import 'package:alhalaqat/app/models/evaluation.dart';
import 'package:alhalaqat/app/models/evaluation_helper.dart';
import 'package:alhalaqat/common_widgets/drop_down_form_field2.dart';
import 'package:alhalaqat/common_widgets/firebase_exception_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/platform_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/platform_exception_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/progress_dialog.dart';
import 'package:alhalaqat/common_widgets/text_form_field2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  List souratList = [];
  List<String> possibleMarks = [];
  bool isMemorizedEnabled;
  bool isRehearsedEnabled;
  String note;
  @override
  void initState() {
    possibleMarks = bloc.getPossibleMarks();
    isMemorizedEnabled = true;
    isRehearsedEnabled = true;
    souratList = bloc.getSouratList();
    souratList.insert(0, ' ');
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
    memorizedMark = 1;
    //
    rehearsedFromSoura = bloc.getSouratList().first;
    rehearsedFromAya = 1;
    rehearsedToSoura = bloc.getSouratList().first;
    rehearsedToAya = 1;
    rehearsedMark = 1;
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
      note: note,
      memorized: memorized,
      rehearsed: rehearsed,
    );

    if (memorizedFromSoura == ' ' && rehearsedFromSoura == ' ') {
      PlatformAlertDialog(
        title: 'فشلت العملية',
        content: '',
        defaultActionText: 'حسنا',
      ).show(context);
      return;
    }
    try {
      await pr.show();
      bloc.validateEvaluation(evaluation);
      widget.bloc.setEvaluation(evaluation, widget.evaluationsList);
      await Future.delayed(Duration(seconds: 1));
      await pr.hide();

      PlatformAlertDialog(
        title: 'نجح الحفظ',
        content: 'تم حفظ البيانات',
        defaultActionText: 'حسنا',
      ).show(context);
      Navigator.of(context).pop();
    } catch (e) {
      await pr.hide();
      if (e is PlatformException) {
        PlatformExceptionAlertDialog(
          title: 'فشلت العملية',
          exception: e,
        ).show(context);
      } else if (e is FirebaseException)
        FirebaseExceptionAlertDialog(
          title: 'فشلت العملية',
          exception: e,
        ).show(context);
      else
        PlatformAlertDialog(
          title: 'فشلت العملية',
          content: 'فشلت العملية',
          defaultActionText: 'حسنا',
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
                SizedBox(height: 10),
                buildNote()
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
              possibleValues: souratList,
              title: 'من سورة',
              onSaved: (String value) {
                memorizedFromSoura = value;
                if (memorizedFromSoura == ' ') {
                  memorizedFromAya = 0;
                  isMemorizedEnabled = false;
                  memorizedToAya = 0;
                  memorizedToSoura = ' ';
                  memorizedMark = 0;
                } else {
                  memorizedToSoura = memorizedFromSoura;
                  memorizedFromAya = 1;
                  memorizedToAya = 1;
                  isMemorizedEnabled = true;
                  memorizedMark = 1;
                }
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
              isEnabled: isMemorizedEnabled,
            ),
          ),
        ],
      ),
      Row(
        children: [
          Expanded(
            child: DropdownButtonFormField2(
              value: memorizedToSoura,
              possibleValues: souratList,
              title: 'إلى سورة',
              onSaved: (String value) {
                memorizedToSoura = value;
                setState(() {});
              },
              isEnabled: isMemorizedEnabled,
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
              isEnabled: isMemorizedEnabled,
            ),
          ),
        ],
      ),
      DropdownButtonFormField2(
        value: memorizedMark.toString(),
        possibleValues: isMemorizedEnabled ? possibleMarks : ['0'],
        title: 'التقييم',
        onSaved: (String value) {
          int temp = int.parse(value);
          memorizedMark = temp;
        },
        isEnabled: isMemorizedEnabled,
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
              possibleValues: souratList,
              title: 'من سورة',
              onSaved: (String value) {
                rehearsedFromSoura = value;
                if (rehearsedFromSoura == ' ') {
                  rehearsedFromAya = 0;
                  isRehearsedEnabled = false;
                  rehearsedToAya = 0;
                  rehearsedToSoura = ' ';
                  rehearsedMark = 0;
                } else {
                  rehearsedToSoura = rehearsedFromSoura;
                  rehearsedFromAya = 1;
                  rehearsedToAya = 1;
                  isRehearsedEnabled = true;
                  rehearsedMark = 1;
                }
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
              isEnabled: isRehearsedEnabled,
            ),
          ),
        ],
      ),
      Row(
        children: [
          Expanded(
            child: DropdownButtonFormField2(
              value: rehearsedToSoura,
              possibleValues: souratList,
              title: 'إلى سورة',
              onSaved: (String value) {
                rehearsedToSoura = value;
                setState(() {});
              },
              isEnabled: isRehearsedEnabled,
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
              isEnabled: isRehearsedEnabled,
            ),
          ),
        ],
      ),
      DropdownButtonFormField2(
        value: rehearsedMark.toString(),
        possibleValues: isRehearsedEnabled ? possibleMarks : ['0'],
        title: 'التقييم',
        onSaved: (String value) {
          int temp = int.parse(value);
          rehearsedMark = temp;
        },
        isEnabled: isRehearsedEnabled,
      ),
    ];
  }

  Widget buildNote() {
    return TextFormField2(
      isEnabled: true,
      title: 'ملاحظة',
      initialValue: note ?? '',
      hintText: 'أدخل ملاحظة',
      errorText: 'خطأ',
      maxLength: 100,
      inputFormatter: FilteringTextInputFormatter.deny(''),
      isPhoneNumber: false,
      onChanged: (value) => note = value,
      validator: (value) => null,
    );
  }
}
