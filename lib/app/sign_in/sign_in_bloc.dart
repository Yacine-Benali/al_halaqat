import 'dart:async';

import 'package:al_halaqat/services/auth.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

class SignInBloc {
  SignInBloc({@required this.auth, @required this.isLoading});
  final Auth auth;
  final ValueNotifier<bool> isLoading;

  Future<AuthUser> _signIn(Future<AuthUser> Function() signInMethod) async {
    try {
      isLoading.value = true;
      return await signInMethod();
    } catch (e) {
      isLoading.value = false;
      rethrow;
    }
  }

  Future<void> signInWithGoogle() async {
    return await _signIn(auth.signInWithGoogle);
  }

  Future<void> signInWithFacebook() async {
    return await _signIn(auth.signInWithFacebook);
  }
}
