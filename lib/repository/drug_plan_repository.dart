import 'dart:convert';

import 'package:app3idade_caretaker/exceptions/unauthorized_exception.dart';
import 'package:app3idade_caretaker/models/drug_plan.dart';
import 'package:app3idade_caretaker/services/api.dart';
import 'package:http/http.dart' as http;

class DrugPlanRepository {
  final baseUri = '/plan';

  Future<DrugPlan> createDrugPLan(DrugPlan drugPlan) async {
    final headers = API.headerContentTypeJson;
    headers.addAll(API.headerAuthorization);

    final http.Response response = await http.post(
      Uri.http(API.url, baseUri),
      body: drugPlan.toJson(),
      headers: headers,
    );

    if (API.isSuccessResponse(response)) {
      return DrugPlan.fromJson(response.body);
    } else if (API.isUnauthorizedOrForbiddenResponse(response)) {
      throw UnauthorizedException(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Erro inserindo usuário: ${response.body}');
    }
  }

  Future<List<DrugPlan>> findAll() async {
    final http.Response response = await http.get(
      Uri.http(API.url, baseUri),
      headers: API.headerAuthorization,
    );
    if (API.isSuccessResponse(response)) {
      return DrugPlan.fromJsonList(utf8.decode(response.bodyBytes));
    } else if (API.isUnauthorizedOrForbiddenResponse(response)) {
      throw UnauthorizedException(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Erro buscando todos os usuários.');
    }
  }
}
