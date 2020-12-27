import 'package:bed_notes/authentication/firebase_auth_service.dart';
import 'package:bed_notes/utils/user.dart';

abstract class AuthService {
  FirebaseAuthService getCurrentUser();
  Stream<UserCredentials> get onAuthStateChanged;
  Future<UserCredentials> createUser(String email, String password,String displayName);
  Future<UserCredentials> signInWithEmailPassword(
      String email, String password);
  Future<UserCredentials> signInWithGoogle();
  Future signOutUser();
  UserCredentials currentUser();
  void dispose();
}
