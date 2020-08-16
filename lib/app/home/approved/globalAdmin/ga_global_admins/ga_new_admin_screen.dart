// import 'package:al_halaqat/app/common_forms/admin_form.dart';
// import 'package:al_halaqat/app/home/approved/globalAdmin/ga_admins/ga_admins_bloc.dart';
// import 'package:al_halaqat/app/models/admin.dart';
// import 'package:al_halaqat/common_widgets/platform_alert_dialog.dart';
// import 'package:al_halaqat/common_widgets/platform_exception_alert_dialog.dart';
// import 'package:al_halaqat/common_widgets/progress_dialog.dart';
// import 'package:al_halaqat/constants/key_translate.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class GaNewAdminScreen extends StatefulWidget {
//   const GaNewAdminScreen({
//     Key key,
//     @required this.admin,
//     @required this.bloc,
//   }) : super(key: key);

//   final Admin admin;
//   final GaAdminsBloc bloc;

//   @override
//   _GaNewAdminScreenState createState() => _GaNewAdminScreenState();
// }

// class _GaNewAdminScreenState extends State<GaNewAdminScreen> {
//   final GlobalKey<FormState> adminFormKey = GlobalKey<FormState>();
//   ProgressDialog pr;
//   bool includeUsernameAndPassword;
//   bool includeEmailAndPassword;
//   List<String> authTypeList;
//   String chosenAdminAuthType;
//   Admin admin;
//   @override
//   void initState() {
//     authTypeList = KeyTranslate.createUserAuthType.keys.toList();
//     chosenAdminAuthType = authTypeList[0];
//     includeUsernameAndPassword = true;
//     includeEmailAndPassword = false;

//     pr = ProgressDialog(
//       context,
//       type: ProgressDialogType.Normal,
//       textDirection: TextDirection.ltr,
//       isDismissible: false,
//     );
//     pr.style(
//       message: 'جاري تحميل',
//       messageTextStyle: TextStyle(fontSize: 14),
//       progressWidget: Container(
//         padding: EdgeInsets.all(8.0),
//         child: CircularProgressIndicator(),
//       ),
//     );
//     super.initState();
//   }

//   void save() async {
//     if (adminFormKey.currentState.validate()) {
//       try {
//         //   print(admin.centers);
//         await pr.show();
//         await widget.bloc.setAdmin(admin);
//         await pr.hide();

//         PlatformAlertDialog(
//           title: 'نجح الحفظ',
//           content: 'تم حفظ البيانات',
//           defaultActionText: 'حسنا',
//         ).show(context);
//         Navigator.of(context).pop();
//       } on PlatformException catch (e) {
//         await pr.hide();
//         PlatformExceptionAlertDialog(
//           title: 'فشلت العملية',
//           exception: e,
//         ).show(context);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text('إملأ الإستمارة'),
//         actions: <Widget>[
//           Padding(
//             padding: EdgeInsets.only(left: 20.0),
//             child: InkWell(
//               onTap: () => save(),
//               child: Icon(
//                 Icons.save,
//                 size: 26.0,
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: AdminForm(
//         includeCenterIdInput: false,
//         includeCenterForm: false,
//         includeUsernameAndPassword: includeUsernameAndPassword,
//         adminFormKey: adminFormKey,
//         onSavedAdmin: (Admin newAdmin) => admin = newAdmin,
//         admin: widget.admin,
//         center: null,
//         isEnabled: true,
//         onSavedCenter: (value) {},
//         centersList: widget.bloc.centersList,
//       ),
//     );
//   }
// }
