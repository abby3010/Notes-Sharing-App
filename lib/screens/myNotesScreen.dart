import 'package:bed_notes/authentication/auth_service.dart';
import 'package:bed_notes/screens/showPDFScreen.dart';
import 'package:bed_notes/utils/navdrawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class MyNotesScreen extends StatefulWidget {
  @override
  _MyNotesScreenState createState() => _MyNotesScreenState();
}

class _MyNotesScreenState extends State<MyNotesScreen> {
  Stream<DocumentSnapshot> getDocument(BuildContext context) {
    final user = Provider.of<AuthService>(context).currentUser();
    var snapshot = FirebaseFirestore.instance
        .collection("Users")
        .doc(user.email)
        .snapshots();
    return snapshot;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.drive_folder_upload),
            Text(" My Uploaded Notes"),
          ],
        ),
      ),
      body: StreamBuilder(
          stream: getDocument(context),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Center(child: Text("Could not fetch your result :("));
            }
            var doc = snapshot.data.data();
            if (doc["urls"].length != 0) {
              return ListView.builder(
                itemCount: doc["urls"].length,
                itemBuilder: (context, index) {
                  var date = DateFormat('dd-MM-yyyy hh:mm:ss')
                      .format(doc["datetime"][index].toDate());
                  return Card(
                    elevation: 5,
                    child: ListTile(
                      leading: Icon(Icons.file_copy_rounded),
                      title: Text(doc["file_names"][index]),
                      subtitle: Text(date),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => ShowPDFScreen(
                              filename: doc["file_names"][index],
                              url: doc["urls"][index],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Text(
                  "No notes yet",
                  style: TextStyle(fontSize: 20),
                ),
              );
            }
          }),
    );
  }
}
