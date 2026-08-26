import 'package:betto_movie_app/constants.dart';
import 'package:betto_movie_app/controllers/trailer_controller.dart';
import 'package:betto_movie_app/models/movie.dart';
import 'package:betto_movie_app/models/trailer.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MoviePage extends StatefulWidget {
  final Movie movie;
  const MoviePage({super.key, required this.movie});

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  
  final TrailerController _trailerController = TrailerController();
  //Inseriamo il late per definire che movies non potrà essere più nullable dopo la chiamata
  late Future<List<Trailer>> _trailers;
  late YoutubePlayerController controller;

  //Inizializzamo lo stato come abbiamo fatto per il movieController e il getMovies, tuttavia
  //rendiamo la funzione asincrona a differenza di movieController così da migliorare la reattività
  //dell'interfaccia

  @override
  void initState() {
    super.initState();
    _loadtrailerData();
  } 

  //E' importante che chiamiamo la funzione asincrona al di fuori di initState, in quanto initState si
  //immediatamente void e non Future
  void _loadtrailerData() async {
    _trailers = _trailerController.getTrailers(widget.movie.id);
    Trailer trailer = (await _trailers).first;
    print(trailer.key);
  }


  @override
  Widget build(BuildContext context) {
    //Fare scaffold con appbar con titolo film, body overview, image e rating
    //Sotto andiamo a fare il trailer
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie.title),
      ),
      body:
        Center(
          child: Column(
            children: [
              Image.network(
                '${Constants.posterUrl}${widget.movie.posterPath}'
              ),
              Text((widget.movie.voteAverage).toString()),
              Text(widget.movie.overview),
 //             YoutubePlayer(controller: controller)
            ],
          ),
        ) 
    );
  }
}