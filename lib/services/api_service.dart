import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/product_model.dart';
import '../models/user_model.dart';

class ApiService {
  static const String baseUrl = 'https://task.itprojects.web.id';
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  // ---------- Token Management ----------

  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  static Future<void> deleteToken() async {
    await _storage.delete(key: 'auth_token');
  }

  static Future<void> saveUser(Map<String, dynamic> userData) async {
    await _storage.write(key: 'user_data', value: jsonEncode(userData));
  }

  static Future<Map<String, dynamic>?> getSavedUser() async {
    final raw = await _storage.read(key: 'user_data');
    if (raw == null) return null;
    return jsonDecode(raw);
  }

  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  // ---------- Auth ----------

  static Future<Map<String, dynamic>> login(
      String username, String password) async {
    final url = Uri.parse('$baseUrl/api/auth/login');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'username': username, 'password': password}),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data['success'] == true) {
      return {'success': true, 'data': data['data']};
    } else {
      return {
        'success': false,
        'message': data['message'] ?? 'Login gagal',
      };
    }
  }

  // ---------- Products ----------

  static Future<List<ProductModel>> getProducts() async {
    final token = await getToken();
    final url = Uri.parse('$baseUrl/api/products');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List productsJson = data['data']['products'] ?? [];
      return productsJson.map((e) => ProductModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal mengambil produk');
    }
  }

  static Future<Map<String, dynamic>> addProduct({
    required String name,
    required int price,
    required String description,
  }) async {
    final token = await getToken();
    final url = Uri.parse('$baseUrl/api/products');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'price': price,
        'description': description,
      }),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return {'success': true, 'data': data['data']};
    } else {
      return {
        'success': false,
        'message': data['message'] ?? 'Gagal menambahkan produk',
      };
    }
  }

  static Future<Map<String, dynamic>> deleteProduct(int productId) async {
    final token = await getToken();
    final url = Uri.parse('$baseUrl/api/products/$productId');
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return {'success': true};
    } else {
      return {
        'success': false,
        'message': data['message'] ?? 'Gagal menghapus produk',
      };
    }
  }

  // ---------- Submit Tugas ----------

  static Future<Map<String, dynamic>> submitTugas({
    required String name,
    required int price,
    required String description,
    required String githubUrl,
  }) async {
    final token = await getToken();
    final url = Uri.parse('$baseUrl/api/products/submit');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'price': price,
        'description': description,
        'github_url': githubUrl,
      }),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return {'success': true, 'data': data['data']};
    } else {
      return {
        'success': false,
        'message': data['message'] ?? 'Gagal submit tugas',
      };
    }
  }
}