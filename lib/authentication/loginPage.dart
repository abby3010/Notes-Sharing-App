import 'package:bed_notes/authentication/auth_service.dart';
// import 'package:bed_notes/authentication/firebase_auth_service.dart';
import 'package:bed_notes/homepage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

enum FormType { login, register }

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FormType _formType = FormType.login;
  // Checking Submission from the Form
  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  // logging In
  void validateAndSubmit(BuildContext _context) async {
    print("I'm here");
    final authServiceProvider =
        Provider.of<AuthService>(_context, listen: false);
    final authService = authServiceProvider.getCurrentUser();
    // print("AuthUser::::::::" + authService.currentUser().email);
    if (validateAndSave()) {
      try {
        if (_formType == FormType.login) {
          await authService.signInwithEmailPassword(
              emailController.text, passwordController.text);
          print("Sign In Successful!");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_context) => HomePage()),
          );
        } else {
          await authService.createUser(
              emailController.text, passwordController.text);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_context) => HomePage()),
          );
          print("Sign In Successful! ");
        }
      } catch (e) {
        print(e);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text("Some error occured!\nPlease Try Again!"),
              actions: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
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
    }
  }

  // Redirecting to register page
  void moveToRegister() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToLogin() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fooduko Login"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Form(
          key: formKey,
          child: Column(
            children: buildTextInputs() + buildSubmitButtons(),
          ),
        ),
      ),
    );
  }

  List<Widget> buildTextInputs() {
    return [
      // Email TextField
      TextFormField(
        controller: emailController,
        decoration: InputDecoration(
          labelText: "Email",
        ),
        validator: (value) {
          if (value.isEmpty) {
            return "Enter Email";
          } else if (!value.contains(RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))) {
            return "Enter valid email address";
          }
          return null;
        },
      ),

      // Password TextField
      TextFormField(
        controller: passwordController,
        decoration: InputDecoration(
          labelText: "Password",
        ),
        validator: (value) {
          if (value.isEmpty) {
            return "Enter Password!";
          } else if (value.length < 6) {
            return "Password should be atleast 6 characters!";
          }
          return null;
        },
        obscureText: true,
      )
    ];
  }

  List<Widget> buildSubmitButtons() {
    if (_formType == FormType.login) {
      return [
        // Login Button
        RaisedButton(
          child: Text(
            "Login",
            style: TextStyle(fontSize: 20.0),
          ),
          onPressed: () => validateAndSubmit(context),
        ),

        // Create an Account Panel
        FlatButton(
          child: Text(
            "Create an Account",
            style: TextStyle(fontSize: 20.0),
          ),
          onPressed: moveToRegister,
        ),
      ];
    } else {
      return [
        // Login Button
        RaisedButton(
          child: Text(
            "Sign Up",
            style: TextStyle(fontSize: 20.0),
          ),
          onPressed: () => validateAndSubmit(context),
        ),

        // Create an Account Panel
        FlatButton(
          child: Text(
            "Have an Account? Login",
            style: TextStyle(fontSize: 20.0),
          ),
          onPressed: moveToLogin,
        ),
      ];
    }
  }
}
