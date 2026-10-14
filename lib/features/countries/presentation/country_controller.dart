import 'package:get/get.dart';
import '../../../core/errors/app_exception.dart';
import '../data/country_model.dart';
import '../data/country_repository.dart';

class CountryController extends GetxController {
  final CountryRepository _repository;
  CountryController(this._repository);

  final countries = <Country>[].obs;
  final isLoading = false.obs;
  final errorMessage = RxnString();
  final searchQuery = ''.obs;
  bool _hasLoaded = false;

  List<Country> get filteredCountries {
    final query = searchQuery.value.trim().toLowerCase();
    if (query.isEmpty) return countries;
    return countries.where((country) => country.name.toLowerCase().contains(query)).toList();
  }

  @override
  void onInit() {
    super.onInit();
    loadCountries();
  }

  Future<void> loadCountries({bool force = false}) async {
    if (isLoading.value || (_hasLoaded && !force)) return;
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final result = await _repository.fetchCountries();
      countries.assignAll(result);
      _hasLoaded = true;
    } catch (error) {
      errorMessage.value = error is AppException ? error.message : 'Unexpected error. Please retry.';
    } finally {
      isLoading.value = false;
    }
  }

  void search(String value) => searchQuery.value = value;
}
