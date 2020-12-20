
import 'package:bed_notes/utils/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'auth_service.dart';

class FirebaseAuthService implements AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // UserCredential is a custom Class which we made in user.dart
  // User is a firebase Auth class which comes inbuilt with firebase_auth package.
  UserCredentials _userFromFirebase(User user, {String displayName}) {
    if (user == null) {
      return null;
    }
    return UserCredentials(
      uid: user.uid,
      email: user.email,
      displayName: displayName ?? user.displayName,
      photoUrl: user.photoURL,
    );
  }

  @override
  FirebaseAuthService getCurrentUser() {
    return this;
  }

  @override
  Stream<UserCredentials> get onAuthStateChanged {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  @override
  Future<UserCredentials> createUser(String email, String password,
      {String displayName}) async {
    final newUser = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    if (displayName == null) {
      return _userFromFirebase(newUser.user);
    } else {
      return _userFromFirebase(newUser.user, displayName: displayName);
    }
  }

  // @override
  bool isNewUser() {

  }

  @override
  Future<UserCredentials> signInwithEmailPassword(
      String email, String password) async {
    final authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<UserCredentials> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final authResult = await _firebaseAuth.signInWithCredential(credential);
    return _userFromFirebase(authResult.user);
  }

  @override
  Future signOutUser() async {
    return _firebaseAuth.signOut();
  }

  @override
  UserCredentials currentUser() {
    final User user = _firebaseAuth.currentUser;
    return _userFromFirebase(user);
  }

  @override
  void dispose() {}
}
