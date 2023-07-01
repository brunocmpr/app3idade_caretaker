import 'dart:convert';

import 'package:app3idade_caretaker/exceptions/unauthorized_exception.dart';
import 'package:app3idade_caretaker/models/custom_posology.dart';
import 'package:app3idade_caretaker/models/drug_plan.dart';
import 'package:app3idade_caretaker/services/api.dart';
import 'package:http/http.dart' as http;

class CustomPosologyRepository {
  final baseUri = '/customposology';

  Future<DrugPlan> replaceAll(int drugPlanId, List<CustomPosology> customPosologies) async {
    final headers = API.headerContentTypeJson;
    headers.addAll(API.headerAuthorization);

    final http.Response response = await http.put(
      Uri.http(API.url, '$baseUri/$drugPlanId'),
      body: CustomPosology.toJsonList(customPosologies),
      headers: headers,
    );

    if (API.isSuccessResponse(response)) {
      return DrugPlan.fromJson(utf8.decode(response.bodyBytes));
    } else if (API.isUnauthorizedOrForbiddenResponse(response)) {
      throw UnauthorizedException(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Erro atualizando tratamento: ${response.body}');
    }
  }
}
