import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

final ImagePicker _imagePicker = ImagePicker();

Future<File?> pickImage(ImageSource source, [int quality = 40]) async {
  final XFile? xfile = await _imagePicker.pickImage(source: source, imageQuality: quality);
  if (xfile == null) return null;
  File file = File(xfile.path);
  return file;
}

Future<File?> showGalleryCameraPicker(BuildContext context, [int quality = 40]) {
  return showModalBottomSheet<File>(
    context: context,
    builder: (BuildContext context) {
      return SizedBox(
        height: 180,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Escolha como selecionar a foto:'),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      var navigator = Navigator.of(context);
                      File? image = await pickImage(ImageSource.gallery, quality);
                      navigator.pop(image);
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.collections),
                        Text('Galeria'),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 32,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      var navigator = Navigator.of(context);
                      File? image = await pickImage(ImageSource.camera, quality);
                      navigator.pop(image);
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.camera_alt),
                        Text('Câmera'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
