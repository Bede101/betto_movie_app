import 'dart:convert';
import 'package:betto_movie_app/constants.dart';
import 'package:betto_movie_app/models/movie.dart';
import 'package:betto_movie_app/models/trailer.dart';
import 'package:betto_movie_app/services/favourite_service.dart';
import 'package:http/http.dart' as http;

//Definiamo il servizio di chiamata dei film popolari
class TMDBService {
  FavouriteService favouriteService = FavouriteService();

  //Andiamo a definire la funzione per ritornare la lista dei film popolari
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
    //Coppie chiave-valore, verificando anche se ogni film è presente nei preferiti
    final List<int> favouritesIds = await favouriteService.getAll();
    final Set<int> favouriteIdSet = favouritesIds.toSet();
    final List<Movie> movies = 
      results.map((row) {
        final bool favouriteCheck = favouriteIdSet.contains(row['id']);
        return Movie.fromJson(row, favouriteCheck);
      }).toList();
    return movies;
  }

  //Andiamo similarmente a definire la getMovieById per fare restituire i film individuali,
  //Usando come parametri l'id della classe Movie e il bool isFavourite, fondamentale per
  //inserire e mantenere il film nella Watchlist
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
  //Utilizziamo la funzione getTrailers per la lista dei trailer
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
    //Coppie chiave-valore, verificando anche se ogni film è presente nei preferiti 
    final List<Trailer> trailers = results.map((row) => Trailer.fromJson(row)).toList();
    return trailers;
  }
  
  Future<List<Movie>> searchMovie (String query) async {

    String query2 = query.toLowerCase().trim();
    final uri = Uri.parse('${Constants.apiUrl}/search/movie?query=$query2');
    final response = await http.get(
      uri,
      //Il campo authorization dell'header contiene l'API key. 
      headers: {
        'Authorization': 'Bearer ${Constants.apiKey}',
        'accept': 'application/json' 
      }
    );
    if (response.statusCode != 200) {
      throw Exception('Errore durante la searchMovie ${response.body}');
    }
    //Decodifichiamo il body dei film parsati
    final data = jsonDecode(response.body);
    //Salviamo i valori result in una Lista dinamica
    final List<dynamic> results = data['results'];
    //Andiamo a fare il mapping dei valori result, ovverosia li mettiamo in una lista di
    //Coppie chiave-valore, verificando anche se ogni film è presente nei preferiti
    final List<int> favouritesIds = await favouriteService.getAll();
    final Set<int> favouriteIdSet = favouritesIds.toSet();
    final List<Movie> movies = 
      results.map((row) {
        final bool favouriteCheck = favouriteIdSet.contains(row['id']);
        return Movie.fromJson(row, favouriteCheck);
      }).toList();
    return movies;
  }
}

