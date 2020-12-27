import 'package:bed_notes/authentication/auth_service.dart';
import 'package:bed_notes/utils/navdrawer.dart';
import 'package:bed_notes/utils/showPDFScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as _firebaseStorage;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyStarredNotesScreen extends StatefulWidget {
  @override
  _MyStarredNotesScreenState createState() => _MyStarredNotesScreenState();
}

class _MyStarredNotesScreenState extends State<MyStarredNotesScreen> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthService>(context).currentUser();
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.star),
            Text(
              " My Starred Notes",
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .doc(user.email)
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Could not fetch your result :("));
          }
          return ListView.builder(itemBuilder: (context, index) {
            var doc = snapshot.data.data()["starred_files"];
            var url = _firebaseStorage.FirebaseStorage.instance.ref().child(user.email+"/"+ doc[index]["file_name"] + ".pdf").getDownloadURL();
            return Card(
              child: ListTile(
                leading: Icon(Icons.file_copy_rounded),
                title: Text(doc[index]["file_name"]),
                subtitle: Text(doc[index]["uploaded_by"]),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ShowPDFScreen(
                        filename: doc[index]["file_name"],
                        url: url,
                      ),
                    ),
                  );
                },
              ),
            );
          });
        },
      ),
    );
  }
}
