import 'package:al_halaqat/app/home/approved/globalAdmin/ga_centers/ga_centers_bloc.dart';
import 'package:al_halaqat/app/home/approved/globalAdmin/ga_centers/ga_centers_provider.dart';
import 'package:al_halaqat/app/home/approved/globalAdmin/ga_centers/ga_centers_tile_widget.dart';
import 'package:al_halaqat/app/home/approved/globalAdmin/ga_centers/ga_new_center_screen.dart';
import 'package:al_halaqat/app/models/study_center.dart';
import 'package:al_halaqat/app/models/user.dart';
import 'package:al_halaqat/common_widgets/empty_content.dart';
import 'package:al_halaqat/constants/key_translate.dart';
import 'package:al_halaqat/services/database.dart';
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
  String chosenCenterState;
  @override
  void initState() {
    chosenCenterState = centersStateList[0];
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
                value: chosenCenterState,
                icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                iconSize: 24,
                underline: Container(),
                elevation: 0,
                style: TextStyle(color: Colors.white, fontSize: 20),
                onChanged: (String newValue) {
                  setState(() {
                    chosenCenterState = newValue;
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
            ),
            fullscreenDialog: true,
          ),
        ),
        tooltip: 'add',
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<List<StudyCenter>>(
        stream: bloc.getCentersStream(chosenCenterState),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<StudyCenter> centersList = snapshot.data;
            if (centersList.isNotEmpty) {
              return _buildList(centersList);
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

  Widget _buildList(List<StudyCenter> centersList) {
    return ListView.separated(
      itemCount: centersList.length + 2,
      separatorBuilder: (context, index) => Divider(height: 0.5),
      itemBuilder: (context, index) {
        if (index == 0 || index == centersList.length + 1) {
          return Container();
        }
        return GaCentersTileWidget(
          scaffoldKey: _scaffoldKey,
          bloc: bloc,
          center: centersList[index - 1],
        );
      },
    );
  }
}
