import 'package:alhalaqat/app/models/halaqa.dart';
import 'package:alhalaqat/app/sign_in/validator.dart';
import 'package:alhalaqat/common_widgets/text_form_field2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HalaqaForm extends StatefulWidget {
  const HalaqaForm({
    Key key,
    @required this.halaqa,
    @required this.onSaved,
    @required this.halaqaFormKey,
    this.isEnabled = true,
  }) : super(key: key);

  final GlobalKey<FormState> halaqaFormKey;

  final ValueChanged<Halaqa> onSaved;
  final Halaqa halaqa;
  final bool isEnabled;

  @override
  _NewHalaqaFormState createState() => _NewHalaqaFormState();
}

class _NewHalaqaFormState extends State<HalaqaForm>
    with UsernameAndPasswordValidators {
  Halaqa get halaqa => widget.halaqa;
  // student information
  String id;
  String readableId;
  String centerId;
  String name;
  String level;
  String description;
  String state;
  Map<String, String> createdBy;
  Timestamp createdAt;

  @override
  void initState() {
    id = halaqa?.id;
    readableId = halaqa?.readableId;
    centerId = halaqa?.centerId;
    name = halaqa?.name;
    level = halaqa?.level;
    description = halaqa?.description;
    state = halaqa?.state;
    createdBy = halaqa?.createdBy;
    createdAt = halaqa?.createdAt;

    _save();

    super.initState();
  }

  void _save() {
    Halaqa halaqa = Halaqa(
      id: id,
      readableId: readableId,
      centerId: centerId,
      name: name,
      level: level,
      description: description,
      state: state,
      createdBy: createdBy,
      createdAt: createdAt,
    );
    widget.onSaved(halaqa);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        onChanged: () {
          _save();
        },
        key: widget.halaqaFormKey,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                TextFormField2(
                  isEnabled: widget.isEnabled,
                  title: 'إسم الحلقة',
                  initialValue: name,
                  hintText: 'إدخل إسم الحلقة',
                  errorText: 'خطأ',
                  maxLength: 30,
                  inputFormatter: FilteringTextInputFormatter.deny(''),
                  onChanged: (value) => name = value,
                  isPhoneNumber: false,
                ),
                TextFormField2(
                  isEnabled: widget.isEnabled,
                  title: 'مستوى الحلقة',
                  initialValue: level,
                  hintText: 'إدخل مستوى الحلقة',
                  errorText: 'خطأ',
                  maxLength: 30,
                  inputFormatter: FilteringTextInputFormatter.deny(''),
                  onChanged: (value) => level = value,
                  isPhoneNumber: false,
                ),
                TextFormField2(
                  isEnabled: widget.isEnabled,
                  title: 'وصف الحلقة',
                  initialValue: description,
                  hintText: 'وصف الحلقة',
                  errorText: 'خطأ',
                  maxLength: 30,
                  inputFormatter: FilteringTextInputFormatter.deny(''),
                  onChanged: (value) => description = value,
                  validator: (t) {},
                ),
                if (halaqa?.readableId != null) ...[
                  TextFormField2(
                    isEnabled: false,
                    title: 'رقم تعريفي',
                    initialValue: readableId,
                    hintText: 'وصف الحلقة',
                    errorText: 'خطأ',
                    maxLength: 30,
                    inputFormatter: FilteringTextInputFormatter.deny(''),
                    onChanged: (value) {},
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
