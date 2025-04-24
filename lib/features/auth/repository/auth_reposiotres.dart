import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:social_media_app/features/auth/data/data_source/auth_firebase_data_source.dart';
import 'package:social_media_app/features/auth/data/model/user_modle.dart';

class AuthRepository {
  final AuthFirebaseDataSource _dataSource = AuthFirebaseDataSource();

  Future<UserModle?> login(String email, String password) {
    return _dataSource.signInWithEmail(email, password);
  }

  Future<UserModle?> register(String name, String email, String password) {
    return _dataSource.register(name: name, email: email, password: password);
  }

  
  // دالة جديدة للتحقق إذا كان البريد الإلكتروني موجود في Firebase Auth
  Future<UserModle?> getUserByEmail(String email) async {
 return _dataSource.getUserByEmail(email);
}

 
  Future<UserModle?> getCurrentUser() {
    return _dataSource.getCurrentUserData();
  }

  Future<String> uploadProfilePictur(File imageFile) async {
    return await _dataSource.uploadProfilePicture(imageFile);
  }

  Future<void> updateProfile(String uid, String name, String about) {
    return _dataSource.updateProfile(uid: uid, name: name, about: about);
  }

  Future<void> updateProfilePicture(String uid, String imageUrl) {
    return _dataSource.updateProfilePicture(uid: uid, imageUrl: imageUrl);
  }

  Future<void> logout() {
    return _dataSource.signOut();
  }

  User? get currentUser => _dataSource.currentUser;

  
}
