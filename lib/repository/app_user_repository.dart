import 'dart:convert';

import 'package:app3idade_caretaker/models/app_user.dart';
import 'package:app3idade_caretaker/services/api.dart';
import 'package:http/http.dart' as http;

class AppUserRepository {
  final baseUri = '/appuser';

  Future<AppUser> findById(int id) async {
    final http.Response response = await http.get(Uri.http(API.url, '$baseUri/$id'));
    if (API.isSuccessResponse(response)) {
      return AppUser.fromJson(API.responseBodyToJson(response));
    } else {
      throw Exception('Erro buscando usuário: $id [code: ${response.statusCode}]');
    }
  }

  Future<List<AppUser>> findAll() async {
    final http.Response response = await http.get(Uri.http(API.url, baseUri));
    if (response.statusCode == 200) {
      return AppUser.fromJsonList(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Erro buscando todos os usuários.');
    }
  }

  Future<AppUser> create(AppUser user) async {
    final http.Response response = await http.post(
      Uri.http(API.url, baseUri),
      body: user.toJson(),
      headers: API.headerContentTypeJson,
    );
    if (API.isSuccessResponse(response)) {
      return AppUser.fromJson(response.body);
    } else {
      throw Exception('Erro inserindo usuário: ${response.body}');
    }
  }

  Future<AppUser> update(AppUser user) async {
    final http.Response response = await http.put(
      Uri.http(API.url, '$baseUri/${user.id}'),
      headers: API.headerContentTypeJson,
      body: user.toJson(),
    );
    if (API.isSuccessResponse(response)) {
      return AppUser.fromJson(response.body);
    } else {
      throw Exception('Erro alterando usuário ${user.id}: ${response.body}');
    }
  }

  Future<AppUser> deleteById(int id) async {
    final http.Response response =
        await http.delete(Uri.http(API.url, '$baseUri/$id'), headers: API.headerContentTypeJson);
    if (API.isSuccessResponse(response)) {
      return AppUser.fromJson(response.body);
    } else {
      throw Exception('Erro removendo usuário: $id.');
    }
  }
}
