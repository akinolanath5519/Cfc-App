import 'dart:convert';
import 'package:agriproduce/state_management/auth_provider.dart';
import 'package:http/http.dart' as http;
import 'package:agriproduce/constant/config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthService {
  // Login Method
  Future<Map<String, dynamic>> login(String email, String password, WidgetRef ref) async {
    final response = await http.post(
      Uri.parse('${Config.baseUrl}/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // Check if the response contains the expected fields
      final responseData = jsonDecode(response.body);
      String token = responseData['token'] ?? ''; // Default to an empty string if null
      String role = responseData['role'] ?? '';   // Default to an empty string if null

      await saveToken(token, ref);
      print('Token received and stored: $token');
      return {
        'statusCode': response.statusCode,
        'role': role,
      };
    } else {
      print('Failed to log in. Status code: ${response.statusCode}');
      return {
        'statusCode': response.statusCode,
        'role': null,
      };
    }
  }

  // Register Method (Admin)
  Future<http.Response> registerAdmin(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('${Config.baseUrl}/register-admin'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );

    return response;
  }

  // Register Method (Standard User)
  Future<http.Response> registerStandardUser(String name, String email, String password, String adminEmail) async {
    final response = await http.post(
      Uri.parse('${Config.baseUrl}/register-standard'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'adminEmail': adminEmail,
      }),
    );

    return response;
  }

  // Logout Method
  Future<void> logout(WidgetRef ref) async {
    await clearToken(ref);
    print('User logged out and token deleted.');
  }
}
