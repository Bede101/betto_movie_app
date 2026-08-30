import 'dart:convert';
import 'package:betto_movie_app/constants.dart';
import 'package:betto_movie_app/models/movie.dart';
import 'package:betto_movie_app/models/trailer.dart';
import 'package:betto_movie_app/services/favourite_service.dart';
import 'package:http/http.dart' as http;

//Definiamo il servizio di chiamata dei film popolari
class TMDBService {
  FavouriteService favouriteService = FavouriteService();

  Future<List<Movie>> getMovies () async {
    //Andiamo a fare il parsing dei film popolari
    final uri = Uri.parse(Constants.trendingUrl);
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer ${Constants.apiKey}',
        'accept': 'application/json' 
      }
    );
    if (response.statusCode != 200) {
      throw Exception('Errore durante la getMovies ${response.body}');
    }
    //Decodifichiamo il body dei film parsati
    final data = jsonDecode(response.body);
    //Salviamo i valori result in una Lista dinamica
    final List<dynamic> results = data['results'];
    //Andiamo a fare il mapping dei valori result, ovverosia li mettiamo in una lista di
    //Coppie chiave-valore.+
    final List<int> favouritesIds = await favouriteService.getAll();
    final Set<int> favouriteIdSet = favouritesIds.toSet();
    final List<Movie> movies = 
      results.map((row) {
        final bool favouriteCheck = favouriteIdSet.contains(row['id']);
        return Movie.fromJson(row, favouriteCheck);
      }).toList();
    return movies;
  }

  Future<Movie> getMovieById(int id, bool isFavourite) async {
    //Andiamo a fare il parsing dei film popolari
    final uri = Uri.parse('${Constants.detailUrl}$id');
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer ${Constants.apiKey}',
        'accept': 'application/json' 
      }
    );
    if (response.statusCode != 200) {
      throw Exception('Errore durante la getMovieById ${response.body}');
    }
    final data = jsonDecode(response.body);
    final Movie m = Movie.fromJson(data, isFavourite); 
    return m;
  }

  Future<List<Trailer>> getTrailers (int id) async {
    //Andiamo a fare il parsing dei film popolari
    final uri = Uri.parse("${Constants.apiUrl}/movie/${id.toString()}/videos");
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer ${Constants.apiKey}',
        'accept': 'application/json' 
      }
    );
    if (response.statusCode != 200) {
      throw Exception('Errore durante la getTrailers ${response.body}');
    }
    //Decodifichiamo il body dei film parsati
    final data = jsonDecode(response.body);
    //Salviamo i valori result in una Lista dinamica
    final List<dynamic> results = data['results'];
    //Andiamo a fare il mapping dei valori result, ovverosia li mettiamo in una lista di
    //Coppie chiave-valore.
    final List<Trailer> trailers = results.map((row) => Trailer.fromJson(row)).toList();
    return trailers;
  }
}

