import 'dart:convert';
import '../config/baseurl.dart';
import 'package:http/http.dart' as http;

class AuthService {
  // 로그인 요청
  static Future<Map<String, dynamic>> login(String email, String password) async {
    Uri loginUri = Uri.parse(Baseurl.baseurl + '/login');
    final response = await http.post(
      loginUri,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'accessToken': data['accessToken'],
        'refreshToken': data['refreshToken'],
        'statusCode': response.statusCode
      };
    } else {
      return {
        'error': response.body,
        'statusCode': response.statusCode
      };
    }
  }

  // 회원가입 요청
  static Future<Map<String, dynamic>> register({
    required String username,
    required String password,
    required String email,
    required String birthDate,
  }) async {
    Uri signUpUri = Uri.parse(Baseurl.baseurl + '/signUp');
    final response = await http.post(
      signUpUri,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
        'nickname': username,
        'birth': birthDate,
      }),
    );

    if (response.statusCode == 200) {
      return {
        'message': 'User registered successfully',
        'statusCode': response.statusCode
      };
    } else {
      return {
        'error': response.body,
        'statusCode': response.statusCode
      };
    }
  }
}