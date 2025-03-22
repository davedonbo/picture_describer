import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../app/app.dart';

class VisionService {
  late final String _visionApiUrl =
      'https://vision.googleapis.com/v1/images:annotate?key=${AppConfig.visionApiKey}';

  // Future<String> analyzeImage(String base64Image) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse(_visionApiUrl),
  //       body: jsonEncode({
  //         'requests': [
  //           {
  //             'image': {'content': base64Image},
  //             'features': [
  //               {'type': 'LABEL_DETECTION', 'maxResults': 10},
  //               {'type': 'TEXT_DETECTION', 'maxResults': 10},
  //               {'type': 'IMAGE_PROPERTIES'},
  //             ],
  //           }
  //         ],
  //       }),
  //     );
  //
  //     return _parseVisionResponse(jsonDecode(response.body));
  //   } catch (e) {
  //     throw Exception('Error analyzing image: $e');
  //   }
  // }

  Future<String> analyzeImage(String base64Image) async {
    try {
      final response = await http.post(
        Uri.parse(_visionApiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'requests': [
            {
              'image': {'content': base64Image},
              'features': [
                {'type': 'LABEL_DETECTION', 'maxResults': 10},
                {'type': 'TEXT_DETECTION', 'maxResults': 10},
                {'type': 'IMAGE_PROPERTIES'},
              ],
            }
          ],
        }),
      );

      print('VISION API RAW RESPONSE: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception('Vision API error: ${response.body}');
      }

      return _parseVisionResponse(jsonDecode(response.body));
    } catch (e) {
      throw Exception('Error analyzing image: $e');
    }
  }


  String _parseVisionResponse(Map<String, dynamic> response) {
    final responseContent = response['responses']?[0];
    if (responseContent == null) {
      return 'No response received from Vision API.';
    }

    final labelAnnotations = responseContent['labelAnnotations'] as List<dynamic>?;
    final textAnnotations = responseContent['textAnnotations'] as List<dynamic>?;
    final imageProperties = responseContent['imagePropertiesAnnotation'] as Map<String, dynamic>?;

    final labels = labelAnnotations?.map((label) => label['description'] as String).toList();
    final text = textAnnotations?.map((t) => t['description'] as String).toList();
    final colors = imageProperties?['dominantColors']?['colors']
        ?.map((color) =>
    'RGB(${color['color']['red']}, ${color['color']['green']}, ${color['color']['blue']})')
        ?.toList();

    final description = StringBuffer();
    description.writeln('This image contains:');
    description.writeln('• ${(labels ?? []).take(5).join(', ')}');

    if ((text?.isNotEmpty ?? false)) {
      description.writeln('\nDetected text: ${text!.first}');
    }
    if ((colors?.isNotEmpty ?? false)) {
      description.writeln('\nMain colors: ${colors!.take(3).join(', ')}');
    }

    if ((labels == null || labels.isEmpty) &&
        (text == null || text.isEmpty) &&
        (colors == null || colors.isEmpty)) {
      description.writeln('\nNo significant features were detected.');
    }

    return description.toString();
  }


}