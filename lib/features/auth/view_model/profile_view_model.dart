import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_app/features/auth/data/model/user_modle.dart';
import 'package:social_media_app/features/auth/repository/auth_reposiotres.dart';

class ProfileViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  ProfileViewModel(this._authRepository);

  UserModle? _user;
  UserModle? get user => _user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _imagePath;
  String? get imagePath => _imagePath;

  Future<void> loadUser() async {
    _setLoading(true);
    _user = await _authRepository.getCurrentUser();
    _setLoading(false);
  }
Future<void> uploadProfilePicture(File imageFile) async {
  try {
    print('Uploading profile picture...');
    // رفع الصورة إلى Firebase
    String imageUrl = await _authRepository.uploadProfilePictur(imageFile);
    print('Image uploaded successfully. Image URL: $imageUrl');

    if (_user != null) {
      // تحديث رابط الصورة في Firebase
      print('Updating profile picture in Firebase...');
      await _authRepository.updateProfilePicture(_user!.uid, imageUrl);
      _user = _user!.copyWith(profileImageUrl: imageUrl);
      print('Profile picture updated successfully');
    }
  } catch (e) {
    print('Error uploading profile picture: $e');
  }
}
Future<void> updateProfile(String name, String about) async {
  if (_user == null) return;
  _setLoading(true);

  print('Updating profile with name: $name and about: $about');
  // تحديث الاسم والوصف في Firebase
  await _authRepository.updateProfile(_user!.uid, name, about);

  _user = _user!.copyWith(name: name, about: about);
  _setLoading(false);
  print('Profile updated successfully');
  notifyListeners();
}

// اختيار صورة من المعرض
Future<void> pickImageFromGallery() async {
  print('Picking image from gallery...');
  final picked = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 80);
  if (picked != null) {
    _imagePath = picked.path;
    print('Image picked from gallery: $_imagePath');
    await uploadProfilePicture(File(picked.path)); // استخدام الميثود الجديدة
    notifyListeners();
  } else {
    print('No image selected from gallery');
  }
}

// التقاط صورة من الكاميرا
Future<void> pickImageFromCamera() async {
  print('Picking image from camera...');
  final picked = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 80);
  if (picked != null) {
    _imagePath = picked.path;
    print('Image picked from camera: $_imagePath');
    await uploadProfilePicture(File(picked.path)); // استخدام الميثود الجديدة
    notifyListeners();
  } else {
    print('No image selected from camera');
  }
}


  

  Future<void> logout() async {
    await _authRepository.logout();
    _user = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
