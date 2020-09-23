import 'package:alhalaqat/app/home/home_page.dart';
import 'package:alhalaqat/app/sign_in/sign_in_page.dart';
import 'package:alhalaqat/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);
    final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

    return StreamBuilder<AuthUser>(
        stream: auth.onAuthStateChanged,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            AuthUser user = snapshot.data;
            if (user == null) {
              return Navigator(
                key: navigatorKey,
                initialRoute: '/',
                onGenerateRoute: (routeSettings) {
                  return MaterialPageRoute(
                      builder: (context) => SignInPageBuilder());
                },
              );
            } else {
              return Provider<AuthUser>.value(
                value: user,
                child: HomePage.create(uid: user.uid),
              );
            }
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
