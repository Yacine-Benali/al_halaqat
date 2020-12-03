import 'package:alhalaqat/app/sign_in/email_password/email_password_sign_in_page.dart';
import 'package:alhalaqat/app/sign_in/sign_in_bloc.dart';
import 'package:alhalaqat/app/sign_in/social_sign_in_button.dart';
import 'package:alhalaqat/common_widgets/platform_exception_alert_dialog.dart';
import 'package:alhalaqat/constants/keys.dart';
import 'package:alhalaqat/constants/strings.dart';
import 'package:alhalaqat/services/apple_sign_in_available.dart';
import 'package:alhalaqat/services/auth.dart';
import 'package:apple_sign_in/apple_sign_in_button.dart'
    as apple_sign_in_button;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SignInPageBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Auth auth = Provider.of<Auth>(context, listen: false);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, ValueNotifier<bool> isLoading, __) => Provider<SignInBloc>(
          create: (_) => SignInBloc(auth: auth, isLoading: isLoading),
          child: Consumer<SignInBloc>(
            builder: (_, SignInBloc manager, __) => SignInPage._(
              isLoading: isLoading.value,
              manager: manager,
              title: 'Al halqat',
            ),
          ),
        ),
      ),
    );
  }
}

class SignInPage extends StatelessWidget {
  const SignInPage._({Key key, this.isLoading, this.manager, this.title})
      : super(key: key);
  final SignInBloc manager;
  final String title;
  final bool isLoading;

  static const Key googleButtonKey = Key('google');
  static const Key facebookButtonKey = Key('facebook');
  static const Key emailPasswordButtonKey = Key('email-password');
  static const Key emailLinkButtonKey = Key('email-link');
  static const Key anonymousButtonKey = Key(Keys.anonymous);

  Future<void> _showSignInError(
      BuildContext context, PlatformException exception) async {
    await PlatformExceptionAlertDialog(
      title: Strings.signInFailed,
      exception: exception,
    ).show(context);
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await manager.signInWithGoogle();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(context, e);
      }
    }
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
    try {
      await manager.signInWithFacebook();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(context, e);
      }
    }
  }

  Future<void> _signInWithEmailAndPassword(BuildContext context) async {
    final navigator = Navigator.of(context);
    await EmailPasswordSignInPage.show(
      context,
      onSignedIn: navigator.pop,
    );
  }

  Future<void> _signInWithApple(BuildContext context) async {
    try {
      await manager.signInWithApple();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(context, e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 2.0,
        title: Text('الحلقات'),
      ),
      // Hide developer menu while loading in progress.
      // This is so that it's not possible to switch auth service while a request is in progress
      backgroundColor: Colors.grey[200],
      body: _buildSignIn(context),
    );
  }

  Widget _buildHeader() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Text(
      'تسجيل الدخول',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w600),
    );
  }

  Widget _buildSignIn(BuildContext context) {
    final appleSignInAvailable = Provider.of<AppleSignInAvailable>(context);
    // Make content scrollable so that it fits on small screens
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 32.0),
            SizedBox(
              height: 50.0,
              child: _buildHeader(),
            ),
            SizedBox(height: 32.0),
            if (appleSignInAvailable.isAvailable) ...[
              apple_sign_in_button.AppleSignInButton(
                style: apple_sign_in_button.ButtonStyle.black,
                type: apple_sign_in_button.ButtonType.signIn,
                onPressed: isLoading ? null : () => _signInWithApple(context),
              ),
              SizedBox(height: 8),
            ],
            SocialSignInButton(
              key: googleButtonKey,
              assetName: 'assets/go-logo.png',
              text: 'تسجيل الدخول مع جوجل',
              onPressed: isLoading ? null : () => _signInWithGoogle(context),
              color: Colors.white,
            ),
            SizedBox(height: 8),
            SocialSignInButton(
              key: facebookButtonKey,
              assetName: 'assets/fb-logo.png',
              text: 'تسجيل الدخول مع فايسبوك',
              textColor: Colors.white,
              onPressed: isLoading ? null : () => _signInWithFacebook(context),
              color: Color(0xFF334D92),
            ),
            SizedBox(height: 8),
            SignInButton(
              key: emailPasswordButtonKey,
              text: 'تسجيل الدخول باسم المستخدم',
              onPressed:
                  isLoading ? null : () => _signInWithEmailAndPassword(context),
              textColor: Colors.white,
              color: Colors.teal[700],
            ),
            SizedBox(height: 8),
            // SignInButton(
            //   key: emailLinkButtonKey,
            //   text: 'تسجيل الدخول باسم المستخدم',
            //   onPressed: isLoading
            //       ? null
            //       : () => _signInWithUsernameAndPassword(context),
            //   textColor: Colors.white,
            //   color: Colors.blueGrey[700],
            // ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
