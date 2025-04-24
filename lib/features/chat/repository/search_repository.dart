import 'package:social_media_app/features/auth/data/model/user_modle.dart';
import 'package:social_media_app/features/chat/data/data_source/search_remote_data_source.dart';

class SearchRepository {
  final SearchRemoteDataSource _remoteDataSource = SearchRemoteDataSource();

  Future<List<UserModle>> searchUsers(String query, String currentUserId) {
    return _remoteDataSource.searchUsersByName(query, currentUserId);
  }
}
