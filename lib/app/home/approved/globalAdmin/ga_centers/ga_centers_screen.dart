import 'package:alhalaqat/app/home/approved/globalAdmin/ga_centers/ga_centers_bloc.dart';
import 'package:alhalaqat/app/home/approved/globalAdmin/ga_centers/ga_centers_provider.dart';
import 'package:alhalaqat/app/home/approved/globalAdmin/ga_centers/ga_centers_tile_widget.dart';
import 'package:alhalaqat/app/home/approved/globalAdmin/ga_centers/ga_new_center_screen.dart';
import 'package:alhalaqat/app/models/study_center.dart';
import 'package:alhalaqat/app/models/user.dart';
import 'package:alhalaqat/common_widgets/empty_content.dart';
import 'package:alhalaqat/constants/key_translate.dart';
import 'package:alhalaqat/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GaCentersScreen extends StatefulWidget {
  const GaCentersScreen._({Key key, @required this.bloc}) : super(key: key);

  final GaCentersBloc bloc;

  static Widget create({@required BuildContext context}) {
    Database database = Provider.of<Database>(context, listen: false);
    User user = Provider.of<User>(context, listen: false);

    GaCentersProvider provider = GaCentersProvider(database: database);
    GaCentersBloc bloc = GaCentersBloc(user: user, provider: provider);

    return GaCentersScreen._(
      bloc: bloc,
    );
  }

  @override
  _GaCentersScreenState createState() => _GaCentersScreenState();
}

class _GaCentersScreenState extends State<GaCentersScreen> {
  GaCentersBloc get bloc => widget.bloc;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> centersStateList = KeyTranslate.centersStateList.keys.toList();
  String chosenCentersState;
  Stream<List<StudyCenter>> centersListStream;
  List<StudyCenter> centersList;
  @override
  void initState() {
    chosenCentersState = centersStateList[0];
    centersListStream = bloc.getCentersStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Center(child: Text('المراكز')),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Center(
              child: DropdownButton<String>(
                dropdownColor: Colors.indigo,
                value: chosenCentersState,
                icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                iconSize: 24,
                underline: Container(),
                elevation: 0,
                style: TextStyle(color: Colors.white, fontSize: 20),
                onChanged: (String newValue) {
                  setState(() {
                    chosenCentersState = newValue;
                  });
                },
                items: centersStateList
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(KeyTranslate.centersStateList[value]),
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
            builder: (context) => GaNewCenterScreen(
              bloc: bloc,
              center: null,
              centersList: centersList,
              isEnabled: true,
            ),
            fullscreenDialog: true,
          ),
        ),
        tooltip: 'add',
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<List<StudyCenter>>(
        stream: centersListStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            centersList =
                bloc.getFilteredCentersList(snapshot.data, chosenCentersState);
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
        return GaCentersTileWidget(
          centersList: centersList,
          scaffoldKey: _scaffoldKey,
          bloc: bloc,
          center: centersList[index - 1],
        );
      },
    );
  }
}
