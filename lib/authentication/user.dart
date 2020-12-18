import 'package:meta/meta.dart';

@immutable
class UserCredentials {
  UserCredentials(
      {@required this.uid, this.email, this.photoUrl, this.displayName});
  final String uid;
  final String email;
  final String photoUrl;
  final String displayName;
}
