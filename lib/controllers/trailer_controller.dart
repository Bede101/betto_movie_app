import 'package:betto_movie_app/models/trailer.dart';
import 'package:betto_movie_app/tmdb_service.dart';

class TrailerController {
  //Definiamo il TMDBService come privato, così che non possa essere ne letto ne modificato
  //Dalle altre classi

  final TMDBService _service = TMDBService();
  Future<List<Trailer>> getTrailers (int id) async {
    return _service.getTrailers(id);
  } 
}