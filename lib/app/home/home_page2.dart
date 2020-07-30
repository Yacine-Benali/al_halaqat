import 'package:al_halaqat/services/firestore_database.dart';
import 'package:flutter/material.dart';
import 'package:al_halaqat/services/database.dart';
import 'package:provider/provider.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen._({Key key, this.database, this.uid}) : super(key: key);
  final Database database;
  final String uid;

  static Widget create({@required String uid}) {
    return Provider<Database>(
      create: (_) => FirestoreDatabase(),
      child: Consumer<Database>(
        builder: (_, Database database, __) => BaseScreen._(
          database: database,
          uid: uid,
        ),
      ),
    );
  }

  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  Database get database => widget.database;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    //print('init');
    // studentStream = database.userDocumentStream(
    //     uid: widget.uid,
    //     builder: (data) {
    //       return StudentModel.fromMap(data);
    //     },
    //     collection: 'students');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {}
}
