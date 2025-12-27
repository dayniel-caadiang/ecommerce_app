import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

class ApiService {
  static const String baseUrl = 'https://fakestoreapi.com';
  static const Duration timeoutDuration = Duration(seconds: 10);

  Future<List<Product>> getAllProducts() async {
    try {
      final uri = Uri.parse('$baseUrl/products');
      final response = await http
          .get(uri)
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Product.fromJson(json)).toList();
      } else {
        throw ApiException(
            'Failed to load products. Status code: ${response.statusCode}');
      }
    } on TimeoutException {
      throw ApiException('Request timed out. Please check your connection.');
    } on http.ClientException {
      throw ApiException('Network error. Please check your internet connection.');
    } catch (e) {
      throw ApiException('An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<Product> getProductById(int id) async {
    try {
      final uri = Uri.parse('$baseUrl/products/$id');
      final response = await http
          .get(uri)
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return Product.fromJson(jsonData);
      } else if (response.statusCode == 404) {
        throw ApiException('Product not found.');
      } else {
        throw ApiException(
            'Failed to load product. Status code: ${response.statusCode}');
      }
    } on TimeoutException {
      throw ApiException('Request timed out. Please check your connection.');
    } on http.ClientException {
      throw ApiException('Network error. Please check your internet connection.');
    } catch (e) {
      throw ApiException('An unexpected error occurred: ${e.toString()}');
    }
  }
}
