import 'dart:io';
import 'package:flutter/material.dart';

//class to handle preliminary view of uploaded images before they are sent for processing at google vision api.
class ImagePreview extends StatelessWidget {
  final File? image;

  const ImagePreview({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return image != null
        ? Semantics(
      image: true,
      label: 'Selected image preview',
      child: Image.file(
        image!,
        height: 200,
        fit: BoxFit.cover,
      ),
    )
        : const Text(
      'No image selected',
      style: TextStyle(fontSize: 18),
      semanticsLabel: 'No image selected',
    );
  }
}