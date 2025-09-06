import 'package:flutter_dotenv/flutter_dotenv.dart';

String get api => dotenv.env['API_KEY'] ?? '';
String get geminiapi => dotenv.env['GEMINI_API_KEY'] ?? '';