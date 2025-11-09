
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

extension UserExtensions on firebase_auth.User {
  String get id => uid; // Firebase User uses 'uid', not 'id'
  String get name => displayName ?? email?.split('@')[0] ?? 'User';
  String? get avatarUrl => photoURL;
  String? get phone => phoneNumber;
}
