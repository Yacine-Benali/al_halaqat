import 'package:alhalaqat/app/home/approved/globalAdmin/ga_global_admins/ga_global_admins_bloc.dart';
import 'package:alhalaqat/app/home/approved/globalAdmin/ga_global_admins/ga_new_global_admin.dart';
import 'package:alhalaqat/app/models/global_admin.dart';
import 'package:alhalaqat/app/models/user.dart';
import 'package:alhalaqat/common_widgets/empty_content.dart';
import 'package:alhalaqat/constants/key_translate.dart';
import 'package:alhalaqat/services/auth.dart';
import 'package:alhalaqat/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ga_global_admins_provider.dart';
import 'ga_global_admins_tile_widget.dart';

class GaGlobalAdminsScreen extends StatefulWidget {
  const GaGlobalAdminsScreen._({
    Key key,
    @required this.bloc,
  }) : super(key: key);
  final GaGlobalAdminsBloc bloc;

  static Widget create({@required BuildContext context}) {
    Database database = Provider.of<Database>(context, listen: false);
    User user = Provider.of<User>(context, listen: false);
    Auth auth = Provider.of<Auth>(context, listen: false);

    GaGlobalAdminsProvider provider =
        GaGlobalAdminsProvider(database: database);
    GaGlobalAdminsBloc bloc = GaGlobalAdminsBloc(
      provider: provider,
      gaAdmin: user,
      auth: auth,
    );

    return GaGlobalAdminsScreen._(
      bloc: bloc,
    );
  }

  @override
  _GaGlobalAdminsScreenState createState() => _GaGlobalAdminsScreenState();
}

class _GaGlobalAdminsScreenState extends State<GaGlobalAdminsScreen> {
  GaGlobalAdminsBloc get bloc => widget.bloc;
  final ScrollController listScrollController = ScrollController();
  Stream<List<GlobalAdmin>> globalAdminsStream;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<GlobalAdmin> globalAdminsList;
  bool isLoading;
  //
  List<String> adminsStateList = KeyTranslate.gaGaState.keys.toList();
  String chosenAdminsState;

  @override
  void initState() {
    chosenAdminsState = adminsStateList[0];
    globalAdminsStream = bloc.globalAdminsListStream;
    isLoading = false;
    bloc.fetchGlobalAdminsList();

    listScrollController.addListener(() {
      double maxScroll = listScrollController.position.maxScrollExtent;
      double currentScroll = listScrollController.position.pixels;
      if (maxScroll == currentScroll) {
        print('load more messages');

        if (globalAdminsList.isNotEmpty) {
          setState(() {
            isLoading = true;
          });
          bloc.fetchMoreGlobalAdminsList().then((value) {
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
                    child: Text(KeyTranslate.gaGaState[value]),
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
            builder: (context) => GaNewGlobalAdminScreen(
              globalAdmin: null,
              bloc: bloc,
            ),
            fullscreenDialog: true,
          ),
        ),
        tooltip: 'add',
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<List<GlobalAdmin>>(
        stream: globalAdminsStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            globalAdminsList = bloc.getFilteredGlobalAdminsList(
                snapshot.data, chosenAdminsState);
            print(globalAdminsList.length);

            if (globalAdminsList.isNotEmpty) {
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
      ),
    );
  }

  Widget _buildList() {
    return ListView.separated(
      controller: listScrollController,
      itemCount: globalAdminsList.length + 1,
      separatorBuilder: (context, index) => Divider(height: 0.5),
      itemBuilder: (context, index) {
        if (index == globalAdminsList.length) {
          return _buildProgressIndicator();
        }

        return GaGlobalAdminsTileWidget(
          globalAdmin: globalAdminsList[index],
          chosenAdminsState: chosenAdminsState,
          bloc: bloc,
          scaffoldKey: _scaffoldKey,
        );
      },
    );
  }
}
