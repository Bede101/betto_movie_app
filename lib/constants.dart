import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constants {
  static final apiKey = dotenv.env['TMDB_API_KEY'];
  static final apiUrl = 'https://api.themoviedb.org/3';
  static final posterUrl = 'https://image.tmdb.org/t/p/w500';
}