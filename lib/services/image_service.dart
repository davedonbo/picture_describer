import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImageService {
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickImage(ImageSource source) async {
    final image = await _picker.pickImage(source: source);
    return image != null ? File(image.path) : null;
  }
}