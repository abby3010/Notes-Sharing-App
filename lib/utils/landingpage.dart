import 'package:bed_notes/authentication/auth_service.dart';
import 'package:bed_notes/authentication/loginPage.dart';
import 'package:bed_notes/authentication/user.dart';
import 'package:bed_notes/homepage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthService auth = Provider.of<AuthService>(context);
    return StreamBuilder<UserCredentials>(
        stream: auth.onAuthStateChanged,
        builder: (_, AsyncSnapshot<UserCredentials> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final user = snapshot.data;
            return user == null ? LoginPage() : HomePage();
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
