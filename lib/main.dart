import 'package:bed_notes/authentication/auth_service.dart';
import 'package:bed_notes/utils/landingpage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bed_notes/authentication/firebase_auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider<AuthService>(
      create: (_) => FirebaseAuthService(),
      dispose: (_, AuthService authService) => authService.dispose(),
      child: MaterialApp(
        title: 'B.Ed Notes',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: LandingPage(),
      ),
    );
  }
}
