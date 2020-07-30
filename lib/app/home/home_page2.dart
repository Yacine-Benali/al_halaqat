import 'package:al_halaqat/app/home/models/user.dart';
import 'package:al_halaqat/app/home/notApproved/join_us_screen.dart';
import 'package:al_halaqat/app/home/notApproved/new_user_screen.dart';
import 'package:al_halaqat/common_widgets/empty_content.dart';
import 'package:al_halaqat/services/api_path.dart';
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
  Stream<User> userStream;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    userStream = database.documentStream(
      path: APIPath.user(widget.uid),
      builder: (data, documentId) => User.fromMap(data, documentId),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: userStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final User user = snapshot.data;
          if (user == null) {
            print('show signup');
            return Container();
          } else {
            print('wtf');
            return Container();
          }
        } else if (snapshot.hasError) {
          return Scaffold(
            body: EmptyContent(
              title: 'Something went wrong',
              message: 'Can\'t load items right now',
            ),
          );
        }
        if (snapshot.data == null) {
          return JoinUsScreen();
        }
//        return Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
