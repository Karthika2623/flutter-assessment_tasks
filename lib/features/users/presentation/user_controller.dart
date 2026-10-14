import 'package:get/get.dart';
import '../../../core/errors/app_exception.dart';
import '../data/post_model.dart';
import '../data/user_model.dart';
import '../data/user_repository.dart';

class UserController extends GetxController {
  final UserRepository _repository;
  UserController(this._repository);

  final users = <AppUser>[].obs;
  final isLoading = false.obs;
  final errorMessage = RxnString();
  final searchQuery = ''.obs;
  bool _hasLoaded = false;

  List<AppUser> get filteredUsers {
    final query = searchQuery.value.trim().toLowerCase();
    if (query.isEmpty) return users;
    return users.where((user) => user.name.toLowerCase().contains(query)).toList();
  }

  @override
  void onInit() {
    super.onInit();
    loadUsers();
  }

  Future<void> loadUsers({bool force = false}) async {
    if (isLoading.value || (_hasLoaded && !force)) return;
    isLoading.value = true;
    errorMessage.value = null;
    try {
      users.assignAll(await _repository.fetchUsers());
      _hasLoaded = true;
    } catch (error) {
      errorMessage.value = error is AppException ? error.message : 'Unexpected error. Please retry.';
    } finally {
      isLoading.value = false;
    }
  }

  void search(String value) => searchQuery.value = value;

  Future<List<UserPost>> loadPosts(int userId) => _repository.fetchPosts(userId);
}
