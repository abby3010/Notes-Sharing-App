import 'dart:io';
import 'package:bed_notes/utils/navdrawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pdf_flutter/pdf_flutter.dart';
import 'package:provider/provider.dart';
import 'package:bed_notes/authentication/auth_service.dart';

class ShowPDFScreen extends StatefulWidget {
  ShowPDFScreen(
      {@required this.filename,
      this.url,
      this.file,
      this.author,
      this.authorEmail});
  final String author;
  final String authorEmail;
  final String url;
  final File file;
  final String filename;
  @override
  _ShowPDFScreenState createState() => _ShowPDFScreenState();
}

class _ShowPDFScreenState extends State<ShowPDFScreen> {
  var isStared = false;
  Map<String, dynamic> fileMap;
  IconButton star() {
    return isStared
        ? IconButton(
            icon: Icon(Icons.star),
            color: Colors.amberAccent,
            onPressed: () {
              setState(() {
                if (isStared == false) {
                  isStared = true;
                } else {
                  isStared = false;
                }
              });
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text("Added to starred notes"),
              ));
            },
          )
        : IconButton(
            icon: Icon(Icons.star_border),
            color: Colors.amberAccent,
            onPressed: () {
              setState(() {
                if (isStared == false) {
                  isStared = true;
                } else {
                  isStared = false;
                }
              });
            },
          );
  }

  @override
  void initState() async{
    super.initState();
    fileMap = {
      "file_name": widget.filename,
      "url": widget.url,
      "uploaded_by": widget.author,
      "author_email": widget.authorEmail,
    };
    print(fileMap);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthService>(context).currentUser();
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text(
          widget.filename,
          style: TextStyle(fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.star_border,
              size: 30,
              color: Colors.amber,
            ),
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection("Users")
                  .doc(user.email)
                  .update({
                "starred_files": FieldValue.arrayUnion([fileMap]),
              });
              // print("My starred files::::::::::: " + user.starFiles.toString());
              Scaffold.of(context)
                  .showSnackBar(SnackBar(content: Text("File starred")));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: widget.url != null
            ? Center(
                child: PDF.network(
                  widget.url,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ),
              )
            : Center(
                child: PDF.file(
                  widget.file,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ),
              ),
      ),
    );
  }
}
