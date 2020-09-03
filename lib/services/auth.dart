import 'dart:async';

import 'package:meta/meta.dart';

@immutable
class AuthUser {
  const AuthUser({
    @required this.uid,
    this.email,
    this.password,
  });

  final String uid;
  final String email;
  final String password;
}

abstract class Auth {
  Future<AuthUser> currentUser();
  Future<AuthUser> signInWithEmailAndPassword(String email, String password);
  Future<AuthUser> createUserWithEmailAndPassword(
      String email, String password);
  Future<AuthUser> signInWithGoogle();
  Future<AuthUser> signInWithFacebook();
  Future<void> signOut();
  Future<List<String>> fetchSignInMethodsForEmail({String email});
  Stream<AuthUser> get onAuthStateChanged;
  void dispose();
}
