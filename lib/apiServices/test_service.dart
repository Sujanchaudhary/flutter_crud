import 'package:dio/dio.dart';

class test_service {
  final dio_init = Dio();
  final baseUrl = "http://localhost:3000";

  Future<Response> getDataFromApi(String endpoint) async {
    final response = await dio_init.post(endpoint);
    return response;
  }
}
