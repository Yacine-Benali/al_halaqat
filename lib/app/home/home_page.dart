import 'package:alhalaqat/app/conversation_helper/conversation_helper_bloc.dart';
import 'package:alhalaqat/app/home/base_sceen.dart';
import 'package:alhalaqat/app/logs_helper/logs_helper_bloc.dart';
import 'package:alhalaqat/app/logs_helper/logs_helper_provider.dart';
import 'package:alhalaqat/app/models/user.dart';
import 'package:alhalaqat/services/api_path.dart';
import 'package:alhalaqat/services/database.dart';
import 'package:alhalaqat/services/firestore_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage._({Key key, this.database, this.uid}) : super(key: key);
  final Database database;
  final String uid;

  static Widget create({@required String uid}) {
    return Provider<Database>(
      create: (_) => FirestoreDatabase(),
      child: Consumer<Database>(builder: (_, Database database, __) {
        return Provider<ConversationHelpeBloc>(
          create: (_) => ConversationHelpeBloc(database: database),
          child: Provider<LogsHelperBloc>(
            create: (_) => LogsHelperBloc(
                provider: LogsHelperProvider(database: database)),
            child: HomePage._(
              database: database,
              uid: uid,
            ),
          ),
        );
      }),
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
                    builder: (context) => BaseScreen(
                      navigatorKey: navigatorKey,
                    ),
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
