import 'package:alhalaqat/app/common_forms/center_form.dart';
import 'package:alhalaqat/app/models/halaqa.dart';
import 'package:alhalaqat/app/models/study_center.dart';
import 'package:alhalaqat/app/models/teacher.dart';
import 'package:alhalaqat/app/sign_in/validator.dart';
import 'package:alhalaqat/common_packages/multiselect_formfield/multiselect_formfield.dart';
import 'package:alhalaqat/common_widgets/country_picker.dart';
import 'package:alhalaqat/common_widgets/drop_down_form_field2.dart';
import 'package:alhalaqat/common_widgets/password_text_field.dart';
import 'package:alhalaqat/common_widgets/text_form_field2.dart';
import 'package:alhalaqat/common_widgets/year_picker2.dart';
import 'package:alhalaqat/constants/key_translate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tuple/tuple.dart';

class TeacherForm extends StatefulWidget {
  const TeacherForm({
    Key key,
    @required this.teacher,
    @required this.onSaved,
    @required this.includeCenterIdInput,
    @required this.includeUsernameAndPassword,
    @required this.isEnabled,
    @required this.teacherFormKey,
    @required this.center,
    @required this.includeCenterForm,
    this.halaqatList,
    @required this.showUserHalaqa,
    @required this.hidePassword,
  }) : super(key: key);
  final GlobalKey<FormState> teacherFormKey;
  final ValueChanged<Teacher> onSaved;
  final Teacher teacher;
  final bool isEnabled;
  final bool includeCenterIdInput;
  final bool includeUsernameAndPassword;
  final List<Halaqa> halaqatList;
  final bool showUserHalaqa;
  final StudyCenter center;
  final bool includeCenterForm;
  final bool hidePassword;

  @override
  _NewStudentFormState createState() => _NewStudentFormState();
}

class _NewStudentFormState extends State<TeacherForm>
    with UsernameAndPasswordValidators {
  Teacher get teacher => widget.teacher;
  String usernameInitValue;
  final GlobalKey<FormState> centerFormKey = GlobalKey<FormState>();

  //
  String centerFormTitle;
  String adminFormTitle;
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
  //
  bool isTeacher;
  List<String> halaqatTeachingIn;
  //
  List<String> availableHalaqatTeachingIn;
  List<String> unavailableHalaqatTeachingIn;

  @override
  void initState() {
    centerFormTitle =
        widget.isEnabled ? 'أدخل معلومات المركز' : 'معلومات المركز';
    adminFormTitle =
        widget.isEnabled ? 'أدخل معلوماتك الشخصية' : 'معلومات الطالب';
    id = teacher?.id;
    name = teacher?.name;
    dateOfBirth = teacher?.dateOfBirth ?? 1950;
    gender = teacher?.gender ?? 'ذكر';
    nationality = teacher?.nationality ?? 'LB';
    address = teacher?.address;
    phoneNumber = teacher?.phoneNumber;
    educationalLevel =
        KeyTranslate.educationalLevel.contains(teacher?.educationalLevel)
            ? teacher?.educationalLevel
            : 'جامعي';
    etablissement = teacher?.etablissement;
    note = teacher?.note;
    readableId = teacher?.readableId;
    username = teacher?.username;
    password = teacher?.password;
    centerState = teacher?.centerState ?? Map<String, String>();
    createdAt = teacher?.createdAt;
    createdBy = teacher?.createdBy ?? Map<String, String>();

    centers = teacher?.centers ?? List<String>(1);
    //
    isTeacher = teacher?.isTeacher;

    halaqatTeachingIn = teacher?.halaqatTeachingIn ?? List<String>();

    //
    usernameInitValue = username?.replaceAll('@al-halaqat.firebaseapp.com', '');
    //
    var temp1 = buildAvail(halaqatTeachingIn, widget.halaqatList);
    availableHalaqatTeachingIn = temp1.item1;
    unavailableHalaqatTeachingIn = temp1.item2;
    //
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
      centers: centers,
      isTeacher: true,
      halaqatTeachingIn: halaqatTeachingIn,
    );
    widget.onSaved(teacher);
  }

  bool isGmailOrFacebook() {
    if (widget.teacher != null) {
      if (widget.teacher.username != null) {
        if (widget.teacher.username.contains('gmail.com')) return true;
      } else {
        return true;
      }
    }
    return false;
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
                    inputFormatter: FilteringTextInputFormatter.deny(''),
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
                    hidePassword: widget.hidePassword,
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
                  title: 'الاسم',
                  initialValue: name,
                  hintText: 'أدخل اسمك',
                  errorText: 'خطأ',
                  maxLength: 30,
                  inputFormatter: FilteringTextInputFormatter.deny(''),
                  onChanged: (value) => name = value,
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
                  validator: (value) => null,
                  errorText: 'خطأ',
                  maxLength: 100,
                  inputFormatter: FilteringTextInputFormatter.deny(''),
                  isPhoneNumber: false,
                  onChanged: (value) => note = value,
                ),
                if (widget.showUserHalaqa) ...[
                  IgnorePointer(
                    ignoring: !widget.isEnabled,
                    child: MultiSelectFormField(
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: widget.isEnabled ? 2.5 : 1.2,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      initialValue: availableHalaqatTeachingIn,
                      fillColor: Colors.transparent,
                      autovalidate: false,
                      titleText: 'حلقات يعلم فيها',
                      validator: (value) => null,
                      dataSource: buildTeachingInMap(widget.halaqatList),
                      textField: 'display',
                      valueField: 'value',
                      okButtonLabel: 'حسنا',
                      cancelButtonLabel: 'إلغاء',
                      hintText: 'انقر هنا للاختيار الحلقات',
                      onSaved: (values) {
                        availableHalaqatTeachingIn = List<String>.from(values);
                        halaqatTeachingIn.clear();
                        halaqatTeachingIn.addAll(availableHalaqatTeachingIn);
                        halaqatTeachingIn.addAll(unavailableHalaqatTeachingIn);

                        _save();
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Tuple2<List<String>, List<String>> buildAvail(
      List<String> halaqatLearningIn, List<Halaqa> halaqatList) {
    List<String> availableHalaqatList = List();
    List<String> unavailableHalaqatList = List();

    for (String halaqaLearningInId in halaqatLearningIn) {
      bool found = false;
      if (halaqatList != null) {
        for (Halaqa halaqa in halaqatList) {
          if (halaqa.id == halaqaLearningInId) {
            found = true;
            availableHalaqatList.add(halaqaLearningInId);
          }
        }
      }
      if (!found) unavailableHalaqatList.add(halaqaLearningInId);
    }

    return Tuple2<List<String>, List<String>>(
        availableHalaqatList, unavailableHalaqatList);
  }

  List<Map<String, String>> buildTeachingInMap(List<Halaqa> halaqatList) {
    List<Map<String, String>> subjectDataSource = List();
    for (Halaqa halaqa in halaqatList) {
      subjectDataSource.add(
        {
          "display": halaqa.name,
          "value": halaqa.id,
        },
      );
    }
    return subjectDataSource;
  }
}
