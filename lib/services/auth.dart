import 'dart:async';

import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:meta/meta.dart';

@immutable
class AuthUser {
  const AuthUser({
    @required this.uid,
    this.email,
    this.photoUrl,
    this.displayName,
  });

  final String uid;
  final String email;
  final String photoUrl;
  final String displayName;
}

abstract class Auth {
  Future<AuthUser> currentUser();
  Future<AuthUser> signInAnonymously();
  Future<AuthUser> signInWithEmailAndPassword(String email, String password);
  Future<AuthUser> createUserWithEmailAndPassword(
      String email, String password);
  Future<void> sendPasswordResetEmail(String email);
  Future<AuthUser> signInWithEmailAndLink({String email, String link});
  Future<bool> isSignInWithEmailLink(String link);
  Future<AuthUser> signInWithGoogle();
  Future<AuthUser> signInWithFacebook();
  Future<AuthUser> signInWithApple({List<Scope> scopes});
  Future<void> signOut();
  Stream<AuthUser> get onAuthStateChanged;
  void dispose();
}
