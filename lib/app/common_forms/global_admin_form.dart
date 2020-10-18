import 'package:alhalaqat/app/models/global_admin.dart';
import 'package:alhalaqat/app/sign_in/validator.dart';
import 'package:alhalaqat/common_widgets/country_picker.dart';
import 'package:alhalaqat/common_widgets/date_picker.dart';
import 'package:alhalaqat/common_widgets/drop_down_form_field2.dart';
import 'package:alhalaqat/common_widgets/password_text_field.dart';
import 'package:alhalaqat/common_widgets/text_form_field2.dart';
import 'package:alhalaqat/constants/key_translate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GlobalAdminForm extends StatefulWidget {
  const GlobalAdminForm({
    Key key,
    @required this.adminFormKey,
    @required this.globalAdmin,
    @required this.onSavedGlobalAdmin,
    @required this.isEnabled,
  }) : super(key: key);
  final GlobalKey<FormState> adminFormKey;
//
  final GlobalAdmin globalAdmin;
  final ValueChanged<GlobalAdmin> onSavedGlobalAdmin;
  //
  final bool isEnabled;
  @override
  _NewGlobalAdminFormState createState() => _NewGlobalAdminFormState();
}

class _NewGlobalAdminFormState extends State<GlobalAdminForm>
    with UsernameAndPasswordValidators, EmailAndPasswordValidators {
  final GlobalKey<FormState> centerFormKey = GlobalKey<FormState>();

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
  String password;
  Timestamp createdAt;
  Map<String, String> createdBy;
  String state;
  @override
  void initState() {
    //! set default birthday
    id = widget.globalAdmin?.id;
    name = widget.globalAdmin?.name;
    dateOfBirth = widget.globalAdmin?.dateOfBirth ?? 1950;
    gender = widget.globalAdmin?.gender ?? "ذكر";
    nationality = widget.globalAdmin?.nationality ?? 'LB';
    address = widget.globalAdmin?.address;
    phoneNumber = widget.globalAdmin?.phoneNumber;
    educationalLevel = educationalLevel = KeyTranslate.educationalLevel
            .contains(widget.globalAdmin?.educationalLevel)
        ? widget.globalAdmin?.educationalLevel
        : 'جامعي';
    etablissement = widget.globalAdmin?.etablissement;
    note = widget.globalAdmin?.note;
    readableId = widget.globalAdmin?.readableId;
    username = widget.globalAdmin?.username;
    password = widget.globalAdmin?.password;
    createdAt = widget.globalAdmin?.createdAt;
    createdBy = widget.globalAdmin?.createdBy ?? Map<String, String>();
    //
    state = widget.globalAdmin?.state;
    //
    usernameInitValue = username?.replaceAll('@al-halaqat.firebaseapp.com', '');
    // print(usernameInitValue);

    _save();
    super.initState();
  }

  void _save() {
    GlobalAdmin globalAdmin = GlobalAdmin(
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
      createdAt: createdAt,
      createdBy: createdBy,
      isGlobalAdmin: true,
      state: state,
    );
    // print(globalAdmin.gender);
    widget.onSavedGlobalAdmin(globalAdmin);
  }

  @override
  Widget build(BuildContext context) {
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
                TextFormField2(
                  isEnabled: widget.isEnabled,
                  title: 'اسم  المستخدم',
                  initialValue: usernameInitValue,
                  hintText: 'أدخل اسم  المستخدم',
                  errorText: 'خطأ',
                  maxLength: 30,
                  inputFormatter: usernameInputFormatter,
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
                  hidePassword: false,
                  onPasswordCreated: (value) {
                    password = value;
                    _save();
                  },
                  isEnabled: widget.isEnabled,
                  existingPassword: password,
                ),
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
                DatePicker(
                    isEnabled: widget.isEnabled,
                    title: 'سنة الميلاد ',
                    initialValue: dateOfBirth,
                    onSelectedDate: (value) {
                      dateOfBirth = value;
                      _save();
                    }),
                DropdownButtonFormField2(
                  isEnabled: widget.isEnabled,
                  title: 'الجنس',
                  possibleValues: ["ذكر", "أنثى"],
                  value: gender,
                  onSaved: (value) {
                    gender = value;
                    _save();
                  },
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
                  inputFormatter: WhitelistingTextInputFormatter.digitsOnly,
                  onChanged: (value) => phoneNumber = value,
                  isPhoneNumber: true,
                ),
                DropdownButtonFormField2(
                    isEnabled: widget.isEnabled,
                    title: 'المستوى التعليمي',
                    possibleValues: KeyTranslate.educationalLevel,
                    value: educationalLevel,
                    onSaved: (value) {
                      educationalLevel = value;
                      _save();
                    }),
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
                TextFormField2(
                  isEnabled: widget.isEnabled,
                  title: 'ملاحظة',
                  initialValue: note,
                  hintText: 'أدخل ملاحظة',
                  errorText: 'خطأ',
                  maxLength: 100,
                  validator: (value) => null,
                  inputFormatter: FilteringTextInputFormatter.deny(''),
                  isPhoneNumber: false,
                  onChanged: (value) => note = value,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
