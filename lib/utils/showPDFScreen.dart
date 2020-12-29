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
  // Map<String, dynamic> fileMap;
  @override
  void initState() {
    super.initState();
    // fileMap = {
    //   "file_name": widget.filename,
    //   "url": widget.url,
    //   "uploaded_by": widget.author,
    //   "author_email": widget.authorEmail,
    // };
    // print(fileMap);
  }

  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<AuthService>(context).currentUser();
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text(
          widget.filename,
          style: TextStyle(fontSize: 18),
        ),
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
