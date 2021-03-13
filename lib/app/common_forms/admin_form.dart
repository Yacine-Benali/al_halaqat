import 'package:alhalaqat/app/common_forms/center_form.dart';
import 'package:alhalaqat/app/models/admin.dart';
import 'package:alhalaqat/app/models/study_center.dart';
import 'package:alhalaqat/app/sign_in/validator.dart';
import 'package:alhalaqat/common_widgets/center_state_form.dart';
import 'package:alhalaqat/common_widgets/country_picker.dart';
import 'package:alhalaqat/common_widgets/drop_down_form_field2.dart';
import 'package:alhalaqat/common_widgets/password_text_field.dart';
import 'package:alhalaqat/common_widgets/text_form_field2.dart';
import 'package:alhalaqat/common_widgets/year_picker2.dart';
import 'package:alhalaqat/constants/key_translate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdminForm extends StatefulWidget {
  const AdminForm({
    Key key,
    @required this.adminFormKey,
    @required this.admin,
    @required this.onSavedAdmin,
    @required this.onSavedCenter,
    @required this.center,
    @required this.isEnabled,
    @required this.includeCenterForm,
    @required this.includeCenterIdInput,
    @required this.includeUsernameAndPassword,
    this.centersList,
    @required this.includeCenterState,
  }) : super(key: key);
  final GlobalKey<FormState> adminFormKey;
//
  final Admin admin;
  final ValueChanged<Admin> onSavedAdmin;
  final StudyCenter center;
  final ValueChanged<StudyCenter> onSavedCenter;
  //
  final bool isEnabled;
  final bool includeCenterForm;
  final bool includeCenterIdInput;
  final bool includeUsernameAndPassword;
  final bool includeCenterState;
  // centers List
  final List<StudyCenter> centersList;
  @override
  _NewAdminFormState createState() => _NewAdminFormState();
}

