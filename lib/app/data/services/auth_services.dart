import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:convert';

import 'api_config.dart';

class AuthService {
  final GetStorage _storage = GetStorage();
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile', 'openid'],
    serverClientId:
        '941760787235-rpq7omdh2e0651jrpf8upiqj4r42lpm3.apps.googleusercontent.com', // <-- Web client ID
  );

  /// Standard login with email & password
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.loginUrl()),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 && body['token'] != null) {
        _storage.write('token', body['token']);
        return {'success': true, 'data': body};
      } else {
        return {'success': false, 'message': body['message'] ?? 'Login failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  /// Login using Google Sign-In
  Future<Map<String, dynamic>> loginWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        print('User cancelled sign in');
        return {'success': false, 'message': 'User cancelled sign-in'};
      }

      final googleAuth = await googleUser.authentication;

      print('accessToken: ${googleAuth.accessToken}');
      print('idToken: ${googleAuth.idToken}');

      final response = await http.post(
        Uri.parse(ApiConfig.googleLoginUrl()), // <-- Define this in ApiConfig
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'idToken': googleAuth.idToken}),
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 && body['token'] != null) {
        _storage.write('token', body['token']);
        return {'success': true, 'data': body};
      } else {
        return {
          'success': false,
          'message': body['message'] ?? 'Login Google gagal'
        };
      }
    } catch (e) {
      print(e);
      return {'success': false, 'message': 'Google login error: $e'};
    }
  }

  /// Retrieve token from local storage
  String? getToken() => _storage.read('token');

  /// Logout and clear token
  Future<Map<String, dynamic>> logout() async {
    try {
      final token = getToken();
      // print(token);
      if (token == null) {
        return {'success': false, 'message': 'Token tidak tersedia'};
      }

      final response = await http.get(
        Uri.parse(ApiConfig.logout()),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      _storage.remove('token');

      if (response.statusCode == 200) {
        return {'success': true};
      } else {
        final body = jsonDecode(response.body);
        print(body['message']);
        return {'success': false, 'message': body['message'] ?? 'Logout gagal'};
      }
    } catch (e) {
      print(e);
      return {'success': false, 'message': 'Logout error: $e'};
    }
  }
}
