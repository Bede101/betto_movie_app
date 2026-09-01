import 'package:betto_movie_app/models/trailer.dart';
import 'package:betto_movie_app/services/tmdb_service.dart';

class TrailerController {
  //Andiamo a creare un altro TMDBService che utilizzeremo per la chiamata dei trailer.
  final TMDBService _service = TMDBService();
  Future<List<Trailer>> getTrailers (int id) async {
    return _service.getTrailers(id);
  } 
}