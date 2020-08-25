import 'package:al_halaqat/app/common_forms/center_form.dart';
import 'package:al_halaqat/app/models/halaqa.dart';
import 'package:al_halaqat/app/models/student.dart';
import 'package:al_halaqat/app/models/study_center.dart';
import 'package:al_halaqat/app/sign_in/validator.dart';
import 'package:al_halaqat/common_widgets/country_picker.dart';
import 'package:al_halaqat/common_widgets/date_picker.dart';
import 'package:al_halaqat/common_widgets/drop_down_form_field2.dart';
import 'package:al_halaqat/common_widgets/password_text_field.dart';
import 'package:al_halaqat/common_widgets/text_form_field2.dart';
import 'package:al_halaqat/common_widgets/user_halaqa_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StudentForm extends StatefulWidget {
  const StudentForm({
    Key key,
    @required this.student,
    @required this.onSaved,
    @required this.studentFormKey,
    @required this.includeCenterIdInput,
    @required this.includeUsernameAndPassword,
    @required this.includeCenterForm,
    @required this.center,
    this.isEnabled = true,
    this.halaqatList,
    @required this.showUserHalaqa,
  }) : super(key: key);
  final GlobalKey<FormState> studentFormKey;
  final StudyCenter center;

  final ValueChanged<Student> onSaved;
  final Student student;
  final bool isEnabled;
  final bool includeCenterIdInput;
  final bool includeCenterForm;

  final bool includeUsernameAndPassword;
  final List<Halaqa> halaqatList;
  final bool showUserHalaqa;

  @override
  _NewStudentFormState createState() => _NewStudentFormState();
}

