import 'package:bed_notes/authentication/auth_service.dart';
import 'package:bed_notes/utils/navdrawer.dart';
import 'package:bed_notes/utils/showPDFScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
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
            Text(
              " My Uploaded Notes",
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
      body: StreamBuilder(
          stream: getDocument(context),
          builder: (context, snapshot) {
            final authUser = Provider.of<AuthService>(context).currentUser();
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            else if (snapshot.hasError) {
              return Center(child: Text("Could not fetch your result :("));
            }

            var doc = snapshot.data.data();
            if (doc["urls"].length != 0) {
              return RefreshIndicator(
                onRefresh: () async {
                  setState(() {});
                },
                child: ListView.builder(
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
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            showDialog<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Confirm Delete"),
                                  content: Text(
                                      "The file be deleted permanently and cannot be retrieved back."),
                                  actions: <Widget>[
                                    FlatButton(
                                      onPressed: () async {
                                        await firebase_storage
                                            .FirebaseStorage.instance
                                            .ref()
                                            .child(authUser.email +
                                                "/" +
                                                doc["file_names"][index] +
                                                ".pdf")
                                            .delete();
                                        await FirebaseFirestore.instance
                                            .collection("Users")
                                            .doc(authUser.email)
                                            .update({
                                          // append the current url in "urls" array in FireSto  re
                                          "urls": FieldValue.arrayRemove(
                                              [doc["urls"][index]]),
                                          // append the name from users input to "file_names" array in FireStore
                                          "file_names": FieldValue.arrayRemove(
                                              [doc["file_names"][index]]),
                                          // append current date time
                                          "datetime": FieldValue.arrayRemove(
                                              [doc["datetime"][index]]),
                                        });
                                        Navigator.pop(context);
                                        var randomListItem = {
                                          "file_name": doc["file_names"][index],
                                          "url": doc["urls"][index],
                                          "uploaded_by": authUser.displayName,
                                          "email": authUser.email,
                                        };
                                        print("Deleting::::::::: " +
                                            randomListItem.toString());
                                        await FirebaseFirestore.instance
                                            .collection("Random Notes")
                                            .doc("Random Notes Doc")
                                            .update({
                                          "file_names": FieldValue.arrayRemove([doc["file_names"][index]]),
                                          "random_notes":
                                              FieldValue.arrayRemove(
                                                  [randomListItem]),
                                        });
                                      },
                                      child: const Text('Delete'),
                                    ),
                                    FlatButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
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
                ),
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
