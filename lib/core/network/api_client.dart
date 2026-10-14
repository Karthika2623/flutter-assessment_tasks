import 'package:dio/dio.dart';

class ApiClient {
  late final Dio rest;
  late final Dio graphQl;

  ApiClient() {
    rest = Dio(BaseOptions(
      baseUrl: 'https://jsonplaceholder.typicode.com',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
      headers: {'Accept': 'application/json'},
    ));
    graphQl = Dio(BaseOptions(
      baseUrl: 'https://countries.trevorblades.com/',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
    ));
  }
}
