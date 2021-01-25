import 'package:alhalaqat/app/home/approved/globalAdmin/ga_admins/ga_admins_bloc.dart';
import 'package:alhalaqat/app/home/approved/globalAdmin/ga_admins/ga_admins_provider.dart';
import 'package:alhalaqat/app/models/admin.dart';
import 'package:alhalaqat/app/models/study_center.dart';
import 'package:alhalaqat/app/models/user.dart';
import 'package:alhalaqat/common_widgets/empty_content.dart';
import 'package:alhalaqat/services/auth.dart';
import 'package:alhalaqat/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ga_center_admins_bloc.dart';
import 'ga_center_admins_provider.dart';
import 'ga_centers_admins_tile_widget.dart';

class GaCenterAdminsScreen extends StatefulWidget {
  const GaCenterAdminsScreen._({
    Key key,
    @required this.bloc,
  }) : super(key: key);
  final GaCenterAdminsBloc bloc;

  static Widget create({
    @required BuildContext context,
    @required StudyCenter studyCenter,
  }) {
    Database database = Provider.of<Database>(context, listen: false);

    GaCenterAdminsProvider provider =
        GaCenterAdminsProvider(database: database);
    GaCenterAdminsBloc bloc =
        GaCenterAdminsBloc(provider: provider, studyCenter: studyCenter);

    return GaCenterAdminsScreen._(bloc: bloc);
  }

  @override
  _GaAdminsScreenState createState() => _GaAdminsScreenState();
}

class _GaAdminsScreenState extends State<GaCenterAdminsScreen> {
  GaCenterAdminsBloc get bloc => widget.bloc;
  Stream<List<Admin>> adminsStream;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Admin> adminsList;
  GaAdminsBloc bloc2;
  @override
  void initState() {
    adminsStream = bloc.fetchCenterAdmins();
    Database database = Provider.of<Database>(context, listen: false);
    GaAdminsProvider provider2 = GaAdminsProvider(database: database);
    User user = Provider.of<User>(context, listen: false);
    Auth auth = Provider.of<Auth>(context, listen: false);

    bloc2 = GaAdminsBloc(
      provider: provider2,
      gaAdmin: user,
      auth: auth,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('إدارة المدراء'),
        centerTitle: true,
      ),
      body: StreamBuilder<List<Admin>>(
        stream: adminsStream,
        builder: (context, snapshot) {
          return FutureBuilder(
            future: bloc2.fetchCenters(),
            builder: (context, snapshot2) {
              if (snapshot.hasData) {
                adminsList = snapshot.data;

                if (adminsList.isNotEmpty) {
                  return _buildList();
                } else {
                  return EmptyContent(
                    title: 'لا يوجد أي مشرفين',
                    message: 'لا يوجد أي مشرفين في هذه الحالة',
                  );
                }
              } else if (snapshot.hasError) {
                return EmptyContent(
                  title: 'Something went wrong',
                  message: 'Can\'t load items right now',
                );
              }
              return Center(child: CircularProgressIndicator());
            },
          );
        },
      ),
    );
  }

  Widget _buildList() {
    return ListView.separated(
      itemCount: adminsList.length + 1,
      separatorBuilder: (context, index) => Divider(height: 0.5),
      itemBuilder: (context, index) {
        if (index == adminsList.length) {
          return SizedBox(
            height: 75,
          );
        }

        return GaCentersAdminsTileWidget(
          admin: adminsList[index],
          bloc: bloc2,
        );
      },
    );
  }
}
