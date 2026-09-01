import 'package:betto_movie_app/constants.dart';
import 'package:betto_movie_app/controllers/trailer_controller.dart';
import 'package:betto_movie_app/models/movie.dart';
import 'package:betto_movie_app/models/trailer.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

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
  bool checkTrailer = false;
  YoutubePlayerController controller = YoutubePlayerController(
      params: YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        mute: false
      )
    );

  //Inizializzamo lo stato come abbiamo fatto per il movieController e il getMovies, tuttavia
  //rendiamo la funzione asincrona a differenza di movieController così da migliorare 
  //la reattività dell'interfaccia

  @override
  void initState() {
    super.initState();
    _loadtrailerData();
  } 

  //E' importante che chiamiamo la funzione asincrona al di fuori di initState, in quanto initState si
  //immediatamente void e non Future
  void _loadtrailerData() async {
    _trailers = _trailerController.getTrailers(widget.movie.id);
    List<Trailer> trailerList = await _trailers;
    if(trailerList.isNotEmpty)
    {
      setState(() {
        checkTrailer = true;
      });
    Trailer trailer = (await _trailers).first;
    controller.cueVideoById(videoId: trailer.key);
    }
  } 

  @override
  void dispose () {
    controller.close();
    super.dispose();
  }

  Widget build(BuildContext context) {
    //Fare scaffold con appbar con titolo film, body overview, image e rating
    //Sotto andiamo a fare il trailer
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie.title),
      ),
      body:
        Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                widget.movie.posterPath == null || widget.movie.posterPath!.isEmpty ?
                Text('No poster available.') :
                Image.network(
                  '${Constants.posterUrl}${widget.movie.posterPath}'
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "⭐ ${(widget.movie.voteAverage)?.toStringAsFixed(1) ?? 'Nessun voto'} ",
                    style: TextStyle(fontSize: 32),  
                  ),
                ),
                Padding(
                  padding: EdgeInsetsGeometry.all(16.0),
                  child: Text(
                    widget.movie.overview,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                checkTrailer ? YoutubePlayer(controller: controller) : SizedBox(height: 16,)
              ],
            ),
          ),
        ) 
    );
  }
}