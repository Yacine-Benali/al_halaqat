import 'package:alhalaqat/app/models/study_center.dart';
import 'package:alhalaqat/common_widgets/country_picker.dart';
import 'package:alhalaqat/common_widgets/text_form_field2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CenterForm extends StatefulWidget {
  const CenterForm({
    Key key,
    this.center,
    @required this.onSaved,
    @required this.formKey,
    @required this.isEnabled,
    @required this.showCenterOptions,
    @required this.showReadableId,
  }) : super(key: key);
  final ValueChanged<StudyCenter> onSaved;
  final StudyCenter center;
  final GlobalKey<FormState> formKey;
  final bool isEnabled;
  final bool showCenterOptions;
  final bool showReadableId;

  @override
  _CenterFormState createState() => _CenterFormState();
}

class _CenterFormState extends State<CenterForm> {
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
  Timestamp createdAt;

  @override
  void initState() {
    id = center?.id;
    readableId = center?.readableId;
    name = center?.name;
    country = center?.country ?? 'LB';
    city = center?.city;
    street = center?.street;
    phoneNumber = center?.phoneNumber;
    isMessagingEnabled = center?.isMessagingEnabled ?? true;
    studentRoaming = center?.studentRoaming ?? false;
    requestPermissionForHalaqaCreation =
        center?.requestPermissionForHalaqaCreation ?? false;
    canTeachersEditStudents = center?.canTeachersEditStudents ?? true;
    canTeacherRemoveStudentsFromHalaqa =
        center?.canTeacherRemoveStudentsFromHalaqa ?? false;
    state = center?.state;
    nextHalaqaReadableId = center?.nextHalaqaReadableId ?? 1000;
    createdBy = center?.createdBy;
    createdAt = center?.createdAt;
    save();
    super.initState();
  }

  void save() {
    StudyCenter center = StudyCenter(
      id: id,
      readableId: readableId,
      name: name,
      country: country ?? 'LB',
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

  @override
  Widget build(BuildContext context) {
    return Form(
      onChanged: () {
        save();
      },
      key: widget.formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TextFormField2(
              isEnabled: widget.isEnabled,
              title: 'إسم المركز',
              initialValue: name,
              hintText: 'إدخل إسم المركز',
              errorText: 'خطأ',
              maxLength: 30,
              inputFormatter: FilteringTextInputFormatter.deny(''),
              onChanged: (value) => name = value,
            ),
            if (widget.showReadableId) ...[
              TextFormField2(
                isEnabled: false,
                title: 'رقم التعريفي',
                initialValue: readableId,
                hintText: 'إدخل إسم المركز',
                errorText: 'خطأ',
                maxLength: 30,
                inputFormatter: FilteringTextInputFormatter.deny(''),
                onChanged: (value) => name = value,
              ),
            ],
            CountryPicker(
              isEnabled: widget.isEnabled,
              title: 'دولة',
              initialValue: country,
              onSavedCountry: (value) {
                country = value;
                save();
              },
            ),
            TextFormField2(
              isEnabled: widget.isEnabled,
              title: 'مدينة',
              initialValue: city,
              hintText: ' إدخل مدينة المركز',
              errorText: 'خطأ',
              maxLength: 30,
              inputFormatter: FilteringTextInputFormatter.deny(''),
              onChanged: (value) => city = value,
            ),
            TextFormField2(
              isEnabled: widget.isEnabled,
              title: 'العنوان',
              initialValue: street,
              hintText: 'إدخل عنوان المركز',
              errorText: 'خطأ',
              maxLength: 30,
              inputFormatter: FilteringTextInputFormatter.deny(''),
              onChanged: (value) => street = value,
            ),
            TextFormField2(
              isEnabled: widget.isEnabled,
              title: 'رقم هاتف مركز',
              initialValue: phoneNumber,
              hintText: 'إدخل رقم هاتف مركز',
              errorText: 'خطأ',
              maxLength: 10,
              inputFormatter: WhitelistingTextInputFormatter.digitsOnly,
              onChanged: (value) => phoneNumber = value,
              isPhoneNumber: true,
            ),
            if (widget.showCenterOptions) ...[
              ListTile(
                title: Text('تمكين الرسائل'),
                trailing: Switch(
                  value: isMessagingEnabled,
                  onChanged: (value) {
                    isMessagingEnabled = value;
                    save();
                    setState(() {});
                  },
                ),
              ),
              ListTile(
                title: Text('يمكن للمعلمين إضافة تعديل الطلاب'),
                trailing: Switch(
                  value: canTeachersEditStudents,
                  onChanged: (value) {
                    canTeachersEditStudents = value;
                    save();
                    setState(() {});
                  },
                ),
              ),
              ListTile(
                title: Text('طلب الموافقة على إنشاء حلقة'),
                trailing: Switch(
                  value: requestPermissionForHalaqaCreation,
                  onChanged: (value) {
                    requestPermissionForHalaqaCreation = value;
                    save();
                    setState(() {});
                  },
                ),
              ),
              ListTile(
                title: Text('يمكن للمعلم إزالة طالب من الحلقة'),
                trailing: Switch(
                  value: canTeacherRemoveStudentsFromHalaqa,
                  onChanged: (value) {
                    canTeacherRemoveStudentsFromHalaqa = value;
                    save();
                    setState(() {});
                  },
                ),
              ),
              ListTile(
                title: Text('إظهار حفظ الطالب للقرآن عبر الحلقات '),
                trailing: Switch(
                  value: studentRoaming,
                  onChanged: (value) {
                    studentRoaming = value;
                    save();
                    setState(() {});
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
