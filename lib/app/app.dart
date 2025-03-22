import 'package:flutter_dotenv/flutter_dotenv.dart';

//this is to fetch the api key from my .env file
class AppConfig {
  static String get visionApiKey {
    assert(dotenv.env['GOOGLE_VISION_API_KEY'] != null,
    'Google Vision API key not found in .env file');
    return dotenv.env['GOOGLE_VISION_API_KEY']!;
  }
}