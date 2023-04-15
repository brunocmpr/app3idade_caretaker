import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app3idade_caretaker/exceptions/unauthorized_exception.dart';
import 'package:app3idade_caretaker/models/drug.dart';
import 'package:app3idade_caretaker/services/api.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

class DrugRepository {
  static const baseUri = '/drug';

  Future<Drug> create(Drug drug, List<XFile>? images) async {
    var request = http.MultipartRequest('POST', Uri.http(API.url, baseUri));

    request.fields['drugForm'] = drug.toJson();

    if (images != null) {
      for (int i = 0; i < images.length && i < 4; i++) {
        final file = await images[i].readAsBytes();
        request.files.add(http.MultipartFile.fromBytes('images', file, filename: 'image$i'));
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
}
