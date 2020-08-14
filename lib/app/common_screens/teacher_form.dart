import 'package:al_halaqat/app/models/halaqa.dart';
import 'package:al_halaqat/app/models/teacher.dart';
import 'package:al_halaqat/app/models/teacher.dart';
import 'package:al_halaqat/app/models/user.dart';
import 'package:al_halaqat/app/sign_in/validator.dart';
import 'package:al_halaqat/common_widgets/date_picker.dart';
import 'package:al_halaqat/common_widgets/password_text_field.dart';
import 'package:al_halaqat/common_widgets/platform_exception_alert_dialog.dart';
import 'package:al_halaqat/common_widgets/text_form_field2.dart';
import 'package:al_halaqat/common_widgets/drop_down_form_field2.dart';
import 'package:al_halaqat/common_widgets/country_picker.dart';
import 'package:al_halaqat/common_widgets/user_halaqa_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TeacherForm extends StatefulWidget {
  const TeacherForm({
    Key key,
    @required this.teacher,
    @required this.onSaved,
    @required this.includeCenterIdInput,
    @required this.includeUsernameAndPassword,
    @required this.isEnabled,
    @required this.teacherFormKey,
    this.halaqatList,
    @required this.showUserHalaqa,
  }) : super(key: key);
  final GlobalKey<FormState> teacherFormKey;
  final ValueChanged<Teacher> onSaved;
  final Teacher teacher;
  final bool isEnabled;
  final bool includeCenterIdInput;
  final bool includeUsernameAndPassword;
  final List<Halaqa> halaqatList;
  final bool showUserHalaqa;

  @override
  _NewStudentFormState createState() => _NewStudentFormState();
}

class _NewStudentFormState extends State<TeacherForm>
    with UsernameAndPasswordValidators {
  Teacher get teacher => widget.teacher;
  String usernameInitValue;
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
    id = teacher?.id;
    name = teacher?.name;
    dateOfBirth = teacher?.dateOfBirth ?? 1950;
    gender = teacher?.gender ?? 'ذكر';
    nationality = teacher?.nationality ?? 'LB';
    address = teacher?.address;
    phoneNumber = teacher?.phoneNumber;
    educationalLevel = teacher?.educationalLevel ?? 'سنة أولى';
    etablissement = teacher?.etablissement;
    note = teacher?.note;
    readableId = teacher?.readableId;
    username = teacher?.username;
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
//
    usernameInitValue = username?.replaceAll('@al-halaqat.firebaseapp.com', '');
    _save();
    super.initState();
  }

  void _save() {
    Teacher teacher = Teacher(
      id: id,
      name: name,
      dateOfBirth: dateOfBirth ?? 1950,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        onChanged: () {
          _save();
        },
        key: widget.teacherFormKey,
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
                TextFormField2(
                  isEnabled: widget.isEnabled,
                  title: 'الإسم',
                  initialValue: name,
                  hintText: 'إدخل إسمك',
                  errorText: 'خطأ',
                  maxLength: 30,
                  inputFormatter: FilteringTextInputFormatter.deny(''),
                  onChanged: (value) => name = value,
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
                    onChanged: (value) => centers[0] = value,
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
                    title: 'حلقات يعلم فيها',
                    halaqatList: widget.halaqatList,
                    onSaved: (List<String> value) {
                      halaqatTeachingIn = value;
                      _save();
                    },
                    currentHalaqatIdsList: halaqatTeachingIn,
                  ),
                ],
                if (teacher?.isStudent ?? false) ...[
                  UserHalaqaForm(
                    title: 'حلقات طالب فيها',
                    halaqatList: widget.halaqatList,
                    onSaved: (List<String> value) {
                      halaqatLearningIn = value;
                      _save();
                    },
                    currentHalaqatIdsList: halaqatLearningIn,
                  )
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
