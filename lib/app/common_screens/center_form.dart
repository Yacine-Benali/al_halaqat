import 'package:al_halaqat/app/home/models/student.dart';
import 'package:al_halaqat/common_widgets/text_form_field2.dart';
import 'package:al_halaqat/common_widgets/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:al_halaqat/app/home/models/study_center.dart';

class CenterForm extends StatefulWidget {
  const CenterForm({
    Key key,
    this.center,
    this.onSaved,
  }) : super(key: key);
  final ValueChanged<StudyCenter> onSaved;
  final StudyCenter center;

  @override
  _NewStudentFormState createState() => _NewStudentFormState();
}

class _NewStudentFormState extends State<CenterForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  StudyCenter get center => widget.center;
  // center information
  String id;
  String readableId;
  String name;
  String country;
  String city;
  String street;
  String phoneNumber;
  bool isMessagingEnabled;
  bool studentRoaming;
  bool requestPermissionForHalaqaCreation;
  bool canTeachersEditStudents;
  bool canTeacherRemoveStudentsFromHalaqa;
  String state;
  int nextHalaqaReadableId;
  Map<String, String> createdBy;
  int createdAt;

  @override
  void initState() {
    readableId = center.readableId;
    name = center.name;
    country = center.country;
    city = center.city;
    street = center.street;
    phoneNumber = center.phoneNumber;
    isMessagingEnabled = center.isMessagingEnabled ?? true;
    studentRoaming = center.studentRoaming ?? false;
    requestPermissionForHalaqaCreation =
        center.requestPermissionForHalaqaCreation ?? false;
    canTeachersEditStudents = center.canTeachersEditStudents ?? true;
    canTeacherRemoveStudentsFromHalaqa =
        center.canTeacherRemoveStudentsFromHalaqa ?? false;
    state = center.state;
    nextHalaqaReadableId = center.nextHalaqaReadableId;
    createdBy = center.createdBy;
    createdAt = center.createdAt ?? DateTime.now().millisecondsSinceEpoch;

    super.initState();
  }

  void _save() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      StudyCenter center = StudyCenter(
        id: id,
        readableId: readableId,
        name: name,
        country: country,
        city: city,
        street: street,
        phoneNumber: phoneNumber,
        isMessagingEnabled: isMessagingEnabled,
        studentRoaming: studentRoaming,
        requestPermissionForHalaqaCreation: requestPermissionForHalaqaCreation,
        canTeachersEditStudents: canTeachersEditStudents,
        canTeacherRemoveStudentsFromHalaqa: canTeacherRemoveStudentsFromHalaqa,
        state: state,
        nextHalaqaReadableId: nextHalaqaReadableId,
        createdBy: createdBy,
        createdAt: createdAt,
      );
      widget.onSaved(center);
    }
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
                  title: 'إسم المركز',
                  initialValue: name,
                  hintText: 'إدخل إسم المركز',
                  errorText: 'خطأ',
                  maxLength: 30,
                  inputFormatter: BlacklistingTextInputFormatter(''),
                  onSaved: (value) => name = value,
                ),
                CountryPicker(
                  title: 'الجنسية',
                  initialValue: country,
                  onSavedCountry: (value) => country = value,
                ),
                TextFormField2(
                  title: 'مدينة',
                  initialValue: city,
                  hintText: ' إدخل مدينة المركز',
                  errorText: 'خطأ',
                  maxLength: 30,
                  inputFormatter: BlacklistingTextInputFormatter(''),
                  onSaved: (value) => city = value,
                ),
                TextFormField2(
                  title: 'العنوان',
                  initialValue: street,
                  hintText: 'إدخل عنوان المركز',
                  errorText: 'خطأ',
                  maxLength: 30,
                  inputFormatter: BlacklistingTextInputFormatter(''),
                  onSaved: (value) => street = value,
                ),
                TextFormField2(
                  title: 'رقم هاتف مركز',
                  initialValue: phoneNumber,
                  hintText: 'إدخل رقم هاتف مركز',
                  errorText: 'خطأ',
                  maxLength: 10,
                  inputFormatter: WhitelistingTextInputFormatter.digitsOnly,
                  onSaved: (value) => phoneNumber = value,
                  isPhoneNumber: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
