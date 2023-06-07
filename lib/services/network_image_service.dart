import 'dart:io';

import 'package:app3idade_caretaker/services/api.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class NetworkImageService {
  final baseUri = '/images';

  String buildFullUrl(int imageId) => 'http://${API.url}$baseUri/$imageId';

  Image createImageWidget(int imageId, {double? height, double? width, BoxFit? fit}) {
    return Image.network(
      buildFullUrl(imageId),
      headers: API.headerAuthorization,
      width: width,
      height: height,
      fit: fit,
    );
  }

  Future<List<File>> fetchImages(List<int> imageIds) async {
    final Directory tempDir = await getTemporaryDirectory();
    List<File> imageFiles = [];

    List<Future<File?>> futures = imageIds.map((id) async {
      String imageUrl = buildFullUrl(id);
      var response = await http.get(Uri.parse(imageUrl));
      if (API.isSuccessResponse(response)) {
        String filename = 'image_$id.jpg';
        File file = File('${tempDir.path}/$filename');
        await file.writeAsBytes(response.bodyBytes);
        return file;
      }
      return null;
    }).toList();

    List<File?> results = await Future.wait(futures);
    imageFiles = results.where((file) => file != null).cast<File>().toList();
    return imageFiles;
  }
}
