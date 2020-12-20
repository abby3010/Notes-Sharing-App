import 'dart:io';
import 'package:bed_notes/utils/navdrawer.dart';
import 'package:flutter/material.dart';
import 'package:pdf_flutter/pdf_flutter.dart';

class ShowPDFScreen extends StatefulWidget {
  ShowPDFScreen({@required this.filename ,this.url, this.file});
  final String url;
  final File file;
  final String filename;
  @override
  _ShowPDFScreenState createState() => _ShowPDFScreenState();
}

class _ShowPDFScreenState extends State<ShowPDFScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text(widget.filename),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: widget.url != null
              ? PDF.network(
                  widget.url,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                )
              : PDF.file(
                  widget.file,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ),
        ),
      ),
    );
  }
}
