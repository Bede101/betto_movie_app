import 'package:betto_movie_app/models/movie.dart';
import 'package:betto_movie_app/services/tmdb_service.dart';
import 'package:betto_movie_app/services/favourite_service.dart';

class MovieController {
  //Definiamo il TMDBService come privato, così che non possa essere ne letto ne modificato
  //Dalle altre classi

  final TMDBService _service = TMDBService();
  
  final FavouriteService _favourites = FavouriteService();

  Future<List<Movie>> getMovies () async {
    List<Movie> movies = await _service.getMovies();
    return movies;
  } 

  Future<bool> isFavourite(int id) async {
    return await _favourites.contains(id);
  }

  Future<void> toggleFavorite(int id) async {
    await _favourites.toggle(id);
  }

  Future<List<Movie>> getAllFavourites() async {
    final favouriteMovieIds = await _favourites.getAll();
    final List<Movie> movieFavList = await Future.wait(
      favouriteMovieIds.map((id) => _service.getMovieById(id, true))
    );
    return movieFavList;
  }
 
  Future<List<Movie>> searchMovies (String query) async {
    List<Movie> movies = await _service.searchMovie(query);
    return movies;
  } 
}