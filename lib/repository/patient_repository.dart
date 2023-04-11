import 'dart:convert';

import 'package:app3idade_caretaker/exceptions/unauthorized_exception.dart';
import 'package:app3idade_caretaker/models/patient.dart';
import 'package:app3idade_caretaker/services/api.dart';
import 'package:http/http.dart' as http;

class PatientRepository {
  final baseUri = '/patient';

  Future<Patient> findById(int id) async {
    final http.Response response = await http.get(
      Uri.http(API.url, '$baseUri/$id'),
      headers: API.headerAuthorization,
    );
    if (API.isSuccessResponse(response)) {
      return Patient.fromJson(API.responseBodyToJson(response));
    } else if (API.isUnauthorizedOrForbiddenResponse(response)) {
      throw UnauthorizedException(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Erro buscando usuário: $id [code: ${response.statusCode}]');
    }
  }

  Future<List<Patient>> findAll() async {
    final http.Response response = await http.get(
      Uri.http(API.url, baseUri),
      headers: API.headerAuthorization,
    );
    if (API.isSuccessResponse(response)) {
      return Patient.fromJsonList(utf8.decode(response.bodyBytes));
    } else if (API.isUnauthorizedOrForbiddenResponse(response)) {
      throw UnauthorizedException(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Erro buscando todos os usuários.');
    }
  }

  Future<Patient> create(Patient patient) async {
    final headers = API.headerContentTypeJson;
    headers.addAll(API.headerAuthorization);

    final http.Response response = await http.post(
      Uri.http(API.url, baseUri),
      body: patient.toJson(),
      headers: headers,
    );

    if (API.isSuccessResponse(response)) {
      return Patient.fromJson(response.body);
    } else if (API.isUnauthorizedOrForbiddenResponse(response)) {
      throw UnauthorizedException(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Erro inserindo usuário: ${response.body}');
    }
  }

  Future<Patient> update(Patient patient) async {
    final headers = API.headerContentTypeJson;
    headers.addAll(API.headerAuthorization);

    final http.Response response = await http.put(
      Uri.http(API.url, '$baseUri/${patient.id}'),
      headers: headers,
      body: patient.toJson(),
    );
    if (API.isSuccessResponse(response)) {
      return Patient.fromJson(response.body);
    } else if (API.isUnauthorizedOrForbiddenResponse(response)) {
      throw UnauthorizedException(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Erro alterando usuário ${patient.id}: ${response.body}');
    }
  }

  Future<Patient> deleteById(int id) async {
    final headers = API.headerContentTypeJson;
    headers.addAll(API.headerAuthorization);

    final http.Response response = await http.delete(
      Uri.http(API.url, '$baseUri/$id'),
      headers: headers,
    );
    if (API.isSuccessResponse(response)) {
      return Patient.fromJson(response.body);
    } else if (API.isUnauthorizedOrForbiddenResponse(response)) {
      throw UnauthorizedException(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Erro removendo usuário: $id.');
    }
  }
}
