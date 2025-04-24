import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media_app/features/auth/data/model/user_modle.dart';

class SearchRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<UserModle>> searchUsersByName(String query, String currentUserId) async {
    final result = await _firestore
        .collection('users')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: '$query\uf8ff')
        .get();

    final users = result.docs
        .map((doc) => UserModle.fromjson(doc.data()))
        .where((user) => user.uid != currentUserId) // استبعاد المستخدم الحالي
        .toList();

    return users;
  } 
}
