import 'package:bed_notes/authentication/auth_service.dart';
import 'package:bed_notes/utils/landingPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavDrawer extends StatefulWidget {
  NavDrawer({Key key}) : super(key: key);

  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  Drawer drawer = Drawer();

  Widget copyrightWidget() {
    return Align(
      alignment: FractionalOffset.bottomCenter,
      child: Column(
        children: [
         SizedBox(height:150),
          Row(
            children: [
              SizedBox(
                width: 15,
              ),
              Image.asset(
                "assets/images/IndianFlag.png",
                height: 50,
                width: 50,
              ),
              SizedBox(
                width: 15,
              ),
              Text("Make In India Initiative"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.copyright, size: 15,),
              Text(" 2021 Abhay Ubhale", style: TextStyle(fontSize: 12),)
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AuthService authService = Provider.of<AuthService>(context);
    final user = authService.currentUser();
    if (user == null) {
      drawer = Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Text(
                "Welcome!\nLogin to share your notes.",
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColorDark,
              ),
            ),
            DrawerLabel(
              icon: Icon(Icons.login),
              text: "Login",
              onTap: () {
                Navigator.popAndPushNamed(context, "/");
              },
            ),
            DrawerLabel(
              icon: Icon(Icons.feedback_sharp),
              text: "Feedback",
              onTap: () {
                Navigator.popAndPushNamed(context, "/feedback");
              },
            ),
            copyrightWidget(),
          ],
        ),
      );
    } else {
      drawer = Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
              ),
              child:user.photoUrl != null
              ? Container(
                decoration:  BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.contain,
                          image: NetworkImage(user.photoUrl),
                        ),
                      ))
                    : Container(
                        decoration:
                            BoxDecoration(color: Theme.of(context).accentColor),
                        child: Center(
                          child: Text(
                            // initials of user name
                            user.displayName != null
                                ? (user.displayName.split(" ")[0][0].toUpperCase() +
                                    user.displayName.split(" ")[1][0]).toUpperCase()
                                : (user.email.split("@")[0]).toUpperCase(),
                            style: TextStyle(fontSize: 25, color: Colors.white),
                          ),
                        ),
                      ),
              ),

            //
            DrawerLabel(
              icon: Icon(Icons.account_circle),
              text: user.displayName ?? user.email,
              onTap: () {},
            ),
            DrawerLabel(
              icon: Icon(Icons.add),
              text: "Add Notes",
              onTap: () {
                Navigator.popAndPushNamed(context, "/addPDF");
              },
            ),
            DrawerLabel(
              icon: Icon(Icons.notes),
              text: "My Notes",
              onTap: () {
                Navigator.popAndPushNamed(context, "/myNotes");
              },
            ),
            DrawerLabel(
              icon: Icon(Icons.person),
              text: "My Profile",
              onTap: () {
                Navigator.popAndPushNamed(context, "/myProfile");
              },
            ),
            DrawerLabel(
              icon: Icon(Icons.feedback_sharp),
              text: "Feedback",
              onTap: () {
                Navigator.popAndPushNamed(context, "/feedback");
              },
            ),
            copyrightWidget(),
          ],
        ),
      );
    }

    return drawer;
  }
}

class DrawerLabel extends StatefulWidget {
  final String text;
  final Icon icon;
  final Function onTap;
  DrawerLabel({@required this.text, @required this.icon, @required this.onTap});

  @override
  _DrawerLabelState createState() => _DrawerLabelState();
}

class _DrawerLabelState extends State<DrawerLabel> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: widget.onTap,
      leading: widget.icon,
      title: Text(
        widget.text,
        style: TextStyle(
            color: Theme.of(context).primaryColorDark,
            fontSize: 15,
            fontWeight: FontWeight.w700),
      ),
    );
  }
}
