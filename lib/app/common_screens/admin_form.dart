import 'package:al_halaqat/app/common_screens/center_form.dart';
import 'package:al_halaqat/app/models/admin.dart';
import 'package:al_halaqat/app/models/admin.dart';
import 'package:al_halaqat/app/models/global_admin.dart';
import 'package:al_halaqat/app/models/user.dart';
import 'package:al_halaqat/common_widgets/date_picker.dart';
import 'package:al_halaqat/common_widgets/platform_exception_alert_dialog.dart';
import 'package:al_halaqat/common_widgets/text_form_field2.dart';
import 'package:al_halaqat/common_widgets/drop_down_form_field2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:al_halaqat/app/models/study_center.dart';
import 'package:al_halaqat/common_widgets/country_picker.dart';

class AdminForm extends StatefulWidget {
  const AdminForm({
    Key key,
    this.admin,
    @required this.onSavedAdmin,
    @required this.includeCenterForm,
    this.onSavedCenter,
    @required this.callback,
    this.center,
    this.isEnabled,
  }) : super(key: key);
  final ValueChanged<User> onSavedAdmin;
  final ValueChanged<StudyCenter> onSavedCenter;
  final VoidCallback callback;

  final bool includeCenterForm;
  final bool isEnabled;
  final Admin admin;
  final StudyCenter center;

  @override
  _NewAdminFormState createState() => _NewAdminFormState();
}

class _NewAdminFormState extends State<AdminForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  String appBarTitle;
  String centerFormTitle;
  String adminFormTitle;

  Admin get admin => widget.admin;
  // center
  StudyCenter center;
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
  List<String> halaqatLearningIn;
  //
  bool isStudent;
  bool isAdmin;

  @override
  void initState() {
    appBarTitle = widget.isEnabled ? 'إملأ الإستمارة' : 'معلومات الطلب';
    centerFormTitle =
        widget.isEnabled ? 'إدخل معلومات المركز' : 'معلومات المركز';
    adminFormTitle =
        widget.isEnabled ? 'إدخل معلوماتك الشخصية' : 'معلومات المشرف';
    //
    id = admin?.id;
    name = admin?.name;
    dateOfBirth = admin?.dateOfBirth ?? DateTime.now().year;
    gender = admin?.gender;
    nationality = admin?.nationality ?? 'LB';
    address = admin?.address;
    phoneNumber = admin?.phoneNumber;
    educationalLevel = admin?.educationalLevel;
    etablissement = admin?.etablissement;
    note = admin?.note;
    readableId = admin?.readableId;
    username = admin?.username;
    email = admin?.email;
    password = admin?.password;
    centerState = admin?.centerState ?? Map<String, String>();
    createdAt = admin?.createdAt;
    createdBy = admin?.createdBy ?? Map<String, String>();
    centers = admin?.centers ?? List<String>(1);
    halaqatLearningIn = admin?.halaqatLearningIn ?? List<String>(1);
    //
    isStudent = admin?.isStudent ?? false;
    isAdmin = admin?.isAdmin;
    super.initState();
  }

  void _save() {
    bool temp = _formKey2?.currentState?.validate();
    temp = temp ?? true;
    if (_formKey.currentState.validate() && temp) {
      _formKey.currentState.save();
      Admin admin = Admin(
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
        isAdmin: true,
      );
      if (widget.includeCenterForm) {
        widget.onSavedCenter(center);
        widget.onSavedAdmin(admin);

        widget.callback();
      } else {
        widget.onSavedAdmin(admin);
      }
    }
  }

  void _temp() {
    GlobalAdmin admin = GlobalAdmin(
      id: null,
      name: 'a',
      dateOfBirth: DateTime.now().year,
      gender: 'male',
      nationality: 'LB',
      address: 'global admin address',
      phoneNumber: 'phoneNumber',
      educationalLevel: 'educationalLevel',
      etablissement: 'etablissement',
      note: 'note',
      readableId: 'readableId',
      username: 'null',
      email: 'null',
      password: 'null',
      centerState: null,
      createdAt: null,
      createdBy: null,
      halaqatLearningIn: [null],
      centers: [null],
      isGlobalAdmin: true,
      isStudent: false,
    );

    widget.onSavedAdmin(admin);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(appBarTitle),
        actions: <Widget>[
          if (widget.isEnabled) ...[
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
            Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: InkWell(
                onTap: () => _temp(),
                child: Icon(
                  Icons.bug_report,
                  size: 26.0,
                ),
              ),
            ),
          ]
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
                if (widget.includeCenterForm) ...[
                  Text(
                    centerFormTitle,
                    style: TextStyle(fontSize: 20),
                  ),
                  CenterForm(
                    isEnabled: widget.isEnabled,
                    formKey: _formKey2,
                    center: widget.center,
                    onSaved: (newcenter) => center = newcenter,
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
                  onSaved: (value) => name = value,
                  onChanged: (value) {},
                  isPhoneNumber: false,
                ),
                DatePicker(
                    isEnabled: widget.isEnabled,
                    title: 'تاريخ الميلاد',
                    onSelectedDate: (value) {
                      dateOfBirth = value;
                      setState(() {});
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
                  onSavedCountry: (value) => nationality = value,
                ),
                TextFormField2(
                  isEnabled: widget.isEnabled,
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
                  isEnabled: widget.isEnabled,
                  title: 'رقم الهاتف',
                  initialValue: phoneNumber,
                  hintText: 'إدخل رقم هاتفك',
                  errorText: 'خطأ',
                  maxLength: 10,
                  inputFormatter: WhitelistingTextInputFormatter.digitsOnly,
                  onSaved: (value) => phoneNumber = value,
                  onChanged: (value) {},
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
                  inputFormatter: BlacklistingTextInputFormatter(''),
                  onSaved: (value) => etablissement = value,
                  onChanged: (value) {},
                ),
                if (!widget.includeCenterForm) ...[
                  TextFormField2(
                    isEnabled: widget.isEnabled,
                    title: 'رقم التعريفي للمركز',
                    //initialValue: centers[0],
                    hintText: 'إدخل رقم التعريفي للمركز',
                    errorText: 'خطأ',
                    maxLength: 20,
                    inputFormatter: WhitelistingTextInputFormatter.digitsOnly,
                    onSaved: (value) => centers[0] = value,
                    isPhoneNumber: true,
                    onChanged: (value) {},
                  ),
                ],
                TextFormField2(
                  isEnabled: widget.isEnabled,
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
