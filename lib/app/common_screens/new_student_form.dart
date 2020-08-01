import 'package:al_halaqat/app/home/models/student.dart';
import 'package:al_halaqat/app/home/models/user.dart';
import 'package:al_halaqat/common_widgets/date_picker.dart';
import 'package:al_halaqat/common_widgets/platform_exception_alert_dialog.dart';
import 'package:al_halaqat/common_widgets/text_form_field2.dart';
import 'package:al_halaqat/common_widgets/drop_down_form_field2.dart';
import 'package:al_halaqat/common_widgets/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NewStudentForm extends StatefulWidget {
  const NewStudentForm({
    Key key,
    this.student,
    @required this.onSaved,
  }) : super(key: key);
  final ValueChanged<Student> onSaved;
  final Student student;

  @override
  _NewStudentFormState createState() => _NewStudentFormState();
}

class _NewStudentFormState extends State<NewStudentForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Student get student => widget.student;
  // student information
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
  String parentPhoneNumber;
  String isStudent;
  String centerId;
  String state;
  int createdAt;
  Map<String, String> createdBy;

  @override
  void initState() {
    name = student?.name;
    dateOfBirth = student?.dateOfBirth ?? DateTime.now().millisecondsSinceEpoch;
    gender = student?.gender;
    nationality = student?.nationality ?? 'LBN';
    address = student?.address;
    phoneNumber = student?.phoneNumber;
    educationalLevel = student?.educationalLevel;
    etablissement = student?.etablissement;
    note = student?.note;
    parentPhoneNumber = student?.parentPhoneNumber;
    centerId = student?.centerId;
    super.initState();
  }

  void _save() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print(nationality);
      Student student = Student(
        id: null,
        name: name,
        dateOfBirth: dateOfBirth ?? DateTime.now().millisecondsSinceEpoch,
        gender: gender,
        nationality: nationality,
        address: address,
        phoneNumber: phoneNumber,
        educationalLevel: educationalLevel,
        etablissement: etablissement,
        note: note,
        readableId: null,
        username: null,
        email: null,
        password: null,
        parentPhoneNumber: parentPhoneNumber,
        isStudent: true,
        centerId: centerId,
        state: null,
        createdAt: null,
        createdBy: null,
        halaqatLearningIn: null,
      );
      // widget.onSaved(student);
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
                  title: 'الإسم',
                  initialValue: name,
                  hintText: 'إدخل إسمك',
                  errorText: 'خطأ',
                  maxLength: 30,
                  inputFormatter: BlacklistingTextInputFormatter(''),
                  onSaved: (value) => name = value,
                ),
                DatePicker(
                  title: 'تاريخ الميلاد',
                  selectedDate:
                      DateTime.fromMillisecondsSinceEpoch(dateOfBirth),
                  onSelectedDate: (value) =>
                      dateOfBirth = value.millisecondsSinceEpoch,
                ),
                DropdownButtonFormField2(
                  title: 'الجنس',
                  possibleValues: ["ذكر", "أنثى"],
                  value: gender,
                  onSaved: (value) => gender = value,
                ),
                CountryPicker(
                  title: 'الجنسية',
                  onSavedCountry: (value) => nationality = value,
                ),
                TextFormField2(
                  title: 'العنوان',
                  hintText: 'إدخل عنوانك',
                  errorText: 'خطأ',
                  maxLength: 30,
                  inputFormatter: BlacklistingTextInputFormatter(''),
                  onSaved: (value) => address = value,
                ),
                TextFormField2(
                  title: 'رقم الهاتف',
                  hintText: 'إدخل رقم هاتفك',
                  errorText: 'خطأ',
                  maxLength: 10,
                  inputFormatter: WhitelistingTextInputFormatter.digitsOnly,
                  onSaved: (value) => phoneNumber = value,
                  isPhoneNumber: true,
                ),
                TextFormField2(
                  title: 'رقم هاتف ولي الأمر',
                  hintText: 'إدخل رقم هاتف ولي الأمر',
                  errorText: 'خطأ',
                  maxLength: 10,
                  inputFormatter: WhitelistingTextInputFormatter.digitsOnly,
                  onSaved: (value) => parentPhoneNumber = value,
                  isPhoneNumber: true,
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
                  hintText: 'إدخل إسم المؤسسة',
                  errorText: 'خطأ',
                  maxLength: 10,
                  inputFormatter: BlacklistingTextInputFormatter(''),
                  onSaved: (value) => etablissement = value,
                ),
                TextFormField2(
                  title: 'رقم التعريفي للمركز',
                  hintText: 'إدخل رقم التعريفي للمركز',
                  errorText: 'خطأ',
                  maxLength: 20,
                  inputFormatter: WhitelistingTextInputFormatter.digitsOnly,
                  onSaved: (value) => centerId = value,
                  isPhoneNumber: true,
                ),
                TextFormField2(
                  title: 'ملاحظة',
                  hintText: 'إدخل ملاحظة',
                  errorText: 'خطأ',
                  maxLength: 100,
                  inputFormatter: BlacklistingTextInputFormatter(''),
                  onSaved: (value) => note = value,
                  isPhoneNumber: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
