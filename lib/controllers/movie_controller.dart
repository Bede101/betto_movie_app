import 'package:betto_movie_app/models/movie.dart';
import 'package:betto_movie_app/tmdb_service.dart';

class MovieController {
  //Definiamo il TMDBService come privato, così che non possa essere ne letto ne modificato
  //Dalle altre classi

  final TMDBService _service = TMDBService();
  Future<List<Movie>> getMovies () async {
    return _service.getMovies();
  } 
}