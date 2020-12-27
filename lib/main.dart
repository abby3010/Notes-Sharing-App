import 'package:bed_notes/authentication/auth_service.dart';
import 'package:bed_notes/screens/feedbackScreen.dart';
import 'package:bed_notes/screens/loginPage.dart';
import 'package:bed_notes/screens/myNotesScreen.dart';
import 'package:bed_notes/screens/myProfileScreen.dart';
import 'package:bed_notes/screens/myStarredNotesScreen.dart';
import 'package:bed_notes/screens/selectPDFScreen.dart';
import 'package:bed_notes/utils/landingPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bed_notes/authentication/firebase_auth_service.dart';
import 'homepage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of application.
  int appRestartCount = -1;

  @override
  Widget build(BuildContext context) {
    return Provider<AuthService>(
      create: (_) => FirebaseAuthService(),
      dispose: (_, AuthService authService) => authService.dispose(),
      child: MaterialApp(
        title: 'B.Ed Notes',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        // initialRoute: initialScreen(),
        initialRoute: "/",
        routes: {
          "/": (context) => LandingPage(),
          "/home": (context) => HomePage(),
          "/login": (context) => LoginPage(),
          "/addPDF": (context) => SelectPDFScreen(),
          "/myNotes": (context) => MyNotesScreen(),
          "/myProfile": (context) => MyProfileScreen(),
          "/feedback": (context) => FeedbackScreen(),
          "/myStarredNotes": (context)=> MyStarredNotesScreen(),
        },
      ),
    );
  }

  String initialScreen() {
    appRestartCount++;
    if (appRestartCount == 1) {
      return "/";
    }
    return "/home";
  }
}
