import 'dart:async';

import 'package:al_halaqat/app/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:al_halaqat/app/sign_in/sign_in_page.dart';
import 'package:al_halaqat/services/auth_service.dart';
import 'package:al_halaqat/services/database.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context, listen: false);
    return StreamBuilder<User>(
        stream: auth.onAuthStateChanged,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User user = snapshot.data;
            if (user == null) {
              return SignInPageBuilder();
            }
            return Provider<User>.value(
              value: user,
              child: Provider<Database>(
                create: (_) => FirestoreDatabase(uid: user.uid),
                child: HomePage(),
              ),
            );
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
