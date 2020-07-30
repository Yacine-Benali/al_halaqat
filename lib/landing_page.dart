import 'dart:async';

import 'package:al_halaqat/app/home/home_page2.dart';
import 'package:al_halaqat/services/firestore_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:al_halaqat/app/sign_in/sign_in_page.dart';
import 'package:al_halaqat/services/auth.dart';
import 'package:al_halaqat/services/database.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);
    return StreamBuilder<AuthUser>(
        stream: auth.onAuthStateChanged,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            AuthUser user = snapshot.data;
            if (user == null) {
              return SignInPageBuilder();
            }
            return Provider<AuthUser>.value(
              value: user,
              child: BaseScreen.create(uid: user.uid),
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
