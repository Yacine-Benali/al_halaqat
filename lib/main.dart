import 'package:alhalaqat/app/landing_page.dart';
import 'package:alhalaqat/services/apple_sign_in_available.dart';
import 'package:alhalaqat/services/auth.dart';
import 'package:alhalaqat/services/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

//TODO @high ios apple sign in integration only the permison from developper console left
//TODO @high notification left to test
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appleSignInAvailable = await AppleSignInAvailable.check();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();
  runApp(MyApp(appleSignInAvailable: appleSignInAvailable));
}

class MyApp extends StatelessWidget {
  // [initialAuthServiceType] is made configurable for testing
  const MyApp({this.appleSignInAvailable});
  final AppleSignInAvailable appleSignInAvailable;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AppleSignInAvailable>.value(value: appleSignInAvailable),
        Provider<Auth>(create: (_) => FirebaseAuthService()),
      ],
      child: MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        supportedLocales: [
          const Locale('ar'),
        ],
        debugShowCheckedModeBanner: false,
        title: 'al-halaqat',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: LandingPage(),
      ),
    );
  }
}
