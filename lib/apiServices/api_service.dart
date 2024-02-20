// api_service.dart
import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio();
  final String baseUrl =
      'https://64855cb4a795d24810b6de57.mockapi.io'; // Set your base URL here

  Future<Response> fetchDataFromAPI(String endpoint) async {
    try {
      final response = await _dio.get('$baseUrl/$endpoint');
      return response;
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  Future<Response> addDataToAPI(String endpoint, Map data) async {
    try {
      final response = await _dio.post('$baseUrl/$endpoint', data: data);
      return response;
    } catch (e) {
      throw Exception('failed to add data: $e');
    }
  }

  Future<Response> fetchDataSingleFromAPI(String endpoint, int id) async {
    try {
      final response = await _dio.get('$baseUrl/$endpoint/$id');
      return response;
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  Future<Response> deleteDataFromAPI(String endpoint, int id) async {
    try {
      final response = await _dio.delete('$baseUrl/$endpoint/$id');
      return response;
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  Future<Response> editDataFromAPI(String endpoint, String id, Map obj) async {
    try {
      final response = await _dio.put('$baseUrl/$endpoint/$id', data: obj);
      return response;
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }
}
