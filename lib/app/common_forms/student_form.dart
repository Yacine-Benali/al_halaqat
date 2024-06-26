import 'package:alhalaqat/app/common_forms/center_form.dart';
import 'package:alhalaqat/app/models/halaqa.dart';
import 'package:alhalaqat/app/models/student.dart';
import 'package:alhalaqat/app/models/study_center.dart';
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
    this.isRemovable = true,
    this.halaqatList,
    @required this.showUserHalaqa,
    @required this.hidePassword,
  }) : super(key: key);
  final GlobalKey<FormState> studentFormKey;
  final StudyCenter center;

  final ValueChanged<Student> onSaved;
  final Student student;
  final bool isEnabled;
  final bool includeCenterIdInput;
  final bool includeCenterForm;
  final bool isRemovable;

  final bool includeUsernameAndPassword;
  final List<Halaqa> halaqatList;
  final bool showUserHalaqa;
  final bool hidePassword;

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
  List<String> halaqatOrganizingIn;
  //
  bool isStudent;
  String parentPhoneNumber;
  //
  List<String> availableHalaqatLearningIn;
  List<String> unavailableHalaqatLearningIn;

  List<String> availableHalaqatOrganizingIn;
  List<String> unavailableHalaqatOrganizingIn;
  @override
  void initState() {
    centerFormTitle =
        widget.isEnabled ? 'أدخل معلومات المركز' : 'معلومات المركز';
    adminFormTitle =
        widget.isEnabled ? 'أدخل معلوماتك الشخصية' : 'معلومات الطالب';
    id = student?.id;
    name = student?.name;
    dateOfBirth = student?.dateOfBirth ?? 1950;
    gender = student?.gender ?? 'ذكر';
    nationality = student?.nationality ?? 'LB';
    address = student?.address ?? ' ';
    phoneNumber = student?.phoneNumber ?? ' ';
    educationalLevel =
        KeyTranslate.educationalLevel.contains(student?.educationalLevel)
            ? student?.educationalLevel
            : 'جامعي';
    etablissement = student?.etablissement ?? ' ';
    note = student?.note ?? ' ';
    readableId = student?.readableId;
    username = student?.username;
    password = student?.password;
    // print('got here');
    createdAt = student?.createdAt;
    state = student?.state;
    createdBy = student?.createdBy ?? Map<String, String>();
    center = student?.center;
    halaqatLearningIn = student?.halaqatLearningIn ?? List<String>();
    halaqatOrganizingIn = student?.halaqatOrganizingIn ?? List<String>();
    isStudent = student?.isStudent;
    parentPhoneNumber = student?.parentPhoneNumber ?? ' ';
    //
    usernameInitValue = username?.replaceAll('@al-halaqat.firebaseapp.com', '');

    var temp1 = buildAvail(halaqatLearningIn, widget.halaqatList);

    availableHalaqatLearningIn = temp1.item1;

    unavailableHalaqatLearningIn = temp1.item2;

    var temp2 = buildAvail(halaqatOrganizingIn, widget.halaqatList);

    availableHalaqatOrganizingIn = temp2.item1;

    unavailableHalaqatOrganizingIn = temp2.item2;

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
      halaqatOrganizingIn: halaqatOrganizingIn,
    );
    widget.onSaved(newStudent);
  }

  bool isGmailOrFacebook() {
    if (widget.student != null) {
      if (widget.student.username != null) {
        if (widget.student.username.contains('gmail.com')) return true;
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
        key: widget.studentFormKey,
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
                    isEnabled: widget.isEnabled,
                    existingPassword: password,
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
                  validator: (value) => null,
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
                  validator: (value) => null,
                ),
                TextFormField2(
                  isEnabled: widget.isEnabled,
                  title: 'رقم هاتف ولي الأمر',
                  initialValue: parentPhoneNumber,
                  hintText: 'أدخل رقم هاتف ولي الأمر',
                  errorText: 'خطأ',
                  maxLength: 10,
                  inputFormatter: FilteringTextInputFormatter.digitsOnly,
                  onChanged: (value) => parentPhoneNumber = value,
                  isPhoneNumber: true,
                  validator: (value) => null,
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
                  validator: (value) => null,
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
                    onChanged: (value) => center = value,
                  ),
                ],
                TextFormField2(
                  isEnabled: widget.isEnabled,
                  title: 'ملاحظة',
                  initialValue: note,
                  hintText: 'أدخل ملاحظة',
                  errorText: 'خطأ',
                  validator: (value) => null,
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
                      initialValue: availableHalaqatLearningIn,
                      fillColor: Colors.transparent,
                      autovalidate: false,
                      titleText: 'حلقات ',
                      validator: (value) => null,
                      dataSource: buildHalaqatLearningInMap(widget.halaqatList),
                      textField: 'display',
                      valueField: 'value',
                      okButtonLabel: 'حسنا',
                      cancelButtonLabel: 'إلغاء',
                      hintText: 'انقر هنا للاختيار الحلقات',
                      onSaved: (values) {
                        availableHalaqatLearningIn = List<String>.from(values);
                        halaqatLearningIn.clear();
                        halaqatLearningIn.addAll(availableHalaqatLearningIn);
                        halaqatLearningIn.addAll(unavailableHalaqatLearningIn);

                        _save();
                        setState(() {});
                      },
                    ),
                  ),
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
                      initialValue: availableHalaqatOrganizingIn,
                      fillColor: Colors.transparent,
                      autovalidate: false,
                      titleText: 'مساعد في هذه الحلقات',
                      validator: (values) {
                        List<String> tt = List<String>.from(values);

                        for (String value in tt) {
                          if (!halaqatLearningIn.contains(value)) {
                            return 'لا يمكن للطالب أن يكون مساعداً في حلقة لا ينتمي إليها. يرجى إضافته للحلقة أولاً';
                          }
                        }
                        return null;
                      },
                      dataSource: buildHalaqatLearningInMap(widget.halaqatList),
                      textField: 'display',
                      valueField: 'value',
                      okButtonLabel: 'حسنا',
                      cancelButtonLabel: 'إلغاء',
                      hintText: 'انقر هنا للاختيار الحلقات',
                      onSaved: (values) {
                        availableHalaqatOrganizingIn =
                            List<String>.from(values);
                        halaqatOrganizingIn.clear();
                        halaqatOrganizingIn
                            .addAll(availableHalaqatOrganizingIn);
                        halaqatOrganizingIn
                            .addAll(unavailableHalaqatOrganizingIn);

                        _save();
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

  List<Map<String, String>> buildHalaqatLearningInMap(
      List<Halaqa> halaqatList) {
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
