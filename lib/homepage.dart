import 'package:bed_notes/authentication/auth_service.dart';
import 'package:bed_notes/utils/navdrawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthService>(context).currentUser();
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text('B.Ed Notes'),
        actions: user == null
            ? [
                FlatButton(
                  onPressed: () {
                    Navigator.popAndPushNamed(context, "/login");
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ]
            : null,
      ),
      body: buildNotesList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (user == null) {
            Navigator.of(context).pushNamedAndRemoveUntil(
                "/login", (Route<dynamic> route) => false);
          } else {
            Navigator.of(context).pushNamed("/addPDF");
          }
        },
        tooltip: 'Upload PDF',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget buildNotesList() {
    return Center(
      child: Text("Hello World!"),
    );
  }
}
