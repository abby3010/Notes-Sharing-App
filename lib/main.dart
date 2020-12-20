import 'package:bed_notes/authentication/auth_service.dart';
import 'package:bed_notes/screens/addPDFScreen.dart';
import 'package:bed_notes/screens/createPDF.dart';
// import 'package:bed_notes/screens/createPDFScreen.dart';
import 'package:bed_notes/screens/feedbackScreen.dart';
import 'package:bed_notes/screens/loginPage.dart';
import 'package:bed_notes/screens/myNotesScreen.dart';
import 'package:bed_notes/screens/myProfileScreen.dart';
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
        initialRoute: "/home",
        routes: {
          "/": (context)=>LandingPage(),
          "/home": (context)=> HomePage(),
          "/login": (context)=> LoginPage(),
          "/addPDF": (context)=> AddPDFScreen(),
          "/selectPDF": (context)=>SelectPDFScreen(),
          "/createPDF": (context) => CreatePDF(),
          "/myNotes": (context) => MyNotesScreen(),
          "/myProfile": (context)=>MyProfileScreen(),
          "/feedback": (context)=> FeedbackScreen(),
        },
      ),
    );
  }
}
