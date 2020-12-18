import 'package:bed_notes/authentication/auth_service.dart';
// import 'package:bed_notes/authentication/firebase_auth_service.dart';
// import 'package:bed_notes/authentication/loginPage.dart';
import 'package:bed_notes/utils/landingpage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavDrawer extends StatefulWidget {
  NavDrawer({Key key}) : super(key: key);

  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  Drawer drawer = Drawer();
  @override
  Widget build(BuildContext context) {
    final AuthService authService = Provider.of<AuthService>(context);
    final user = authService.currentUser();
    if (user.email == null) {
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
                LandingPage();
              },
            ),
            DrawerLabel(
              icon: Icon(Icons.feedback_sharp),
              text: "Feedback",
              onTap: () {},
            ),
            DrawerLabel(
              icon: Icon(Icons.contact_page),
              text: "Contact Us",
              onTap: () {},
            ),
          ],
        ),
      );
    } else {
      drawer = Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: user.photoUrl != null
                  ? BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(user.photoUrl),
                      ),
                    )
                  : BoxDecoration(color: Theme.of(context).accentColor),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  CircleAvatar(
                    radius: 20,
                    child: Icon(
                      Icons.account_circle,
                      size: 40,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    user.displayName ?? user.email,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
            DrawerLabel(
              icon: Icon(Icons.add),
              text: "Add Notes",
              onTap: () {},
            ),
            DrawerLabel(
              icon: Icon(Icons.person),
              text: "Profile",
              onTap: () {},
            ),
            DrawerLabel(
                icon: Icon(Icons.logout),
                text: "Logout",
                onTap: () {
                  try {
                    authService.signOutUser();
                    print("SignOut Successful!");
                    Navigator.pushNamedAndRemoveUntil(
                        context, "/", (Route<dynamic> route) => false);
                  } catch (e) {
                    print(e);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("LogOut Error"),
                          content: Text(
                              "Some error occured!\nYou are still Signed In"),
                          actions: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(15, 10, 15, 10),
                              child: FlatButton(
                                child: Text("Try Again"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }
                }),
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
