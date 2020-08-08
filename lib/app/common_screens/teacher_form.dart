import 'package:al_halaqat/app/models/teacher.dart';
import 'package:al_halaqat/app/models/teacher.dart';
import 'package:al_halaqat/app/models/user.dart';
import 'package:al_halaqat/common_widgets/date_picker.dart';
import 'package:al_halaqat/common_widgets/platform_exception_alert_dialog.dart';
import 'package:al_halaqat/common_widgets/text_form_field2.dart';
import 'package:al_halaqat/common_widgets/drop_down_form_field2.dart';
import 'package:al_halaqat/common_widgets/country_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TeacherForm extends StatefulWidget {
  const TeacherForm({
    Key key,
    this.teacher,
    @required this.onSaved,
  }) : super(key: key);
  final ValueChanged<Teacher> onSaved;
  final Teacher teacher;

  @override
  _NewStudentFormState createState() => _NewStudentFormState();
}

class _NewStudentFormState extends State<TeacherForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Teacher get teacher => widget.teacher;
  // teacher information
  String id;
  String name;
  int dateOfBirth;
  String gender;
  String nationality;
  String address;
  String phoneNumber;
  String educationalLevel;
  String etablissement;
  String note;
  String readableId;
  String username;
  String email;
  String password;
  Map<String, String> centerState;
  Timestamp createdAt;
  Map<String, String> createdBy;
  List<String> centers;
  List<String> halaqatLearningIn;
  //
  bool isStudent;
  bool isTeacher;
  List<String> halaqatTeachingIn;

  @override
  void initState() {
    name = teacher?.name;
    dateOfBirth = teacher?.dateOfBirth ?? DateTime.now().year;
    gender = teacher?.gender;
    nationality = teacher?.nationality ?? 'LB';
    address = teacher?.address;
    phoneNumber = teacher?.phoneNumber;
    educationalLevel = teacher?.educationalLevel;
    etablissement = teacher?.etablissement;
    note = teacher?.note;
    readableId = teacher?.readableId;
    username = teacher?.username;
    email = teacher?.email;
    password = teacher?.password;
    centerState = teacher?.centerState ?? Map<String, String>();
    createdAt = teacher?.createdAt;
    createdBy = teacher?.createdBy ?? Map<String, String>();

    centers = teacher?.centers ?? List<String>(1);
    halaqatLearningIn = teacher?.halaqatLearningIn ?? List<String>(1);
    //
    isStudent = teacher?.isStudent ?? false;
    isTeacher = teacher?.isTeacher;
    halaqatTeachingIn = teacher?.halaqatTeachingIn ?? List<String>(1);

    super.initState();
  }

  void _save() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Teacher teacher = Teacher(
        id: null,
        name: name,
        dateOfBirth: dateOfBirth ?? DateTime.now().year,
        gender: gender,
        nationality: nationality,
        address: address,
        phoneNumber: phoneNumber,
        educationalLevel: educationalLevel,
        etablissement: etablissement,
        note: note,
        readableId: readableId,
        username: username,
        email: email,
        password: password,
        centerState: centerState,
        createdAt: createdAt,
        createdBy: createdBy,
        isStudent: isStudent,
        halaqatLearningIn: halaqatLearningIn,
        centers: centers,
        isTeacher: true,
        halaqatTeachingIn: halaqatTeachingIn,
      );
      widget.onSaved(teacher);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('إملأ الإستمارة'),
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
                  title: 'الإسم',
                  initialValue: name,
                  hintText: 'إدخل إسمك',
                  errorText: 'خطأ',
                  maxLength: 30,
                  onChanged: (value) {},
                  inputFormatter: BlacklistingTextInputFormatter(''),
                  onSaved: (value) => name = value,
                ),
                DatePicker(
                    title: 'تاريخ الميلاد',
                    onSelectedDate: (value) {
                      dateOfBirth = value;
                      setState(() {});
                    }),
                DropdownButtonFormField2(
                  title: 'الجنس',
                  possibleValues: ["ذكر", "أنثى"],
                  value: gender,
                  onSaved: (value) => gender = value,
                ),
                CountryPicker(
                  title: 'الجنسية',
                  initialValue: nationality,
                  onSavedCountry: (value) => nationality = value,
                ),
                TextFormField2(
                  title: 'العنوان',
                  initialValue: address,
                  hintText: 'إدخل عنوانك',
                  errorText: 'خطأ',
                  maxLength: 30,
                  inputFormatter: BlacklistingTextInputFormatter(''),
                  onSaved: (value) => address = value,
                  onChanged: (value) {},
                ),
                TextFormField2(
                  title: 'رقم الهاتف',
                  initialValue: phoneNumber,
                  hintText: 'إدخل رقم هاتفك',
                  errorText: 'خطأ',
                  maxLength: 10,
                  inputFormatter: WhitelistingTextInputFormatter.digitsOnly,
                  onSaved: (value) => phoneNumber = value,
                  isPhoneNumber: true,
                  onChanged: (value) {},
                ),
                DropdownButtonFormField2(
                  title: 'مستوى تعليمي',
                  possibleValues: [
                    'سنة أولى',
                    'سنة الثانية',
                    'سنة الثالثة',
                    'سنة الرابعة',
                    'سنة الخامسة',
                    'سنة السادسة',
                    'سنة السابعة',
                    'سنة الثامنة',
                    'سنة التاسعة',
                    'سنة العاشرة',
                    'سنة الإحدى عاشر',
                    'سنة الإثنا عشر',
                    'سنة أولى جامعة',
                    'سنة ثانية جامعة',
                    'سنة ثالثة جامعة',
                    'سنة رابعة جامعة',
                    'ماجستير',
                    'دكتوراة',
                    'مهني',
                    'أخرى',
                  ],
                  value: educationalLevel,
                  onSaved: (value) => educationalLevel = value,
                ),
                TextFormField2(
                  title: 'مدرسة / الجامعة',
                  initialValue: etablissement,
                  hintText: 'إدخل إسم المؤسسة',
                  errorText: 'خطأ',
                  maxLength: 10,
                  inputFormatter: BlacklistingTextInputFormatter(''),
                  onSaved: (value) => etablissement = value,
                  onChanged: (value) {},
                ),
                TextFormField2(
                  title: 'رقم التعريفي للمركز',
                  // initialValue: centers[0],
                  hintText: 'إدخل رقم التعريفي للمركز',
                  errorText: 'خطأ',
                  maxLength: 20,
                  inputFormatter: WhitelistingTextInputFormatter.digitsOnly,
                  onSaved: (value) => centers[0] = value,
                  onChanged: (value) {},
                  isPhoneNumber: true,
                ),
                TextFormField2(
                  title: 'ملاحظة',
                  initialValue: note,
                  hintText: 'إدخل ملاحظة',
                  errorText: 'خطأ',
                  maxLength: 100,
                  inputFormatter: BlacklistingTextInputFormatter(''),
                  onSaved: (value) => note = value,
                  isPhoneNumber: false,
                  onChanged: (value) {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