class _NewStudentFormState extends State<StudentForm>
    with UsernameAndPasswordValidators {
  Student get student => widget.student;
  final GlobalKey<FormState> centerFormKey = GlobalKey<FormState>();

  String usernameInitValue;
  //
  String centerFormTitle;
  String adminFormTitle;
  // student information
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
  String state;
  Timestamp createdAt;
  Map<String, String> createdBy;
  String center;
  List<String> halaqatLearningIn;
  //
  bool isStudent;
  String parentPhoneNumber;
  //

  @override
  void initState() {
    centerFormTitle =
        widget.isEnabled ? 'إدخل معلومات المركز' : 'معلومات المركز';
    adminFormTitle =
        widget.isEnabled ? 'إدخل معلوماتك الشخصية' : 'معلومات الطالب';
    id = student?.id;
    name = student?.name;
    dateOfBirth = student?.dateOfBirth ?? 1950;
    gender = student?.gender ?? 'ذكر';
    nationality = student?.nationality ?? 'LB';
    address = student?.address;
    phoneNumber = student?.phoneNumber;
    educationalLevel = student?.educationalLevel ?? 'سنة أولى';
    etablissement = student?.etablissement;
    note = student?.note;
    readableId = student?.readableId;
    username = student?.username;
    password = student?.password;
    // print('got here');
    createdAt = student?.createdAt;
    state = student?.state;
    createdBy = student?.createdBy ?? Map<String, String>();
    center = student?.center;
    halaqatLearningIn = student?.halaqatLearningIn ?? List<String>(1);
    isStudent = student?.isStudent;
    parentPhoneNumber = student?.parentPhoneNumber;
    //
    usernameInitValue = username?.replaceAll('@al-halaqat.firebaseapp.com', '');

    _save();

    super.initState();
  }

  void _save() {
    Student newStudent = Student(
      id: id,
      name: name,
      dateOfBirth: dateOfBirth,
      gender: gender,
      nationality: nationality,
      address: address,
      phoneNumber: phoneNumber,
      educationalLevel: educationalLevel,
      etablissement: etablissement,
      note: note,
      readableId: readableId,
      username: username,
      password: password,
      parentPhoneNumber: parentPhoneNumber,
      isStudent: true,
      state: state,
      createdAt: createdAt,
      createdBy: createdBy,
      halaqatLearningIn: halaqatLearningIn,
      center: center,
    );
    widget.onSaved(newStudent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        onChanged: () {
          _save();
        },
        key: widget.studentFormKey,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                if (widget.includeUsernameAndPassword) ...[
                  TextFormField2(
                    isEnabled: widget.isEnabled,
                    title: 'إسم المتستخدم',
                    initialValue: usernameInitValue,
                    hintText: 'إدخل إسم المتستخدم',
                    errorText: 'خطأ',
                    maxLength: 30,
                    inputFormatter: FilteringTextInputFormatter.deny(''),
                    onChanged: (value) {
                      value = value + '@al-halaqat.firebaseapp.com';
                      username = value;
                    },
                    isPhoneNumber: false,
                    validator: (value) {
                      if (!usernameSubmitValidator.isValid(value)) {
                        return 'خطأ';
                      }
                      return null;
                    },
                  ),
                  PasswordTextField(
                    onPasswordCreated: (value) {
                      password = value;
                      _save();
                    },
                    existingPassword: password,
                  ),
                ],
                if (widget.includeCenterForm) ...[
                  Text(
                    centerFormTitle,
                    style: TextStyle(fontSize: 20),
                  ),
                  CenterForm(
                    isEnabled: false,
                    formKey: centerFormKey,
                    center: widget.center,
                    onSaved: (newcenter) {},
                    showCenterOptions: false,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    adminFormTitle,
                    style: TextStyle(fontSize: 20),
                  ),
                ],
                TextFormField2(
                  isEnabled: widget.isEnabled,
                  title: 'الإسم',
                  initialValue: name,
                  hintText: 'إدخل إسمك',
                  errorText: 'خطأ',
                  maxLength: 30,
                  inputFormatter: FilteringTextInputFormatter.deny(''),
                  onChanged: (value) => name = value,
                  isPhoneNumber: false,
                ),
                DatePicker(
                    isEnabled: widget.isEnabled,
                    initialValue: dateOfBirth,
                    title: 'تاريخ الميلاد',
                    onSelectedDate: (value) {
                      dateOfBirth = value;
                      _save();
                    }),
                DropdownButtonFormField2(
                  isEnabled: widget.isEnabled,
                  title: 'الجنس',
                  possibleValues: ["ذكر", "أنثى"],
                  value: gender,
                  onSaved: (value) => gender = value,
                ),
                CountryPicker(
                  isEnabled: widget.isEnabled,
                  title: 'الجنسية',
                  initialValue: nationality,
                  onSavedCountry: (value) {
                    nationality = value;
                    _save();
                  },
                ),
                TextFormField2(
                  isEnabled: widget.isEnabled,
                  title: 'العنوان',
                  initialValue: address,
                  hintText: 'إدخل عنوانك',
                  errorText: 'خطأ',
                  maxLength: 30,
                  inputFormatter: FilteringTextInputFormatter.deny(''),
                  onChanged: (value) => address = value,
                ),
                TextFormField2(
                  isEnabled: widget.isEnabled,
                  title: 'رقم الهاتف',
                  initialValue: phoneNumber,
                  hintText: 'إدخل رقم هاتفك',
                  errorText: 'خطأ',
                  maxLength: 10,
                  inputFormatter: WhitelistingTextInputFormatter.digitsOnly,
                  onChanged: (value) => phoneNumber = value,
                  isPhoneNumber: true,
                ),
                TextFormField2(
                  isEnabled: widget.isEnabled,
                  title: 'رقم هاتف ولي الأمر',
                  initialValue: parentPhoneNumber,
                  hintText: 'إدخل رقم هاتف ولي الأمر',
                  errorText: 'خطأ',
                  maxLength: 10,
                  inputFormatter: WhitelistingTextInputFormatter.digitsOnly,
                  onChanged: (value) => parentPhoneNumber = value,
                  isPhoneNumber: true,
                ),
                DropdownButtonFormField2(
                  isEnabled: widget.isEnabled,
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
                  isEnabled: widget.isEnabled,
                  title: 'مدرسة / الجامعة',
                  initialValue: etablissement,
                  hintText: 'إدخل إسم المؤسسة',
                  errorText: 'خطأ',
                  maxLength: 10,
                  inputFormatter: FilteringTextInputFormatter.deny(''),
                  onChanged: (value) => etablissement = value,
                ),
                if (widget.includeCenterIdInput) ...[
                  TextFormField2(
                    isEnabled: widget.isEnabled,
                    title: 'رقم التعريفي للمركز',
                    //initialValue: centers[0],
                    hintText: 'إدخل رقم التعريفي للمركز',
                    errorText: 'خطأ',
                    maxLength: 20,
                    inputFormatter: WhitelistingTextInputFormatter.digitsOnly,
                    isPhoneNumber: true,
                    onChanged: (value) => center = value,
                  ),
                ],
                TextFormField2(
                  isEnabled: widget.isEnabled,
                  title: 'ملاحظة',
                  initialValue: note,
                  hintText: 'إدخل ملاحظة',
                  errorText: 'خطأ',
                  maxLength: 100,
                  inputFormatter: FilteringTextInputFormatter.deny(''),
                  isPhoneNumber: false,
                  onChanged: (value) => note = value,
                ),
                if (widget.showUserHalaqa) ...[
                  UserHalaqaForm(
                    title: 'حلقات',
                    halaqatList: widget.halaqatList,
                    onSaved: (List<String> value) {
                      halaqatLearningIn = value;
                      _save();
                    },
                    currentHalaqatIdsList: halaqatLearningIn,
                  )
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
