import 'package:bed_notes/utils/navdrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class ShowPDFScreen extends StatefulWidget {
  ShowPDFScreen({
    @required this.filename,
    this.url,
  });

  final String url;
  final String filename;

  @override
  _ShowPDFScreenState createState() => _ShowPDFScreenState();
}

class _ShowPDFScreenState extends State<ShowPDFScreen> {
  @override
  void initState() {
    super.initState();
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
        body: PDF(
            // enableSwipe: true,
          // swipeHorizontal: true,
          autoSpacing: false,
        ).cachedFromUrl(
          widget.url,
          placeholder: (progress) => Center(child: CircularProgressIndicator()),
          errorWidget: (error) => Center(
              child: Text(
            "OOPS!\n Some error occured\nCheck your internet connection speed\nSorry for the inconvenience :(",
            textAlign: TextAlign.center,
          )),
        ));
  }
}
