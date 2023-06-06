import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app3idade_caretaker/exceptions/unauthorized_exception.dart';
import 'package:app3idade_caretaker/models/drug.dart';
import 'package:app3idade_caretaker/services/api.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class DrugRepository {
  static const baseUri = '/drug';

  Future<Drug> create(Drug drug, List<File>? images) async {
    var request = http.MultipartRequest('POST', Uri.http(API.url, baseUri));
    request.headers.addAll(API.headerAuthorization);
    request.headers.addAll(API.headerContentTypeJson);

    request.fields['drugForm'] = drug.toJson();

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
      return Drug.fromMap(responseMap);
    } else if (API.isUnauthorizedOrForbiddenResponse(response)) {
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      throw UnauthorizedException(responseString);
    } else {
      throw Exception('Erro inserindo medicamento: $responseString');
    }
  }

  Future<List<Drug>> findAll() async {
    final http.Response response = await http.get(
      Uri.http(API.url, baseUri),
      headers: API.headerAuthorization,
    );
    if (API.isSuccessResponse(response)) {
      return Drug.fromJsonList(utf8.decode(response.bodyBytes));
    } else if (API.isUnauthorizedOrForbiddenResponse(response)) {
      throw UnauthorizedException(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Erro buscando todos os medicamentos.');
    }
  }

  Future<Drug> deleteById(int id) async {
    final headers = API.headerAuthorization;

    final http.Response response = await http.delete(
      Uri.http(API.url, baseUri, {'id': '$id'}),
      headers: headers,
    );
    if (API.isSuccessResponse(response)) {
      return Drug.fromJson(response.body);
    } else if (API.isUnauthorizedOrForbiddenResponse(response)) {
      throw UnauthorizedException(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Erro removendo medicamento: $id.');
    }
  }
}
