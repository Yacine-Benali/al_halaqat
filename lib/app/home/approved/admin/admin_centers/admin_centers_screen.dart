import 'package:al_halaqat/app/home/approved/admin/admin_centers/admin_centers_bloc.dart';
import 'package:al_halaqat/app/home/approved/admin/admin_centers/admin_centers_provider.dart';
import 'package:al_halaqat/app/home/approved/admin/admin_centers/admin_centers_tile_widget.dart';
import 'package:al_halaqat/app/models/study_center.dart';
import 'package:al_halaqat/app/models/user.dart';
import 'package:al_halaqat/common_widgets/empty_content.dart';
import 'package:al_halaqat/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminCentersScreen extends StatefulWidget {
  const AdminCentersScreen._({Key key, @required this.bloc}) : super(key: key);

  final AdminCentersBloc bloc;

  static Widget create({
    @required BuildContext context,
    @required List<StudyCenter> centers,
  }) {
    Database database = Provider.of<Database>(context, listen: false);
    User user = Provider.of<User>(context, listen: false);

    AdminCentersProvider provider = AdminCentersProvider(database: database);
    AdminCentersBloc bloc = AdminCentersBloc(
      user: user,
      provider: provider,
      centers: centers,
    );

    return AdminCentersScreen._(
      bloc: bloc,
    );
  }

  @override
  _AdminCentersScreenState createState() => _AdminCentersScreenState();
}

class _AdminCentersScreenState extends State<AdminCentersScreen> {
  AdminCentersBloc get bloc => widget.bloc;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Stream<List<StudyCenter>> centersListStream;
  List<StudyCenter> centersList;

  @override
  void initState() {
    centersListStream = bloc.getCentersStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('المراكز'),
        centerTitle: true,
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => Navigator.of(context, rootNavigator: false).push(
      //     MaterialPageRoute(
      //       builder: (context) => GaNewCenterScreen(
      //         bloc: bloc,
      //         center: null,
      //         centersList: centersList,
      //       ),
      //       fullscreenDialog: true,
      //     ),
      //   ),
      //   tooltip: 'add',
      //   child: Icon(Icons.add),
      // ),
      body: StreamBuilder<List<StudyCenter>>(
        stream: centersListStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            centersList = snapshot.data;
            if (centersList.isNotEmpty) {
              return _buildList();
            } else {
              return EmptyContent(
                title: 'لا يوجد مراكز ',
                message: 'لا يوجد مراكز في هذه الحالة',
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
      ),
    );
  }

  Widget _buildList() {
    return ListView.separated(
      itemCount: centersList.length + 2,
      separatorBuilder: (context, index) => Divider(height: 0.5),
      itemBuilder: (context, index) {
        if (index == 0 || index == centersList.length + 1) {
          return Container();
        }
        return AdminCenterTileWidget(
          centersList: centersList,
          scaffoldKey: _scaffoldKey,
          bloc: bloc,
          center: centersList[index - 1],
        );
      },
    );
  }
}
