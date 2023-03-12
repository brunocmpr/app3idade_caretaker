import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

class API {
  static const String url = "app3idade.herokuapp.com";

  static String responseBodyToJson(Response response) => utf8.decode(response.bodyBytes);

  static const Map<String, String> headerContentTypeJson = {'Content-Type': 'application/json; charset=UTF-8'};

  static bool isSuccessResponse(Response response) => (200 <= response.statusCode && response.statusCode <= 299);
  static bool isClientErrorResponse(Response response) => (400 <= response.statusCode && response.statusCode <= 499);
  static bool isServerErrorResponse(Response response) => (500 <= response.statusCode && response.statusCode <= 599);
  static bool isUnauthorizedOrForbiddenResponse(Response response) =>
      (response.statusCode == 401 || response.statusCode == 403);
}
