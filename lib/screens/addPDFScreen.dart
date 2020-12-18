import 'dart:io';
import 'package:bed_notes/authentication/auth_service.dart';
import 'package:bed_notes/authentication/user.dart';
import 'package:bed_notes/utils/navdrawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:provider/provider.dart';

class AddPDFScreen extends StatefulWidget {
  @override
  _AddPDFScreenState createState() => _AddPDFScreenState();
}

class _AddPDFScreenState extends State<AddPDFScreen> {
  File file;
  TextEditingController _nameController = TextEditingController();
  CollectionReference users = FirebaseFirestore.instance.collection('Users');

  @override
  Widget build(BuildContext context) {
    final UserCredentials authUser =
        Provider.of<AuthService>(context).currentUser();
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text("Add Notes"),
      ),
      body: Container(
        child: Column(
          children: [
            Text(
              "Enter name of your File which you want to display to others:",
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _nameController,
                onSubmitted: (value) {
                  setState(() {
                    _nameController.text = value;
                  });
                },
              ),
            ),
            RaisedButton(
              onPressed: () async {
                FilePickerResult pickedFileResult =
                    await FilePicker.platform.pickFiles(
                  allowedExtensions: ["pdf"],
                  type: FileType.custom,
                );
                setState(() {
                  file = File(pickedFileResult.files.single.path);
                });
                final firebase_storage.Reference storage = firebase_storage
                    .FirebaseStorage.instance
                    .ref()
                    .child(_nameController.text);
                try {
                  await storage.putFile(file);
                  final url = await storage.getDownloadURL();
                  await users
                      .doc(authUser.email)
                      .update({
                        // append the current url in "urls" array in FireStore
                        "urls": FieldValue.arrayUnion([url]),
                        // append the name from users input to "file_names" array in FireStore
                        "file_names":
                            FieldValue.arrayUnion([_nameController.text]),
                      })
                      .then((value) => print("User Added"))
                      .catchError(
                          (error) => print("Failed to add user: $error"));
                } on firebase_storage.FirebaseException catch (e) {
                  await showDialog<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Upload Fialed!"),
                        content: Text(
                            "Some Error Occured while uploading the file!"),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text("Add PDF from Phone"),
            ),
          ],
        ),
      ),
    );
  }
}
