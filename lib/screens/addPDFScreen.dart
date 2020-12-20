import 'package:bed_notes/utils/navdrawer.dart';
import 'package:flutter/material.dart';

class AddPDFScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          Icon(Icons.select_all),
          Text(" Add Notes"),
        ]),
      ),
      drawer: NavDrawer(),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.85,
              child: RaisedButton(
                color: Theme.of(context).accentColor,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: BorderSide(color: Colors.blueAccent)),
                padding: EdgeInsets.all(20),
                child: Text(
                  "Create new PDF file",
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  Navigator.popAndPushNamed(context, "/createPDF");
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.85,
              child: RaisedButton(
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
                onPressed: () {
                  Navigator.popAndPushNamed(context, "/selectPDF");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
