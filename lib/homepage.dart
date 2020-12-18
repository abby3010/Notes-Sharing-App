import 'package:bed_notes/authentication/auth_service.dart';
import 'package:bed_notes/utils/navdrawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pdf_flutter/pdf_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authUser = Provider.of<AuthService>(context);
    final user = authUser.currentUser();
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text('B.Ed Notes'),
      ),
      body: Column(
        children: <Widget>[
          // TextField(
          //   decoration: InputDecoration(),
          //   controller: _controller,
          //   onSubmitted: (String value) async {
          //     await showDialog<void>(
          //       context: context,
          //       builder: (BuildContext context) {
          //         return AlertDialog(
          //           title: const Text('Thanks!'),
          //           content: Text('You typed "$value".'),
          //           actions: <Widget>[
          //             FlatButton(
          //               onPressed: () {
          //                 Navigator.pop(context);
          //               },
          //               child: const Text('OK'),
          //             ),
          //           ],
          //         );
          //       },
          //     );
          //   },
          // ),

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Upload PDF',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
