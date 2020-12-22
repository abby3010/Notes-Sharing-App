import 'package:bed_notes/authentication/auth_service.dart';
import 'package:bed_notes/utils/navdrawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController feedbackController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthService>(context).currentUser();
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text('B.Ed Notes Feedback Form'),
        actions: user.email == null
            ? [
                FlatButton(
                  onPressed: () {
                    Navigator.popAndPushNamed(context, "/login");
                  },
                  child: Text("Login"),
                )
              ]
            : null,
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Expanded(
                  child: Text(
                    "Your reviews will help us to improve more. Openly address your problems with this app. Since we have kept this feedback system anonymous.",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    maxLines: 6,
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              ),

              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Text(
                      "Your Reviews:",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
              // Feedback textField
              TextFormField(
                keyboardType: TextInputType.multiline,
                minLines: 1, //Normal textInputField will be displayed
                maxLines: 7,
                controller: feedbackController,
                decoration: new InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(20.0),
                      ),
                    ),
                    filled: true,
                    hintStyle: new TextStyle(color: Colors.grey[600]),
                    hintText: "Type in your text here...",
                    fillColor: Colors.grey[200]),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Enter Name";
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: RaisedButton(
                      padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                      child: Text(
                        "Submit Feedback",
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      color: Theme.of(context).accentColor,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                      onPressed: () async {
                        if (formKey.currentState.validate()) {
                          await FirebaseFirestore.instance
                              .collection('Feedback')
                              .doc(user.displayName)
                              .set({
                                "name": user.displayName,
                                "email": user.email,
                                "feedback": FieldValue.arrayUnion([feedbackController.text]),
                              })
                              .then(
                                (value) => showDialog<void>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Submitted!"),
                                      content:
                                          Text("Thank you for your reviews. They are the true source of information for us to improve."),
                                      actions: <Widget>[
                                        FlatButton(
                                          onPressed: () {
                                            Navigator.pushNamedAndRemoveUntil(
                                                context,
                                                "/home",
                                                (route) => false);
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              )
                              .catchError((error) =>
                                  print("Failed to upload feedback: $error"));
                        }
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: 20,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.copyright,
                    size: 20,
                  ),
                  Text(
                    " 2021 Abhay Ubhale",
                    style: TextStyle(fontSize: 15),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
