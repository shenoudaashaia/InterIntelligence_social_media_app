import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media_app/features/auth/data/model/user_modle.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthFirebaseDataSource {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  static CollectionReference<UserModle> getuserCollection() => FirebaseFirestore
      .instance
      .collection("users")
      .withConverter<UserModle>(
        fromFirestore: (snapshot, _) => UserModle.fromjson(snapshot.data()!),
        toFirestore: (user, _) => user.tojson(),
      );

  Future<UserModle?> signInWithEmail(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return await _getUserData(credential.user!.uid);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModle> register({
    required String name,
    required String email,
    required String password,
  }) async {
    email = email.trim();
    password = password.trim();

    try {
      final signInMethods = await _auth.fetchSignInMethodsForEmail(email);
      if (signInMethods.isNotEmpty) {
        throw FirebaseAuthException(
          code: 'email-already-in-use',
          message: 'This email is already registered, please log in.',
        );
      }

      final existingUsers =
          await getuserCollection().where("email", isEqualTo: email).get();

      if (existingUsers.docs.isNotEmpty) {
        throw FirebaseAuthException(
          code: 'email-already-in-use',
          message: 'This email is already registered, please log in.',
        );
      }

      final credentials = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = UserModle(
        uid: credentials.user!.uid,
        name: name,
        email: email,
      );

      await getuserCollection().doc(user.uid).set(user);

      return user;
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModle?> _getUserData(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return UserModle.fromjson(doc.data()!);
    }
    return null;
  }

  Future<UserModle?> getUserByEmail(String email) async {
    try {
      final signInMethods = await _auth.fetchSignInMethodsForEmail(email);
      if (signInMethods.isNotEmpty) {
        return _getUserData(email);
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  Future<String> uploadProfilePicture(File imageFile) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();

      Reference ref = _storage.ref().child('profile_pictures/$fileName');
      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;

      String imageUrl = await snapshot.ref.getDownloadURL();

      return imageUrl;
    } catch (e) {
      print('Error uploading profile picture: $e');
      rethrow;
    }
  }

  Future<void> updateProfile({
    required String uid,
    required String name,
    required String about,
  }) async {
    await getuserCollection().doc(uid).update({'name': name, 'about': about});
  }

  Future<void> updateProfilePicture({
    required String uid,
    required String imageUrl,
  }) async {
    await getuserCollection().doc(uid).update({'profileImage': imageUrl});
  }

  Future<UserModle?> getCurrentUserData() async {
    if (_auth.currentUser != null) {
      return await _getUserData(_auth.currentUser!.uid);
    }
    return null;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;
}
