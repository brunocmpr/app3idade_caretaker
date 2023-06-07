import 'dart:convert';
import 'dart:io';

import 'package:app3idade_caretaker/exceptions/unauthorized_exception.dart';
import 'package:app3idade_caretaker/models/patient.dart';
import 'package:app3idade_caretaker/services/api.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

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

  Future<Patient> create(Patient patient, List<File>? images) async {
    var request = http.MultipartRequest('POST', Uri.http(API.url, baseUri));
    request.headers.addAll(API.headerAuthorization);

    request.fields['form'] = patient.toJson();

    if (images != null) {
      for (int i = 0; i < images.length && i < 4; i++) {
        final file = await images[i].readAsBytes();
        final fileExtension = images[i].path.split('/').last.split('.').last;
        //TODO provide MediaType for http.MultipartFile.fromBytes
        request.files.add(http.MultipartFile.fromBytes('images', file, filename: 'image$i.$fileExtension'));
      }
    }

    StreamedResponse response = await request.send();
    var responseBytes = await response.stream.toBytes();
    var responseString = utf8.decode(responseBytes);

    if (API.isSuccessResponse(response)) {
      var responseMap = jsonDecode(responseString);
      return Patient.fromMap(responseMap);
    } else if (API.isUnauthorizedOrForbiddenResponse(response)) {
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      throw UnauthorizedException(responseString);
    } else {
      throw Exception('Erro inserindo paciente: $responseString');
    }
  }

  Future<Patient> update(Patient patient, List<File>? images) async {
    var request = http.MultipartRequest('PUT', Uri.http(API.url, baseUri));
    request.headers.addAll(API.headerAuthorization);

    request.fields['form'] = patient.toJson();

    if (images != null) {
      for (int i = 0; i < images.length && i < 4; i++) {
        final file = await images[i].readAsBytes();
        final fileExtension = images[i].path.split('/').last.split('.').last;
        //TODO provide MediaType for http.MultipartFile.fromBytes
        request.files.add(http.MultipartFile.fromBytes('images', file, filename: 'image$i.$fileExtension'));
      }
    }

    StreamedResponse response = await request.send();
    var responseBytes = await response.stream.toBytes();
    var responseString = utf8.decode(responseBytes);

    if (API.isSuccessResponse(response)) {
      var responseMap = jsonDecode(responseString);
      return Patient.fromMap(responseMap);
    } else if (API.isUnauthorizedOrForbiddenResponse(response)) {
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      throw UnauthorizedException(responseString);
    } else {
      throw Exception('Erro inserindo paciente: $responseString');
    }
  }

  Future<Patient> deleteById(int id) async {
    final headers = API.headerAuthorization;

    final http.Response response = await http.delete(
      Uri.http(API.url, baseUri, {'id': '$id'}),
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
