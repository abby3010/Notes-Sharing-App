import 'package:bed_notes/authentication/auth_service.dart';
import 'package:bed_notes/screens/showPDFScreen.dart';
import 'package:bed_notes/utils/navdrawer.dart';
import 'package:bed_notes/utils/user.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:provider/provider.dart';

class MyNotesScreen extends StatefulWidget {
  @override
  _MyNotesScreenState createState() => _MyNotesScreenState();
}

class _MyNotesScreenState extends State<MyNotesScreen> {
  // Stream<DocumentSnapshot> getDocument(BuildContext context) {
  //   final user = Provider.of<AuthService>(context).currentUser();
  //   var snapshot = FirebaseFirestore.instance
  //       .collection("Users")
  //       .doc(user.email)
  //       .snapshots();
  //   return snapshot;
  // }

  Stream<ListResult> listStream(UserCredentials authUser) {
    return firebase_storage.FirebaseStorage.instance
        .ref(authUser.email)
        .list(firebase_storage.ListOptions())
        .asStream();
  }

  @override
  Widget build(BuildContext context) {
    var authUser = Provider.of<AuthService>(context).currentUser();
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Row(children: [
          Icon(Icons.drive_folder_upload),
          Text(" My Uploaded Notes"),
        ]),
      ),
      body: StreamBuilder(
          stream: listStream(authUser),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Center(child: Text("Could not fetch your result :("));
            }

            return ListView.builder(
              itemCount: snapshot.data.items.length,
              itemBuilder: (context, index) {
                var refString = snapshot.data.items[index].toString().split("/")[1];
                var name = refString.split(")")[0];
                return Card(
                  elevation: 5,
                  child: ListTile(
                    leading: Icon(Icons.file_copy_rounded),
                    title: Text(name),
                    // subtitle: Text(doc["datetime"][index].toDate()),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => ShowPDFScreen(
                              url: snapshot.data.items[index].getDownloadURL()),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }),
    );
  }
}
