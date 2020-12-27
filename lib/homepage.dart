import 'package:bed_notes/authentication/auth_service.dart';
import 'package:bed_notes/utils/navdrawer.dart';
import 'package:bed_notes/utils/showPDFScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Stream randomDocsStream = FirebaseFirestore.instance
      .collection("Random Notes")
      .doc("Random Notes Doc")
      .snapshots();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthService>(context).currentUser();
    return Scaffold(
      drawer: NavDrawer(),
      // backgroundColor: Colors.orange[100],
      appBar: AppBar(
        title: Text(
          'B.Ed Notes',
          style: TextStyle(fontSize: 18),
        ),
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
            : [
                IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      showSearch(context: context, delegate: DataSearch());
                    }),
              ],
      ),
      body: StreamBuilder(
        stream: randomDocsStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var doc = snapshot.data.data();
            var notes = doc["random_notes"];
            return RefreshIndicator(
              onRefresh: () async{
                setState(() {});
              },
              child: ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, int index) {
                  return Card(
                    elevation: 5,
                    child: ListTile(
                      // contentPadding: EdgeInsets.only(left: 20),
                      title: Text(notes[index]["file_name"]),
                      subtitle: Text( notes[index]["uploaded_by"]),
                      leading: Icon(Icons.file_present, color: Colors.yellow, size: 27,),
                      trailing: IconButton(
                        icon: Icon(Icons.share),
                        onPressed: () {},
                      ),
                      // isThreeLine: true,
                      // dense: true,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => ShowPDFScreen(
                              filename: notes[index]["file_name"],
                              url: notes[index]["url"],
                              author: notes[index]["uploaded_by"],
                              authorEmail: notes[index]["email"],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            );
          }
          if (snapshot.hasError) {
            print(snapshot.error);
            return Center(
              child: Text("Unable to load notes" +
                  "Ensure proper internet connection" +
                  "OR" +
                  "Restart the App"),
            );
          }
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
