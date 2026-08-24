import 'dart:convert';

import 'package:betto_movie_app/constants.dart';
import 'package:betto_movie_app/models/movie.dart';
import 'package:http/http.dart' as http;

class TMDBService {
  Future<List<Movie>> getMovies () async {
    final uri = Uri.parse("${Constants.apiUrl}trending/movie/");
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer ${Constants.apiKey}',
        'accept': 'application/json' 
      }
    );
    if (response.statusCode != 200) {
      throw Exception('Errore durante la getMovies');
    }
    final data = jsonDecode(response.body);
    final List<dynamic> results = data['results'];
    final List<Movie> movies = results.map((row) => Movie.fromJson(row)).toList();
    return movies;
  }
}

