import 'package:al_halaqat/common_widgets/date_picker.dart';
import 'package:al_halaqat/common_widgets/text_form_field2.dart';
import 'package:al_halaqat/common_widgets/drop_down_form_field2.dart';
import 'package:al_halaqat/common_widgets/country_phone_number_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NewStudentForm extends StatefulWidget {
  @override
  _NewStudentFormState createState() => _NewStudentFormState();
}

class _NewStudentFormState extends State<NewStudentForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool enabled = true;
  String sex;

  void _save() {
    _formKey.currentState.validate();
    _formKey.currentState.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('fill info'),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: InkWell(
              onTap: () => _save(),
              child: Icon(
                Icons.save,
                size: 26.0,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                TextFormField2(
                  title: 'name',
                  hintText: 'enter yourname',
                  errorText: 'fuck it bitch',
                  maxLength: 30,
                  inputFormatter: BlacklistingTextInputFormatter(''),
                  onSaved: (value) => print(value),
                ),
                DatePicker(
                  title: 'pick a date',
                  selectedDate: DateTime.now(),
                  onSelectedDate: (value) => print(value),
                ),
                DropdownButtonFormField2(
                  title: 'srx',
                  possibleValues: ["ذكر", "أنثى"],
                  value: sex,
                  onSaved: (value) => sex = value,
                ),
                CountryPhoneNumberPicker(
                  title: 'title',
                  onSavedCountry: (value) => print(value),
                  onSavedPhoneNumber: (value) => print(value),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
