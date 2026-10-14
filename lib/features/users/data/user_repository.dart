import 'package:dio/dio.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/network/api_client.dart';
import 'post_model.dart';
import 'user_model.dart';

class UserRepository {
  final ApiClient _client;
  UserRepository(this._client);

  Future<List<AppUser>> fetchUsers() async {
    try {
      final response = await _client.rest.get('/users');
      if (response.statusCode != 200 || response.data is! List) {
        throw const AppException('Users service returned an unsuccessful response.');
      }
      return (response.data as List).whereType<Map<String, dynamic>>().map(AppUser.fromJson).toList();
    } on DioException catch (error) {
      throw AppException(error.response?.statusCode != null
        ? 'Could not load users (HTTP ${error.response!.statusCode}).'
        : 'Network error while loading users. Check your connection.');
    } on AppException {
      rethrow;
    } catch (_) {
      throw const AppException('Unable to read user data. Please retry.');
    }
  }

  Future<List<UserPost>> fetchPosts(int userId) async {
    try {
      final response = await _client.rest.get('/posts', queryParameters: {'userId': userId});
      if (response.statusCode != 200 || response.data is! List) {
        throw const AppException('Posts service returned an unsuccessful response.');
      }
      return (response.data as List).whereType<Map<String, dynamic>>().map(UserPost.fromJson).toList();
    } on DioException catch (error) {
      throw AppException(error.response?.statusCode != null
        ? 'Could not load posts (HTTP ${error.response!.statusCode}).'
        : 'Network error while loading posts. Check your connection.');
    } on AppException {
      rethrow;
    } catch (_) {
      throw const AppException('Unable to read post data. Please retry.');
    }
  }
  Future<UserPost> fetchPost(int postId) async {
    try {
      final response = await _client.rest.get('/posts/$postId');
      if (response.statusCode != 200 || response.data is! Map<String, dynamic>) {
        throw const AppException('Post service returned an unsuccessful response.');
      }
      return UserPost.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (error) {
      throw AppException(error.response?.statusCode != null
          ? 'Could not load post (HTTP ${error.response!.statusCode}).'
          : 'Network error while loading the post. Check your connection.');
    } on AppException {
      rethrow;
    } catch (_) {
      throw const AppException('Unable to read post data. Please retry.');
    }
  }

}
