import 'package:flutter_dotenv/flutter_dotenv.dart';

class Costants {
  final apiKey = dotenv.env['TMDB_API_KEY'];
}