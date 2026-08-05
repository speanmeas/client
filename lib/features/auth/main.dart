import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// ហៅ API ភ្ជាប់ទៅ backend សម្រាប់ការចុះឈ្មោះ និងចូលប្រើប្រាស់ (TCS)
class AuthService {
  static const String baseUrl = 'http://127.0.0.1:8000';
  static const String signupPath = '/auth/sign_up';
  static const String signinPath = '/auth/sign_in';
  static const String signoutPath = '/auth/sign_out';

  static String? _accessToken;
  static String? _tokenType;
  static String? _username;

  static Future<String> signup({required String username, required String password, required String fullName, required String phoneNumber}) async {
    final response = await http.post(
      Uri.parse('$baseUrl$signupPath'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'username': username, 'password': password, 'full_name': fullName, 'phone_number': phoneNumber},
    );

    if (response.statusCode == 200) {
      try {
        return jsonDecode(response.body) as String;
      } catch (_) {
        return response.body;
      }
    } else {
      throw Exception(response.body);
    }
  }

  static Future<String> signin({required String username, required String password}) async {
    final response = await http.post(Uri.parse('$baseUrl$signinPath'), headers: {'Content-Type': 'application/x-www-form-urlencoded'}, body: {'username': username, 'password': password});

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      _accessToken = json['access_token'] as String?;
      _tokenType = json['token_type'] as String?;
      _username = username;
      debugPrint('Token after signin: $_accessToken');
      return response.body;
    } else {
      throw Exception(response.body);
    }
  }

  static Future<String> signout() async {
    if (_accessToken == null) {
      throw Exception('No signed-in user found.');
    }

    final response = await http.post(Uri.parse('$baseUrl$signoutPath'), headers: {'Authorization': '${_tokenType ?? 'bearer'} $_accessToken'});

    if (response.statusCode == 200) {
      _accessToken = null;
      _tokenType = null;
      _username = null;
      try {
        return jsonDecode(response.body) as String;
      } catch (_) {
        return response.body;
      }
    } else {
      throw Exception(response.body);
    }
  }
}
