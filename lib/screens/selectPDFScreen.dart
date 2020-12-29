import 'dart:io';
import 'package:bed_notes/authentication/auth_service.dart';
import 'package:bed_notes/utils/navdrawer.dart';
import 'package:bed_notes/utils/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:pdf_flutter/pdf_flutter.dart';
import 'package:provider/provider.dart';

class SelectPDFScreen extends StatefulWidget {
  @override
  _SelectPDFScreenState createState() => _SelectPDFScreenState();
}

class _SelectPDFScreenState extends State<SelectPDFScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int counter = 1;
  String appBarText = " Select File";
  final formKey = GlobalKey<FormState>();
  File file;
  TextEditingController _nameController = TextEditingController();
  CollectionReference users = FirebaseFirestore.instance.collection('Users');

  Future<void> _selectPDF(BuildContext context) async {
    final UserCredentials authUser =
        Provider.of<AuthService>(context, listen: false).currentUser();
    final doc = await FirebaseFirestore.instance
        .collection("Random Notes")
        .doc("Random Notes Doc")
        .get();
    if (!doc["file_names"].contains(_nameController.text)) {
      if (formKey.currentState.validate()) {
        FilePickerResult pickedFileResult = await FilePicker.platform.pickFiles(
          allowedExtensions: ["pdf"],
          type: FileType.custom,
        );
        var fileSplit = pickedFileResult.files.single.path.split(".");
        if (fileSplit[fileSplit.length - 1] == "pdf") {
          setState(() {
            file = File(pickedFileResult.files.single.path);
            appBarText = " File Preview";
          });
        } else {
          showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Only PDF files are allowed"),
                content: Text("Please select appropriate PDF file only."),
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
        final firebase_storage.Reference storage = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child(authUser.email + "/" + _nameController.text + ".pdf");
        try {
          await storage.putFile(file);
          final url = await storage.getDownloadURL();
          await users.doc(authUser.email).update({
            // append the current url in "urls" array in FireSto  re
            "urls": FieldValue.arrayUnion([url]),
            // append the name from users input to "file_names" array in FireStore
            "file_names": FieldValue.arrayUnion([_nameController.text]),
            // append current date time
            "datetime": FieldValue.arrayUnion([Timestamp.now()]),
          }).then(
            (value) async => await FirebaseFirestore.instance
                .collection("Random Notes")
                .doc("Random Notes Doc")
                .update({
              "random_notes": FieldValue.arrayUnion([
                {
                  "file_name": _nameController.text,
                  "url": url,
                  "uploaded_by": authUser.displayName,
                  "email": authUser.email,
                }
              ]),
            }).then(
              (value) => showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Upload Complete!"),
                    content: Text("File Uploaded successfully!"),
                    actions: <Widget>[
                      FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              ),
            ),
          );

          Navigator.popAndPushNamed(context, "/myNotes");
        } on firebase_storage.FirebaseException {
          await showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Upload Failed!"),
                content: Text("Some Error Occurred while uploading the file!"),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: const Text('Try Again'),
                  ),
                ],
              );
            },
          );
        }
      }
    } else {
      _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text('The name already exists!'),
            duration: Duration(seconds: 3),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Row(children: [
          Icon(Icons.upload_file),
          Text(
            appBarText,
            style: TextStyle(fontSize: 18),
          ),
        ]),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: file == null
            ? Form(
                key: formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.10,
                    ),
                    Text(
                      "Enter name for your Notes",
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      "This name will be displayed to others",
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        controller: _nameController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Enter name for your Notes";
                          }
                          return null;
                        },
                        onFieldSubmitted: (value) {
                          setState(() {
                            _nameController.text = value;
                          });
                        },
                        decoration: new InputDecoration(
                            border: new OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(10.0),
                              ),
                            ),
                            filled: true,
                            hintStyle: new TextStyle(color: Colors.grey[800]),
                            hintText: "Name",
                            fillColor: Colors.white70),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RaisedButton(
                      color: Theme.of(context).accentColor,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: BorderSide(color: Colors.blueAccent)),
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "Select PDF file from Phone",
                        style: TextStyle(fontSize: 18),
                      ),
                      onPressed: () async {
                        await _selectPDF(context);
                      },
                    ),
                  ],
                ),
              )
            : PDF.file(
                file,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              ),
      ),
      floatingActionButton: file != null
          ? FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Uploading..."),
                      content: counter < 3
                          ? Text("Please wait while we upload your file.")
                          : Text(
                              "Please wait!\nEither the file size is big or please check your internet connection."),
                      actions: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                          child: FlatButton(
                            child: Text("OK"),
                            onPressed: () {
                              setState(() {
                                ++counter;
                              });
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              tooltip: 'Preview PDF',
              child: Icon(
                Icons.check_circle_sharp,
                color: Colors.white,
              ),
            )
          : FloatingActionButton(
              onPressed: () async {
                await _selectPDF(context);
              },
              tooltip: 'Select PDF',
              child: Icon(
                Icons.insert_drive_file_outlined,
                color: Colors.white,
              ),
            ), // This trailing comma ,
    );
  }
}
