import 'package:al_halaqat/app/home/approved/admin/admin_centers/admin_centers_screen.dart';
import 'package:al_halaqat/app/home/approved/admin/admin_halaqat/admin_halaqat_screen.dart';
import 'package:al_halaqat/app/home/approved/admin/admin_profile/admin_profile_screen.dart';
import 'package:al_halaqat/app/home/approved/admin/admin_requests/center_requests_screen.dart';
import 'package:al_halaqat/app/home/approved/admin/admin_students/admin_students_screen.dart';
import 'package:al_halaqat/app/home/approved/admin/admin_teachers/admin_teacher_screen.dart';
import 'package:al_halaqat/app/models/admin.dart';
import 'package:al_halaqat/app/models/study_center.dart';
import 'package:al_halaqat/app/models/user.dart';
import 'package:al_halaqat/common_widgets/empty_content.dart';
import 'package:al_halaqat/common_widgets/menu_button_widget.dart';
import 'package:al_halaqat/common_widgets/platform_alert_dialog.dart';
import 'package:al_halaqat/common_widgets/platform_exception_alert_dialog.dart';
import 'package:al_halaqat/services/api_path.dart';
import 'package:al_halaqat/services/auth.dart';
import 'package:al_halaqat/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({
    Key key,
    @required this.isGlobalAdmin,
    @required this.centerId,
  }) : super(key: key);

  final bool isGlobalAdmin;
  final String centerId;

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  Stream<List<StudyCenter>> studyCentersStream;
  Future<List<StudyCenter>> centersListFuture;
  @override
  initState() {
    Database database = Provider.of<Database>(context, listen: false);
    List<String> centerIds;
    if (!widget.isGlobalAdmin) {
      Admin admin = Provider.of<User>(context, listen: false);
      centerIds = admin.centers;
    } else {
      centerIds = [widget.centerId];
    }

    studyCentersStream = database.collectionStream(
      path: APIPath.centersCollection(),
      builder: (data, documentId) => StudyCenter.fromMap(data, documentId),
      queryBuilder: (query) =>
          query.where(FieldPath.documentId, whereIn: centerIds),
    );
    super.initState();
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      final Auth auth = Provider.of<Auth>(context, listen: false);
      await auth.signOut();
    } on PlatformException catch (e) {
      await PlatformExceptionAlertDialog(
        title: 'Strings.logoutFailed',
        exception: e,
      ).show(context);
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final bool didRequestSignOut = await PlatformAlertDialog(
      title: 'تسجيل الخروج',
      content: 'هل أنت متأكد ؟',
      cancelActionText: 'إلغاء',
      defaultActionText: 'حسنا',
    ).show(context);
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('')),
        leading: !widget.isGlobalAdmin
            ? Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: InkWell(
                  onTap: () => _confirmSignOut(context),
                  child: Icon(
                    Icons.exit_to_app,
                    size: 26.0,
                  ),
                ),
              )
            : SizedBox(),
        actions: [
          !widget.isGlobalAdmin
              ? Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: InkWell(
                    onTap: () =>
                        Navigator.of(context, rootNavigator: false).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            AdminProfileScreen.create(context: context),
                        fullscreenDialog: true,
                      ),
                    ),
                    child: Icon(
                      Icons.account_circle,
                      size: 26.0,
                    ),
                  ),
                )
              : SizedBox(),
        ],
      ),
      body: StreamBuilder<List<StudyCenter>>(
          stream: studyCentersStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final List<StudyCenter> items = snapshot.data;
              if (items.isNotEmpty) {
                return _buildContent(items);
              } else {
                return EmptyContent(
                  title: 'title',
                  message: 'message',
                );
              }
            } else if (snapshot.hasError) {
              return EmptyContent(
                title: 'Something went wrong',
                message: 'Can\'t load items right now',
              );
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }

  Widget _buildContent(List<StudyCenter> items) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 32.0),
              Container(
                  height: 100,
                  width: 100,
                  color: Colors.grey[300],
                  child: Center(
                      child: Text(
                    'logo',
                    style: TextStyle(fontSize: 40),
                  ))),
              SizedBox(height: 50.0),
              SizedBox(height: 10),
              MenuButtonWidget(
                text: 'إدارة الحلقات',
                onPressed: () =>
                    Navigator.of(context, rootNavigator: false).push(
                  MaterialPageRoute(
                    builder: (context) => AdminHalaqatScreen.create(
                      context: context,
                      centers: items,
                    ),
                    fullscreenDialog: true,
                  ),
                ),
              ),
              SizedBox(height: 10),
              MenuButtonWidget(
                text: 'إدارة المعلمين',
                onPressed: () =>
                    Navigator.of(context, rootNavigator: false).push(
                  MaterialPageRoute(
                    builder: (context) => AdminTeachersScreen.create(
                      context: context,
                      centers: items,
                    ),
                    fullscreenDialog: true,
                  ),
                ),
              ),
              SizedBox(height: 10),
              MenuButtonWidget(
                text: ' إدارة الطلاب',
                onPressed: () =>
                    Navigator.of(context, rootNavigator: false).push(
                  MaterialPageRoute(
                    builder: (context) => AdminsStudentsScreen.create(
                      context: context,
                      centers: items,
                    ),
                    fullscreenDialog: true,
                  ),
                ),
              ),
              SizedBox(height: 10),
              if (!widget.isGlobalAdmin) ...[
                MenuButtonWidget(
                  text: 'إدارة المراكز ',
                  onPressed: () =>
                      Navigator.of(context, rootNavigator: false).push(
                    MaterialPageRoute(
                      builder: (context) => AdminCentersScreen.create(
                        context: context,
                        centers: items,
                      ),
                      fullscreenDialog: true,
                    ),
                  ),
                ),
                SizedBox(height: 10),
              ],
              if (!widget.isGlobalAdmin) ...[
                MenuButtonWidget(
                  text: 'المحادثات',
                  onPressed: () {},
                ),
                SizedBox(height: 10),
              ],
              MenuButtonWidget(
                text: 'تقارير',
                onPressed: () {},
              ),
              SizedBox(height: 10),
              MenuButtonWidget(
                text: 'الطلبات',
                onPressed: () =>
                    Navigator.of(context, rootNavigator: false).push(
                  MaterialPageRoute(
                    builder: (context) => CenterRequestsScreen.create(
                      context: context,
                      centers: items,
                    ),
                    fullscreenDialog: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
