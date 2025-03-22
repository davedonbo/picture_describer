import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import '../services/vision_service.dart';
import '../services/tts_service.dart';
import '../services/image_service.dart';
import '../widgets/control_buttons.dart';
import '../widgets/image_preview.dart';
import '../widgets/description_section.dart';

class MainScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const MainScreen({super.key, required this.cameras});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  File? _image;
  String _description = '';
  bool _isLoading = false;
  final TtsService _ttsService = TtsService();
  final ImageService _imageService = ImageService();
  final VisionService _visionService = VisionService();

  Future<void> _processImage(File image) async {
    setState(() {
      _isLoading = true;
      _description = '';
    });

    try {
      final base64Image = base64Encode(await image.readAsBytes());
      final description = await _visionService.analyzeImage(base64Image);
      setState(() => _description = description);
      _ttsService.speak(description);
    } catch (e) {
      setState(() => _description = 'Error processing image: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _takePhoto() async {
    final image = await _imageService.pickImage(ImageSource.camera);
    if (image != null) {
      _image = image;
      await _processImage(_image!);
    }
  }

  Future<void> _pickImage() async {
    final image = await _imageService.pickImage(ImageSource.gallery);
    if (image != null) {
      _image = image;
      await _processImage(_image!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Picture Describer'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ControlButtons(
              onTakePhoto: _takePhoto,
              onPickImage: _pickImage,
            ),
            const SizedBox(height: 20),
            ImagePreview(image: _image),
            const SizedBox(height: 20),
            DescriptionSection(
              isLoading: _isLoading,
              description: _description,
              onSpeak: () => _ttsService.speak(_description),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _ttsService.stop();
    super.dispose();
  }
}