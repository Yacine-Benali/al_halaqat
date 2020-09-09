import 'package:al_halaqat/app/home/approved/globalAdmin/ga_admins/ga_admins_bloc.dart';
import 'package:al_halaqat/app/home/approved/globalAdmin/ga_admins/ga_admins_provider.dart';
import 'package:al_halaqat/app/home/approved/globalAdmin/ga_admins/ga_admins_tile_widget.dart';
import 'package:al_halaqat/app/home/approved/globalAdmin/ga_admins/ga_new_admin_screen.dart';
import 'package:al_halaqat/app/models/admin.dart';
import 'package:al_halaqat/app/models/user.dart';
import 'package:al_halaqat/common_widgets/empty_content.dart';
import 'package:al_halaqat/constants/key_translate.dart';
import 'package:al_halaqat/services/auth.dart';
import 'package:al_halaqat/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GaAdminsScreen extends StatefulWidget {
  const GaAdminsScreen._({
    Key key,
    @required this.bloc,
  }) : super(key: key);
  final GaAdminsBloc bloc;

  static Widget create({@required BuildContext context}) {
    Database database = Provider.of<Database>(context, listen: false);
    User user = Provider.of<User>(context, listen: false);
    Auth auth = Provider.of<Auth>(context, listen: false);

    GaAdminsProvider provider = GaAdminsProvider(database: database);
    GaAdminsBloc bloc = GaAdminsBloc(
      provider: provider,
      gaAdmin: user,
      auth: auth,
    );

    return GaAdminsScreen._(
      bloc: bloc,
    );
  }

  @override
  _GaAdminsScreenState createState() => _GaAdminsScreenState();
}

class _GaAdminsScreenState extends State<GaAdminsScreen> {
  GaAdminsBloc get bloc => widget.bloc;
  final ScrollController listScrollController = ScrollController();
  Stream<List<Admin>> adminsStream;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Admin> adminsList;
  bool isLoading;
  //
  List<String> adminsStateList = KeyTranslate.usersStateList.keys.toList();
  String chosenAdminsState;

  @override
  void initState() {
    chosenAdminsState = adminsStateList[0];
    adminsStream = bloc.adminsListStream;
    isLoading = false;
    bloc.fetchAdminsList();

    listScrollController.addListener(() {
      double maxScroll = listScrollController.position.maxScrollExtent;
      double currentScroll = listScrollController.position.pixels;
      if (maxScroll == currentScroll) {
        print('load more messages');

        if (adminsList.isNotEmpty) {
          setState(() {
            isLoading = true;
          });
          bloc.fetchMoreAdminsList().then((value) {
            setState(() {
              isLoading = false;
            });
          });
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Opacity(
          opacity: isLoading ? 1 : 0,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('إدارة المدراء'),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Center(
              child: DropdownButton<String>(
                dropdownColor: Colors.indigo,
                value: chosenAdminsState,
                icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                iconSize: 24,
                underline: Container(),
                elevation: 0,
                style: TextStyle(color: Colors.white, fontSize: 20),
                onChanged: (String newValue) {
                  setState(() {
                    chosenAdminsState = newValue;
                  });
                },
                items: adminsStateList
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(KeyTranslate.usersStateList[value]),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context, rootNavigator: false).push(
          MaterialPageRoute(
            builder: (context) => GaNewAdminScreen(
              bloc: bloc,
              admin: null,
              isEnabled: true,
            ),
            fullscreenDialog: true,
          ),
        ),
        tooltip: 'add',
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<List<Admin>>(
        stream: adminsStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            adminsList =
                bloc.getFilteredAdminsList(snapshot.data, chosenAdminsState);
            if (adminsList.isNotEmpty) {
              return _buildList();
            } else {
              return EmptyContent(
                title: 'لا يوجد أي مشرفون',
                message: 'لا يوجد أي مشرفون في هذه الحالة',
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
      controller: listScrollController,
      itemCount: adminsList.length + 1,
      separatorBuilder: (context, index) => Divider(height: 0.5),
      itemBuilder: (context, index) {
        if (index == adminsList.length) {
          return _buildProgressIndicator();
        }

        return GaAdminsTileWidget(
          admin: adminsList[index],
          chosenAdminsState: chosenAdminsState,
          bloc: bloc,
        );
      },
    );
  }
}
