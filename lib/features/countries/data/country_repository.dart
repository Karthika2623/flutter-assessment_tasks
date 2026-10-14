import '../../../core/errors/app_exception.dart';
import '../../../core/network/api_client.dart';
import 'country_model.dart';

class CountryRepository {
  final ApiClient _client;
  CountryRepository(this._client);

  Future<List<Country>> fetchCountries() async {
    const query = r'''
      query GetCountries {
        countries {
          code
          name
          capital
          continent { name }
        }
      }
    ''';
    try {
      final response = await _client.graphQl.post('', data: {'query': query});
      final body = response.data;
      if (body is! Map<String, dynamic>) throw const AppException('Unexpected response from countries service.');
      if (body['errors'] is List && (body['errors'] as List).isNotEmpty) {
        final first = (body['errors'] as List).first;
        final message = first is Map ? first['message']?.toString() : null;
        throw AppException(message ?? 'Countries service returned an error.');
      }
      final data = body['data'];
      final list = data is Map ? data['countries'] : null;
      if (list is! List) throw const AppException('Countries data was missing or invalid.');
      return list.whereType<Map<String, dynamic>>().map(Country.fromJson).toList()
        ..sort((a, b) => a.name.compareTo(b.name));
    } on AppException {
      rethrow;
    } catch (_) {
      throw const AppException('Unable to load countries. Check your connection and retry.');
    }
  }
}
