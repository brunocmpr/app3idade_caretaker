import 'dart:convert';
import 'package:app3idade_caretaker/routes/routes.dart';
import 'package:flutter/material.dart';

import 'package:app3idade_caretaker/services/token_buffer.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;

import 'api.dart';

class AuthService {
  final _authEndpoint = '/auth';
  final _tokenType = 'tokenType';
  final _accessToken = 'accessToken';

  final _tokenBuffer = TokenBuffer();

  final _tokenStorageKey = 'token';
  final mobileStorage = const FlutterSecureStorage();

  Future<String?> login(String email, String password) async {
    final response = await _loginToBackend(email, password)
        .timeout(const Duration(seconds: 20), onTimeout: () => http.Response('Error', 408));
    return await _treatLoginResponse(response);
  }

  Future<String?> getToken() async {
    if (_tokenBuffer.isTokenAvailable()) {
      return _tokenBuffer.token;
    }
    String? token;
    if (Platform.isAndroid || Platform.isIOS) {
      token = await mobileStorage.read(key: _tokenStorageKey);
    } else {
      final desktopStorage = await SharedPreferences.getInstance();
      token = desktopStorage.getString(_tokenStorageKey);
    }
    _tokenBuffer.token = token ?? "";
    return token;
  }

  Future<bool> isLoggedIn() async {
    final String? token = await getToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> logoutAndGoToLogin(BuildContext context) async {
    var navigator = Navigator.of(context);
    await _clearToken();
    navigator.pushNamedAndRemoveUntil(Routes.login, (route) => false);
  }

  Future<void> _clearToken() async {
    _tokenBuffer.clear();
    if (Platform.isAndroid || Platform.isIOS) {
      await mobileStorage.delete(key: _tokenStorageKey);
    } else {
      final desktopStorage = await SharedPreferences.getInstance();
      await desktopStorage.remove(_tokenStorageKey);
    }
  }

  Future<void> _saveToken(String token) async {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        await mobileStorage.write(key: _tokenStorageKey, value: token);
      } else {
        final desktopStorage = await SharedPreferences.getInstance();
        await desktopStorage.setString(_tokenStorageKey, token);
      }
      _tokenBuffer.token = token;
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> _treatLoginResponse(http.Response response) async {
    if (response.statusCode == 200) {
      final token =
          '${jsonDecode(response.body)[_tokenType] as String} ${jsonDecode(response.body)[_accessToken] as String}';
      await _saveToken(token);
      return token;
    } else if (response.statusCode == 408) {
      throw Exception('Tempo de conexão esgotado');
    }
    return null;
  }

  Future<http.Response> _loginToBackend(String email, String password) {
    return http.post(
      Uri.http(API.url, _authEndpoint),
      headers: API.headerContentTypeJson,
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );
  }
}
