import 'package:flutter/material.dart';
import 'package:social_media_app/features/auth/data/model/user_modle.dart';
import 'package:social_media_app/features/auth/repository/auth_reposiotres.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  AuthViewModel(this._authRepository);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  UserModle? _user;
  UserModle? get user => _user;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> login(String email, String password) async {
    _setLoading(true);

    if (email.isEmpty || password.isEmpty) {
      _errorMessage = 'Email and password cannot be empty';
      _setLoading(false);
      return;
    }

    try {
      _user = await _authRepository.login(email, password);
      _errorMessage = null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        _errorMessage = 'Wrong password provided.';
      } else {
        _errorMessage = e.message ?? 'Login failed.';
      }
    } catch (e) {
      _errorMessage = 'Something went wrong';
    }

    _setLoading(false);
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    _setLoading(true);

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _errorMessage = 'All fields are required';
      _setLoading(false);
      return;
    }

    try {
      final existingUser = await _authRepository.getUserByEmail(email);
      if (existingUser != null) {
        _errorMessage = 'This email is already in use. Please log in.';
        _setLoading(false);
        return;
      }

      _user = await _authRepository.register(name, email, password);
      _errorMessage = null;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        _errorMessage = 'This email is already in use';
      } else if (e.code == 'invalid-email') {
        _errorMessage = 'The email address is not valid';
      } else if (e.code == 'weak-password') {
        _errorMessage = 'The password is too weak';
      } else {
        _errorMessage = e.message ?? 'Registration failed';
      }
    } catch (e) {
      _errorMessage = 'Something went wrong';
    }

    _setLoading(false);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String? validateName(String name) {
    if (name.isEmpty) return 'Name cannot be empty';
    if (name.length < 3) return 'Name must be at least 3 characters';
    return null;
  }

  String? validateEmail(String email) {
    if (email.isEmpty) return 'Email cannot be empty';
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      return 'Invalid email address';
    }
    return null;
  }

  String? validatePassword(String password) {
    if (password.isEmpty) return 'Password cannot be empty';
    if (password.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

    Future<void> logout() async {
    await _authRepository.logout();
    _user = null;
    notifyListeners();
  }
}
