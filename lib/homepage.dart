import 'package:bed_notes/authentication/auth_service.dart';
import 'package:bed_notes/screens/showPDFScreen.dart';

// import 'package:bed_notes/screens/showPDFScreen.dart';
import 'package:bed_notes/utils/navdrawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final documents = [];
  // String currentDocID;

  Future<void> loadNotesData() async {

  }


  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthService>(context).currentUser();
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text('B.Ed Notes'),
        actions: user == null
            ? [
                IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      showSearch(context: context, delegate: DataSearch());
                    }),
                FlatButton(
                  onPressed: () {
                    Navigator.popAndPushNamed(context, "/login");
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ]
            : IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  showSearch(context: context, delegate: DataSearch());
                }),
      ),
      body: FutureBuilder(
        future: loadNotesData(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            /// When the result of the future call respond and has data show that data
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                var doc = documents[index];
                var fileName = doc["file_names"].shuffle().first;
                print(doc);
                return Card(
                  elevation: 5,
                  child: ListTile(
                    title: Text(fileName),
                    subtitle: Text(" "),
                    trailing: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.star_border),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(Icons.share),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          if (snapshot.hasError) {
            print(snapshot.error);
            return Center(
                child: Column(
              children: [
                Text("Unable to load notes"),
                Text("Ensure proper internet connection"),
                Text("OR"),
                Text("Restart the App"),
              ],
            ));
          }

          /// While is no data show this
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (user == null) {
            Navigator.of(context).pushNamedAndRemoveUntil(
                "/login", (Route<dynamic> route) => false);
          } else {
            Navigator.of(context).pushNamed("/addPDF");
          }
        },
        tooltip: 'Upload PDF',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class DataSearch extends SearchDelegate {
  final cities = [
    "Bhandup",
    "Mumbai",
    "Delhi",
    "Dubai",
    "Indore",
    "Lucknow",
    "Indore",
    "kanpur",
    "Chennai",
    "Agra",
    "Rajkot",
    "Jaipur",
    "Faridabad",
    "Pune",
    "Ghaziabad",
  ];

  final recentCities = [
    "Bhandup",
    "Mumbai",
    "Delhi",
    "Indore",
    "Lucknow",
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    // actions for app bar
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // leading icon on the left of the app bar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // show some result based on the selection
    return ShowPDFScreen(filename: "FileName");
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // show when someone searches for something
    final suggestionList = query.isEmpty
        ? recentCities
        : cities.where((element) => element.startsWith(query)).toList();
    return ListView.builder(
      itemBuilder: (context, index) => Card(
        child: ListTile(
          leading: Icon(Icons.insert_drive_file_rounded),
          title: RichText(
            text: TextSpan(
                text: suggestionList[index].substring(0, query.length),
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    text: suggestionList[index].substring(query.length),
                    style: TextStyle(color: Colors.grey),
                  ),
                ]),
          ),
        ),
      ),
      itemCount: suggestionList.length,
    );
  }
}
