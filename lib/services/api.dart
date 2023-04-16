import 'dart:convert';

import 'package:app3idade_caretaker/services/token_buffer.dart';
import 'package:http/http.dart';

class API {
  static const String url = "192.168.200.200:8080";

  static String responseBodyToJson(Response response) => utf8.decode(response.bodyBytes);

  static Map<String, String> headerContentTypeJson = {'Content-Type': 'application/json; charset=UTF-8'};
  static Map<String, String> get headerAuthorization => {'Authorization': TokenBuffer().token};

  static bool isSuccessResponse(BaseResponse response) => (200 <= response.statusCode && response.statusCode <= 299);
  static bool isClientErrorResponse(BaseResponse response) =>
      (400 <= response.statusCode && response.statusCode <= 499);
  static bool isServerErrorResponse(BaseResponse response) =>
      (500 <= response.statusCode && response.statusCode <= 599);
  static bool isUnauthorizedOrForbiddenResponse(BaseResponse response) =>
      (response.statusCode == 401 || response.statusCode == 403);
}
