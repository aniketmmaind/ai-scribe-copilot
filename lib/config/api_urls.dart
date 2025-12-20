// api URL end point
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppUrls {
  //retrive BASE_URL from .env store just for testing
  static String baseUrl = dotenv.env['BASE_URL'] ?? "";
}
