import 'package:bed_notes/utils/navdrawer.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/cupertino.dart';
// import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'dart:async';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:flutter/rendering.dart';

class CreatePDFScreen extends StatefulWidget {
  @override
  _CreatePDFScreenState createState() => _CreatePDFScreenState();
}

class _CreatePDFScreenState extends State<CreatePDFScreen> {
  final GlobalKey<State<StatefulWidget>> shareWidget = GlobalKey();
  final GlobalKey<State<StatefulWidget>> pickWidget = GlobalKey();
  final GlobalKey<State<StatefulWidget>> previewContainer = GlobalKey();

  File _image;
  File _tempImage;
  final pdf = pw.Document();
  int index;
  final x = ImagePicker().getImage(source: null);

  Future getImageCamera() async {
    final pickedImage =
        await ImagePicker().getImage(source: ImageSource.camera);
    final image = File(pickedImage.path);
    setState(() {
      if (_image == null) {
        _image = image;
      } else {
        _tempImage = _image;
        _image = image;
      }
    });
  }

  Future getImageGallery() async {
    final pickedImage =
        await ImagePicker().getImage(source: ImageSource.gallery);
    final image = File(pickedImage.path);
    setState(() {
      if (_image == null) {
        _image = image;
      } else {
        _tempImage = _image;
        _image = image;
      }
    });
  }

  void createPDF(File _image) async {
    final image = PdfImage.file(
      pdf.document,
      bytes: _image.readAsBytesSync(),
    );
    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Image(image),
          ); // Center
        }));
    final output = await getExternalStorageDirectory();
    print("${output.path}/example.pdf");
    final file = File("${output.path}/Document$index.pdf");
    index = index + 1;
    await file.writeAsBytes(pdf.save());
    // await Printing.layoutPdf(
    //     onLayout: (PdfPageFormat format) async => pdf.save());
    //   await Printing.sharePdf(bytes: pdf.save(), filename: 'my-document.pdf');
  }

  // void savePDF() async {
  //   final output = await getExternalStorageDirectory();
  //   // print(output[0]);
  //   print("${output.path}/example.pdf");
  //   final file = File("${output.path}/example.pdf");
  //   // await file.writeAsBytes(pdf.save());
  //   // await Printing.layoutPdf(
  //   //     onLayout: (PdfPageFormat format) async => pdf.save());
  //   await Printing.sharePdf(bytes: pdf.save(), filename: 'my-document.pdf');
  // }
  // Future<void> _printPdf() async {
  //   print('Print ...');
  //   try {
  //     final bool result = await Printing.layoutPdf(
  //         onLayout: (PdfPageFormat format) async => pdf.save());
  //     _showPrintedToast(result);
  //   } catch (e) {
  //     final ScaffoldState scaffold = Scaffold.of(shareWidget.currentContext);
  //     scaffold.showSnackBar(SnackBar(
  //       content: Text('Error: ${e.toString()}'),
  //     ));
  //   }
  // }

  @override
  void initState() {
    super.initState();
  }

  // void _showPrintedToast(bool printed) {
  //   final ScaffoldState scaffold = Scaffold.of(shareWidget.currentContext);
  //   if (printed) {
  //     scaffold.showSnackBar(const SnackBar(
  //       content: Text('Document printed successfully'),
  //     ));
  //   } else {
  //     scaffold.showSnackBar(const SnackBar(
  //       content: Text('Document not printed'),
  //     ));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Row(children: [
          Icon(Icons.create_new_folder_outlined),
          Text(" Create PDF File"),
        ]),
        actions: <Widget>[
          _image == null
              ? _tempImage == null
                  ? Container()
                  : IconButton(
                      icon: Icon(Icons.arrow_forward),
                      onPressed: () {
                        createPDF(_tempImage);
                      },
                    )
              : IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: () {
                    createPDF(_image);
                  },
                )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8),
            child: _image == null
                ? _tempImage == null
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height * 0.65,
                        child: Center(child: Text('No Image Selected'),),)
                    : SizedBox(
                        height: MediaQuery.of(context).size.height * 0.65,
                        child: Image.file(_tempImage),
                      )
                : SizedBox(
                    height: MediaQuery.of(context).size.height * 0.65,
                    child: Image.file(_image),
                  ),
          ),
          ScanButton(getImageCamera, getImageGallery),
        ],
      ),
    );
  }
}

class ScanButton extends StatelessWidget {
  Function getImageCamera;
  Function getImageGallery;
  ScanButton(this.getImageCamera, this.getImageGallery);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                child: SizedBox(
                  height: 60,
                  child: RaisedButton(
                    onPressed: getImageCamera,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.camera_alt,
                        ),
                        Text('Scan')
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: SizedBox(
                  height: 60,
                  child: RaisedButton(
                    onPressed: getImageGallery,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.photo,
                        ),
                        Text('Gallery')
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