class _NewAdminFormState extends State<AdminForm>
    with UsernameAndPasswordValidators, EmailAndPasswordValidators {
  final GlobalKey<FormState> centerFormKey = GlobalKey<FormState>();
  String appBarTitle;
  String centerFormTitle;
  String adminFormTitle;

  Admin get admin => widget.admin;
  // center
  StudyCenter center;
  String usernameInitValue;
  // admin information
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
  //
  bool isAdmin;

  @override
  void initState() {
    appBarTitle = widget.isEnabled ? 'إملأ الإستمارة' : 'معلومات الطلب';
    centerFormTitle =
        widget.isEnabled ? 'أدخل معلومات المركز' : 'معلومات المركز';
    adminFormTitle =
        widget.isEnabled ? 'أدخل معلوماتك الشخصية' : 'معلومات المشرف';
    //
    id = admin?.id;
    name = admin?.name;
    dateOfBirth = admin?.dateOfBirth ?? 1950;
    gender = admin?.gender ?? 'ذكر';
    nationality = admin?.nationality ?? 'LB';
    address = admin?.address;
    phoneNumber = admin?.phoneNumber;
    educationalLevel =
        KeyTranslate.educationalLevel.contains(admin?.educationalLevel)
            ? admin?.educationalLevel
            : 'جامعي';
    etablissement = admin?.etablissement;
    note = admin?.note;
    readableId = admin?.readableId;
    username = admin?.username;
    password = admin?.password;
    centerState = admin?.centerState ?? Map<String, String>();
    createdAt = admin?.createdAt;
    createdBy = admin?.createdBy ?? Map<String, String>();
    centers = admin?.centers ?? List<String>(1);
    //
    isAdmin = admin?.isAdmin;
    //
    usernameInitValue = username?.replaceAll('@al-halaqat.firebaseapp.com', '');
    // print(usernameInitValue);

    _save();
    super.initState();
  }

  void _save() {
    // bool temp = centerFormKey?.currentState?.validate();
    // temp = temp ?? true;
    // if (adminFormKey.currentState.validate() && temp) {
    //   adminFormKey.currentState.save();

    Admin admin = Admin(
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
      centers: centers,
      isAdmin: true,
    );
    if (widget.includeCenterForm) {
      widget.onSavedCenter(center);
      widget.onSavedAdmin(admin);
    } else {
      widget.onSavedAdmin(admin);
    }
  }

  bool isGmailOrFacebook() {
    if (widget.admin != null) {
      if (widget.admin.username != null) {
        if (widget.admin.username.contains('gmail.com')) return true;
      } else {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    print(widget.includeUsernameAndPassword);
    return Scaffold(
      body: Form(
        onChanged: () {
          _save();
        },
        key: widget.adminFormKey,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                if (widget.includeUsernameAndPassword &&
                    !isGmailOrFacebook()) ...[
                  TextFormField2(
                    isEnabled: widget.isEnabled,
                    title: 'اسم  المستخدم',
                    initialValue: usernameInitValue,
                    hintText: 'أدخل اسم  المستخدم',
                    errorText:
                        'اسم المستخدم يجب أن يكون بدون فراغ من 3 إلى 20 حرف',
                    maxLength: 30,
                    inputFormatter: usernameInputFormatter,
                    onChanged: (value) {
                      value = value + '@al-halaqat.firebaseapp.com';
                      username = value;
                    },
                    isPhoneNumber: false,
                    validator: (value) {
                      if (!usernameSubmitValidator.isValid(value)) {
                        return 'اسم المستخدم يجب أن يكون بدون فراغ من 3 إلى 20 حرف';
                      }
                      return null;
                    },
                  ),
                  PasswordTextField(
                    hidePassword: false,
                    onPasswordCreated: (value) {
                      password = value;
                      _save();
                    },
                    existingPassword: password,
                    isEnabled: widget.isEnabled,
                  ),
                ],
                if (widget.includeCenterForm) ...[
                  Text(
                    centerFormTitle,
                    style: TextStyle(fontSize: 20),
                  ),
                  CenterForm(
                    showReadableId: false,
                    isEnabled: widget.isEnabled,
                    formKey: centerFormKey,
                    center: widget.center,
                    onSaved: (newcenter) {
                      center = newcenter;
                      _save();
                    },
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
                  title: 'الاسم',
                  initialValue: name,
                  hintText: 'أدخل اسمك',
                  errorText: 'خطأ',
                  maxLength: 30,
                  inputFormatter: FilteringTextInputFormatter.deny(''),
                  onChanged: (value) => name = value,
                  isPhoneNumber: false,
                ),
                YearPicker2(
                    isEnabled: widget.isEnabled,
                    initialValue: dateOfBirth,
                    title: 'سنة الميلاد ',
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
                  hintText: 'أدخل عنوانك',
                  errorText: 'خطأ',
                  maxLength: 30,
                  inputFormatter: FilteringTextInputFormatter.deny(''),
                  onChanged: (value) => address = value,
                ),
                TextFormField2(
                  isEnabled: widget.isEnabled,
                  title: 'رقم الهاتف',
                  initialValue: phoneNumber,
                  hintText: 'أدخل رقم هاتفك',
                  errorText: 'خطأ',
                  maxLength: 10,
                  inputFormatter: FilteringTextInputFormatter.digitsOnly,
                  onChanged: (value) => phoneNumber = value,
                  isPhoneNumber: true,
                ),
                DropdownButtonFormField2(
                  isEnabled: widget.isEnabled,
                  title: 'المستوى التعليمي',
                  possibleValues: KeyTranslate.educationalLevel,
                  value: educationalLevel,
                  onSaved: (value) => educationalLevel = value,
                ),
                TextFormField2(
                  isEnabled: widget.isEnabled,
                  title: 'مدرسة / الجامعة',
                  initialValue: etablissement,
                  hintText: 'أدخل اسم المؤسسة',
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
                    hintText: 'أدخل رقم التعريفي للمركز',
                    errorText: 'خطأ',
                    maxLength: 20,
                    inputFormatter: FilteringTextInputFormatter.digitsOnly,
                    isPhoneNumber: true,
                    onChanged: (value) => centers[0] = value,
                  ),
                ],
                TextFormField2(
                  isEnabled: widget.isEnabled,
                  title: 'ملاحظة',
                  initialValue: note,
                  hintText: 'أدخل ملاحظة',
                  errorText: 'خطأ',
                  maxLength: 100,
                  inputFormatter: FilteringTextInputFormatter.deny(''),
                  isPhoneNumber: false,
                  onChanged: (value) => note = value,
                  validator: (value) => null,
                ),
                if (widget.includeCenterState) ...[
                  CenterStateForm(
                    isEnabled: widget.isEnabled,
                    centersList: widget.centersList,
                    statesList: KeyTranslate.gaAdminsState.keys.toList(),
                    centerState: centerState,
                    onSavedCenterStates: (newCenterState) {
                      centerState = newCenterState;
                      _save();
                    },
                    onSavedCentersIds: (newCentersIds) {
                      centers = newCentersIds;
                      _save();
                    },
                  ),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
