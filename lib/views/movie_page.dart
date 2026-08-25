import 'package:betto_movie_app/constants.dart';
import 'package:betto_movie_app/models/movie.dart';
import 'package:flutter/material.dart';

class MoviePage extends StatefulWidget {
  final Movie movie;
  const MoviePage({super.key, required this.movie});

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
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
              Text(widget.movie.overview)
            ],
          ),
        ) 
    );
  }
}