import 'package:flutter/material.dart';
import 'package:social_media_app/features/auth/data/model/user_modle.dart';
import 'package:social_media_app/features/chat/repository/search_repository.dart';

class SearchViewModel extends ChangeNotifier {
  final SearchRepository _repository = SearchRepository();

  List<UserModle> _results = [];
  List<UserModle> get results => _results;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? currentUserId; // لتخزين currentUserId

  // دالة لضبط currentUserId
  void setCurrentUserId(String? id) {
    currentUserId = id;
  }

  Future<void> search(String query) async {
    if (currentUserId == null) return; // تأكد من أنه يوجد currentUserId
    _isLoading = true;
    notifyListeners();

    _results = await _repository.searchUsers(query, currentUserId!); // تمرير currentUserId

    _isLoading = false;
    notifyListeners();
  }
}
