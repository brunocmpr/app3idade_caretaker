import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;

import 'api.dart';

class AuthService {
  final _authEndpoint = '/auth';
  final _tokenType = 'tokenType';
  final _accessToken = 'accessToken';
  final _tokenStorageKey = 'token';

  final mobileStorage = const FlutterSecureStorage();

  Future<String?> login(String email, String password) async {
    final response = await http.post(Uri.http(API.url, _authEndpoint),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }));

    if (response.statusCode == 200) {
      final token =
          '${jsonDecode(response.body)[_tokenType] as String} ${jsonDecode(response.body)[_accessToken] as String}';
      await saveToken(token);
      return token;
    } else {
      return null;
    }
  }

  Future<void> saveToken(String token) async {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        await mobileStorage.write(key: _tokenStorageKey, value: token);
      } else {
        final desktopStorage = await SharedPreferences.getInstance();
        await desktopStorage.setString(_tokenStorageKey, token);
      }
    } catch (e) {
      final asd = 1;
    }
  }

  Future<String?> getToken() async {
    if (Platform.isAndroid || Platform.isIOS) {
      return await mobileStorage.read(key: _tokenStorageKey);
    } else {
      final desktopStorage = await SharedPreferences.getInstance();
      return desktopStorage.getString(_tokenStorageKey);
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> logout() async {
    await mobileStorage.delete(key: _tokenStorageKey);
  }
}
