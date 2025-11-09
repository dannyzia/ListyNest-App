
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class AuthProvider with ChangeNotifier {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  firebase_auth.User? _user;
  bool _isLoading = false;
  String? _errorMessage;
  
  firebase_auth.User? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isLoggedIn => _user != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Stream<firebase_auth.User?> get authStateChanges => _auth.authStateChanges();
  
  AuthProvider() {
    _auth.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
  }
  
  Future<void> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
  
  Future<void> register(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
  
  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<void> checkAuth() async {
    _user = _auth.currentUser;
    notifyListeners();
  }

  Future<void> updateUser(String name, String? phone) async {
    try {
      await _user?.updateDisplayName(name);
      // Phone update would need Firebase Phone Auth setup
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }
}
