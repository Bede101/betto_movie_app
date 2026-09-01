import 'package:betto_movie_app/models/movie.dart';
import 'package:betto_movie_app/services/tmdb_service.dart';
import 'package:betto_movie_app/services/favourite_service.dart';

class MovieController {
  //Definiamo il nuovo controller TMDBService, _service
  final TMDBService _service = TMDBService();
  
  //Definiamo il nuovo controller di FavouriteService _favourites, 
  //necessario per le operazioni con i film preferiti
  final FavouriteService _favourites = FavouriteService();

  //Definiamo la funzione getMovies per la chiamata di tutti i film popolari
  Future<List<Movie>> getMovies () async {
    List<Movie> movies = await _service.getMovies();
    return movies;
  } 

  //Definiamo la funzione isFavourite per verificare se l'id del movie è all'interno
  //di _favourites, così da distinguere se si trova all'interno della watchlist o no
  Future<bool> isFavourite(int id) async {
    return await _favourites.contains(id);
  }

  //Definiamo la funzione toggleFavourite per l'aggiunta/rimozione s
  //dell'id del movie è all'interno di _favourites
  Future<void> toggleFavorite(int id) async {
    await _favourites.toggle(id);
  }
  //Definiamo la funzione getAllFavourites per restituirci la lista di tutti i film che
  //Sono all'interno della watchlist
  Future<List<Movie>> getAllFavourites() async {
    final favouriteMovieIds = await _favourites.getAll();
    final List<Movie> movieFavList = await Future.wait(
      favouriteMovieIds.map((id) => _service.getMovieById(id, true))
    );
    return movieFavList;
  }
  //Definiamo la funzione searchMovies per la ricerca di film attraverso l'input dell'utente
  Future<List<Movie>> searchMovies (String query) async {
    List<Movie> movies = await _service.searchMovie(query);
    return movies;
  } 
}