import 'package:al_halaqat/app/home/base_sceen.dart';
import 'package:al_halaqat/app/models/user.dart';
import 'package:al_halaqat/app/home/notApproved/join_us_screen.dart';
import 'package:al_halaqat/app/common_screens/user_info_screen.dart';
import 'package:al_halaqat/common_widgets/empty_content.dart';
import 'package:al_halaqat/services/api_path.dart';
import 'package:al_halaqat/services/firestore_database.dart';
import 'package:flutter/material.dart';
import 'package:al_halaqat/services/database.dart';
import 'package:provider/provider.dart';
import 'notApproved/pending_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage._({Key key, this.database, this.uid}) : super(key: key);
  final Database database;
  final String uid;

  static Widget create({@required String uid}) {
    return Provider<Database>(
      create: (_) => FirestoreDatabase(),
      child: Consumer<Database>(
        builder: (_, Database database, __) => HomePage._(
          database: database,
          uid: uid,
        ),
      ),
    );
  }

  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<HomePage> {
  Database get database => widget.database;
  Stream<User> userStream;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    userStream = database.documentStream(
      path: APIPath.userDocument(widget.uid),
      builder: (data, documentId) => User.fromMap(data, documentId),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: userStream,
      builder: (context, snapshot) {
        userStream.isEmpty.then((value) => print(value));
        print(snapshot);
        return Provider<AsyncSnapshot<User>>.value(
          value: snapshot,
          child: Provider<User>.value(
            value: snapshot.data,
            child: WillPopScope(
              onWillPop: () async =>
                  !await navigatorKey.currentState.maybePop(),
              child: Navigator(
                key: navigatorKey,
                initialRoute: '/',
                onGenerateRoute: (routeSettings) {
                  return MaterialPageRoute(
                    builder: (context) => BaseScreen(),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
