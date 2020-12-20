import 'package:bed_notes/screens/showPDFScreen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class CreatePDF extends StatefulWidget {
  @override
  _CreatePDFState createState() => _CreatePDFState();
}

class _CreatePDFState extends State<CreatePDF> {
  List<File> _files = [];

  Future<void> getImageCamera() async {
    final pickedImage =
        await ImagePicker().getImage(source: ImageSource.camera);
    final image = File(pickedImage.path);
    setState(() {
      _files.add(image);
    });
  }

  Future<void> getImageGallery() async {
    final pickedImages = await FilePicker.platform.pickFiles(
        allowedExtensions: [".jpg", ".jpeg", ".jpe", ".svg", ".png", ".webp"],
        allowMultiple: true);
    List<File> fileList = pickedImages.paths.map((path) => File(path)).toList();

    setState(() {
      _files.addAll(fileList);
    });
  }

  Future<void> createSaveAndUploadPDF() async {
    final pdf = pw.Document(pageMode: PdfPageMode.outlines);

    List<pw.Container> pwPdfImages = [];
    for (int i = 0; i < _files.length; i++) {
      final profileImage = pw.MemoryImage(
          (await rootBundle.load(_files[i].path)).buffer.asUint8List());
      pwPdfImages.add(pw.Container(
        child: pw.Image.provider(profileImage),
      ));
    }
    pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) => pwPdfImages));

    final pdfFile = File.fromRawPath(pdf.save());
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShowPDFScreen(
          filename: "test file",
          file: pdfFile,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create PDF from images"),
        actions: _files.length > 0
            ? [
                FlatButton(
                  onPressed: () {},
                  child: Text(
                    "Done",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ]
            : null,
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: new GridView.builder(
              itemCount: _files.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemBuilder: (context, index) {
                return displaySelectedFile(_files[index]);
              },
            ),
          ),
          // Positioned(
          //   left: 30.0,
          //   bottom: 18.0,
          //   child: RaisedButton(
          //     onPressed: () {
          //       for (var i = 0; i < _files.length; i++) {
          //         // added this
          //         var image = PdfImage.file(
          //           pdf.document,
          //           bytes: File(_files[i].path).readAsBytesSync(),
          //         );
          //
          //         pdf.addPage(pw.Page(
          //             pageFormat: PdfPageFormat.a4,
          //             build: (pw.Context context) {
          //               return pw.Center(child: pw.Image(image));
          //             }));
          //       }
          //     },
          //     color: Colors.blue,
          //     child: Text(
          //       'Get PDF',
          //       style: TextStyle(color: Colors.white),
          //     ),
          //   ),
          // ),
          Positioned(
            left: 10.0,
            bottom: 20.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: SizedBox(
                          height: 30,
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
                          height: 30,
                          child: RaisedButton(
                            onPressed: () async {
                              await getImageGallery();
                            },
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
            ),
          ),
        ],
      ),
    );
  }

  Widget displaySelectedFile(File file) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        children: [
          SizedBox(
            height: 200.0,
            width: 200.0,
            child: Image.file(file),
          ),
          SizedBox(
            width: 200.0,
            height: 20.0,
            child: FlatButton(
              color: Colors.blue,
              onPressed: () {
                setState(() {
                  _files.remove(file);
                });
              },
              child: Text(
                "Remove",
                style: TextStyle(fontSize: 13, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
