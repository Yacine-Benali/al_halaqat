import 'package:alhalaqat/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService implements Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String password;

  @override
  Future<List<String>> fetchSignInMethodsForEmail({String email}) =>
      _firebaseAuth.fetchSignInMethodsForEmail(email);

  AuthUser _userFromFirebase(User user) {
    if (user == null) {
      return null;
    }
    return AuthUser(
      uid: user.uid,
      email: user.email,
      password: password,
    );
  }

  @override
  Stream<AuthUser> get onAuthStateChanged {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  @override
  Future<AuthUser> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    this.password = password;
    final UserCredential authResult =
        await _firebaseAuth.signInWithCredential(EmailAuthProvider.credential(
      email: email,
      password: password,
    ));
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<AuthUser> createUserWithEmailAndPassword(
      String email, String password) async {
    this.password = password;

    final UserCredential authResult = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<AuthUser> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount googleUser =
        await googleSignIn.signIn().catchError((error) {
      print('AN ERROR OCCURED');
    });

    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        final UserCredential authResult = await _firebaseAuth
            .signInWithCredential(GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        ));
        return _userFromFirebase(authResult.user);
      } else {
        throw PlatformException(
            code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
            message: 'Missing Google Auth Token');
      }
    } else {
      throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
    }
  }

  @override
  // ignore: missing_return
  Future<AuthUser> signInWithFacebook() async {
    final fb = FacebookLogin();
    final result = await fb.logIn(permissions: []);

    if (result.status == FacebookLoginStatus.Success) {
      if (result.accessToken != null) {
        final UserCredential authResult =
            await _firebaseAuth.signInWithCredential(
          FacebookAuthProvider.credential(result.accessToken.token),
        );
        return _userFromFirebase(authResult.user);
      }
    } else {
      throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
    }
  }

  @override
  Future<AuthUser> currentUser() async {
    final User user = _firebaseAuth.currentUser;
    return _userFromFirebase(user);
  }

  @override
  Future<void> signOut() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    final FacebookLogin facebookLogin = FacebookLogin();
    await facebookLogin.logOut();
    return _firebaseAuth.signOut();
  }

  @override
  void dispose() {}
}
