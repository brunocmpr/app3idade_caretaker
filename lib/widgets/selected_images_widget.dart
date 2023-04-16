import 'dart:io';

import 'package:flutter/material.dart';

class SelectedImagesWidget extends StatelessWidget {
  final List<File> images;
  final Function(int) onImageRemoved;

  const SelectedImagesWidget({super.key, required this.images, required this.onImageRemoved});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Imagens selecionadas:'),
        const SizedBox(height: 8.0),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: images.asMap().entries.map(buildSelectedImage).toList(),
        ),
      ],
    );
  }

  Stack buildSelectedImage(entry) => Stack(
        children: [
          Image.file(entry.value, height: 100, width: 100, fit: BoxFit.cover),
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
                onTap: () {
                  onImageRemoved(entry.key);
                },
                child: Container(
                  decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                  child: const Icon(Icons.close),
                )),
          ),
        ],
      );
}
